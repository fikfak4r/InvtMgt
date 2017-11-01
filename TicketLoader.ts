/// <reference path="../../Scripts/Kendo/typescript/kendo.all.d.ts" />

namespace CustomerSupport.BusinessObjects {
    
    
        export class TicketLoader {
    
            protected dtSrc =  kendo.data.DataSource;
    
        constructor(){
          this.dtSrc =  new kendo.data.DataSource( {
                
                                        schema: {
                                            //data: function (response) { alert(JSON.stringify(response)); return response.Entities; },
                                            data:"Entities",
                                            total: "TotalCount",
                                            model: {
                                                id: "TicketId",
                                                fields: {
                                                    TicketId: { editable: false, nullable: false },
                                                    Date: { type: "date" },
                                                    CustomerId: { type: "string" },
                                                    Subject: { type: "string" }
                                                },
                                                
                                            }
                                        },
                                        batch: true,
                                        pageSize: 12,
                                        transport: {
                                            read: function (options) {
                                                TicketService.List({}, 
                                                    res => {
                                                    options.success(res);
                                                })
                                            },
                                            create: function (options) {
                                                $("#output").html(JSON.parse("{" + Q.replaceAll(JSON.stringify(options.data.models[0]), '"TicketId":"",', '') + "}"))
                                                TicketService.Create({ Entities:[JSON.parse("{" + Q.replaceAll(JSON.stringify(options.data.models[0]), '"TicketId":"",', '') + "}")] }, 
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
                                            destroy:function(options){
                                                TicketService.Delete({ EntityId: options.data.models[0].TicketId }, 
                                                    res => {
                                                        options.success(options.data.models[0]);
                                                    })
                                            },
                
                                            parameterMap: function (options, operation) {
                
                                               
                                                if (operation !== "read" && options.models) {
                
                
                                                    return { models: kendo.stringify(options.models) };
                                                }
                
                                            },
                
                
                                        },
                
                
                                    })
        }
    
    
    
        public Load(): void {

            $("#groups").kendoDropDownList({
                text:"Select Group"
            })
            $("#agents").kendoDropDownList({
                
            })
              
    TicketService.List({}, res => 
        {
        $("#ticket-list").kendoListView({
            dataSource: res.Entities,
            template:kendo.template($("#ticket-preview").html())
})
        })
            }
    
    
    
        }
    }