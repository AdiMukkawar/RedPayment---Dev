({
	initRecords: function(component, event, helper) {
		helper.getAccountIDNameList(component, event, helper);
        var paymentIn = component.find("paymentInCheckbox").get("v.value");
		console.log('Init paymentIn=>'+paymentIn);
		var paymentOut = component.find("paymentOutCheckbox").get("v.value");
		console.log('Init paymentOut=>'+paymentOut);
		
	},

	checkBoxPaymentOut: function(component, event, helper){
		var paymentOut = component.find("paymentOutCheckbox").get("v.value");
		console.log('paymentOut=>'+paymentOut);
	},

	checkBoxPaymentIn: function(component, event, helper){
		var paymentIn = component.find("paymentInCheckbox").get("v.value");
		console.log('paymentIn=>'+paymentIn);
	},

	getPayments : function(component, event, helper){
		console.log('Inside getPayments=>');
	},

    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
   },
    
    hideSpinner : function(component,event,helper){
       component.set("v.Spinner", false);
    }
})