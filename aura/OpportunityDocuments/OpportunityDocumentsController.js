({
    doInit: function(component, event, helper) {
        // Fetch the account list from the Apex controller
        helper.getsObjectRecs(component);
        helper.showHideReqDocButtonHelper(component);
        //helper.showHideSendStipButtonHelper(component);
        helper.fetchUserHelper(component, event, helper);
        helper.checkFunderAvailableHelper(component, event, helper);
    },
    
    RequestStip : function(component, event, helper) {
    	helper.RequestStipHelper(component, event, helper);
	},
	
    sendMailToSalesRep :function(component, event, helper) {
        helper.sendMailToSelectedStipsHelper(component, event);
	},
    
    reqDocsUploaded : function(component, event, helper) {
        helper.reqDocsUploadedHelper(component, event);
	},
    
    openFinalUWPopUp: function(component, event, helper) {
        helper.getUWDocumentListHelper(component,helper);
        component.set("v.showPopup",true);
    },
    
    closePopup : function(component, event, helper) {
    	component.set("v.showPopup",false);
	},
    
    sendMailForSelectedStips : function(component,event,helper){
        var stipIds = [];
        var getAllId = component.find("selectedCheckbox");
        if(! Array.isArray(getAllId)){
            if (getAllId.get("v.value") == true) {
                stipIds.push(getAllId.get("v.text"));
            }
        }else{
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.value") == true) {
                    stipIds.push(getAllId[i].get("v.text"));
                }
            }
        }
        console.log('stipIds=>'+stipIds.length);
        if(stipIds.length ==0){
            console.log('Not Selected=>');
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title" : 'Warning',
                "message" : "Please select atleast one Document",
                "type": 'warning'
            });
            $A.get("e.force:closeQuickAction").fire();
            resultsToast.fire();
            $A.get("e.force:refreshView").fire();
        }else{
            console.log('Send=>');
            helper.sendMailForSelectedStipsHelper(component, event, stipIds);
        }
        
    }
})