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
                console.log(resp.getReturnValue());
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
    }
})