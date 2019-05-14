({
	fetchUserHelper : function(component,helper,event) {
        var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
               // set current user information on userInfo attribute
               console.log('storeResponse=>'+storeResponse);
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },

    saveEdit: function(component, event, helper,chatSection) {
        var action = component.get("c.updateNotes");
        if(chatSection == 'InternalUWNote'){
            action.setParams({
                oppId: component.get("v.recordId"),
                chatList:component.get('v.InternalUWNote')
            });
        }else if(chatSection == 'RepaymentUWNote'){
            action.setParams({
                oppId: component.get("v.recordId"),
                chatList:component.get('v.repymentNoteList')
            });
        }else if(chatSection == 'OperationalNote'){
            action.setParams({
                oppId: component.get("v.recordId"),
                chatList:component.get('v.OperationalAndUWNotes')
            });
        }else if(chatSection == 'SalesRepNote'){
            action.setParams({
                oppId: component.get("v.recordId"),
                chatList:component.get('v.salesRepNoteList')
            });
        }
        action.setCallback(this, function(response) {
            console.log('response => '+response);
            console.log('sourceComponent => '+component.get("v.sourceComponent"));
            var state = response.getState();
            if(state === "SUCCESS"){
                var storeResponse = response.getReturnValue();
                for(var key in storeResponse){
                    var resultsToast = $A.get("e.force:showToast");
                    if(chatSection == 'InternalUWNote'){
                        this.getinternalUWNoteList(component, event, helper);
                    }else if(chatSection == 'RepaymentUWNote'){
                        this.getRepaymentNoteList(component, event, helper);
                    }else if(chatSection == 'OperationalNote'){
                        this.getoperationalUWNoteList(component, event, helper);
                    }else if(chatSection == 'SalesRepNote'){
                        this.getSalesRepNoteList(component, event, helper);
                    }
                    resultsToast.setParams({
                        "title" : key,
                        "message" : storeResponse[key],
                        "type": key
                    });
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire();
                    $A.get("e.force:refreshView").fire();
                }
            }else{
                alert('Error');
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
    
    SendMessageToSalesHelper : function(component, event, helper) {
        console.log('Inside SendMessageToSalesHelper');
        var action = component.get("c.SendMessageToSalesCtrl");
        var message = component.find("msgToSales").get("v.value");
        console.log('message=>'+message);
        var count = (message.match(/p/g) || []).length;
        if(count == 2){
            message = message.replace('<p>', '');
            message = message.replace('</p>', '');
            message = message.trim();
        }
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
                    component.set("v.supportToSalesDescription", "");
                    component.set('v.SendSupportSales', true);
                    helper.getChatList(component, event, helper);
                    //helper.getCustomerSuccessChatList(component, event, helper);
                }
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
    },

    getChatList : function(component, event, helper) {
        var action = component.get("c.supportSalesChatListCtrl");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            console.log('state=>'+state);
            if(state == "SUCCESS"){
               component.set("v.supportToSalesChatList",data.getReturnValue());
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    sendSalesRepNoteHelper : function(component, event, helper) {
        var note = component.find("salesRepNote").get("v.value");
        console.log('note=>'+note);
        var count = (note.match(/p/g) || []).length;
        if(count == 2){
            note = note.replace('<p>', '');
            note = note.replace('</p>', '');
            note = note.trim();
        }
        var action = component.get("c.createSalesRepNoteCtrl");
        action.setParams({
            oppId: component.get("v.recordId"),
            inputmsg:note
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
                component.set("v.salesRepNoteDescription", "");
                component.set('v.SaveRepresentativeNote', true);
                helper.getSalesRepNoteList(component, event, helper);
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    getSalesRepNoteList : function(component, event, helper) {
        var action = component.get("c.salesRepNoteListCtrl");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            console.log('state=>'+state);
            if(state == "SUCCESS"){
               component.set("v.salesRepNoteList",data.getReturnValue());
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
    },
})