({
	doInit : function(component, event, helper) {
        helper.getLabelHelper(component, event, helper);
        helper.fetchUserHelper(component, event, helper);
        helper.getTaskList(component, event, helper);
    },

    SendMessage : function(component, event, helper) {
        var message = component.find("Message").get("v.value");
        console.log('Inside Method'+message);
        helper.SendMessageHelper(component, event, helper);       
    }
})