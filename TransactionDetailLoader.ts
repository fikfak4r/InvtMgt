/// <reference path="../../Kendo/typescript/kendo.all.d.ts" />

namespace CustomerSupport.BusinessObjects {

    export class TransactionDetailLoader {


        protected calcObservable: kendo.data.ObservableObject;
        protected customerInfoObservable: kendo.data.ObservableObject;
        protected transactionDetailsDtSrc: kendo.data.DataSource;


        public static CalcObservable_Static: kendo.data.ObservableObject;
        public static CustomerInfoObservable_Static: kendo.data.ObservableObject;

        constructor() {
            
            this.calcObservable = kendo.observable({
                CalculateAmount: function (dataItem) {
                    return dataItem.Quantity * dataItem.UnitPrice;
                },
                CalculateTotalAmount: function (gridRef) {
                    alert('in calc')
                    var items = gridRef.items();
                    var rowCount = items.length - 1
                    var ttlAmt = 0;
                    for (var x = 0; x < items.length; x++) {
                        ttlAmt += this.CalculateAmount(gridRef.dataItem(items[x]))
                    }
                    this.set("totalAmountProp", ttlAmt);
                    alert(ttlAmt)
                    alert(this.get("totalAmountProp"))
                },
                totalAmountProp: 0,
                paid: 0,
                discount: 0,
                tax: 0,
                grandTotal: 0,
                calculateGrandTotal: function () {

                    var discount = 0;
                    var tax = 0;
                    var totalPaid = this.get("paid")
                    var totalAmount = this.get("totalAmountProp")

                    if (this.get("tax") > 0 && isNaN(this.get("tax"))) {
                        tax = (this.get("tax") / 100) * totalAmount
                    }

                    if (this.get("discount") > 0 && isNaN(this.get("discount"))) {
                        tax = (this.get("discount") / 100) * totalAmount
                    }

                    var paid = totalAmount - discount;
                    paid = paid + tax

                    this.set("paid", paid)
                    this.set("grandTotal", paid)

                }

            })//Ends calcObservable

            kendo.bind($("#total-amt-calc"), this.calcObservable)

            TransactionDetailLoader.CalcObservable_Static = this.calcObservable;

            this.customerInfoObservable = kendo.observable({
                date: null,
                name: "Fikoli",
                email: "fik@yahoo.com",
                phoneNumber: "080",
                customerInfo: function () {
                    return { date: this.get("date"), name: this.get("name"), email: this.get("email"), phoneNumber: this.get("phoneNumber") }
                }
            })

            kendo.bind($("#customer-info"), this.customerInfoObservable)

            TransactionDetailLoader.CustomerInfoObservable_Static = this.customerInfoObservable



            this.transactionDetailsDtSrc = new kendo.data.DataSource({
                schema: {
                    model: {
                        id: "TransactionDetailId",
                        fields: {
                            TransactionDetailId: { type: "number" },
                            TransactionId: { type: "number" },
                            Date: { type: "number" },
                            ProductName: {type:"string"},
                        }
                    },
                },
                pageSize: 20,
                transport: {
                    create: function (options) {
                        //options.
                    },
                    update: function (options) { }
                }

            })


        }

        public static CalculatorObservable(): kendo.data.ObservableObject {
            return 
        }

        public static CustomerInfoObservable(): kendo.data.ObservableObject {

        return 

    }




    public static DltGrdDataSource(): kendo.data.DataSource {

        var inMem = [{ Product: "Samsung", Quantity: "1", UnitPrice: "105000", Amount: "105000" }]
        var dtSrc = new kendo.data.DataSource({
            schema: {

                model: {
                    id: "",
                    fields: {
                        Product: { type: "string" },
                        Quantity: { type: "number" },
                        UnitPrice: { type: "number" },
                        Amount: { type: "number" }

                    }
                }
            },
            transport: {
                read: function (options) {
                    options.success(inMem)
                }
            }
        })//Ends dtSrc

        return dtSrc;
    }


    public Load() {
        
        $("#customer-date").kendoDatePicker()

        var trax_dtl_grd = $("#transaction-dtl-grd").kendoGrid({
            dataSource: TransactionDetailLoader.DltGrdDataSource(),
            columns: [
                { field: "Product" },
                { field: "Quantity" },
                { field: "UnitPrice", title: "Unit price" },
                { field: "Amount" },


            ],
            editable: {
                createAt: "bottom"
            },
            navigatable: true,
            cellClose: function (e) {

            }
        }).data("kendoGrid");

        trax_dtl_grd.addRow();

        trax_dtl_grd.tbody.on('keydown', function (e) {
           
            if ($(e.target).closest('td').is(':last-child') && $(e.target).closest('tr').is(':last-child')) {
                trax_dtl_grd.addRow();

                TransactionDetailLoader.CalcObservable_Static.CalculateTotalAmount(trax_dtl_grd)
                TransactionDetailLoader.CalcObservable_Static.calculateGrandTotal()

            }
        })




        $("#customer-list-ddl").kendoAutoComplete(
            {
                dataSource: ["Data 1", "Data 2"],
                placeholder: "Select customer"
            }
        )



    }//Ends the Load method






    public static Submit() {
        alert(kendo.stringify(TransactionDetailLoader.CustomerInfoObservable_Static.customerInfo()))
        $("#transaction-dtl-grd").data("kendoGrid").saveChanges()
    }

}
}