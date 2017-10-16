/// <reference path="../../../Scripts/Kendo/typescript/kendo.all.d.ts" />
namespace CustomerSupport.BusinessObjects {
    
    
        export class TicketLoader {
    
            protected dtSrc =  kendo.data.DataSource;
    
        constructor(){
          dtSrc =  new kendo.data.DataSource( {
                
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
    
    
    
                TicketService.List({}, response => {
    
                    $("#Grid").kendoGrid({
                        dataSource: dtSrc,
                        columns: [
                            { command: ["edit", "destroy"], title: "&nbsp;", width: "250px" },
                            {field: "TicketIdString"},
                            {field: "Date", format:"{0:MM/dd/yyyy}"}
                            
                            { field: "CustomerId", values: JSON.parse(Q.replaceAll(Q.replaceAll(JSON.stringify(Q.getLookup("Administration.CustomerLocationLookup").items), "CustomerId", "value"), "FullName", "text")) },
                            { field: "Subject" },
                            {field:"Type"},
                            {field:"Priority"},
                            {field:"Status"},
                            {field:"GroupRoleName"},
                            {field:"UserUserName"},
                            {field:"ProductName"},
                            {field:"PhoneNumber"},
                            {field:"NextFollowUpDate"},
                            {field:"FollowUpAction"},  
                            {field:"LocationId"}],
                            
                        pageable: true,
                        toolbar: ["create"],
                        editable: "popup",
                        
    
    
                    })
    
    
    
                })
            }
    
    
    
        }
    }