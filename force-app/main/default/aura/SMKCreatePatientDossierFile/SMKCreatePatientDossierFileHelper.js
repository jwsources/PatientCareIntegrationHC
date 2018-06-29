({
    getResponse: function(component, query) {
        // create a server side action.
        //var host = 'https://www.nationalevacaturebank.nl';     
        var action = component.get("c.SendDossierRequest");

        action.setParams({"MPIID": component.get("v.MPIID")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                // set the response(return Map <string,object>) to response attribute.      
                component.set("v.response", response.getReturnValue()); 
                component.set("v.show", "true");
            }
        });
 
        $A.enqueueAction(action);
    },
})