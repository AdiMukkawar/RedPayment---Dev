({
    
    doInit: function(component, event, helper) {
        helper.fetchPickListVal(component, 'Cloufi__Offer_Status__c', 'ratingPicklistOpts');
        helper.fetchUserHelper(component, event, helper);
    },
    
    
    inlineEditRating : function(component,event,helper){  
        component.set("v.ratingEditMode", true);
        component.find("accRating").set("v.options" , component.get("v.ratingPicklistOpts"));
        setTimeout(function(){
            component.find("accRating").focus();
        }, 100);
    },
    
    
    onRatingChange : function(component,event,helper){
        console.log('onRatingChange=>'+component.find("accRating").get("v.value"));
        component.set("v.showSaveCancelBtn",true);
    },    
    
    closeRatingBox : function (component, event, helper) {
        component.set("v.ratingEditMode", false);
    },
    
})