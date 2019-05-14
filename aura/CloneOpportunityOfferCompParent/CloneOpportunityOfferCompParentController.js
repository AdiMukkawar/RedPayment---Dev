({
    initRecords: function(component, event, helper) {
        helper.checkOpportunityStageHelper(component, event, helper);
        helper.fetchUserHelper(component, event, helper);
        helper.checkOfferChosen(component, event, helper);
        helper.requDocsAvail(component, event, helper);
        helper.getOppHelper(component, event, helper);
        helper.fetchPickListVal(component, 'Program_Type__c', 'programType');
		helper.initializeOfferList(component, event, helper);
        helper.initializeNewOffer(component, event, helper);
        helper.checkForSignedApplication(component, event, helper);
    },
    
    onPicklistChange: function(component, event, helper) {
        // get the value of select option
        //alert(event.getSource().get("v.value"));
        console.log('in program type method');
        var type = component.find("programType").get("v.value");
        if(type=='MCA'){
        	component.set("v.showHideDailyPB",true); 
            component.set("v.Offer.Cloufi__Percentage_Of_Gross__c","0");
            component.find("Daily_PB_Amount").set("v.disabled", true);
        }else{
            component.set("v.showHideDailyPB",false);   
            component.set("v.Offer.Holdback_Per__c","0");
            component.find("Daily_PB_Amount").set("v.disabled", true);
        }
        var fund = component.find("Funding_Amount").get("v.value");
        var fact = component.find("Factor_Rate").get("v.value");
        
        console.log('fund=>'+fund);
        console.log('fact=>'+fact);
        helper.onchangePayback(component, event, helper,fund,fact);
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
                    helper.checkOfferChosen(component, event, helper);
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire();
                    //this.initRecords(component, event, helper);
                    $A.get("e.force:refreshView").fire();
                    
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
    openFinalUWPopUp: function(component, event, helper) {
        helper.getUWDocumentListHelper(component,helper);
        component.set("v.showPopup",true);
    },
    closePopup : function(component, event, helper) {
        console.log('Inside Close');
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
        console.log('stipIds=>'+stipIds);
        helper.sendMailForSelectedStipsHelper(component, event, stipIds);
    },
    openNewOfferPopUp: function(component, event, helper) {
        //helper.getUWDocumentListHelper(component,helper);
        //helper.getOppHelper(component,helper);
        component.set("v.isSave",false);
        component.find("programType").set("v.value",null);
        component.find("Product_Name").set("v.value",null);
        component.set("v.Offer.Product_Name__c",null);
        
        component.set("v.programsList",null);
        var amount = component.get("v.loan.Amount_Requested__c");
        component.set("v.Offer.Cloufi__Funding_Amount__c",amount);
        
        component.set("v.showNewOfferPopup",true);
    },
    
    saveNewOffer : function(component, event, helper) {
        console.log('Inside saveNewOffer');
        helper.saveOffer(component,event,helper);
        component.set("v.isSave",true);
    },

    closeNewOfferPopup : function(component, event, helper) {
        console.log('Inside Close');
        helper.initializeOfferList(component, event, helper);
        helper.initializeNewOffer(component, event, helper);
        component.set("v.showNewOfferPopup",false);
    },

    /*getFunder : function(component, event, helper) { 
        //component.set("v.popupSpinner", true); 
        var funderId = component.find("Funder").get("v.value");
        console.log('funderId=>'+funderId);
        helper.getProgramDetails(component,event,helper,funderId);
    },*/
    getFunder : function(component, event, helper) { 
        var funderId = component.find("Funder").get("v.value");
        console.log('funderId=>'+funderId);
        if(funderId !=''){
            console.log('Inside If');
            var action = component.get("c.checkSubmissionCountry");
            action.setParams({
                oppId: component.get("v.recordId"),
                accId: funderId
            });
            action.setCallback(this,function(data){
                var state = data.getState();
                var response = data.getReturnValue();
                if(state == "SUCCESS"){
                    if(response){
                        component.set("v.isSave",false);
                        helper.getProgramDetails(component,event,helper,funderId);
                    }else{
                        component.set("v.isSave",true);
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title" : 'Error Message',
                            "message" : 'Please select Lender of the same submission country',
                            "type" : 'error'
                        });
                        $A.get("e.force:closeQuickAction").fire();
                        resultsToast.fire();
                        $A.get("e.force:refreshView").fire();
                    }
                }else if(state = "ERROR"){
                    alert('Unknow error');
                }
            });
            $A.enqueueAction(action);
        }
    },
    

    onchangeFunding : function(component, event, helper) { 
        console.log('onchangeFunding=>');
        var fund = component.find("Funding_Amount").get("v.value");
        var fact = component.find("Factor_Rate").get("v.value");
        console.log('fund=>'+fund);
        console.log('fact=>'+fact);
        helper.onchangePayback(component, event, helper,fund,fact);
    },
    leaveChange: function(component, event, helper) { 
        helper.calculatePayback(component, event, helper);
        var type = component.find("programType").get("v.value");
        var pType = component.find("programType").get("v.value");
        var originalGross = component.find("Percentage_Of_Gross").get("v.value");

        console.log('originalGross'+originalGross);
        
        if(type == 'MCA' || pType == 'MCA'){
            
        }else {
          
        }
        return true;
    }

})