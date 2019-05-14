({
    initRecords: function(component, event, helper) {
        component.set("v.Spinner", true);
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
        var type = component.find("programType").get("v.value");
        if(type=='MCA'){
            component.set("v.showHideDailyPB",true);
            component.find("Daily_PB_Amount").set("v.disabled", true);
        }else{
            component.set("v.showHideDailyPB",false);   
            component.set("v.Offer.Holdback_Per__c","0");
            component.find("Daily_PB_Amount").set("v.disabled", true);
        }
    },
    
    save: function(component, event, helper) {
        var action = component.get("c.saveOffer");
        console.log('OfferList in save=>'+component.get("v.OfferList"));
        action.setParams({
            "lstOffer" : component.get('v.OfferList')
        });
        action.setCallback(this, function(response) {
            console.log('response -> '+response);
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.showSaveCancelBtn",false);
                var storeResponse = response.getReturnValue();
                for(var key in storeResponse){
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
                    $A.get("e.force:refreshView").fire();
                }
            }else{
                alert('Error');
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
        helper.getOtherUWDocumentListHelper(component,helper);
        component.set("v.showPopup",true);
    },
    
    closePopup : function(component, event, helper) {
        component.set("v.showPopup",false);
    },
    
    sendMailForSelectedStips : function(component,event,helper){
        component.set('v.requestContract', false);
        var stipIds = [];
        var getAllId;
        getAllId = component.find("selectedCheckbox");
        if(getAllId){
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
        }
        var otherStipIds = [];
        var getAllOtherId;
        var getAllOtherId = component.find("otherSelectedCheckbox");
        if(getAllOtherId){
            console.log('Inside getAllOtherId=>'+getAllOtherId);
            if(! Array.isArray(getAllOtherId)){
                console.log('Inside If');
                if (getAllOtherId.get("v.value") == true) {
                    otherStipIds.push(getAllOtherId.get("v.text"));
                }
            }else{
                console.log('Inside else');
                for (var i = 0; i < getAllOtherId.length; i++) {
                    if (getAllOtherId[i].get("v.value") == true) {
                        otherStipIds.push(getAllOtherId[i].get("v.text"));
                    }
                }
            }
        }
        if(otherStipIds == '' && stipIds == ''){
            console.log('Not Selected=>');
            component.set('v.requestContract', true);
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
            console.log('Inside Else=>');
            helper.sendMailForSelectedStipsHelper(component, event, stipIds,otherStipIds);
        }
            
    },
    
    openNewOfferPopUp: function(component, event, helper) {
        component.find("programType").set("v.value",null);
        component.find("Product_Name").set("v.value",null);
        component.set("v.Offer.Product_Name__c",null);
        component.set("v.programsList", null);
        component.set("v.funderList", null);
        helper.getFunder(component, event, helper);
        //var amount = component.get("v.loan.Amount_Requested__c");
        //component.set("v.Offer.Cloufi__Funding_Amount__c",amount);
        component.set("v.showNewOfferPopup",true);
    },
    
    saveNewOffer : function(component, event, helper) {
        var selectedFunder = component.find('Funder').get('v.value');
        var programId = component.find('InputSelectSingle').get('v.value');
        if(selectedFunder== null || selectedFunder == ''){
             var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title" : 'Warning',
                "message" : "Please select Funder",
                "type": 'Warning'
            });
            resultsToast.fire();
        }else if(programId == null || programId == ''){
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title" : 'Warning',
                "message" : "Program can not be blank",
                "type": 'Warning'
            });
            resultsToast.fire();
        }else{
            helper.saveOffer(component,event,helper);
        }
    },
    
    closeNewOfferPopup : function(component, event, helper) {
        helper.initializeOfferList(component, event, helper);
        helper.initializeNewOffer(component, event, helper);
        component.set("v.showNewOfferPopup",false);
    },
    
    onchangeFunding : function(component, event, helper) { 
        var fund = component.find("Funding_Amount").get("v.value");
        var fact = component.find("Factor_Rate").get("v.value");
         var paymentSchedule = component.get('v.Offer.Payment_Schedule__c');
        helper.onchangePayback(component, event, helper,fund,fact,paymentSchedule);
    },
    
    leaveChange: function(component, event, helper) { 
        helper.calculatePayback(component, event, helper);
        var type = component.find("programType").get("v.value");
        var pType = component.find("programType").get("v.value");
        return true;
    },
    
    getProgramList : function(component, event, helper){
        component.set('v.Spinner', true);
        var accountId = component.find('Funder').get('v.value');
        var action = component.get("c.getProgramDetails");
        action.setParams({
            accId : accountId
        });
        action.setCallback(this,function(response){
            var programList = response.getReturnValue();
            if(accountId != '' && accountId != null){   
                if(response.getState() === 'SUCCESS'){
                    component.set("v.programsList", programList);
                }
            }else{
                component.set("v.programsList",null);
            }
        });
        $A.enqueueAction(action); 
    },
    
    onPaymentScheduleChange : function(component, event, helper){
        var fund = component.find("Funding_Amount").get("v.value");
        var fact = component.find("Factor_Rate").get("v.value");
        var paymentSchedule = component.get('v.Offer.Payment_Schedule__c');
        helper.onchangePayback(component, event, helper,fund,fact,paymentSchedule);
    },

    onChangeOriginationFee :  function(component, event, helper){
        var origFee = component.find('Origination_Fee').get('v.value');
        if(origFee != null && origFee != ""){
            if(origFee.includes('-')){
                origFee = origFee.replace(/-/g, '');
                //component.find('Funding_Amount').set('v.value', val);
                component.set("v.Offer.Origination_Fee__c",origFee);
            }
        }
    },

    onChangeAdditionalFee : function(component, event, helper){
        var addFee = component.find('Additional_Fees').get('v.value');
        if(addFee != null && addFee != ""){
            if(addFee.includes('-')){
                addFee = addFee.replace(/-/g, '');
                //component.find('Funding_Amount').set('v.value', val);
                component.set("v.Offer.Additional_Fees__c",addFee);
            }
        }
    }
})