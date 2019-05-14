({
    initRecords: function(component, event, helper) {
        //component.set('v.dropboxpath', false);
        helper.getDropboxpath(component, event, helper); //- Download ALl
        helper.showHideDownloadAll(component, event, helper); //- Download ALl
        helper.showHideReqDocButtonHelper(component);
        helper.fetchUserHelper(component, event, helper);
        helper.checkFunderAvailableHelper(component, event, helper);
        helper.checkAllDocumentsCompleted(component, event, helper);
        helper.checkOppStageHelper(component, event, helper);
        helper.requestStipVisibleHelper(component, event, helper);
        helper.getLendersHelper(component, event, helper);
        helper.getLendersNameHelper(component, event, helper);
        helper.getUWDocumentListHelper(component,helper);
        helper.getOtherUWDocumentListHelper(component,helper);
        var action = component.get("c.fetchDocument");
        action.setParams({
            'oppId': component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.documentList", storeResponse);
                //console.log('storeResponse.Cloufi__URL__c=>'+storeResponse[0].Cloufi__URL__c);
                var aList = [];
                aList =  component.get("v.documentList");
                if(aList.length <= 0){
                    component.set("v.documentList", null);         
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        component.set("v.Spinner", false);
    },
    
    refreshList : function(component,event,helper){
        helper.refreshDocumentList(component, event, helper);
    },
    
    save: function(component, event, helper) {
        var action = component.get("c.saveDocument");
        action.setParams({
            'lstDocument': component.get("v.documentList")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.showSaveCancelBtn",false);
                var storeResponse = response.getReturnValue();
                console.log('storeResponse=>'+storeResponse);
                for(var key in storeResponse){
                    console.log('key : '+ key+ 'Map value: ', storeResponse[key]);
                    var resultsToast = $A.get("e.force:showToast");
                    helper.refreshDocumentList(component, event, helper);
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
    
    createRecord : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Cloufi__UW_Document__c"
        });
        createRecordEvent.fire();
    },  
    
    cancel : function(component,event,helper){
        var action = component.get("c.cancelDocument");
        action.setParams({
            'lstDocument': component.get("v.documentList")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.documentList", storeResponse);
                component.set("v.showSaveCancelBtn",false);
                //alert('Updated...');
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title" : '',
                    "message" : "",
                    "type": ''
                });
                $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
            }
        });
        $A.enqueueAction(action);
        
    },
    
    RequestStip : function(component, event, helper) {
        helper.RequestStipHelper(component, event, helper);
    },
    
    RequestStipFromUW : function(component, event, helper) {
        console.log('RequestStipFromUW');
        helper.RequestStipFromUWHelper(component, event, helper);
    },
    
    sendMailToSalesRep :function(component, event, helper) {
        helper.sendMailToSelectedStipsHelper(component, event);
    },
    
    reqDocsUploaded : function(component, event, helper) {
        helper.reqDocsUploadedHelper(component, event);
    },
    
    openFinalUWPopUp: function(component, event, helper) {
        helper.checkOppStageHelper(component, event, helper);
        helper.checkAllDocumentsCompleted(component,helper);
        helper.getUWDocumentListHelper(component,helper);
        helper.getOtherUWDocumentListHelper(component,helper);        
        component.set("v.showPopup",true);
    },

    closePopup : function(component, event, helper) {
        component.set("v.showPopup",false);
    },

    closeLenderSharePopup : function(component, event, helper) {
        component.find("lender").set("v.value", "");
        component.set("v.lenderPopup",false);
    },

    openLenderSharePopUp: function(component, event, helper) {
        helper.getSubmissions(component, event, helper);
        component.set("v.lenderPopup",true);
        component.set("v.lender","");
        component.set("v.lenderSelected",false);
    },

    getDocumentList : function(component, event, helper){
        var selectedLender = component.find('lender').get('v.value');
        console.log('selectedLender=>'+selectedLender);
        if(selectedLender != '' && selectedLender != null){
            component.set("v.lenderSelected",true);
            helper.getSharedUWDocumentListHelper(component,helper,selectedLender);
            helper.getUnsharedUWDocumentListHelper(component,helper,selectedLender);
        }else{
            component.set("v.lenderSelected",false);
        }
    },

    shareDocumentsWithLender : function(component,event,helper){
        var shareStipIds = [];
        var getAllOtherId = component.find("shareWithLender");
        if(! Array.isArray(getAllOtherId)){
            if (getAllOtherId.get("v.value") == true) {
                shareStipIds.push(getAllOtherId.get("v.text"));
            }
        }else{
            for (var i = 0; i < getAllOtherId.length; i++) {
                if (getAllOtherId[i].get("v.value") == true) {
                    shareStipIds.push(getAllOtherId[i].get("v.text"));
                }
            }
        }
        console.log('shareStipIds=>'+shareStipIds.length);
        if(shareStipIds.length ==0){
            console.log('Not Selected=>');
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title" : 'Warning',
                "message" : "Please select atleast one Document to share",
                "type": 'warning'
            });
            $A.get("e.force:closeQuickAction").fire();
            resultsToast.fire();
            $A.get("e.force:refreshView").fire();
        }else{
            var selectedLender = component.find('lender').get('v.value');
            console.log('shareDocumentsWithLender selectedLender=>'+selectedLender);
            helper.shareDocumentsWithLenderHelper(component,event,helper,shareStipIds,selectedLender);
        }
    },
    
    sendMailForSelectedStips : function(component,event,helper){
        component.set('v.sendForFinalUW', false);
        var stipIds = [];
        var getAllId;
        getAllId = component.find("selectedCheckbox");
        if(getAllId){
            if(! Array.isArray(getAllId)){
                if (getAllId.get("v.value") == true) {
                    stipIds.push(getAllId.get("v.text"));
                }
            }else{
                for (var i = 0; i < getAllId.length; i++) {
                    if (getAllId[i].get("v.value") == true) {
                        stipIds.push(getAllId[i].get("v.text"));
                    }
                }
            }
        }
        console.log('getAllId=>'+getAllId);
        var otherStipIds = [];
        var getAllOtherId;
        getAllOtherId = component.find("otherSelectedCheckbox");
        if(getAllOtherId){
            if(! Array.isArray(getAllOtherId)){
                if (getAllOtherId.get("v.value") == true) {
                    otherStipIds.push(getAllOtherId.get("v.text"));
                }
            }else{
                for (var i = 0; i < getAllOtherId.length; i++) {
                    if (getAllOtherId[i].get("v.value") == true) {
                        otherStipIds.push(getAllOtherId[i].get("v.text"));
                    }
                }
            }
            console.log('otherStipIds=>'+otherStipIds.length);
        }
        console.log('getAllOtherId=>'+getAllOtherId);
        console.log('stipIds=>'+stipIds);
        console.log('otherStipIds=>'+otherStipIds);
        if(otherStipIds == '' && stipIds == ''){
            console.log('Not Selected=>');
            component.set('v.sendForFinalUW', true);
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title" : 'Warning',
                "message" : "Please select atleast one Document",
                "type": 'warning'
            });
            $A.get("e.force:closeQuickAction").fire();
            resultsToast.fire();
            $A.get("e.force:refreshView").fire();
        }else{
            var notes = component.get("v.noteInput");
            helper.sendMailForSelectedStipsHelper(component, event,helper, stipIds,notes,otherStipIds);
        }
        
    },
    
    downloadAllDocuments : function(component,event,helper){ 
        //component.set('v.uwURL', false);
        component.set("v.showSpinner", true); 
        //this.showSpinner(component,event,helper);
        console.log('In downloadAllDocuments');
        var zip;
        var filePaths;
        var a;
        var i = 0;
        var dropboxToken ='';
        var map;
        var folder;
        var action = component.get('c.getHiearchySettings');
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('State=>'+state);
            if(state == 'SUCCESS'){
                //saving custom setting to attribute
                var token = response.getReturnValue();
                console.debug('Token -> '+token);
                console.debug('Token -> '+token.Cloufi__Access_Token__c );
                dropboxToken = token.Cloufi__Access_Token__c;
                
                if(dropboxToken != null && dropboxToken !='' && dropboxToken != 'undefined'){
                    var action1 = component.get('c.getAllUWDocuments');
                    action1.setParams({
                        oppId : component.get('v.recordId')
                    });
                    $A.enqueueAction(action1);
                    action1.setCallback(this, function(response){
                        var state1 = response.getState();
                        console.log('State=>'+state1);
                        if(state1 == 'SUCCESS'){
                            console.log('All Documents State In=>'+state);
                            console.log('All Documents In onload');
                            var xhr = new XMLHttpRequest();  
                            var folderPath = response.getReturnValue();  
                            if(folderPath != null && folderPath != ''){
                                var folderName = folderPath.substring(folderPath.lastIndexOf('/')+1, folderPath.length);
                                console.log('folderPath -> '+folderPath);
                                console.log('folderName -> '+folderName);
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
                                        saveAs(blob,folderName);
                                    }
                                    //this.hideSpinner(component,event,helper);
                                    //component.set('v.uwURL', true);
                                    component.set("v.showSpinner", false); 
                                }
                            }else{
                                alert('Folder Not Found');
                            }
                        }
                        else{
                            alert('Error');
                        }
                    });
                }
            }
        });
        $A.enqueueAction(action);
    }
})