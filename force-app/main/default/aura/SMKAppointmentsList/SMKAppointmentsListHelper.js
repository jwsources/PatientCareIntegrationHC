({
      // Fetch the medications from the Apex controller
      RetrieveAppointments: function(component) {
          console.log("1");
        var action = component.get('c.getAppointments');
        action.setParams({"AccountId": component.get("v.recordId")});
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
         component.set('v.appointments', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
      }
    })