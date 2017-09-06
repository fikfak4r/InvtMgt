using System;
using FluentMigrator;
using FluentMigrator.Runner.Extensions;

namespace CustomerSupport.Migrations.DefaultDB
{
    [Migration(20170429053500)]
    public class Default_201704290535 : FluentMigrator.Migration
    {


        public override void Up()
        {
            #region Create Schemas
            #endregion

            #region Create Tables
            Create.Table("Accounts").InSchema("dbo")
                .WithColumn("AccountID").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("Date").AsDate().NotNullable()
                .WithColumn("CompanyName").AsAnsiString(250).NotNullable()
                .WithColumn("Logo").AsCustom("IMAGE").Nullable()
                .WithColumn("Address").AsString(Int32.MaxValue).Nullable()
                .WithColumn("Email").AsAnsiString(250).Nullable()
                .WithColumn("PhoneNumber").AsString(50).Nullable()
                .WithColumn("WebsiteAddress").AsString(250).Nullable()
                .WithColumn("AgreeToTerms").AsBoolean().Nullable();

            Create.Table("ActionsLogs").InSchema("dbo")
                .WithColumn("ActionLogId").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("TicketId").AsInt32().Nullable()
                .WithColumn("Action").AsAnsiString(50).Nullable()
                .WithColumn("Date").AsDateTime().Nullable()
                .WithColumn("UserId").AsInt32().Nullable();

            Create.Table("CallProcess").InSchema("dbo")
                .WithColumn("CallProcessID").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("CallID").AsInt32().NotNullable()
                .WithColumn("UserID").AsInt32().Nullable()
                .WithColumn("Date").AsDateTime().NotNullable()
                .WithColumn("Description").AsAnsiString(Int32.MaxValue).NotNullable()
                .WithColumn("ReplyComment").AsByte().Nullable()
                .WithColumn("CreatorID").AsInt32().Nullable()
                .WithColumn("CallDirection").AsByte().NotNullable();

            Create.Table("Calls").InSchema("dbo")
                .WithColumn("CallID").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("CustomerID").AsInt32().NotNullable()
                .WithColumn("GroupID").AsInt32().Nullable()
                .WithColumn("UserID").AsInt32().Nullable()
                .WithColumn("Date").AsDateTime().NotNullable()
                .WithColumn("Subject").AsAnsiString(250).Nullable()
                .WithColumn("Description").AsAnsiString(Int32.MaxValue).NotNullable()
                .WithColumn("CallDirection").AsByte().NotNullable()
                .WithColumn("Priority").AsByte().Nullable()
                .WithColumn("Status").AsByte().Nullable()
                .WithColumn("NextFollowUpDate").AsDateTime().Nullable()
                .WithColumn("CreatorID").AsInt32().Nullable()
                .WithColumn("Me").AsBoolean().Nullable()
                .WithColumn("LocationID").AsInt32().NotNullable()
                .WithColumn("FollowUpAction").AsAnsiString(Int32.MaxValue).Nullable();

            Create.Table("Customers").InSchema("dbo")
                .WithColumn("CustomerID").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("LocationID").AsInt32().Nullable()
                .WithColumn("Date").AsDateTime().Nullable()
                .WithColumn("FirstName").AsAnsiString(150).Nullable()
                .WithColumn("LastName").AsAnsiString(150).Nullable()
                .WithColumn("FullName").AsAnsiString(150).Nullable()
                .WithColumn("Sex").AsByte().Nullable()
                .WithColumn("DateOfBirth").AsDate().Nullable()
                .WithColumn("PhoneNumber").AsAnsiString(50).Nullable()
                .WithColumn("Email").AsAnsiString(50).Nullable()
                .WithColumn("Address").AsAnsiString(Int32.MaxValue).Nullable();

            Create.Table("CustomersSms").InSchema("dbo")
                .WithColumn("CustomerSmsId").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("CustomerId").AsInt32().Nullable()
                .WithColumn("SmsId").AsInt32().Nullable()
                .WithColumn("Sent").AsBoolean().Nullable()
                .WithColumn("Delivered").AsBoolean().Nullable()
                .WithColumn("UnDelivered").AsBoolean().Nullable();


            Create.Table("GetCode").InSchema("dbo")
                .WithColumn("GetCodeID").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("AccountID").AsInt32().Nullable()
                .WithColumn("LocationID").AsInt32().Nullable()
                .WithColumn("LinkCode").AsAnsiString(350).Nullable()
                .WithColumn("FormCode").AsAnsiString(500).Nullable();

            Create.Table("KB_Category").InSchema("dbo")
                .WithColumn("KB_CategoryID").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("CategoryName").AsAnsiString(250).NotNullable()
                .WithColumn("LocationID").AsInt32().Nullable();

            Create.Table("KBCategoryLocations").InSchema("dbo")
                .WithColumn("KBCategoryLocationID").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("KBCategoryID").AsInt32().Nullable()
                .WithColumn("LocationID").AsInt32().Nullable();

            Create.Table("KnowledgeBase").InSchema("dbo")
                .WithColumn("KB_ID").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("KB_CategoryID").AsInt32().NotNullable()
                .WithColumn("Title").AsAnsiString(250).NotNullable()
                .WithColumn("KB_Content").AsAnsiString(Int32.MaxValue).NotNullable();

            Create.Table("KnowledgeBaseLocations").InSchema("dbo")
                .WithColumn("KBLocationID").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("KBID").AsInt32().Nullable()
                .WithColumn("LocationID").AsInt32().Nullable();



            Create.Table("Locations").InSchema("dbo")
                .WithColumn("LocationID").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("AccountID").AsInt32().NotNullable()
                .WithColumn("Date").AsDate().Nullable()
                .WithColumn("PhoneNumber").AsString(50).Nullable()
                .WithColumn("Email").AsString(50).Nullable()
                .WithColumn("Website").AsString(50).Nullable()
                .WithColumn("LocationName").AsString(250).NotNullable()
                .WithColumn("Address").AsString(Int32.MaxValue).Nullable()
                .WithColumn("UserID").AsInt32().Nullable()
                .WithColumn("IsVisible").AsBoolean().Nullable();

            Create.Table("Notes").InSchema("dbo")
                .WithColumn("NoteID").AsInt64().Identity().NotNullable().PrimaryKey()
                .WithColumn("CallDirection").AsAnsiString(10).Nullable()
                .WithColumn("EntityType").AsString(100).NotNullable()
                .WithColumn("EntityID").AsInt64().NotNullable()
                .WithColumn("Text").AsString(Int32.MaxValue).NotNullable()
                .WithColumn("InsertUserId").AsInt32().NotNullable()
                .WithColumn("InsertDate").AsDateTime().NotNullable();

            Create.Table("PaymentsDetails").InSchema("dbo")
                .WithColumn("PaymentDetailId").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("TransactionId").AsInt32().Nullable()
                .WithColumn("Date").AsDateTime().Nullable()
                .WithColumn("TotalAmount").AsCurrency().Nullable()
                .WithColumn("AmountPaid").AsCurrency().Nullable()
                .WithColumn("AmountLeft").AsCurrency().Nullable()
                .WithColumn("IsTotalAmountRow").AsBoolean().NotNullable()
                .WithColumn("LocationID").AsInt32().Nullable();

            Create.Table("Products").InSchema("dbo")
                .WithColumn("ProductId").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("Name").AsAnsiString(100).Nullable()
                .WithColumn("UnitName").AsAnsiString(50).Nullable()
                .WithColumn("Price").AsCurrency().Nullable();

            Create.Table("ProductsLocations").InSchema("dbo")
                .WithColumn("ProductLocationId").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("ProductId").AsInt32().Nullable()
                .WithColumn("LocationId").AsInt32().Nullable();

            Create.Table("RolesLocations").InSchema("dbo")
            .WithColumn("RoleLocationID").AsInt32().Identity().NotNullable().PrimaryKey()
            .WithColumn("RoleID").AsInt32().Nullable()
            .WithColumn("LocationID").AsInt32().Nullable();


            Create.Table("Sms").InSchema("dbo")
                .WithColumn("SmsId").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("Date").AsCustom("SMALLDATETIME").Nullable()
                .WithColumn("Message").AsAnsiString(500).Nullable();

            Create.Table("SmsLocations").InSchema("dbo")
                .WithColumn("SmsLocationId").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("SmsId").AsInt32().Nullable()
                .WithColumn("LocationId").AsInt32().Nullable();

            Create.Table("TicketProcess").InSchema("dbo")
                .WithColumn("TicketProcessID").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("TicketID").AsInt32().Nullable()
                .WithColumn("Date").AsDateTime().Nullable()
                .WithColumn("UserID").AsInt32().Nullable()
                .WithColumn("Description").AsAnsiString(Int32.MaxValue).Nullable()
                .WithColumn("ReplyComment").AsByte().Nullable()
                .WithColumn("CreatorID").AsInt32().Nullable();

            Create.Table("Tickets").InSchema("dbo")
                .WithColumn("TicketID").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("TicketIdString").AsAnsiString(50).Nullable()
                .WithColumn("LocationID").AsInt32().Nullable()
                .WithColumn("Date").AsDateTime().NotNullable()
                .WithColumn("CustomerID").AsInt32().Nullable()
                .WithColumn("TransactionId").AsInt32().Nullable()
                .WithColumn("CallDirection").AsByte().Nullable()
                .WithColumn("ProductId").AsInt32().Nullable()
                .WithColumn("Type").AsByte().Nullable()
                .WithColumn("Priority").AsByte().Nullable()
                .WithColumn("Status").AsByte().Nullable()
                .WithColumn("GroupID").AsInt32().Nullable()
                .WithColumn("UserID").AsInt32().Nullable()
                .WithColumn("Subject").AsAnsiString(250).Nullable()
                .WithColumn("CreatorID").AsInt32().Nullable()
                .WithColumn("Me").AsBoolean().Nullable()
                .WithColumn("PhoneNumber").AsAnsiString(50).Nullable()
                .WithColumn("NextFollowUpdate").AsDateTime().Nullable()
                .WithColumn("FollowUpAction").AsAnsiString(Int32.MaxValue).Nullable();

            Create.Table("TicketsSms").InSchema("dbo")
                .WithColumn("TicketSmsId").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("TicketId").AsInt32().Nullable()
                .WithColumn("SmsId").AsInt32().Nullable()
                .WithColumn("Sent").AsBoolean().Nullable()
                .WithColumn("Delivered").AsBoolean().Nullable()
                .WithColumn("UnDelivered").AsBoolean().Nullable();

            Create.Table("Transactions").InSchema("dbo")
                .WithColumn("TransactionId").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("OrderID").AsAnsiString(50).NotNullable()
                .WithColumn("Date").AsDateTime().NotNullable()
                .WithColumn("TicketId").AsInt32().Nullable()
                .WithColumn("CustomerId").AsInt32().Nullable()
                .WithColumn("Subject").AsAnsiString(250).Nullable()
                .WithColumn("TotalAmount").AsCurrency().NotNullable()
                .WithColumn("TotalAmountPaid").AsCurrency().Nullable()
                .WithColumn("TotalAmountLeft").AsCurrency().Nullable()
                .WithColumn("HasTransactionsDetails").AsBoolean().NotNullable()
                .WithColumn("LocationID").AsInt32().Nullable()
                .WithColumn("IsIntegerTrailingOrderIDWithPrefixPO").AsBoolean().Nullable()
                .WithColumn("Status").AsAnsiString(20).NotNullable()
                .WithColumn("IsOpen").AsBoolean().NotNullable()
                .WithColumn("IsInProgress").AsBoolean().NotNullable()
                .WithColumn("IsFullyReceived").AsBoolean().NotNullable()
                .WithColumn("IsFullyPaid").AsBoolean().NotNullable()
                .WithColumn("IsAdvanced").AsBoolean().Nullable();

            Create.Table("TransactionsDetails").InSchema("dbo")
                .WithColumn("TransactionDetailId").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("TransactionId").AsInt32().Nullable()
                .WithColumn("Date").AsDateTime().Nullable()
                .WithColumn("ProductId").AsInt32().Nullable()
                .WithColumn("UnitPrice").AsCurrency().Nullable()
                .WithColumn("UnitName").AsAnsiString(50).Nullable()
                .WithColumn("Discount").AsCurrency().Nullable()
                .WithColumn("Amount").AsCurrency().NotNullable()
                .WithColumn("Quantity").AsInt32().NotNullable()
                .WithColumn("LocationID").AsInt32().Nullable()
                .WithColumn("IsReceived").AsBoolean().Nullable();

            Create.Table("TransactionsSms").InSchema("dbo")
                .WithColumn("TransactionSmsId").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("TransactionId").AsInt32().Nullable()
                .WithColumn("SmsId").AsInt32().Nullable()
                .WithColumn("Sent").AsBoolean().Nullable()
                .WithColumn("Delivered").AsBoolean().Nullable()
                .WithColumn("UnDelivered").AsBoolean().Nullable();






            Create.Table("UsersLocations").InSchema("dbo")
                .WithColumn("UserLocationID").AsInt32().Identity().NotNullable().PrimaryKey()
                .WithColumn("UserID").AsInt32().Nullable()
                .WithColumn("LocationID").AsInt32().Nullable();
            #endregion

            #region Create Foreign Keys
            Create.ForeignKey("FK_ActionsLogs_Tickets")
                .FromTable("ActionsLogs").InSchema("dbo").ForeignColumns("TicketId")
                .ToTable("Tickets").InSchema("dbo").PrimaryColumns("TicketID");

            Create.ForeignKey("FK_ActionsLogs_Users")
                .FromTable("ActionsLogs").InSchema("dbo").ForeignColumns("UserId")
                .ToTable("Users").InSchema("dbo").PrimaryColumns("UserId");

            Create.ForeignKey("FK_CallProcess_Calls")
                .FromTable("CallProcess").InSchema("dbo").ForeignColumns("CallID")
                .ToTable("Calls").InSchema("dbo").PrimaryColumns("CallID");

            Create.ForeignKey("FK_Calls_Customers")
                .FromTable("Calls").InSchema("dbo").ForeignColumns("CustomerID")
                .ToTable("Customers").InSchema("dbo").PrimaryColumns("CustomerID");

            Create.ForeignKey("FK_Calls_Locations")
                .FromTable("Calls").InSchema("dbo").ForeignColumns("LocationID")
                .ToTable("Locations").InSchema("dbo").PrimaryColumns("LocationID");

            Create.ForeignKey("FK_Customers_Locations")
                .FromTable("Customers").InSchema("dbo").ForeignColumns("LocationID")
                .ToTable("Locations").InSchema("dbo").PrimaryColumns("LocationID");

            Create.ForeignKey("FK_CustomersSms_Customers")
                .FromTable("CustomersSms").InSchema("dbo").ForeignColumns("CustomerId")
                .ToTable("Customers").InSchema("dbo").PrimaryColumns("CustomerID");

            Create.ForeignKey("FK_CustomersSms_Sms")
                .FromTable("CustomersSms").InSchema("dbo").ForeignColumns("SmsId")
                .ToTable("Sms").InSchema("dbo").PrimaryColumns("SmsId");

            Create.ForeignKey("FK_GetCode_Accounts")
                .FromTable("GetCode").InSchema("dbo").ForeignColumns("AccountID")
                .ToTable("Accounts").InSchema("dbo").PrimaryColumns("AccountID");

            Create.ForeignKey("FK_GetCode_Locations")
                .FromTable("GetCode").InSchema("dbo").ForeignColumns("LocationID")
                .ToTable("Locations").InSchema("dbo").PrimaryColumns("LocationID");

            Create.ForeignKey("FK_KB_Category_Locations")
                .FromTable("KB_Category").InSchema("dbo").ForeignColumns("LocationID")
                .ToTable("Locations").InSchema("dbo").PrimaryColumns("LocationID");

            Create.ForeignKey("FK_KnowledgeBase_KB_Category")
                .FromTable("KnowledgeBase").InSchema("dbo").ForeignColumns("KB_CategoryID")
                .ToTable("KB_Category").InSchema("dbo").PrimaryColumns("KB_CategoryID");

            Create.ForeignKey("FK_Locations_Accounts")
                .FromTable("Locations").InSchema("dbo").ForeignColumns("AccountID")
                .ToTable("Accounts").InSchema("dbo").PrimaryColumns("AccountID");

            Create.ForeignKey("FK_PaymentsDetails_Transactions")
                .FromTable("PaymentsDetails").InSchema("dbo").ForeignColumns("TransactionId")
                .ToTable("Transactions").InSchema("dbo").PrimaryColumns("TransactionId");

            Create.ForeignKey("FK_ProductsLocations_Locations")
                .FromTable("ProductsLocations").InSchema("dbo").ForeignColumns("LocationId")
                .ToTable("Locations").InSchema("dbo").PrimaryColumns("LocationID");

            Create.ForeignKey("FK_ProductsLocations_Products")
                .FromTable("ProductsLocations").InSchema("dbo").ForeignColumns("ProductId")
                .ToTable("Products").InSchema("dbo").PrimaryColumns("ProductId");


            Create.ForeignKey("FK_SmsLocations_Locations")
                .FromTable("SmsLocations").InSchema("dbo").ForeignColumns("LocationId")
                .ToTable("Locations").InSchema("dbo").PrimaryColumns("LocationID");

            Create.ForeignKey("FK_SmsLocations_Sms")
                .FromTable("SmsLocations").InSchema("dbo").ForeignColumns("SmsId")
                .ToTable("Sms").InSchema("dbo").PrimaryColumns("SmsId");

            Create.ForeignKey("FK_Tickets_Products")
                .FromTable("Tickets").InSchema("dbo").ForeignColumns("ProductId")
                .ToTable("Products").InSchema("dbo").PrimaryColumns("ProductId");

            Create.ForeignKey("FK_TicketsSms_Sms")
                .FromTable("TicketsSms").InSchema("dbo").ForeignColumns("TicketSmsId")
                .ToTable("Sms").InSchema("dbo").PrimaryColumns("SmsId");

            Create.ForeignKey("FK_TicketsSms_Tickets")
                .FromTable("TicketsSms").InSchema("dbo").ForeignColumns("TicketId")
                .ToTable("Tickets").InSchema("dbo").PrimaryColumns("TicketID");

            Create.ForeignKey("FK_Transactions_Locations")
                .FromTable("Transactions").InSchema("dbo").ForeignColumns("LocationID")
                .ToTable("Locations").InSchema("dbo").PrimaryColumns("LocationID");

            Create.ForeignKey("FK_TransactionsDetails_Products")
                .FromTable("TransactionsDetails").InSchema("dbo").ForeignColumns("ProductId")
                .ToTable("Products").InSchema("dbo").PrimaryColumns("ProductId");

            Create.ForeignKey("FK_TransactionsDetails_Transactions")
                .FromTable("TransactionsDetails").InSchema("dbo").ForeignColumns("TransactionId")
                .ToTable("Transactions").InSchema("dbo").PrimaryColumns("TransactionId");

            Create.ForeignKey("FK_TransactionsSms_Sms")
                .FromTable("TransactionsSms").InSchema("dbo").ForeignColumns("SmsId")
                .ToTable("Sms").InSchema("dbo").PrimaryColumns("SmsId");

            Create.ForeignKey("FK_TransactionsSms_Transactions")
                .FromTable("TransactionsSms").InSchema("dbo").ForeignColumns("TransactionId")
                .ToTable("Transactions").InSchema("dbo").PrimaryColumns("TransactionId");





            Create.ForeignKey("FK_UsersLocations_Locations")
                .FromTable("UsersLocations").InSchema("dbo").ForeignColumns("LocationID")
                .ToTable("Locations").InSchema("dbo").PrimaryColumns("LocationID");

            Create.ForeignKey("FK_UsersLocations_Users")
                .FromTable("UsersLocations").InSchema("dbo").ForeignColumns("UserID")
                .ToTable("Users").InSchema("dbo").PrimaryColumns("UserId");
            #endregion

            #region Create Unique Constraints



            #endregion

            #region Create Indexes
            Create.Index("IX_ActionsLogs")
                .OnTable("ActionsLogs").InSchema("dbo")
                .OnColumn("ActionLogId").Ascending()
                .WithOptions()
                .NonClustered();








            #endregion
        }



