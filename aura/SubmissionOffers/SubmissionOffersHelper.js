({
    /*requiredFieldValidation : function(component,event) {
        var allRecords = component.get("v.OfferList");
        var isValid = false;
        for(var i = 0; i < allRecords.length;i++){
            if((allRecords[i].Cloufi__Offer_Status__c == 'Rejected' || allRecords[i].Cloufi__Offer_Status__c == 'Expired') && isValid == false){        
                var toastEvent = $A.get("e.force:showToast");
                var resultsToast = $A.get("e.force:showToast");
                isValid = true;
            } 
        }
        return isValid;
    },*/
    refreshOfferList: function(component,helper,event){
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
    
    fetchUserHelper : function(component,helper,event) {
        var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // set current user information on userInfo attribute
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
})