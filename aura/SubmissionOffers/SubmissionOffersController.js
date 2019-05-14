({
    initRecords: function(component, event, helper) {
        var action = component.get("c.fetchOffer");
        action.setParams({
            'subId': component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            /*if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                //console.log(JSON.stringify(storeResponse));
                component.set("v.OfferList", storeResponse);
                var aList = [];
                aList =  component.get("v.OfferList");
                if(aList.length <= 0){
                    component.set("v.OfferList", null);	       
                }
            }*/
            if (state === "SUCCESS") {
                var offers = response.getReturnValue();
                if(offers.length > 0){
                    var newlst =[];
                    for(var i = 0  ; i < offers.length ; i++){
                        offers[i].CreatedDate = $A.localizationService.formatDate(offers[i].CreatedDate, "MM/DD/YYYY");
                        newlst.push(offers[i]);
                    }
                    component.set("v.OfferList", newlst);
                }else{

                    component.set("v.OfferList", null);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
		component.set("v.Spinner", true); 
	},
    
	// this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
		component.set("v.Spinner", false);
    },	
    save: function(component, event, helper) {
        var action = component.get("c.saveOffer");
        action.setParams({
            'lstOffer': component.get("v.OfferList")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
				component.set("v.showSaveCancelBtn",false);
                var storeResponse = response.getReturnValue();
                console.log('storeResponse=>'+storeResponse);
                for(var key in storeResponse){
					console.log('key : '+ key+ 'Map value: ', storeResponse[key]);
					var resultsToast = $A.get("e.force:showToast");
                    helper.refreshOfferList(component, event, helper);
					resultsToast.setParams({
						"title" : key,
						"message" : storeResponse[key],
						"type": key
					});
					$A.get("e.force:closeQuickAction").fire();
					resultsToast.fire();
					$A.get("e.force:refreshView").fire();
				}
            }
        });
        $A.enqueueAction(action);
    },
    createRecord : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Cloufi__Offers__c"
        });
        createRecordEvent.fire();
    },	
    
    cancel : function(component,event,helper){
        var action = component.get("c.cancelOffer");
        action.setParams({
            'lstOffer': component.get("v.OfferList")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.OfferList", storeResponse);
                component.set("v.showSaveCancelBtn",false);
                //alert('Updated...');
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title" : '',
                    "message" : "",
                    "type": ''
                });
                $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
            }
        });
        $A.enqueueAction(action);
        
    },      
})