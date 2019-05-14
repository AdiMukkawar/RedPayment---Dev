({
    refreshDocumentList: function(component,helper,event){
        var action = component.get("c.fetchDocument");
        action.setParams({
            'oppId': component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('initRecords state=>'+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('initRecords storeResponse=>'+storeResponse);
                component.set("v.documentList", storeResponse);
                var aList = [];
                aList =  component.get("v.documentList");
                if(aList.length <= 0){
                    component.set("v.documentList", null);         
                }
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
    
    RequestStipHelper : function(component,helper,event) {
        console.log('Inside Helper');
        var action = component.get("c.RequestStipAlertToMerchant");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
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
            }
        });
        $A.enqueueAction(action);
    },
    
    RequestStipFromUWHelper : function(component,helper,event) {
        console.log('Inside Helper');
        var action = component.get("c.RequestStipAlertToSupport");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
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
    
    checkAllDocumentsCompleted : function(component,helper,event) {
        var action = component.get("c.allDocumentsCompleted");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            console.log('documentsCompleted=>'+response);
            if(state == "SUCCESS"){
                component.set("v.documentsCompleted", response);
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    checkOppStageHelper : function(component,helper,event) {
        var action = component.get("c.checkOppStage");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            console.log('oppStage=>'+response);
            if(state == "SUCCESS"){
                component.set("v.oppStage", response);
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

    getOtherUWDocumentListHelper:function(component,helper) {
        var action = component.get("c.getOtherUWDocumentList");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            if(state == "SUCCESS"){
                component.set("v.otherStips",data.getReturnValue());
                console.log('Other Docs=>'+data.getReturnValue());
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
        });
        $A.enqueueAction(action);
        
    },

    getSubmissions : function(component, event, helper) {
        var action = component.get("c.dealSubmissionList");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            if(state == "SUCCESS"){
                component.set('v.submissionList', response);
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
        });
        $A.enqueueAction(action);
    },

    getSharedUWDocumentListHelper:function(component,helper,selectedLender) {
        var action = component.get("c.getSharedUWDocumentList");
        action.setParams({
            oppId: component.get("v.recordId"),
            lenderId: selectedLender
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            if(state == "SUCCESS"){
                component.set("v.shareRemainingStips",data.getReturnValue());
                
            }else if(state = "ERROR"){
                alert('Unknown error 1234');
            }
        });
        $A.enqueueAction(action);
        
    },

    getUnsharedUWDocumentListHelper:function(component,helper,selectedLender) {
        var action = component.get("c.getUnsharedUWDocumentList");
        action.setParams({
            oppId: component.get("v.recordId"),
            lenderId: selectedLender
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            if(state == "SUCCESS"){
                component.set("v.shareOtherStips",data.getReturnValue());
                console.log('Other Docs=>'+data.getReturnValue());
            }else if(state = "ERROR"){
                alert('Unknown error 12345');
            }
        });
        $A.enqueueAction(action);
        
    },

    shareDocumentsWithLenderHelper : function(component,event,helper,shareStipIds,selectedLender) {
        var action = component.get("c.createShareForLender");
        action.setParams({
            oppId: component.get("v.recordId"),
            'createShareStipIds':shareStipIds,
            'lenderId':selectedLender
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state=>'+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                this.getSubmissions(component, event, helper);
                component.set("v.lender","");
                component.find("lender").set("v.value","");
                component.set("v.lenderSelected",false);
                component.set("v.lenderPopup",false);
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
            }else{
                console.log('Inside else');
            }
        });
        $A.enqueueAction(action);
    },
    
    sendMailForSelectedStipsHelper : function(component, event,helper, selectedStipsIds,inputedNote,otherSelectedStipsIds) {
        var action = component.get("c.sendEmailToLender");
        action.setParams({
            'stipIds': selectedStipsIds,
            oppId: component.get("v.recordId"),
            'inputNote':inputedNote,
            'otherStipIds':otherSelectedStipsIds
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state=>'+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.showPopup",false);
                component.set("v.noteInput","");
                component.set('v.sendForFinalUW', true);
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
            }else{
                console.log('Inside elde');
            }
        });
        $A.enqueueAction(action);
    },
    
    requestStipVisibleHelper : function(component,helper,event) {
        var action = component.get("c.requestStipVisibleCtrl");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            console.log('oppStage=>'+response);
            if(state == "SUCCESS"){
                component.set("v.isVisbleReqStip", response);
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    getLendersHelper : function(component, event, helper) {
        var action = component.get("c.getReqLenders");
        action.setParams({
            'oppId': component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var arrayMapKeys = [];
                for(var key in result){
                    arrayMapKeys.push({key: key, value: result[key]});
                }
                component.set("v.mapValuesP", arrayMapKeys);
            }
        });
        $A.enqueueAction(action);
    },
    
    getLendersNameHelper : function(component, event, helper) {
        var action = component.get("c.getReqLendersName");
        action.setParams({
            'oppId': component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var arrayMapKeys1 = [];
                for(var key in result){
                    arrayMapKeys1.push({key: key, value: result[key]});
                }
                console.log('getLendersNameHelper Parent=>'+arrayMapKeys1);
                component.set("v.mapNameValuesP", arrayMapKeys1);
            }
        });
        $A.enqueueAction(action);
    },

    /*getReqLendersHelper : function(component, event, helper) {
        console.log('Inside Class=>');
        var action = component.get("c.getReqLenders");
        action.setParams({
            'oppId': component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var arrayMapKeys = [];
                for(var key in result){
                    console.log('key : '+ key+ 'Map value: ', result[key]);
                    arrayMapKeys.push({key: key, value: result[key]});
                }
                console.log('arrayMapKeys=>'+arrayMapKeys);
                component.set("v.mapValues", arrayMapKeys);
            }
        });
        $A.enqueueAction(action);
    }*/
    
    /*downloadAllUWDocuments : function(component, event, helper, dropboxToken){//- Download ALl
        console.log('In downloadAllUWDocuments');
        var action = component.get('c.getUWDocuments');
        action.setParams({
            oppId : component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                var xhr = new XMLHttpRequest();   
                var data = response.getReturnValue();
                var folderPath = data.Dropbox_Folder_Path__c;
                console.log('folderPath=>'+folderPath);
                xhr.open('POST', 'https://content.dropboxapi.com/2/files/download_zip');
                xhr.setRequestHeader('Authorization', 'Bearer ' + dropboxToken);
                xhr.setRequestHeader('Dropbox-API-Arg', JSON.stringify({
                    path: folderPath
                }));
                xhr.responseType = "arraybuffer";
                xhr.send();
                
                xhr.onload = function() {
                    if (xhr.status === 200) {
                        var blob = new Blob([xhr.response], {type: 'application/zip'});
                        saveAs(blob,data.Name);
                    }
                }
            }else{
                alert('Error');
            }
        });
        $A.enqueueAction(action);
    },*/

    showHideDownloadAll: function(component, event, helper){
        var action = component.get("c.checkUWURL");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
            var state = data.getState();
            var response = data.getReturnValue();
            console.log('uwURL=>'+response);
            if(state == "SUCCESS"){
                component.set("v.uwURL", response);
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    getDropboxpath : function(component, event, helper){
        var action = component.get('c.getAllUWDocuments');
        action.setParams({
            oppId : component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                var data = response.getReturnValue();
                console.log('data=>'+data);
                if(data != null)
                {
                    component.set('v.dropboxpath', true);
                }else{
                    component.set('v.dropboxpath', false);
                }
                console.log('dropboxpath=>'+component.get('v.dropboxpath'));
            }else{
                alert('Error');
            }
        });
        $A.enqueueAction(action);
    }
})