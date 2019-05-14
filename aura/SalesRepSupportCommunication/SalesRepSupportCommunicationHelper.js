({
	getDateTimeZoneHelper : function(component, event, helper) {
		var action = component.get("c.dateTimeUserZone");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.dateTimeZone", response.getReturnValue());
             }
          });
           $A.enqueueAction(action);
	},
    
    getUserNameHelper : function(component, event, helper) {
		var action = component.get("c.getUserName");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.UserName", response.getReturnValue());
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
    
    getLabelHelper : function(component, event, helper) {
		var action = component.get("c.showLabel");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            if(state == "SUCCESS"){
                component.set("v.headerlabel",response);
            }
        });
        $A.enqueueAction(action);
	},
    
    getTaskList : function(component, event, helper) {
        var action = component.get("c.taskList");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            console.log('state=>'+state);
            if(state == "SUCCESS"){
               component.set("v.tasks",data.getReturnValue());
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    SendMessageHelper : function(component, event, helper) {
		var action = component.get("c.SendMessageC");
        var message = component.find("Message").get("v.value");
        console.log('message=>'+message);
        action.setParams({
            oppId: component.get("v.recordId"),
            inputmsg:message
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            console.log('state=>'+state);            
            if(state == "SUCCESS"){
                var storeResponse = data.getReturnValue();
                if(storeResponse !='Message has been sent successfully'){
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title" : "Warning",
                        "message" : response,
                        "type": 'warning'
                    });
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire();
                    $A.get("e.force:refreshView").fire();
                    component.set("v.description", "");
                    helper.getTaskList(component, event, helper);
                }else{
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title" : "Success",
                        "message" : response,
                        "type": 'success'
                    });
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire();
                    $A.get("e.force:refreshView").fire();
                    component.set("v.description", "");
                    helper.getTaskList(component, event, helper);
                }
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
	}
})