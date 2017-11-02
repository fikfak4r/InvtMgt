


namespace CustomerSupport.BusinessObjects.Pages
{
    using Serenity;
    using Serenity.Web;
    using System.Web.Mvc;

    [RoutePrefix("BusinessObjects/TransactionDetail"), Route("{action=index}")]
    public class TransactionDetailController : Controller
    {
        [PageAuthorize(BusinessObjects.PermissionKeys.TransactionDetail.Read)]
        public ActionResult Index()
        {
            return View("~/Modules/BusinessObjects/TransactionDetail/TransactionDetailIndex.cshtml");
        }
    }
}