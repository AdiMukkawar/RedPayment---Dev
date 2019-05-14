({
	doInit : function(component, event, helper) {
        helper.doInitHandler(component, event, helper);
    },
    
    OfferUpdate :function(component, event, helper) {
        console.log('Inside Controller');
    	helper.OfferUpdateHelper(component, event, helper);
    },
    
    ContractUpdate : function(component, event, helper) {
    	helper.ContractUpdateHelper(component, event, helper);
	},
    
    GeneralUpdate: function(component, event, helper) {
    	helper.GeneralUpdateHelper(component, event, helper);
	},
    
    FundingUpdate: function(component, event, helper) {
    	helper.FundingUpdateHelper(component, event, helper);
	},
    
    CommissionUpdate:function(component, event, helper) {
    	helper.CommissionUpdateHelper(component, event, helper);
	},
    
    sendEmail :function(component, event, helper) {
        helper.sendEmailHelper(component, event, helper);
    }
})