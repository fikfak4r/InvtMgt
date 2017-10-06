/// <reference path="../../../Scripts/ej/tsFiles/ej.web.all.d.ts" />
/// <reference path="../../../Scripts/Kendo/typescript/kendo.all.d.ts" />
namespace CustomerSupport.BusinessObjects {
    export class TicketLoader {



        public Load(): void {

           

            TicketService.List({}, response => {

                $("#Grid").kendoGrid({
                    dataSource: {

                        schema: {
                            data: "Entities",
                            total: "TotalCount",
                            model: {
                                id: "TicketId",
                                fields: {
                                    Date: { type: "date" },
                                    CustomerId: { type: "string" },
                                    Subject:{type:"string"}
                                }
                            }
                        },
                        batch: true,
                        pageSize: 20,
                        transport: {
                            read: {
                                url: "http://localhost:16737/Services/BusinessObjects/Ticket/List",
                                type: "post",
                                dataType: "json"
                            },
                            update: {
                                url: "https://demos.telerik.com/kendo-ui/service/products/update",
                                dataType: "jsonp"
                            },
                            create: {
                                url: "https://demos.telerik.com/kendo-ui/service/products/create",
                                dataType: "jsonp"
                            },
                            parameterMap: function (options, operation) {
                                if (operation !== "read" && options.models) {
                                    return { models: kendo.stringify(options.models) };
                                }
                            },
                        

                        },
                        

                    },
                    columns:[{field:"TicketId"},
                {field:"CustomerId", values: JSON.parse(Q.replaceAll(Q.replaceAll(JSON.stringify(Q.getLookup("Administration.CustomerLocationLookup").items), "CustomerId", "value"), "FullName", "text")) },
                {field:"Subject"}],
                pageable: true,
                toolbar: ["create"],
                editable: "popup"

                })



            })
        }




    }
    }