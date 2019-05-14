({
  
    doInit: function(component, event, helper) {
        helper.fetchPickListVal(component, 'Status__c', 'ratingPicklistOpts');
        helper.fetchUserHelper(component, event, helper);
        //helper.getLendersHelper(component, event, helper);  
        //helper.getLendersNameHelper(component, event, helper);          
    },
  
   
    inlineEditRating : function(component,event,helper){  
        component.set("v.ratingEditMode", true);
        component.find("accRating").set("v.options" , component.get("v.ratingPicklistOpts"));
        setTimeout(function(){
            component.find("accRating").focus();
        }, 100);
    },
  
    inlineEditComment : function(component,event,helper){  
        component.set("v.commentEditMode", true);
        setTimeout(function(){ 
            component.find("CommentId").focus();
        }, 100);
    },

    closeCommentBox : function (component, event, helper) {
        component.set("v.commentEditMode", false);
    },
    onCommentChange : function(component,event,helper){ 
        //if(event.getSource().get("v.value").trim() != ''){ 
            component.set("v.showSaveCancelBtn",true);
        //}
    },  
    
    onRatingChange : function(component,event,helper){
        component.set("v.showSaveCancelBtn",true);
    },    
  
    closeRatingBox : function (component, event, helper) {
        component.set("v.ratingEditMode", false);
    },

    deleteUW : function(component, event, helper) {
       console.log('Inside Delete');
       helper.deleteUWHelper(component, event);
    },

    closeUWDeletePopup : function(component, event, helper) {
        component.set("v.showDeletePopup",false);
    },

    openUWDeletePopup : function(component, event, helper) {
        console.log('delUW Id=>'+event.target.id);
        var uwId = event.target.id;
        helper.getUWNameHelper(component, event, helper,uwId);
        component.set("v.showDeletePopup",true);
        component.set("v.uwIDToDelete",event.target.id);
    },

    delUW : function(component, event, helper) {
        helper.deleteUWHelper(component, event, helper);
        component.set("v.showDeletePopup",false);
    },

})