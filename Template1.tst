${
    // Enable extension methods by adding using Typewriter.Extensions.*
    using Typewriter.Extensions.Types;


    // Uncomment the constructor to change template settings.
    //Template(Settings settings)
    //{
    //    settings.IncludeProject("Project.Name");
    //    settings.OutputExtension = ".tsx";
    //}


    // Custom extension methods can be used in the template by adding a $ prefix e.g. $LoudName
    string LoudName(Property property)
    {
        return property.Name.ToUpperInvariant();
    }

    string ServiceName(Class c){
    return c.Name + "Fikoli";
    }


}
module AdminLTE1 {

    // $Classes/Enums/Interfaces(filter)[template][separator]
    // filter (optional): Matches the name or full name of the current item. * = match any, wrap in [] to match attributes or prefix with : to match interfaces or base classes.
    // template: The template to repeat for each matched item
    // separator (optional): A separator template that is placed between all templates e.g. $Properties[public $name: $Type][, ]

    // More info: http://frhagn.github.io/Typewriter/
 
    $Classes(*Model)[
    namespace CustomerSupport.BusinessObjects {
    export class $Name {

    protected dtSrc =  kendo.data.DataSource;

	constructor(){}

                 this.dtSrc =  new kendo.data.DataSource({
                
                                        schema: {
                                            //data: function (response) { alert(JSON.stringify(response)); return response.Entities; },
                                            data:"Entities",
                                            total: "TotalCount",
                                            model: {
                                                id: "TicketId",
                                                fields: {

                                                    $Properties[
                                                    $Name : {type:"$Type"},
                                                    ]

                                                },
                                                
                                            }
                                        },
                                        batch: true,
                                        pageSize: 12,
                                        transport: {
                                            read: function (options) {
                                            
                                                $ServiceName.List({}, 
                                                    res => {
                                                    options.success(res);
                                                })
                                            },
                                            create: function (options) {
                                                $("#output").html(JSON.parse("{" + Q.replaceAll(JSON.stringify(options.data.models[0]), '"TicketId":"",', '') + "}"))
                                                $ServiceName.Create({ Entities:[JSON.parse("{" + Q.replaceAll(JSON.stringify(options.data.models[0]), '"TicketId":"",', '') + "}")] }, 
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
                                             
                                                $ServiceName.Update({ Entity: options.data.models[0] }, 
                                                res => {
                                                    options.success(options.data.models[0]);
                                                })
                
                
                
                                            },
                                            destroy:function(options){
                                                $ServiceName.Delete({ EntityId: options.data.models[0].TicketId }, 
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
    }]
}