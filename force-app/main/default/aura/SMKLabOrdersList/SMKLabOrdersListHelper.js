({
      // Fetch the medications from the Apex controller
      RetrieveLabOrders: function(component) {
        var action = component.get('c.getLabOrders');
          action.setParams({"RecordId": component.get("v.recordId"), "ObjectType": component.get("v.ObjectType")});
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
         component.set('v.laborders', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
      }
    })