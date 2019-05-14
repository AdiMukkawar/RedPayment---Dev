({
	getLabelHelper : function(component, event, helper) {
		var action = component.get("c.showLabelCtrl");
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

	getTaskList : function(component, event, helper) {
        var action = component.get("c.taskListCtrl");
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
		var action = component.get("c.SendMessageCtrl");
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
                console.log('storeResponse=>'+storeResponse);
                //var storeResponse = response.getReturnValue();
                for(var key in storeResponse){
                    console.log('key : '+ key+ 'Map value: ', storeResponse[key]);
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title" : key,
                        "message" : storeResponse[key],
                        "type": key
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