({
    
    initializeOfferList : function(component,event,helper){
        console.log('inside initializeOfferList');
        var action = component.get("c.fetchOffer");
        action.setParams({
            'oppId': component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('initRecords state=>'+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('initRecords storeResponse=>'+storeResponse);
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
    
    initializeNewOffer : function(component,event,helper){
        console.log('inside initializeNewOffer');
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
            console.log('initRecords state=>'+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('initRecords storeResponse=>'+storeResponse);
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
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('storeResponse=>'+storeResponse);
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
    sendMailForSelectedStipsHelper : function(component, event, selectedStipsIds) {
        console.log('Inside RequestContract');
        var action = component.get("c.requestContract");
        console.log('selectedStipsIds=>'+selectedStipsIds);
        action.setParams({
            'stipIds': selectedStipsIds,
             oppId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var storeResponse = response.getReturnValue();
                console.log('storeResponse=>'+storeResponse);
                for(var key in storeResponse){
                    console.log('key : '+ key+ 'Map value: ', storeResponse[key]);
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
                console.log('result>>'+result);
                if(result == true){
                    component.set("v.isSignedApp",true);
                }else{
                    component.set("v.isSignedApp",false);
                }
            }
            var app = component.get("v.isSignedApp");
            console.log('app>>'+app);
        }); 
        $A.enqueueAction(action);       
    },
    saveOffer : function(component, event, helper){      
        console.log('Inside helper');    
        var term = component.find("Terms_In_Months").get("v.value");
        var progType = component.find("programType").get("v.value");
        var advanceAmt = component.find("Funding_Amount").get("v.value");
        var factorRate = component.find("Factor_Rate").get("v.value");
		var funderId = component.find("Funder").get("v.value");
		var dailyPB = component.find("Daily_PB_Amount").get("v.value");
        var payBackAmt = component.find("Payback_Amount").get("v.value");
        var perGross = component.find("Percentage_Of_Gross").get("v.value");
        var holdback = component.find("Holdback_Per").get("v.value");
        console.log('perGross>>'+perGross);
        console.log('holdback>>'+holdback);
        
        component.set("v.Offer.Factor_Rate__c",factorRate);
        component.set("v.Offer.Cloufi__Funding_Amount__c",advanceAmt);
        component.set("v.Offer.Cloufi__Terms_In_Months__c",term);
        component.set("v.Offer.Program_Type__c",progType);
        component.set("v.Offer.Cloufi__Funder__c",funderId);
        component.set("v.Offer.Funder_Dev__c",funderId);

        var program = component.get("v.selectedProgram");
        var action = component.get("c.saveNewOfferController");
        action.setParams({
            objOffer : component.get("v.Offer"),
            oppId: component.get("v.recordId"),
            programId:program
        });
        action.setCallback(this, function(response){
            var state = response.getState();
           	var isRender = false;
            console.log('State ->'+state); 
            if(state == "SUCCESS") {
               /* var offer = response.getReturnValue();
                console.log('offer ->'+offer.Id);
                var resultsToast = $A.get("e.force:showToast");
                console.log('resultsToast ->'+resultsToast);*/
                
                var storeResponse = response.getReturnValue();
            	for(var key in storeResponse){
                console.log('key : '+ key+ 'Map value: ', storeResponse[key]);
                 var resultsToast = $A.get("e.force:showToast");
                 //var createRecordEvent = $A.get("e.force:createRecord");
                if(resultsToast != undefined){
                    resultsToast.setParams({
                        "title" : key,
                        "message" : storeResponse[key],
                        "type": key
                    });
                    
                    if((holdback <= 100 && perGross ==0) || (perGross <= 100 && holdback == 0)){
                       isRender = true;
                    }
                    console.log('isRender>>'+isRender);
                    resultsToast.fire();
                     if(isRender && key != 'WARNING'){
                        $A.get("e.force:closeQuickAction").fire();
                        
                        this.initializeOfferList(component, event, helper);
                        $A.get("e.force:refreshView").fire();
                    } else{
                        console.log('in else');
                    }
                    
                } 
                    if(key == 'WARNING'){
                         component.set("v.isSave",false);
                         component.set("v.showNewOfferPopup",true);
                    }else{
                        component.set("v.programsList",null);
                        component.set("v.showNewOfferPopup",false);
                    }
               //createRecordEvent.fire();
            }  
            }
        }); 
        $A.enqueueAction(action);       
    },
    getProgramDetails : function(component, event, helper,accountId) {
        console.log('in get program method');
        component.set("v.Spinner", true); 
        
        //component.set("v.Spinner", true); 
        var action = component.get("c.getProgramDetails");
		
        action.setParams({
            accId : accountId
        });

        action.setCallback(this,function(response){
        var val = response.getReturnValue();
        var tempList = [];
        tempList = val;
        console.log('299 State>>'+response.getState());
        if(accountId != '' && accountId != null){   
                if(response.getState()==='SUCCESS'){
                    if(! $A.util.isEmpty(tempList)){
                        component.set("v.programsList",tempList);
                        console.log('programsList'+component.get("v.programsList"));
                        console.log('List==>'+tempList[0].Id);
                    }
                }
            }else{
                component.set("v.programsList",null);
            }
        });
        
        $A.enqueueAction(action); 
    },
    
    calculatePerOfGross: function(component, event, helper,dailyPBAmount) {
        console.log('Inside per of gross method');
        var grossProfit = component.find("Gross_Profit").get("v.value");
        var progType = component.find("programType").get("v.value");
        var perOfGross = 0;
        if(progType != 'MCA' && dailyPBAmount != null && dailyPBAmount != '' && grossProfit != null && grossProfit != 0 && grossProfit != ''){
            perOfGross = ((dailyPBAmount * 20) / grossProfit).toFixed(2);
        }else{
            perOfGross = 0;
        }
        component.set("v.Offer.Cloufi__Percentage_Of_Gross__c",perOfGross);
    },
    
    calculateDailyPaybackAmt: function(component, event, helper,paybackAmount) {
        console.log('inside dailyPB amount method');
        var term = component.find("Terms_In_Months").get("v.value");
        var progType = component.find("programType").get("v.value");
        var dailyPBAmt = 0;
        if(progType != 'MCA' && paybackAmount != null && (term != '' && term != null && term != 0)){
            console.log('term days >>'+ term*21);
            dailyPBAmt = paybackAmount / (term*21);
        }else {
            dailyPBAmt = 0;
        }
        component.set("v.Offer.Cloufi__Daily_PB_Amount__c",dailyPBAmt);
        this.calculatePerOfGross(component, event, helper,dailyPBAmt);
        component.find("Daily_PB_Amount").set("v.disabled", true);
         //if(paybackAmount != null && (term == 0 || term == '' || term == null))
    },
    
    onchangePayback: function(component, event, helper,val,fact) {
        console.log('Inside onchangePayback');
        console.log('val=>'+val);
        console.log('fact=>'+fact);
        var paybackAmount = 0;
        if(val != null && (fact != '' && fact != null)){
            console.log('inside first If');
            paybackAmount = val*fact;
        }else{
            paybackAmount = 0;
        }
        
        /*else if(val != null && (fact == null || fact == '')){
            console.log('inside second If');
            paybackAmount = val;
        }else if(val == null || val == '' || (val == null && fact == null)){
            console.log('inside third If');
            paybackAmount = 0;  
        }*/
        console.log('paybackAmount>>'+paybackAmount);
        component.set("v.Offer.Cloufi__Payback_Amount__c",paybackAmount);
        this.calculateDailyPaybackAmt(component, event, helper,paybackAmount);
        this.updatePerGross(component, event, helper);
        var Payback = val;
        var termList = document.getElementsByClassName(
            'OfferTermClass');
        var DailyPBList = document.getElementsByClassName(
            'OfferDailyClass');
        var PercentageList = document.getElementsByClassName(
            'OfferPerGrossClass');
        console.log('PercentageList=>'+PercentageList);
        console.log('termList=>'+termList);
        //var pType = $('.progType ').val();
        var pType = component.find("programType").get("v.value");
        console.log('pType=>'+pType);

        var term = component.find("Terms_In_Months").get("v.value");
        console.log('term=>'+term);
        //term = term.replace(/,/g, '');
        //term = term.replace(/\s/g,'');
        
       if (term != null && Payback != null) {
            var DailyPB = (parseFloat(Payback) / parseFloat(term)).toFixed(2);
            console.log('DailyPB=>'+DailyPB);
            /*if(DailyPBList.length > 0){
                if(DailyPBList[DailyPBList.length - 1]){
                    DailyPBList[DailyPBList.length - 1].value = DailyPB;
                }
            }else{
                if(DailyPBList[0]){
                    DailyPBList[DailyPBList.length].value = DailyPB;
                }
            }*/
            //component.set("v.Offer.Cloufi__Daily_PB_Amount__c",DailyPB);
            //component.set("v.Daily_PB_Amount",DailyPB);
        }

        if (isNaN(DailyPB) || !isFinite(DailyPB)) {
            /*if(DailyPBList.length > 0){
                if(DailyPBList[DailyPBList.length - 1]){
                    DailyPBList[DailyPBList.length - 1].value = 0;
                }
            }else{
                if(DailyPBList[0]){
                    DailyPBList[0].value = 0;
                }
            }*/
            component.set("v.Offer.Cloufi__Daily_PB_Amount__c","0");
        }

        /*var MonthlyGross = $("[id$='LoanMonthSale']").val();
        MonthlyGross = MonthlyGross.replace('$', '');
        MonthlyGross = MonthlyGross.replace(/,/g, '');
        MonthlyGross = MonthlyGross.replace(/\s/g,'');*/

        var grossPro = component.find("Gross_Profit").get("v.value");
        if (grossPro != null && DailyPB != null && pType != 'MCA') {
            var Percentage = (parseFloat(DailyPB * 20) / parseFloat(grossPro)).toFixed(2);
            console.log('Per%->'+Percentage);
            //PercentageList[PercentageList.length - 1].value = Percentage;
            component.set("v.Offer.Percentage_Of_Gross",DailyPB);                                            
        }
        if (isNaN(Percentage) || !isFinite(Percentage)) {
            //PercentageList[PercentageList.length - 1].value = 0;
            component.set("v.Offer.Percentage_Of_Gross","0");
        }
        
    },
    updatePerGross: function(component, event, helper) {
        console.log('Inside updatePerGross');
        //var type = $('.progType ').val();
        var type = component.find("programType").get("v.value");
        var perGross = component.find("Percentage_Of_Gross").get("v.value");
        console.log('type'+type);
        console.log('perGross'+perGross);
        if(type =='MCA'){
            //$(".OfferPerGrossClass").val("0");
            component.set("v.Offer.Percentage_Of_Gross","0");
        }
    },

    calculatePayback: function(component, event, helper) {
        console.log('Inside calculatePayback');
        /*var PaybackList = document.getElementsByClassName(
            'OfferPaybackClass');
        var FunderList = document.getElementsByClassName(
            'OfferFundedClass');
        var FactorList = document.getElementsByClassName(
            'OfferFactorClass');
        var PercentageList = document.getElementsByClassName(
            'OfferPerGrossClass');
        var Fund = FunderList[FunderList.length - 1].value;
        var Fact = FactorList[FactorList.length - 1].value;
        var MonthlyGross = $("[id$='LoanMonthSale']").val();
        var pType = $('.progType ').val();
        console.log('pType'+pType);
        Fund = Fund.replace('$', '');
        Fund = Fund.replace(/,/g, '');
        Fund = Fund.replace(/\s/g,'');
        MonthlyGross = MonthlyGross.replace('$', '');
        MonthlyGross = MonthlyGross.replace(/,/g, '');
        MonthlyGross = MonthlyGross.replace(/\s/g,'');

        if (Fund != null && Fact != null) {
            var Payback = (parseFloat(Fund) * parseFloat(Fact))
                .toFixed(2);
            PaybackList[PaybackList.length - 1].value = Payback
        }
        if (isNaN(Payback) || !isFinite(Payback)) {
            PaybackList[PaybackList.length - 1].value = 0;
        }

        //calculate DailyPB amount
        var termList = document.getElementsByClassName(
            'OfferTermClass');
        var DailyPBList = document.getElementsByClassName(
            'OfferDailyClass');
        var term = termList[termList.length - 1].value;
        term = term.replace(/,/g, '');

        if (term != null && Payback != null) {
            var DailyPB = (parseFloat(Payback) / parseFloat(term)).toFixed(2);
            console.log('DailyPB ->'+DailyPB);
            console.log('DailyPBList.length ->'+DailyPBList.length);
            console.log('DailyPBList ->'+DailyPBList[0]);
            if(DailyPBList.length > 0){
                if(DailyPBList[DailyPBList.length - 1]){
                    DailyPBList[DailyPBList.length - 1].value = DailyPB;
                }
            }else{
                if(DailyPBList[0]){
                    DailyPBList[DailyPBList.length].value = DailyPB;
                }
            }                        
        }
        if (isNaN(DailyPB) || !isFinite(DailyPB)) {
            if(DailyPBList.length > 0){
                if(DailyPBList[DailyPBList.length - 1]){
                    DailyPBList[DailyPBList.length - 1].value = 0;
                }
            }else{
                if(DailyPBList[0]){
                    DailyPBList[0].value = 0;
                }
            }
        }
        console.log(':::DailyPB::', DailyPB);
        console.log(':::MonthlyGross::', MonthlyGross);
        console.log(':::PercentageList::', PercentageList);
        if (DailyPB != null && '{!loan.Cloufi__Gross_Profit__c}' != null && pType != 'MCA') {
            
            Percentage = (parseFloat(DailyPB * 20) / parseFloat('{!loan.Cloufi__Gross_Profit__c}')).toFixed(2);
            console.log('Per%->'+Percentage);
            PercentageList[PercentageList.length - 1].value = Percentage;                                            
        }else if(pType == 'MCA'){
            $(".OfferPerGrossClass").val("0");
            $(".OfferDailyClass").val("0");
            
        }
        if (isNaN(Percentage) || !isFinite(Percentage)) {
            PercentageList[PercentageList.length - 1].value = 0;
        }*/

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
})