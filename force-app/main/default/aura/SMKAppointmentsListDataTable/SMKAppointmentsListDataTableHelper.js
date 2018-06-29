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
      },
    
    getData : function(component) {
        var action = component.get('c.getAppointments');
        action.setParams({"AccountId": component.get("v.recordId"),
                          "limits" : component.get("v.initialRows"),
                          "offsets" : component.get("v.rowNumberOffset")
                         });
        action.setCallback(this, function(a) {
            
            //icons
            let sObjs = a.getReturnValue();
            let columns = component.get("v.columns");
            
            if(sObjs != null && columns != null) {
                for(let row of sObjs) {
                    for(let col of columns) {
                        if(col.type=='boolean') {
                            if(row[col.fieldName]==true) {
                               row[col.fieldName+'_chk'] ='utility:sentiment_negative';
                            }
                            else
                            {
                                row[col.fieldName+'_chk'] = 'utility:check';
                            }
                        }                    
                    }
                }
            }
            
            component.set("v.data", sObjs);
            component.set("v.currentCount", component.get("v.initialRows"));
        });
        $A.enqueueAction(action);
    },
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.data", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    fetchData: function(component , rows){
        return new Promise($A.getCallback(function(resolve, reject) {
            var currentDatatemp = component.get('c.getAppointments');
            var counts = component.get("v.currentCount");
            currentDatatemp.setParams({
                "AccountId": component.get("v.recordId"),
                "limits": component.get("v.initialRows"),
                "offsets": counts 
            });
            currentDatatemp.setCallback(this, function(a) {
                resolve(a.getReturnValue());
                var countstemps = component.get("v.currentCount");
                countstemps = countstemps+component.get("v.initialRows");
                component.set("v.currentCount",countstemps);
                
            });
            $A.enqueueAction(currentDatatemp);
            
            
        }));
        
    } 
    })