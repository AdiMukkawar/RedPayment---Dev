({
    validateRepaymentForm: function(component) {
        // Show error messages if required fields are blank
        var allValid = component.find('leadField').reduce(function (validFields,inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);
        return allValid;
    },
    
    saveLead : function(component, event, helper){
        //var emailFieldValue = component.get('v.Lead.Email');
        //component.set("v.displayEmailError",  false);
        var action = component.get('c.saveLeadCtrl');
        action.setParams({
            objLead : component.get('v.Lead')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('State ->'+state); 
            if(state === "SUCCESS") {
                var lead = response.getReturnValue();
                console.log('lead ->'+lead.Id);
                var resultsToast = $A.get("e.force:showToast");
                console.log('resultsToast ->'+resultsToast);
                if(resultsToast != undefined){
                    resultsToast.setParams({
                        "title": "Saved",
                        "message": "Record saved successfully",
                        "type" : "success"
                    });
                    resultsToast.fire(); 
                }  
                var navEvt = $A.get("e.force:navigateToSObject");
                if(navEvt != undefined){
                    navEvt.setParams({
                        "recordId": lead.Id,
                        "isredirect": true,
                        "slideDevName":"detail"
                    });
                    navEvt.fire();
                }                         		
            }                  	
        }); 
        $A.enqueueAction(action);   	
    }
})