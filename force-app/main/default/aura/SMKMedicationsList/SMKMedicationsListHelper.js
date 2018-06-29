({
      // Fetch the medications from the Apex controller
      RetrieveMedications: function(component) {
        var action = component.get('c.getMedications');
          action.setParams({"AccountId": component.get("v.recordId")});
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
         component.set('v.medications', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
      }
    })