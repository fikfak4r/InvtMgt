using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Serenity.Services;
using System.Collections.Generic;
using MyRow = CustomerSupport.BusinessObjects.Entities.TransactionDetailRow;

namespace CustomerSupport.BusinessObjects
{
    public class TransactionDetailSaveRequest<MyRow> : ServiceRequest
    {
        public List<SaveRequest<MyRow>> Entities { get; set; }
    }
}