({
    doInit : function(component, event, helper) {
        var action = component.get('c.sendLoginDetails');
        action.setParams({
            userid : component.get('v.recordId')
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            if(state == 'SUCCESS')
            {
                var storeResponse = response.getReturnValue();
                for(var key in storeResponse){
                    console.log('key : '+ key+ 'Map value: ', storeResponse[key]);
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title" : key,
                        "message" : storeResponse[key],
                        "type": key
                    });
                    resultsToast.fire();
                }
            }
        });
        $A.enqueueAction(action); 
    }
})