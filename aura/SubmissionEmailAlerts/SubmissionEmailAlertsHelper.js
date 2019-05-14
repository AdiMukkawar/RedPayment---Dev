({
    doInitHandler : function(component, event, helper) {
        var action = component.get("c.isLenderAvailable");
        action.setParams({
            subId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            if(state == "SUCCESS"){
                var storeResponse = data.getReturnValue();
                console.log('storeResponse=>'+storeResponse);
                if(storeResponse){
                    component.find("sendCustomMessage").set("v.disabled", false); 
                }else{
                    component.find("sendCustomMessage").set("v.disabled", true); 
                }
            }
        });
        $A.enqueueAction(action);
    },
    
	OfferUpdateHelper : function(component, event, helper) {
        console.log('Inside Helper');
        var action = component.get("c.AlertToLender");
        action.setParams({
            subId: component.get("v.recordId"),
            mailFor:'Submission'
        });
        action.setCallback(this,function(data){
            var state = data.getState();
           
            console.log('state=>'+state);
            if(state == "SUCCESS"){
                var storeResponse = data.getReturnValue();
                console.log('storeResponse=>'+storeResponse);
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
                }
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    ContractUpdateHelper : function(component, event, helper) {
        var action = component.get("c.AlertToLender");
        action.setParams({
            subId: component.get("v.recordId"),
            mailFor:'Contract'
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            console.log('state=>'+state);
            if(state == "SUCCESS"){
				var storeResponse = data.getReturnValue();
                console.log('storeResponse=>'+storeResponse);
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
				}
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    GeneralUpdateHelper : function(component, event, helper) {
        var action = component.get("c.AlertToLender");
        action.setParams({
            subId: component.get("v.recordId"),
            mailFor:'General'
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            console.log('state=>'+state);
            if(state == "SUCCESS"){
				var storeResponse = data.getReturnValue();
                console.log('storeResponse=>'+storeResponse);
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
				}
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    FundingUpdateHelper : function(component, event, helper) {
        var action = component.get("c.AlertToLender");
        action.setParams({
            subId: component.get("v.recordId"),
            mailFor:'Funding'
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            console.log('state=>'+state);
            if(state == "SUCCESS"){
				var storeResponse = data.getReturnValue();
                console.log('storeResponse=>'+storeResponse);
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
				}
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    CommissionUpdateHelper : function(component, event, helper) {
        var action = component.get("c.AlertToLender");
        action.setParams({
            subId: component.get("v.recordId"),
            mailFor:'Commission'
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            console.log('state=>'+state);
            if(state == "SUCCESS"){
				var storeResponse = data.getReturnValue();
                console.log('storeResponse=>'+storeResponse);
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
				}
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    sendEmailHelper: function(component, event, helper) {
        var emailId = component.get("v.email");
        console.log('emailId=>'+emailId);        
        var selectedOption = component.get("v.selectedOption");
        console.log('selectedOption=>'+selectedOption);
        var emailBody = component.get("v.message");
        console.log('emailBody=>'+emailBody);
        
        
        if(emailBody===null || emailBody==''){
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title" : 'warning',
                "message" : 'Please type message',
                "type": 'warning'
            });
            $A.get("e.force:closeQuickAction").fire();
            resultsToast.fire();
            $A.get("e.force:refreshView").fire();
        }else if(selectedOption===null || selectedOption==''){
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title" : 'warning',
                "message" : 'Please select Option',
                "type": 'warning'
            });
            $A.get("e.force:closeQuickAction").fire();
            resultsToast.fire();
            $A.get("e.force:refreshView").fire();
        }else{
            var action = component.get("c.sendSelectedOptionMail");
            action.setParams({
                subId: component.get("v.recordId"),
                selectedOption:selectedOption,
                msgBody:emailBody
            });
            action.setCallback(this,function(data){
                var state = data.getState();
                var response = data.getReturnValue();
                console.log('state=>'+state);
                if(state == "SUCCESS"){
                    var storeResponse = data.getReturnValue();
                    console.log('storeResponse=>'+storeResponse);
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
                    }
                    component.set("v.message", "");
                    component.set("v.selectedOption", "");
                }else if(state = "ERROR"){
                    alert('Please Refresh the page');
                }
                
            });
            $A.enqueueAction(action);
        }
    }
    
})