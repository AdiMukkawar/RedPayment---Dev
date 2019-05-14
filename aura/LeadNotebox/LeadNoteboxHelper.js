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

    saveSalesRepNoteHelper : function(component, event, helper) {
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
            leadId: component.get("v.recordId"),
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
            leadId: component.get("v.recordId")
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