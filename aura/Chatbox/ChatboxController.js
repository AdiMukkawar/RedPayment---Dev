({
    doInit : function(component, event, helper) {
        helper.getChatList(component, event, helper);
        helper.getSupportLenderChatList(component, event, helper);
        helper.getoperationalUWNoteList(component, event, helper);
        helper.getRepaymentNoteList(component, event, helper);
        helper.getSalesRepNoteList(component, event, helper);  
        helper.getLegalNoteList(component, event, helper);  
        helper.getLabelHelper(component, event, helper);
        helper.getSupportLenderLabelHelper(component, event, helper);
        helper.getinternalUWNoteList(component, event, helper);
        helper.fetchUserHelper(component, event, helper);
    },

    EditChat : function(component,event,helper){
        console.log('EditChat'+component.get("v.sourceComponent"));  
        component.set("v.chatEditMode", true);
        setTimeout(function(){
            component.find("InternalUWNote").focus();
        }, 100);
    },
    closeChatBox : function (component, event, helper) {
        component.set("v.chatEditMode", false);
        if(event.getSource().get("v.value").trim() == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    },

    handleComponentEvent : function(component,event,helper) {
        var getActionType = event.getParam("eventAction");
        console.log('getActionType=>'+getActionType);
        if(getActionType.includes('Cancel')){
            var chatSection = getActionType.replace('-Cancel','');
            console.log('Cancel chatSection=>'+chatSection);
            if(chatSection == 'InternalUWNote'){
                helper.getinternalUWNoteList(component, event, helper);
            }else if(chatSection == 'RepaymentUWNote'){
                helper.getRepaymentNoteList(component, event, helper);
            }else if(chatSection == 'OperationalNote'){
                helper.getoperationalUWNoteList(component, event, helper);
            }else if(chatSection == 'SalesRepNote'){
                helper.getSalesRepNoteList(component, event, helper);
            }else if(chatSection == 'LegalNote'){
                helper.getLegalNoteList(component, event, helper);
            }
        }else if(getActionType.includes('Save')){
            var chatSection = getActionType.replace('-Save','');
            console.log('Save chatSection=>'+chatSection);
            helper.saveEdit(component, event, helper,chatSection);
        }
    },

    SendMessageToSales : function(component, event, helper) {
        component.set('v.SendSupportSales', false);
        helper.SendMessageToSalesHelper(component, event, helper);       
    },

    SendMessageToSupportLender : function(component, event, helper) {
        component.set('v.SendSupportLender', false);
        helper.MessageToSupportLenderHelper(component, event, helper);
    },

    SendInternalUWNote : function(component, event, helper) {
        component.set('v.SaveInternalUW', false);
        helper.SendInternalUWNoteHelper(component, event, helper);       
    },

    SendOperationalUWNote : function(component, event, helper) {
        component.set('v.SaveOperationalUW', false);
        helper.SendOperationalUWNoteHelper(component, event, helper);       
    },

    SendFundingNote : function(component, event, helper) {
        component.set('v.SaveFundingNote', false);
        helper.SendFundingNoteHelper(component, event, helper);       
    },

    SendRepaymentNote : function(component, event, helper) {
        component.set('v.SaveRepaymentNote', false);
        helper.SendRepaymentNoteHelper(component, event, helper);       
    },

    sendSalesRepNote : function(component, event, helper) {
        component.set('v.SaveRepresentativeNote', false);
        helper.sendSalesRepNoteHelper(component, event, helper);       
    },

    SendLegalNote : function(component, event, helper) {
        component.set('v.SaveLegalNote', false);
        helper.SendLegalNoteHelper(component, event, helper);       
    },
})