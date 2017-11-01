/// <reference path="../../../Scripts/Kendo/typescript/kendo.all.d.ts" />
namespace CustomerSupport.BusinessObjects {
    
    
        export class TransactionDetailList {

            protected transDtlDtSrc

            constructor(){
                this.transDtlDtSrc = new kendo.data.DataSource({
                    schema:
                    {
                        total:"TotalCount",
                        data:"Entities",
                        model:{
                            id:"TransactionDetailId",
                            fields:{
                                ProductId:{type:"string"},
                                Date:{type:"date"},
                                Quantity:{type:"number"},
                                UnitPrice:{type:"number"},
                                Discount:{type:"number"},
                                Amount:{type:"number"}
                            }

                        }
                    },
                    transport:{
                        read:function(res)
                        {
                            TransactionDetailService.List({}, response => {res.success(response)})
                        },
                        create:function(options)
                        {

                        }, 
                        update:function(options)
                        {
                            
                            var mdls = options.data.models;
                          
                            var mdsRepositroy = {Entities:[]}

                            for(var x =0; x < mdls.length; x++)
                            {
                                mdsRepositroy.Entities.push({Entity:mdls[x]})
                            }

                            
                            TransactionDetailService.Update(mdsRepositroy, 
                                res => {
                                    options.success(options.data.models);
                                })
                        },
                    },
                    batch:true,
                })
            }


            public Load():void{
                $("#transaction-dtl-grid").kendoGrid({
                    dataSource:this.transDtlDtSrc,
                    columns:[
                        {field:"TransactionDetailId"},
                        {field:"Date", format:"{0:yyyy/MM/dd}"},
                        {field:"ProductId", values: JSON.parse(Q.replaceAll(Q.replaceAll(JSON.stringify(Q.getLookup("Administration.ProductLocationLookup").items), "ProductId", "value"), "Name", "text"))},
                        {field:"Quantity"},
                        {field:"UnitName"},
                        {field:"UnitPrice"},
                        {field:"Discount"},
                        {field:"Amount"},
                        {field:"Total", title:"Total", template:"#:(Quantity * UnitPrice)#", },
                        {command:["destroy"]},

                    ],
                    toolbar:["create", "save", "cancel"],
                    editable:true,
                    navigatable:true,
               
                    cellClose:function(e)
                    {
                        
                        $("#transaction-dtl-grid").data("kendoGrid").refresh()
                        
                       
                        //alert()
                    }
                
                })
            }


        }
    }