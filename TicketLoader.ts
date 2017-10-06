
/// <reference path="../../../Scripts/Kendo/typescript/kendo.all.d.ts" />
namespace CustomerSupport.BusinessObjects {


    export class TicketLoader {






        public Load(): void {



            TicketService.List({}, response => {

                $("#Grid").kendoGrid({
                    dataSource: {

                        schema: {
                            //data: function (response) { alert(JSON.stringify(response)); return response.Entities; },
                            total: "TotalCount",
                            model: {
                                id: "TicketId",
                                fields: {
                                    TicketId: { editable: false, nullable: false },
                                    Date: { type: "date" },
                                    CustomerId: { type: "string" },
                                    Subject: { type: "string" }
                                }
                            }
                        },
                        batch: true,
                        pageSize: 12,
                        transport: {
                            read: function (options) {
                                // make JSONP request to https://demos.telerik.com/kendo-ui/service/products/create

                                $.ajax({
                                    url: "http://localhost:31337/Services/BusinessObjects/Ticket/List",
                                    dataType: "json", // "jsonp" is required for cross-domain requests; use "json" for same-domain requests
                                    // send the created data items as the "models" service parameter encoded in JSON
                                    // data: {
                                    //     models: kendo.stringify(options.data.models)
                                    // },
                                    success: function (result) {
                                        // notify the data source that the request succeeded
                                        alert(JSON.stringify(result))
                                        options.success(result.Entities);
                                    },
                                    error: function (result) {
                                        // notify the data source that the request failed
                                        options.error(result);
                                    }
                                })
                            },
                            create: function (options) {
                         
                                TicketService.Create({ Entity: JSON.parse(Q.replaceAll(JSON.stringify(options.data.models[0]), '"TicketId":"",', '')) }, 
                                res => {
                                    options.success(options.data.models[0]);
                                })
//                                 TicketService.Create({Entity:{
//                 TicketIdString:"ID_003067",LocationId:2,ProductId:1,TransactionId:7,Date:"2017-09-22T13:55:00.000",PhoneNumber:"08065701697",CustomerId:1,
// Subject:"Sales -Tran-fikoli-Good"
//             }}, res => {alert(JSON.stringify(options))})
                                
                            },
                            update: function (options) {
                                // make JSONP request to https://demos.telerik.com/kendo-ui/service/products/create

                                TicketService.Update({ Entity: options.data.models[0] }, 
                                res => {
                                    options.success(options.data.models[0]);
                                })



                            },

                            parameterMap: function (options, operation) {

                                //                 if(operation == "update")
                                //                 {
                                //                     alert("operation")
                                //                     return  { models:kendo.stringify({Entity:{
                                // TicketId:8,TicketIdString:"ID_00007",LocationId:2,ProductId:1,TransactionId:7,Date:"2017-09-22T13:55:00.000",PhoneNumber:"08065701697",CustomerId:1,Subject:"Sales -Tran 0"}})
                                //                     };

                                //                 }else 
                                if (operation !== "read" && options.models) {


                                    return { models: kendo.stringify(options.models) };
                                }

                            },


                        },


                    },
                    columns: [
                        { command: ["edit", "destroy"], title: "&nbsp;", width: "250px" },
                        {field: "TicketIdString"},
                        {field:"PhoneNumber"},
                        { field: "CustomerId", values: JSON.parse(Q.replaceAll(Q.replaceAll(JSON.stringify(Q.getLookup("Administration.CustomerLocationLookup").items), "CustomerId", "value"), "FullName", "text")) },
                        { field: "Subject" },
                        {field:"LocationId"}],
                    pageable: true,
                    toolbar: ["create"],
                    editable: "popup",
                    


                })



            })
        }



    }
}