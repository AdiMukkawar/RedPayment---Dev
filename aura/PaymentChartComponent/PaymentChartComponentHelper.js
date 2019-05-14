({
    // Display all records on load of page
    initializeRecords : function(component, event, helper){
        component.set('v.checkBox1', false);
        component.set('v.checkBox2', false);
        component.set('v.recordType1', null);
        component.set('v.recordType2', null);
        component.find("syndication").set("v.value", null);
        component.find("type").set("v.value", null);
        component.find("effTo").set("v.value", null);
        component.find("effFrom").set("v.value", null);
        component.find("settTo").set("v.value", null);
        component.find("settFrom").set("v.value", null);
        component.find("status").set("v.value", null);
        var action = component.get('c.getPaymentRecords');
        console.log('recordId--->'+component.get('v.recordId'));
        action.setParams({
            oppId : component.get('v.recordId')
        })
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                var val = response.getReturnValue();
                component.set('v.paymentList', val);
                if(val != null && val != ''){
                    var totalAmount = 0;
                    var totalAmountParse = 0;
                    for(var i = 0 ; i < val.length ; i++){
                        totalAmount = totalAmount + val[i].Cloufi__Payment_Amount__c;
                    }
                    component.set('v.paymentAmount', totalAmount);
                }
            }
        });
        $A.enqueueAction(action); 
    },
    
    // Method to fetch syndicating records
    getSyndicationRecords : function(component, event, helper) {
        console.log('In getSyndicationRecords');
        var action = component.get('c.getSyndication');
        action.setParams({
            oppId : component.get('v.recordId')
        })
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state-->'+state);
            if(state == 'SUCCESS')
            {
                var val = response.getReturnValue();
                component.set('v.syndiactionList', val);
            }
        });
        $A.enqueueAction(action);
    },
    
    // Method to fetch picklist values 
    getPicklistValues : function(component, fieldName){
        var action = component.get('c.getPicklistValues');
        action.setParams({
            "fld": fieldName
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                if(fieldName == 'Cloufi__Status__c')
                {
                    component.set('v.statusPicklistValues', allValues);
                }else{
                    component.set('v.typePicklistValues', allValues);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    // Method to fetch filtered records
    getFilteredPayments : function(component, fieldName, elementId){
        var action = component.get('c.getFilteredRecords');
        var effectiveDate = component.find("effFrom").get("v.value");
        var effectiveDate1 = component.find("effTo").get("v.value");
        console.log('recordType1---->'+component.get("v.recordType1"));
        console.log('recordType2----->'+component.get("v.recordType2"));
        action.setParams({
            oppId : component.get('v.recordId'),
            syndication : component.find("syndication").get("v.value"),
            PaymentType : component.find("type").get("v.value"),
            PaymentRecordType1 : component.get("v.recordType1"),
            PaymentRecordType2 : component.get("v.recordType2"),
            EffectiveDateFrom : effectiveDate,
            EffectiveDateTo : effectiveDate1,
            SettlementDateFrom : component.find("settFrom").get("v.value"),
            SettlementDateTo : component.find("settTo").get("v.value"),
            PaymentStatus : component.find("status").get("v.value")
        });
        console.log('syndication=>'+component.find("syndication").get("v.value"));
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var data = response.getReturnValue();
                component.set('v.paymentList', data);
                if(data != null && data != ''){
                    var totalAmount = 0;
                    var totalAmountParse = 0;
                    for(var i = 0 ; i < data.length ; i++){
                        totalAmount = totalAmount + data[i].Cloufi__Payment_Amount__c;
                    }
                    component.set('v.paymentAmount', totalAmount);
                }
            }
        });
        $A.enqueueAction(action); 
    },
    
    // Method to clear records
    clearRecords : function(component, event, helper){
        this.initializeRecords(component, event, helper);
        component.set('v.displayError1', false);
        component.set('v.displayError2', false);
        component.set('v.displayError3', false);
        component.set('v.displayError4', false);
    },
    
    // Method to toggle filter Section
    helperFilterSection : function(component,event,secId) {
        var acc = component.find(secId);
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
        }
    },
    
    stripCharsInBag : function(s, bag){
        var i;
        var returnString = "";
        // Search through string's characters one by one.
        // If character is not in bag, append to returnString.
        for (i = 0; i < s.length; i++){   
            var c = s.charAt(i);
            if (bag.indexOf(c) == -1) 
                returnString += c;
        }
        return returnString;
    },
    
    isIntegerDate : function(s){
        var i;
        for (i = 0; i < s.length; i++){   
            // Check that current character is number.
            var c = s.charAt(i);
            if (((c < "0") || (c > "9"))) 
                return false;
        }
        // All characters are numbers.
        return true;
    },
    
    daysInFebruary : function(year){
        return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
    },
    
    DaysArray : function(n){
        for (var i = 1; i <= n; i++) {
            this[i] = 31;
            if (i==4 || i==6 || i==9 || i==11) {
                this[i] = 30;
            }
            if (i==2) {
                this[i] = 29;
            }
        } 
        return this;
    },
    
    isDate : function(component, dtStr){
        var daysInMonth = this.DaysArray(12);
        console.log('dtStr=>'+dtStr);
        if(dtStr != null){
            var dtCh = "-";
            var pos1 = dtStr.indexOf(dtCh);
            var pos2 = dtStr.indexOf(dtCh, pos1+1);
            var strMonth = dtStr.substring(pos1+1,pos2);
            var strDay = dtStr.substring(pos2+1);
            var strYear = dtStr.substring(0,pos1);
            var strYr = strYear;
            if (strDay.charAt(0)=="0" && strDay.length > 1) {
                strDay = strDay.substring(1);
            }
            
            if (strMonth.charAt(0)=="0" && strMonth.length>1) {
                strMonth=strMonth.substring(1);
            }
            
            for (var i = 1; i <= 3; i++) {
                if (strYr.charAt(0)=="0" && strYr.length>1) 
                    strYr=strYr.substring(1)
                    }
            var month = parseInt(strMonth);
            var day = parseInt(strDay);
            var year = parseInt(strYr);
            if((pos1 == -1 || pos2 == -1 || dtStr.includes('//')) && dtStr != '') {
                return false;
            }else{
                return true;
            }
        }
    },
})