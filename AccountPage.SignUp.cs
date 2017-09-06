
namespace CustomerSupport.Membership.Pages
{

    using Administration;
    using Administration.Entities;
    using Administration.Repositories;
    using Serenity;
    using Serenity.Data;
    using Serenity.Services;
    using Serenity.Web;
    using System;
    using System.IO;
    using System.Net.Mail;
    using System.Web;
    using System.Web.Mvc;
    using System.Web.Security;
    using BizPrcs = CustomerSupport.BusinessObjects.Repositories;
    using System.Collections.Generic;
    using BusinessObjects.Entities;
    using BusinessObjects.Repositories;
    using CustomerSupport.Membership.Forms;
    using Processes;


    public partial class AccountController : Controller
    {
        [HttpGet]
        public ActionResult SignUp(string acct, string loc)
        {
            SetLoginPageNavViewBags(acct, loc);

            if (String.IsNullOrEmpty(acct))
                return View(MVC.Views.Membership.Account.SignUp.AccountSignUp);

            return View("~/Modules/Membership/Account/SignUp/AccountSignUp_ClientOfClient.cshtml");
        }


        [HttpPost, JsonFilter]
        public ActionResult SignUp(SignUpRequest request, string acct, string loc)
        {

            SetLoginPageNavViewBags(acct, loc);

            using (var conn = SqlConnections.NewByKey("Default"))
            {

                if (AuthenticationService.DoesBusinessExist(conn, request.CompanyName))
                    ModelState.AddModelError("CompanyName", "Company name already exist");

                if (AuthenticationService.DoesEmailExist(conn, request.Email))
                    ModelState.AddModelError("Email", "Email address already exist");

                if (!request.AgreeToTerms)
                {
                    ModelState.AddModelError("", "You have to agree to terms");
                }

            }

            var username = "";

            if (ModelState.IsValid)
            {
                if (!String.IsNullOrEmpty(acct))
                    return ClientOfClientSignUp(request, acct, loc);

                #region MyRegion

                using (var connection = SqlConnections.NewByKey("Default"))
                using (var uow = new UnitOfWork(connection))
                {

                    //request.CheckNotNull();

                    //Check.NotNullOrWhiteSpace(request.Email, "email");
                    //Check.NotNullOrEmpty(request.Password, "password");
                    //UserRepository.ValidatePassword(request.Email, request.Password, true);
                    //Check.NotNullOrWhiteSpace(request.CompanyName, "companyName");

                    //if (connection.Exists<UserRow>(
                    //        UserRow.Fields.Username == request.Email |
                    //        UserRow.Fields.Email == request.Email))
                    //{
                    //    throw new ValidationError("EmailInUse", Texts.Validation.CantFindUserWithEmail);
                    //}



                    string salt = null;
                    var hash = UserRepository.GenerateHash(request.Password, ref salt);
                    var companyName = request.CompanyName.TrimToEmpty();
                    var email = request.Email;
                    username = request.Email;

                    //Creates Account
                    var acctFld = AccountRow.Fields;
                    var accountID = (int)new SqlInsert(acctFld.TableName)
                        .Set(acctFld.Date, DateTime.Now)
                        .Set(acctFld.CompanyName, companyName)
                        .Set(acctFld.AgreeToTerms, request.AgreeToTerms)
                        .ExecuteAndGetID(connection);

                    //       var accountID = (int)connection.InsertAndGetID(new AccountRow
                    //{
                    //    Date = DateTime.Now,
                    //    CompanyName = companyName,
                    //    AgreeToTerms = request.AgreeToTerms

                    //});

                    //Creates All Locations
                    var locationFld = LocationRow.Fields;
                    int locationID = (int)new SqlInsert(locationFld.TableName)
                        .Set(locationFld.Date, DateTime.Now)
                        .Set(locationFld.AccountId, accountID)
                        .Set(locationFld.LocationName, "All Locations")
                        .Set(locationFld.IsVisible, false)
                        .ExecuteAndGetID(connection);

                    BizPrcs.GetCodeBizPrcs.CreateGetCode(connection, accountID, locationID, true);



                    //Creates Default Location
                    locationID = (int)new SqlInsert(locationFld.TableName)
                        .Set(locationFld.Date, DateTime.Now)
                        .Set(locationFld.AccountId, accountID)
                        .Set(locationFld.LocationName, "Default Location")
                        .Set(locationFld.IsVisible, true)
                        .ExecuteAndGetID(connection);

                    BizPrcs.GetCodeBizPrcs.CreateGetCode(connection, accountID, locationID, false);

                    //Creates User
                    var fld = UserRow.Fields;
                    var userId = (int)new SqlInsert(fld.TableName)
                        .Set(fld.Username, username)
                        .Set(fld.Source, "sign")
                        .Set(fld.DisplayName, companyName)
                        .Set(fld.Email, email)
                        .Set(fld.PasswordHash, hash)
                        .Set(fld.PasswordSalt, salt)
                        .Set(fld.IsActive, 1)
                        .Set(fld.InsertDate, DateTime.Now)
                        .Set(fld.InsertUserId, 1)
                        .Set(fld.LastDirectoryUpdate, DateTime.Now)
                        .Set(fld.AccountId, accountID)
                        .Set(fld.CustomerId, 0)
                        .ExecuteAndGetID(connection);

                    //Creates UserLocation
                    var userLocFlds = UserLocationRow.Fields;
                    var userLocationID = (int)new SqlInsert(userLocFlds.TableName)
                        .Set(userLocFlds.UserId, userId)
                        .Set(userLocFlds.LocationId, locationID)
                        .ExecuteAndGetID(connection);

                    //Creates Role
                    var roleFlds = RoleRow.Fields;
                    var roleId = (int)new SqlInsert(roleFlds.TableName)
                        .Set(roleFlds.AccountId, accountID)
                        .Set(roleFlds.RoleName, RoleRow.AccountOwner)
                        .ExecuteAndGetID(connection);


                    //Creates RolePermissions
                    RolePermission(connection, roleId, Administration.PermissionKeys.Client);

                    RolePermission(connection, roleId, Administration.PermissionKeys.Administration);
                    RolePermission(connection, roleId, Administration.PermissionKeys.Security);
                    RolePermission(connection, roleId, Administration.PermissionKeys.Account);
                    RolePermission(connection, roleId, Administration.PermissionKeys.Location);
                    RolePermission(connection, roleId, Administration.PermissionKeys.GetCode);

                    RolePermission(connection, roleId, Administration.PermissionKeys.UserLocation.Read);
                    RolePermission(connection, roleId, Administration.PermissionKeys.UserLocation.Insert);
                    RolePermission(connection, roleId, Administration.PermissionKeys.UserLocation.Update);
                    RolePermission(connection, roleId, Administration.PermissionKeys.UserLocation.Delete);

                    RolePermission(connection, roleId, Administration.PermissionKeys.RoleLocation.Read);
                    RolePermission(connection, roleId, Administration.PermissionKeys.RoleLocation.Insert);
                    RolePermission(connection, roleId, Administration.PermissionKeys.RoleLocation.Update);

                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Ticket.Insert);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Ticket.Read);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Ticket.Update);

                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.SmsLocation.Read);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.SmsLocation.Insert);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.SmsLocation.Update);

                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.TransactionSms.Read);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.TransactionSms.Insert);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.TransactionSms.Update);

                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.TicketSms.Insert);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.TicketSms.Read);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.TicketSms.Update);

                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.TicketProcess.Read);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.TicketProcess.Insert);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.TicketProcess.Update);

                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Customer.Insert);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Customer.Read);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Customer.Update);

                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Sms.Insert);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Sms.Read);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Sms.Update);

                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.CustomerSms.Insert);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.CustomerSms.Read);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.CustomerSms.Update);

                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Product.Insert);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Product.Read);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Product.Update);

                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.ProductLocation.Insert);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.ProductLocation.Read);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.ProductLocation.Update);

                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KbCategory.Read);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KbCategory.Insert);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KbCategory.Update);

                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KnowledgeBase.Read);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KnowledgeBase.Insert);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KnowledgeBase.Update);

                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KbCategoryLocation.Read);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KbCategoryLocation.Insert);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KbCategoryLocation.Update);

                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KnowledgeBaseLocation.Read);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KnowledgeBaseLocation.Insert);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KnowledgeBaseLocation.Update);

                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.ActionLog.Read);


                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Transaction.Insert);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Transaction.Read);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Transaction.Update);

                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.TransactionDetail.Insert);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.TransactionDetail.Read);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.TransactionDetail.Update);

                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.PaymentDetail.Insert);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.PaymentDetail.Read);
                    RolePermission(connection, roleId, BusinessObjects.PermissionKeys.PaymentDetail.Update);



                    //Creates RoleLocation
                    var roleLocFlds = RoleLocationRow.Fields;
                    new SqlInsert(roleLocFlds.TableName)
                        .Set(roleLocFlds.RoleId, roleId)
                        .Set(roleLocFlds.LocationId, locationID)
                        .Execute(connection);


                    //Creates UserRole
                    var userRoleFlds = UserRoleRow.Fields;
                    new SqlInsert(userRoleFlds.TableName)
                        .Set(userRoleFlds.UserId, userId)
                        .Set(userRoleFlds.RoleId, roleId)
                        .Execute(connection);


                    /***************** Creates Role and Permissions for ClientOfClient *******************/
                    #region CleintOfClient


                    roleId = CreateRoleAndPermissionsForClientOfClient(connection, accountID, locationID, roleFlds);

                    #endregion

                    //byte[] bytes;
                    //using (var ms = new MemoryStream())
                    //using (var bw = new BinaryWriter(ms))
                    //{
                    //    bw.Write(DateTime.UtcNow.AddHours(3).ToBinary());
                    //    bw.Write(userId);
                    //    bw.Flush();
                    //    bytes = ms.ToArray();
                    //}

                    //var token = Convert.ToBase64String(MachineKey.Protect(bytes, "Activate"));

                    //var externalUrl = Config.Get<EnvironmentSettings>().SiteExternalUrl ??
                    //    Request.Url.GetLeftPart(UriPartial.Authority) + VirtualPathUtility.ToAbsolute("~/");

                    //var activateLink = UriHelper.Combine(externalUrl, "Account/Activate?t=");
                    //activateLink = activateLink + Uri.EscapeDataString(token);

                    //var emailModel = new ActivateEmailModel();
                    //emailModel.Username = username;
                    //emailModel.DisplayName = displayName;
                    //emailModel.ActivateLink = activateLink;

                    //var emailSubject = Texts.Forms.Membership.SignUp.ActivateEmailSubject.ToString();
                    //var emailBody = TemplateHelper.RenderTemplate(
                    //    MVC.Views.Membership.Account.SignUp.AccountActivateEmail, emailModel);

                    //var message = new MailMessage();
                    //message.To.Add(email);
                    //message.Subject = emailSubject;
                    //message.Body = emailBody;
                    //message.IsBodyHtml = true;

                    //var client = new SmtpClient();

                    //if (client.DeliveryMethod == SmtpDeliveryMethod.SpecifiedPickupDirectory &&
                    //    string.IsNullOrEmpty(client.PickupDirectoryLocation))
                    //{
                    //    var pickupPath = Server.MapPath("~/App_Data");
                    //    pickupPath = Path.Combine(pickupPath, "Mail");
                    //    Directory.CreateDirectory(pickupPath);
                    //    client.PickupDirectoryLocation = pickupPath;
                    //}

                    uow.OnRollback += () => { };
                    uow.Commit();
                    UserRetrieveService.RemoveCachedUser(userId, username);

                    //client.Send(message);

                    //return new ServiceResponse();
                }

                #endregion

                LoginForm loginForm = new LoginForm();
                loginForm.Username = username;
                loginForm.Password = request.Password;

                //RedirectToAction("LoginAfterSignup", "AccountPage", loginForm);
                return Redirect("~/");
            }
            //return Redirect("~/");
            return View(MVC.Views.Membership.Account.SignUp.AccountSignUp, request);

        }

        private void uow_OnRollback()
        {
            throw new Exception("Roll back happened!");
        }





        private int CreateRoleAndPermissionsForClientOfClient(System.Data.IDbConnection connection, int accountID, int locationID, RoleRow.RowFields roleFlds)
        {

            int roleId;

            roleId = (int)new SqlInsert(roleFlds.TableName)
                .Set(roleFlds.AccountId, accountID)
                .Set(roleFlds.RoleName, RoleRow.ClientOfClient)
                .ExecuteAndGetID(connection);

            var roleLocFlds = RoleLocationRow.Fields;
            new SqlInsert(roleLocFlds.TableName)
                .Set(roleLocFlds.RoleId, roleId)
                .Set(roleLocFlds.LocationId, locationID)
                .Execute(connection);

            //RolePersmission for ClientOfClient
            RolePermission(connection, roleId, Administration.PermissionKeys.ClientOfClient);

            RolePermission(connection, roleId, Administration.PermissionKeys.Administration);

            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Customer.Read);
            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Customer.Update);


            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Ticket.Insert);
            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Ticket.Read);
            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.Ticket.Update);

            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.TicketProcess.Read);
            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.TicketProcess.Insert);
            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.TicketProcess.Update);

            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KbCategory.Read);
            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KbCategory.Insert);
            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KbCategory.Update);

            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KnowledgeBase.Read);
            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KnowledgeBase.Insert);
            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KnowledgeBase.Update);

            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KbCategoryLocation.Read);
            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KbCategoryLocation.Insert);
            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KbCategoryLocation.Update);

            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KnowledgeBaseLocation.Read);
            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KnowledgeBaseLocation.Insert);
            RolePermission(connection, roleId, BusinessObjects.PermissionKeys.KnowledgeBaseLocation.Update);

            return roleId;

        }


        public static void RolePermission(System.Data.IDbConnection conn, int roleId, string permissionKey)
        {
            var rolePermFlds = RolePermissionRow.Fields;
            new SqlInsert(rolePermFlds.TableName)
            .Set(rolePermFlds.RoleId, roleId)
            .Set(rolePermFlds.PermissionKey, permissionKey)
            .Execute(conn);
        }


        public static void DeleteRolePermission(System.Data.IDbConnection conn, int roleId)
        {
            conn.DeleteById<RolePermissionRow>(roleId);
        }

        private Result<ServiceResponse> ClientOfClientSignUp(SignUpRequest request, string accountID, string locationID)
        {
            return this.UseConnection("Default", connection =>
            {

                request.CheckNotNull();

                Check.NotNullOrWhiteSpace(request.Email, "email");
                Check.NotNullOrEmpty(request.Password, "password");
                UserRepository.ValidatePassword(request.Email, request.Password, true);
                Check.NotNullOrWhiteSpace(request.FullName, "fullName");

                if (connection.Exists<UserRow>(
                        UserRow.Fields.Username == request.Email |
                        UserRow.Fields.Email == request.Email))
                {
                    throw new ValidationError("EmailInUse", Texts.Validation.CantFindUserWithEmail);
                }

                using (var uow = new UnitOfWork(connection))
                {

                    string username;
                    int userId;

                    List<LocationRow> locationList = new List<LocationRow>();
                    if (String.IsNullOrEmpty(locationID))
                    {
                        locationList.AddRange(connection.List<LocationRow>(new Criteria("AccountId") == accountID));
                    }
                    else
                    {
                        locationList.Add(connection.Single<LocationRow>(new Criteria("LocationId") == locationID));
                    }

                    CustomerBizPrcs.CreateCustomerWithUserReference(request, accountID, locationList, connection, out username, out userId);

                    uow.Commit();
                    UserRetrieveService.RemoveCachedUser(userId, username);
                    //client.Send(message);

                    return new ServiceResponse();
                }

            });
        }





        [HttpGet]
        public ActionResult Activate(string t)
        {
            using (var connection = SqlConnections.NewByKey("Default"))
            using (var uow = new UnitOfWork(connection))
            {
                int userId;
                try
                {
                    using (var ms = new MemoryStream(MachineKey.Unprotect(Convert.FromBase64String(t), "Activate")))
                    using (var br = new BinaryReader(ms))
                    {
                        var dt = DateTime.FromBinary(br.ReadInt64());
                        if (dt < DateTime.UtcNow)
                            return Error(Texts.Validation.InvalidActivateToken);

                        userId = br.ReadInt32();
                    }
                }
                catch (Exception)
                {
                    return Error(Texts.Validation.InvalidActivateToken);
                }

                var user = uow.Connection.TryById<UserRow>(userId);
                if (user == null || user.IsActive != 0)
                    return Error(Texts.Validation.InvalidActivateToken);

                uow.Connection.UpdateById(new UserRow
                {
                    UserId = user.UserId.Value,
                    IsActive = 1
                });

                BatchGenerationUpdater.OnCommit(uow, UserRow.Fields.GenerationKey);
                uow.Commit();

                return new RedirectResult("~/Account/Login?activated=" + Uri.EscapeDataString(user.Email));
            }
        }


    }
}