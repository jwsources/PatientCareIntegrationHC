({
   doInit: function(component, event, helper) {
		var totalCnt = component.get("c.getTotalCount");
        totalCnt.setParams({"AccountId": component.get("v.recordId")});
        totalCnt.setCallback(this, function(a) {
            component.set("v.totalNumberOfRows", a.getReturnValue());
        });
        $A.enqueueAction(totalCnt);
        
        
        var actions = [
            { label: 'Show details', name: 'show_details' }
        ]; //,            { label: 'Delete', name: 'delete' }
        var headerActions = [
            {
                label: 'All',
                checked: true,
                name:'All'
            },
            {
                label: 'Booked',
                checked: false,
                name:'Booked'
            },
            {
                label: 'Planned',
                checked: false,
                name:'Planned'
            }
        ];
        
        component.set('v.columns', [
            {label: 'STATUS', fieldName: 'HealthCloudGA__Status__c', type: 'text',initialWidth: 70, sortable:true ,actions: headerActions},
            {label: 'NO SHOW', fieldName: 'No_Show__c', type: 'boolean', initialWidth: 50, cellAttributes: {iconName: {fieldName: 'No_Show__c_chk' }, iconPosition: 'left'}},
            {label: 'INVOER', fieldName: 'Entered_On__c', type: 'date', typeAttributes:{day:'2-digit',month:'short',year:'numeric', hour:'2-digit', minute:'2-digit'},sortable:true},
            {label: 'AFSPRAAK', fieldName: 'HealthCloudGA__PeriodStart__c', type: 'date', typeAttributes:{day:'2-digit',month:'short',year:'numeric', hour:'2-digit', minute:'2-digit'},sortable:true},
            {label: 'Z.VERL.', fieldName: 'Care_Provider__c', type: 'text',initialWidth: 60, sortable:true},
            {label: 'BRON.S.', fieldName: 'HealthCloudGA__SourceSystem__c', initialWidth: 80, type: 'text', sortable:true},
            { type: 'action', typeAttributes: { rowActions: actions } } 
        ]);
        helper.getData(component)
    },
    updateSelectedText : function(component, event, helper){
        var selectedRows = event.getParam('selectedRows');
        //  console.log('selectedRows'+selectedRows);
        component.set("v.selectedRowsCount" ,selectedRows.length );
        let obj =[] ; 
        for (var i = 0; i < selectedRows.length; i++){
            
            obj.push({Name:selectedRows[i].Name});
            
        }
        
        
        component.set("v.selectedRowsDetails" ,JSON.stringify(obj) );
        component.set("v.selectedRowsList" ,event.getParam('selectedRows') );
        
    },
    handleSelect: function (component, event, helper) {
        var arr = component.get('v.data');
        var obj =  component.get("v.selectedRowsList");
        console.log('obj '+JSON.stringify(obj) );
        var selectedButtonLabel = event.getSource().get("v.label");
        console.log('Button label: ' + selectedButtonLabel);
        var updateAction = component.get("c.setBookStatus");
        updateAction.setParams({ status : selectedButtonLabel , books: obj});
        updateAction.setCallback(this, function(a) {
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(updateAction);
        
        
        
    },
    loadMoreData: function (component, event, helper) {
        //Display a spinner to signal that data is being loaded
        event.getSource().set("v.isLoading", true);
        //Display "Loading" when more data is being loaded
        component.set('v.loadMoreStatus', 'Loading');
        helper.fetchData(component, component.get('v.rowsToLoad')).then($A.getCallback(function (data) {
            if (component.get('v.data').length >= component.get('v.totalNumberOfRows')) {
                component.set('v.enableInfiniteLoading', false);
                component.set('v.loadMoreStatus', 'No more data to load');
            } else {
                var currentData = component.get('v.data');
                //Appends new data to the end of the table
                var newData = currentData.concat(data);
                component.set('v.data', newData);
                component.set('v.loadMoreStatus', 'Please wait ');
            }
            event.getSource().set("v.isLoading", false);
        }));
    },
    
    
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'show_details':
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": row.Id,
                    "slideDevName": "detail"
                });
                navEvt.fire();
                break;
            case 'delete':
                var rows = cmp.get('v.data');
                var rowIndex = rows.indexOf(row);
                console.log('rowIndex'+rowIndex);
                console.log('rowIndex row'+rows[rowIndex].Id);
                var deleteAct = cmp.get("c.deleteBooks");
                deleteAct.setParams({ ids : rows[rowIndex].Id });
                $A.enqueueAction(deleteAct);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been delete successfully."
                });
                toastEvent.fire();
                rows.splice(rowIndex, 1);
                cmp.set('v.data', rows);
                break;
        }
    },
    handleHeaderAction: function (cmp, event, helper) {
        
        // helper.getData(cmp);
        
        
        var actionName = event.getParam('action').name;
        var colDef = event.getParam('columnDefinition');
        var columns = cmp.get('v.columns');
        var activeFilter = cmp.get('v.activeFilter');
        console.log('activeFilter-->'+activeFilter);
        if (actionName !== activeFilter) {
            var idx = columns.indexOf(colDef);
            var actions = columns[idx].actions;
            console.log('actions'+actions)
            actions.forEach(function (action) {
                action.checked = action.name === actionName;
            });
            cmp.set('v.activeFilter', actionName);
            helper.updateBooks(cmp);
            cmp.set('v.columns', columns);
        }
    },
    
    // Client-side controller called by the onsort event handler
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    
    
    
    
})