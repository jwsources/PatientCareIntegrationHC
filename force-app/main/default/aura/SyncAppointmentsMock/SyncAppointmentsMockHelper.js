({
      // Fetch the medications from the Apex controller
      RetrieveAppointments: function(component) {
        console.log("In Helper Retrieve Apppointments");
        var action = component.get('c.syncAppointments');
        action.setParams({"AccountId": component.get("v.recordId")});
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
         component.set('v.result', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
      }
    })