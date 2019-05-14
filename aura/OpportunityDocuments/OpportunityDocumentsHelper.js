({
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
    
    RequestStipHelper : function(component,helper,event) {
        console.log('Inside Helper');
        var action = component.get("c.RequestStipAlertToMerchant");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            console.log('state=>'+state);
            if(state == "SUCCESS"){
                var storeResponse = data.getReturnValue();
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title" : "Success",
                    "message" : response,
                    "type": 'Success'
                });
                $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    checkFunderAvailableHelper : function(component,helper,event) {
        var action = component.get("c.isFunderAvailable");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            if(state == "SUCCESS"){
                component.set("v.funderAvailable", response);
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
   showHideReqDocButtonHelper:function(component,helper) {
        var action = component.get("c.showHideReqDocButtonC");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            if(state == "SUCCESS"){
                component.set("v.showHideReqDoc", response);
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    /*showHideSendStipButtonHelper:function(component,helper) {
        var action = component.get("c.showHideSendStipButtonC");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            console.log('state=>'+state);
            if(state == "SUCCESS"){
                component.set("v.showHideSendStip", response);
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
    },*/
    
    getsObjectRecs: function(component) {
        var action = component.get("c.getsObjRecords");
        action.setParams({
            "sObj": component.get("v.sObj"),
            "fSetName": component.get("v.fSetName"),
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function(resp) {
            var state = resp.getState();
            if (state === "SUCCESS") {
                var response = resp.getReturnValue();
                var sObjlist = response["sObjlist"];
                var fSetlist = response["fieldSetlist"];
                component.set("v.fieldlist", fSetlist);
                var objWrapperlist = [];
                for (var sObj = 0; sObj < sObjlist.length; sObj++) {
                    var objRec = [];
                    for (var fSet = 0; fSet < fSetlist.length; fSet++) {
                        var fAPIname = fSetlist[fSet].fAPIName;
                        var fValue = sObjlist[sObj].sObjRecord[fAPIname];
                        var offerId = sObjlist[sObj].sObjRecord['Id'];
                        var jsonStr = JSON.parse(fSetlist[fSet].fSetMember);
                        var childName = sObjlist[sObj].childName;  
                        
                        objRec.push({
                            "fvalue": fValue,
                            "fDetails": jsonStr,
                            "fAPIname":fAPIname,
                            "offerId":offerId,
                            "childName":childName
                        });
                    }
                    objWrapperlist.push(objRec);
                }
                console.log(objWrapperlist.length);
                if(objWrapperlist.length > 0){
                    component.set("v.sObjWrapperlist", objWrapperlist);       
                }else{
                    component.set("v.sObjWrapperlist", null);
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    
    sendMailToSelectedStipsHelper : function(component, event) {
        var action = component.get("c.sendemailToOppOwner");
        action.setParams({
           'oppId': component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title" : "Success",
                    "message" : response.getReturnValue(),
                    "type": 'success'
                });
                $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
            }
            
        });
        $A.enqueueAction(action);
	},
    
    reqDocsUploadedHelper:function(component,helper) {
        var action = component.get("c.showRequDocResult");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
           var state = data.getState();
            if(state == "SUCCESS"){
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title" : "Success",
                    "type": 'success',
                    "message" : data.getReturnValue()
                });
                $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    getUWDocumentListHelper:function(component,helper) {
        var action = component.get("c.getUWDocumentList");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
           var state = data.getState();
            if(state == "SUCCESS"){
                component.set("v.RemainingStips",data.getReturnValue());
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
        });
        $A.enqueueAction(action);
    },
    
   sendMailForSelectedStipsHelper : function(component, event, selectedStipsIds) {
        var action = component.get("c.sendEmailToLender");
        action.setParams({
            'stipIds': selectedStipsIds,
             oppId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title" : "Success",
                    "message" : "Email send successfully.",
                    "type": 'success'
                });
                $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
                component.set("v.showPopup",false);
            }
            
        });
        $A.enqueueAction(action);
	}
})