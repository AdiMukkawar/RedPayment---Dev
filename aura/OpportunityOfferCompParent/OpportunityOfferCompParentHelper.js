({
    initializeOfferList : function(component,event,helper){
        var action = component.get("c.fetchOffer");
        action.setParams({
            'oppId': component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.OfferList", storeResponse);
                var aList = [];
                aList =  component.get("v.OfferList");
                if(aList.length <= 0){
                    component.set("v.OfferList", null);        
                }
            }
        });
        $A.enqueueAction(action);        
    },
    
    initializeNewOffer : function(component, event, helper){
        var action = component.get("c.initNewOffer");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Offer", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    refreshOfferList: function(component,helper,event){
        var action = component.get("c.fetchOffer");
        action.setParams({
            'oppId': component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.OfferList", storeResponse);
                var aList = [];
                aList =  component.get("v.OfferList");
                if(aList.length <= 0){
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
    
    checkOpportunityStageHelper : function(component,helper,event) {
        var action = component.get("c.isOppInApprovedStage");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            if(state == "SUCCESS"){
                component.set("v.oppApprovedStage", response);
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
        });
        $A.enqueueAction(action);
    },
    
    getOppHelper : function(component,helper,event) {
        var action = component.get("c.getCurrentOpp");
        action.setParams({
            oppId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // set current user information on userInfo attribute
                component.set("v.loan", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
    
    getUWDocumentListHelper:function(component,helper) {
        var action = component.get("c.getCompletedUWDocumentList");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            if(state == "SUCCESS"){
                component.set("v.RemainingStips",data.getReturnValue());
            }else if(state = "ERROR"){
                alert('Unknown error');
            }
        });
        $A.enqueueAction(action);
    },

    getOtherUWDocumentListHelper:function(component,helper) {
        var action = component.get("c.getOtherUWDocumentList");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            if(state == "SUCCESS"){
                component.set("v.otherStips",data.getReturnValue());
                console.log('Other Docs=>'+data.getReturnValue());
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
        });
        $A.enqueueAction(action);
        
    },
    
    sendMailForSelectedStipsHelper : function(component, event, selectedStipsIds,otherSelectedStipsIds) {
        var action = component.get("c.requestContract");
        action.setParams({
            'stipIds': selectedStipsIds,
            oppId: component.get("v.recordId"),
            'otherStipIds':otherSelectedStipsIds
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                component.set('v.requestContract', true);
                var storeResponse = response.getReturnValue();
                for(var key in storeResponse){
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title" : key,
                        "message" : storeResponse[key],
                        "type": key
                    });
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire();
                    $A.get("e.force:refreshView").fire();
                    component.set("v.showPopup",false);
                    this.checkOpportunityStageHelper(component, event);
                }
            }else if(state = "ERROR"){
                alert('Unknown error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    checkOfferChosen : function(component,helper,event) {
        var action = component.get("c.isOfferChosen");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            if(state == "SUCCESS"){
                component.set("v.isOfferChosen", response);
            }else if(state = "ERROR"){
                alert('Unknown error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    requDocsAvail : function(component,helper,event) {
        var action = component.get("c.isReqDocsAvailable");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            if(state == "SUCCESS"){
                component.set("v.requDocsAvailable", response);
            }else if(state = "ERROR"){
                alert('Unknown error');
            }
        });
        $A.enqueueAction(action);
    },
    
    checkForSignedApplication : function(component, event, helper){      
        var action = component.get("c.checkForSignedApp");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('State ->'+state); 
            if(state == "SUCCESS") {
                var result = response.getReturnValue();
                if(result == true){
                    component.set("v.isSignedApp",true);
                }else{
                    component.set("v.isSignedApp",false);
                }
            }
            var app = component.get("v.isSignedApp");
        }); 
        $A.enqueueAction(action);       
    },
    
    saveOffer : function(component, event, helper){   
        var term = component.find("Terms_In_Months").get("v.value");
        var progType = component.find("programType").get("v.value");
        var advanceAmt = component.find("Funding_Amount").get("v.value");
        var factorRate = component.find("Factor_Rate").get("v.value");
        var funderId = component.find("Funder").get("v.value");
        var dailyPB = component.find("Daily_PB_Amount").get("v.value");
        var payBackAmt = component.find("Payback_Amount").get("v.value");
        var holdback = component.find("Holdback_Per").get("v.value");
        
        component.set("v.Offer.Factor_Rate__c",factorRate);
        component.set("v.Offer.Cloufi__Funding_Amount__c",advanceAmt);
        component.set("v.Offer.Cloufi__Terms_In_Months__c",term);
        component.set("v.Offer.Program_Type__c",progType);
        component.set("v.Offer.Cloufi__Funder__c",funderId);
        component.set("v.Offer.Funder_Dev__c",funderId);
        
        var programId = component.find('InputSelectSingle').get('v.value');
        var FunderId = component.find('Funder').get('v.value');
        var action = component.get("c.saveNewOfferController");
        action.setParams({
            objOffer : component.get("v.Offer"),
            oppId   : component.get("v.recordId"),
            programId   :   programId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var isRender = false; 
            if(state == "SUCCESS") {
                var storeResponse = response.getReturnValue();
                for(var key in storeResponse){
                    var resultsToast = $A.get("e.force:showToast");
                    if(resultsToast != undefined){
                        resultsToast.setParams({
                            "title" : key,
                            "message" : storeResponse[key],
                            "type": key
                        });
                        if((holdback <= 100) || (holdback == 0)){
                            isRender = true;
                        }
                        resultsToast.fire();
                        if(isRender && key != 'WARNING'){
                           $A.get("e.force:closeQuickAction").fire();
                            this.initializeOfferList(component, event, helper);
                            $A.get("e.force:refreshView").fire();
                        }
                    } 
                    if(key == 'WARNING'){
                        component.set("v.showNewOfferPopup",true);
                    }else{
                        component.set("v.Spinner", true);
                        component.set("v.showNewOfferPopup",false); 
                    }
                }
            }
        }); 
        $A.enqueueAction(action);       
    },
    
    calculateDailyPaybackAmt: function(component, event, helper,paybackAmount,paymentSchedule) {
        var term = component.find("Terms_In_Months").get("v.value");
        var progType = component.find("programType").get("v.value");
        var dailyPBAmt = 0;
        if(progType != 'MCA' && paybackAmount != null && (term != '' && term != null && term != 0)){
            dailyPBAmt = (paybackAmount / (term*20)).toFixed(2);
        }else {
            dailyPBAmt = 0;
        }
        console.log('schedulePayment'+paymentSchedule);
        if(paymentSchedule == 'Weekly'){
            dailyPBAmt = (dailyPBAmt*5).toFixed(2);
        }
        component.set("v.Offer.Cloufi__Daily_PB_Amount__c",dailyPBAmt);
        component.find("Daily_PB_Amount").set("v.disabled", true);
    },
    
    onchangePayback: function(component, event, helper,val,fact,paymentSchedule) {
        console.log('Inside onchangePayback');
        console.log('val=>'+val);
        console.log('fact=>'+fact);
        var paybackAmount = 0;
        console.log('Inside onchangePayback');
        console.log('val=>'+val);
        console.log('fact=>'+fact);
        var paybackAmount = 0;
        if(val != null && val != ""){
            if(val.includes('-')){
                val = val.replace(/-/g, '');
                console.log('after Replace val=>'+val);
                //component.find('Funding_Amount').set('v.value', val);
                component.set("v.Offer.Cloufi__Funding_Amount__c",val);
            }
        }
        if(fact != null && fact != ""){
            if(fact.includes('-')){
                fact = fact.replace(/-/g, '');
                console.log('after Replace fact=>'+fact);
                //component.find('Funding_Amount').set('v.value', val);
                component.set("v.Offer.Factor_Rate__c",fact);
            }
        }
        var term = component.find("Terms_In_Months").get("v.value");
        if(term != null && term != ""){
            if(term.includes('-')){
                term = term.replace(/-/g, '');
                console.log('after Replace term=>'+term);
                //component.find('Funding_Amount').set('v.value', val);
                component.set("v.Offer.Cloufi__Terms_In_Months__c",term);
            }
        }
        if(val != null && (fact != '' && fact != null)){
            console.log('inside first If');
            paybackAmount = val*fact;
        }else{
            paybackAmount = 0;
        }
        console.log('paybackAmount>>'+paybackAmount);
        component.set("v.Offer.Cloufi__Payback_Amount__c",paybackAmount);
        this.calculateDailyPaybackAmt(component, event, helper,paybackAmount,paymentSchedule);
        var Payback = val;
        var termList = document.getElementsByClassName(
            'OfferTermClass');
        var DailyPBList = document.getElementsByClassName(
            'OfferDailyClass');
        var PercentageList = document.getElementsByClassName(
            'OfferPerGrossClass');
        var pType = component.find("programType").get("v.value");
        //var term = component.find("Terms_In_Months").get("v.value");
        console.log('Term=>'+term*20);
        var termsInMonth = term*20;
        if (term != null && Payback != null) {
            var DailyPB = (parseFloat(Payback) / parseFloat(termsInMonth)).toFixed(2);
            console.log('DailyPB=>'+DailyPB);
        }
        if (isNaN(DailyPB) || !isFinite(DailyPB)) {
            component.set("v.Offer.Cloufi__Daily_PB_Amount__c","0");
        }
    },
    
    fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.Offer"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },
    
    getFunder : function(component, event, helper) {
        var action = component.get("c.checkSubmissionCountry");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            if(state == "SUCCESS"){
                component.set('v.funderList', response);
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
        });
        $A.enqueueAction(action);
    },
})