({
    // this function execute on load of page
    initRecords : function(component, event, helper) {
        component.set('v.Spinner', true);
        helper.initializeRecords(component, event, helper);
        helper.getSyndicationRecords(component, event, helper);
        helper.getPicklistValues(component, 'Cloufi__Status__c');
        helper.getPicklistValues(component, 'Cloufi__Payment_Type__c');     
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        component.set("v.Spinner", false);
    },
    
    showFilteredRecords : function(component, event, helper){
        helper.getFilteredPayments(component, event, helper);
    },
    
    clearFilteredRecords : function(component, event, helper){
        helper.clearRecords(component, event, helper);
    },
    
    handleClick1 : function(component, event, helper){
        var recordType1 = component.get('v.recordType1');
        if(recordType1 != true){
            component.set('v.recordType1', true);
        }else{
            component.set('v.recordType1', false);
        }
    },
    
    handleClick2 : function(component, event, helper){
        var recordType2 = component.get('v.recordType2');
        if(recordType2 != true){
            component.set('v.recordType2', true);
        }else{
            component.set('v.recordType2', false);
        }
    },
    
    fiterSection : function(component, event, helper) {
        helper.helperFilterSection(component,event,'filter');
    },
    
    /* validatedate : function(component, event, helper) {
        var date_val = component.find("effFrom").get("v.value");
        var date_formatter = new Date(date_val);
        if(!moment(date_formatter, 'MM/DD/YYYY', true).isValid()){
            alert("invalid date please enter in MM/DD/YYYY format");
        }
    },*/
    
    validateEffDateFrom : function(component, event, helper) {
        var dtStr = component.find("effFrom").get("v.value");
        if (helper.isDate(component, dtStr) == false){
            component.set('v.displayError1', true);
            return false;
        }else{
            component.set('v.displayError1', false);
            return true;
        }
    },
    
    validateEffDateTo : function(component, event, helper) {
        var dtStr = component.find("effTo").get("v.value");
        if (helper.isDate(component, dtStr) == false){
            component.set('v.displayError2', true);
            return false;
        }else{
            component.set('v.displayError2', false);
            return true;
        }
    },
    
    validateSettDateFrom : function(component, event, helper) {
        var dtStr = component.find("settFrom").get("v.value");
        if (helper.isDate(component, dtStr) == false){
            component.set('v.displayError3', true);
            return false;
        }else{
            component.set('v.displayError3', false);
            return true;
        }
    },
    
    validateSettDateTo : function(component, event, helper) {
        var dtStr = component.find("settTo").get("v.value");
        if (helper.isDate(component, dtStr) == false){
            component.set('v.displayError4', true);
            return false;
        }else{
            component.set('v.displayError4', false);
            return true;
        }
    },
})