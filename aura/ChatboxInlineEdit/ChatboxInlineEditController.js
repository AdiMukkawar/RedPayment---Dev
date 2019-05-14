({
    
    EditChat : function(component,event,helper){  
        component.set("v.chatEditMode", true);
        setTimeout(function(){
            component.find("editNote").focus();
        }, 100);
    },
    /*closeChatBox : function (component, event, helper) {
        console.log('closeChatBox');
        component.set("v.chatEditMode", false);
        if(event.getSource().get("v.value").trim() == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
            component.set("v.showSaveCancelBtn",false);
            component.set("v.repaymentShowSaveCancelBtn",false);
            component.set("v.operationalShowSaveCancelBtn",false);
            component.set("v.salesRepShowSaveCancelBtn",false);
        }
    },*/
    onChatChange : function(component,event,helper){
        var buttonVisibility = component.get("v.sourceComponent");
        console.log('buttonVisibility=>'+buttonVisibility);
        if(event.getSource().get("v.value").trim() != ''){
            component.set("v.showSaveCancelBtn",true);
        }
    },
    cancelEvent : function(component,event,helper) {
        console.log('Inside Component Event');
        var cmpEvent = component.getEvent("cmpSaveCancelEvent");
        cmpEvent.setParams( { "eventAction" : component.get("v.sourceComponent")+'-Cancel' });
        cmpEvent.fire();
        component.set("v.chatEditMode", false);
        component.set("v.showSaveCancelBtn",true);
    },
    saveEvent : function(component,event,helper) {
        console.log('Inside Component Event');
        var note = component.find("editNote").get("v.value");
       
        var count = (note.match(/p/g) || []).length;
        if(count == 2){
            note = note.replace('<p>', '');
            note = note.replace('</p>', '');
            note = note.trim();
        }
        console.log('note=>'+note);
        if(note.trim() == '' || note.trim() == null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title" : "Warning!",
                "message" : "Please Type message.",
                "type": "Warning"
            });
            toastEvent.fire();
        }else{
            var cmpEvent = component.getEvent("cmpSaveCancelEvent");
            cmpEvent.setParams( { "eventAction" : component.get("v.sourceComponent")+'-Save' });
            cmpEvent.fire();
            component.set("v.chatEditMode", false);
            component.set("v.showSaveCancelBtn",true);
        }
    },
})