        public override void Down()
        {
            #region Delete Unique Constraints
            Delete.UniqueConstraint("UQ_RolePerm_RoleId_PermKey").FromTable("RolePermissions").InSchema("dbo");
            Delete.UniqueConstraint("UQ_UserPerm_UserId_PermKey").FromTable("UserPermissions").InSchema("dbo");
            Delete.UniqueConstraint("IX_UserPref_UID_PrefType_Name").FromTable("UserPreferences").InSchema("dbo");
            Delete.UniqueConstraint("UQ_UserRoles_UserId_RoleId").FromTable("UserRoles").InSchema("dbo");
            #endregion

            #region Delete Foreign Keys
            Delete.ForeignKey("FK_ActionsLogs_Tickets").OnTable("ActionsLogs").InSchema("dbo");
            Delete.ForeignKey("FK_ActionsLogs_Users").OnTable("ActionsLogs").InSchema("dbo");
            Delete.ForeignKey("FK_BusinessUnits_ParentUnit").OnTable("BusinessUnits").InSchema("dbo");
            Delete.ForeignKey("FK_CallProcess_Calls").OnTable("CallProcess").InSchema("dbo");
            Delete.ForeignKey("FK_Calls_Customers").OnTable("Calls").InSchema("dbo");
            Delete.ForeignKey("FK_Calls_Locations").OnTable("Calls").InSchema("dbo");
            Delete.ForeignKey("FK_Contacts_UserId").OnTable("Contacts").InSchema("dbo");
            Delete.ForeignKey("FK_Customers_Locations").OnTable("Customers").InSchema("dbo");
            Delete.ForeignKey("FK_GetCode_Accounts").OnTable("GetCode").InSchema("dbo");
            Delete.ForeignKey("FK_GetCode_Locations").OnTable("GetCode").InSchema("dbo");
            Delete.ForeignKey("FK_KB_Category_Locations").OnTable("KB_Category").InSchema("dbo");
            Delete.ForeignKey("FK_KnowledgeBase_KB_Category").OnTable("KnowledgeBase").InSchema("dbo");
            Delete.ForeignKey("FK_Locations_Accounts").OnTable("Locations").InSchema("dbo");
            Delete.ForeignKey("FK_AgendaRel_AgendaId").OnTable("MeetingAgendaRelevant").InSchema("dbo");
            Delete.ForeignKey("FK_AgendaRel_ContactId").OnTable("MeetingAgendaRelevant").InSchema("dbo");
            Delete.ForeignKey("FK_MeetAgendas_AgendaTypeId").OnTable("MeetingAgendas").InSchema("dbo");
            Delete.ForeignKey("FK_MeetAgendas_MeetingId").OnTable("MeetingAgendas").InSchema("dbo");
            Delete.ForeignKey("FK_MeetAgendas_RequestedBy").OnTable("MeetingAgendas").InSchema("dbo");
            Delete.ForeignKey("FK_MeetAttendees_ContactId").OnTable("MeetingAttendees").InSchema("dbo");
            Delete.ForeignKey("FK_MeetAttendees_MeetingId").OnTable("MeetingAttendees").InSchema("dbo");
            Delete.ForeignKey("FK_DecisionRel_ContactId").OnTable("MeetingDecisionRelevant").InSchema("dbo");
            Delete.ForeignKey("FK_DecisionRel_DecisionId").OnTable("MeetingDecisionRelevant").InSchema("dbo");
            Delete.ForeignKey("FK_MeetDecisions_AgendaId").OnTable("MeetingDecisions").InSchema("dbo");
            Delete.ForeignKey("FK_MeetDecisions_AgendaType").OnTable("MeetingDecisions").InSchema("dbo");
            Delete.ForeignKey("FK_MeetDecisions_MeetingId").OnTable("MeetingDecisions").InSchema("dbo");
            Delete.ForeignKey("FK_MeetDecisions_RequestedBy").OnTable("MeetingDecisions").InSchema("dbo");
            Delete.ForeignKey("FK_Meetings_LocationId").OnTable("Meetings").InSchema("dbo");
            Delete.ForeignKey("FK_Meetings_Organizer").OnTable("Meetings").InSchema("dbo");
            Delete.ForeignKey("FK_Meetings_Reporter").OnTable("Meetings").InSchema("dbo");
            Delete.ForeignKey("FK_Meetings_TypeId").OnTable("Meetings").InSchema("dbo");
            Delete.ForeignKey("FK_Meetings_UnitId").OnTable("Meetings").InSchema("dbo");
            Delete.ForeignKey("FK_RolePermissions_RoleId").OnTable("RolePermissions").InSchema("dbo");
            Delete.ForeignKey("FK_TicketProcess_Tickets").OnTable("TicketProcess").InSchema("dbo");
            Delete.ForeignKey("FK_Tickets_Customers").OnTable("Tickets").InSchema("dbo");
            Delete.ForeignKey("FK_Tickets_Locations").OnTable("Tickets").InSchema("dbo");
            Delete.ForeignKey("FK_UserPermissions_UserId").OnTable("UserPermissions").InSchema("dbo");
            Delete.ForeignKey("FK_UserRoles_RoleId").OnTable("UserRoles").InSchema("dbo");
            Delete.ForeignKey("FK_UserRoles_UserId").OnTable("UserRoles").InSchema("dbo");
            Delete.ForeignKey("FK_UsersLocations_Locations").OnTable("UsersLocations").InSchema("dbo");
            Delete.ForeignKey("FK_UsersLocations_Users").OnTable("UsersLocations").InSchema("dbo");
            #endregion

            #region Delete Tables
            Delete.Table("Accounts").InSchema("dbo");
            Delete.Table("ActionsLogs").InSchema("dbo");
            Delete.Table("Agents").InSchema("dbo");
            Delete.Table("AgentsGroup").InSchema("dbo");
            Delete.Table("BusinessUnits").InSchema("dbo");
            Delete.Table("CallProcess").InSchema("dbo");
            Delete.Table("Calls").InSchema("dbo");
            Delete.Table("Contacts").InSchema("dbo");
            Delete.Table("ContactUs").InSchema("dbo");
            Delete.Table("Customers").InSchema("dbo");
            Delete.Table("Exceptions").InSchema("dbo");
            Delete.Table("GetCode").InSchema("dbo");
            Delete.Table("KB_Category").InSchema("dbo");
            Delete.Table("KBCategoryLocations").InSchema("dbo");
            Delete.Table("KnowledgeBase").InSchema("dbo");
            Delete.Table("KnowledgeBaseLocations").InSchema("dbo");
            Delete.Table("Languages").InSchema("dbo");
            Delete.Table("Locations").InSchema("dbo");
            Delete.Table("MeetingAgendaRelevant").InSchema("dbo");
            Delete.Table("MeetingAgendas").InSchema("dbo");
            Delete.Table("MeetingAgendaTypes").InSchema("dbo");
            Delete.Table("MeetingAttendees").InSchema("dbo");
            Delete.Table("MeetingDecisionRelevant").InSchema("dbo");
            Delete.Table("MeetingDecisions").InSchema("dbo");
            Delete.Table("MeetingLocations").InSchema("dbo");
            Delete.Table("Meetings").InSchema("dbo");
            Delete.Table("MeetingTypes").InSchema("dbo");
            Delete.Table("Notes").InSchema("dbo");
            Delete.Table("RolePermissions").InSchema("dbo");
            Delete.Table("Roles").InSchema("dbo");
            Delete.Table("RolesLocations").InSchema("dbo");
            Delete.Table("TicketProcess").InSchema("dbo");
            Delete.Table("Tickets").InSchema("dbo");
            Delete.Table("UserPermissions").InSchema("dbo");
            Delete.Table("UserPreferences").InSchema("dbo");
            Delete.Table("UserRoles").InSchema("dbo");
            Delete.Table("Users").InSchema("dbo");
            Delete.Table("UsersLocations").InSchema("dbo");
            #endregion

            #region Delete Schemas
            #endregion
        }

    }
}
