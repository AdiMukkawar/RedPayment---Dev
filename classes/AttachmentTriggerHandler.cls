/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: AttachmentTriggerHandler
* Created Date: 05-September-2018
* Description: To Attach Signed Agreement under UW of Signed Application
*******************************************************************
* Updates
* Author            | Date             | Description
* Gaurav Agrawal    | 03 October 2018  | Added createSignedApplication method to attach Signed Application with Opportunity
* Gaurav Agrawal    | 30 January 2019  | Added uploadUWAttachment method to upload file to dropbox
********************************************************************/

public class AttachmentTriggerHandler {
    
    public static void createSignedApplication(List<Attachment> attachmentList){
        Map<Id, Attachment> docusignStatusAttachmentMap = new Map<Id, Attachment>();    
        Map<Id, Id> docusignStatusOpportunityIdMap = new Map<Id, Id>();
        Map<Attachment, Cloufi__UW_Document__c> attachmentUWDocumentMap = new Map<Attachment, Cloufi__UW_Document__c>();
        Map<Id, Id> opportunityApplicationMap = new Map<Id, Id>();
        Map<Id, Cloufi__UW_Document__c> opportunityUWDocMap = new Map<Id, Cloufi__UW_Document__c>();
        
        for(Attachment objAttachment : attachmentList){         
            if(objAttachment.ParentId.getSObjectType().getDescribe().getName() == 'dsfs__DocuSign_Status__c'){
                docusignStatusAttachmentMap.put(objAttachment.ParentId, objAttachment);
            }
        }
        
        for(dsfs__DocuSign_Status__c objDocusignStatus : [SELECT Id, dsfs__Opportunity__c FROM dsfs__DocuSign_Status__c WHERE Id IN : docusignStatusAttachmentMap.keyset()]){
            docusignStatusOpportunityIdMap.put(objDocusignStatus.Id, objDocusignStatus.dsfs__Opportunity__c);
        }
        
        for(Opportunity objOpportunity : [SELECT Id, (SELECT Id FROM Cloufi__Applications__r) FROM Opportunity WHERE Id IN : docusignStatusOpportunityIdMap.values()]){
            if(objOpportunity.Cloufi__Applications__r.size()>0){
                opportunityApplicationMap.put(objOpportunity.Id, objOpportunity.Cloufi__Applications__r[0].Id);
            }
        }
        
        for(Cloufi__UW_Document__c objUWDocument : [SELECT Id, Name, Stip_Name__c, Cloufi__Opportunity__c, Cloufi__Application__c, Cloufi__Type__c, Status__c FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c IN : opportunityApplicationMap.keyset()]){
            opportunityUWDocMap.put(objUWDocument.Cloufi__Opportunity__c, objUWDocument);
        }
        
        for(Id docusignStatusId : docusignStatusAttachmentMap.keySet()){
            Attachment objAttachment = docusignStatusAttachmentMap.get(docusignStatusId);
            Attachment objNewAttachment = new Attachment();
            objNewAttachment.Name = objAttachment.Name;
            objNewAttachment.Body = objAttachment.Body;            
            
            if(docusignStatusOpportunityIdMap.get(objAttachment.ParentId) != null){   
                Cloufi__UW_Document__c objUWDocument;             
                if(opportunityUWDocMap.get(docusignStatusOpportunityIdMap.get(objAttachment.ParentId)) == null){
                    objUWDocument = new Cloufi__UW_Document__c();                   
                    objUWDocument.Name = 'Signed Application';
                    objUWDocument.Stip_Name__c = 'Signed Application';              
                    objUWDocument.Cloufi__Opportunity__c = docusignStatusOpportunityIdMap.get(objAttachment.ParentId);
                    if(objUWDocument.Cloufi__Opportunity__c != null && opportunityApplicationMap.get(objUWDocument.Cloufi__Opportunity__c) != null){
                        objUWDocument.Cloufi__Application__c = opportunityApplicationMap.get(objUWDocument.Cloufi__Opportunity__c);
                    }
                    objUWDocument.Cloufi__Type__c = 'Application - Document';
                    objUWDocument.Status__c = 'Completed';
                }else{
                    objUWDocument = new Cloufi__UW_Document__c();
                    objUWDocument = opportunityUWDocMap.get(docusignStatusOpportunityIdMap.get(objAttachment.ParentId));
                    objUWDocument.Status__c = 'Completed';
                }
                attachmentUWDocumentMap.put(objNewAttachment, objUWDocument);             
            }                   
        }
        
        upsert attachmentUWDocumentMap.values();
        List<Attachment> newAttachmentList = new List<Attachment>();
        for(Attachment objAttachment : attachmentUWDocumentMap.keyset()){
            objAttachment.ParentId = attachmentUWDocumentMap.get(objAttachment).Id;
            newAttachmentList.add(objAttachment);
        }       
        insert newAttachmentList;       
    }
    
    /*public static void uploadUWAttachment(List<Attachment> attachmentList){
        try{
        Set<Id> attachmentIds = New Set<Id>();
        Set<Id> uwDocumentIdSet = new Set<Id>();
        Cloufi__Dropbox_Settings__c dropBoxSetting = Cloufi__Dropbox_Settings__c.getOrgDefaults();
        system.debug('dropBoxSetting---->'+dropBoxSetting);
        String token = dropBoxSetting.Cloufi__Access_Token__c;
        
        
        
        for(Attachment objAttachment : attachmentList){
            system.debug('token---->'+token);
            system.debug('objAttachment.ParentId--->'+objAttachment.ParentId);
            system.debug('objAttachment.ParentId.getSobjectType().getDescribe().getName()---->'+objAttachment.ParentId.getSobjectType().getDescribe().getName());
            if(objAttachment.ParentId != null && objAttachment.ParentId.getSobjectType().getDescribe().getName() == 'Cloufi__UW_Document__c' && token != null){
                attachmentIds.add(objAttachment.Id);
                uwDocumentIdSet.add(objAttachment.ParentId);
            }
        }
        System.debug('attachmentIds -> '+attachmentIds);
        System.debug('token -> '+token);
        if(attachmentIds.size()>0 && token != null){ 
            AttachmentTriggerHandler.uploadUWAttachment(attachmentIds, uwDocumentIdSet, token);            
        }
        }catch(Exception e){
            System.debug('error -> '+e.getMessage());
            System.debug('Line No -> '+e.getLineNumber());
        }
    }
    
    @future(callout=true)
    public static void uploadUWAttachment(Set<Id> attachment_Ids, Set<Id> uwDocumentIdSet, String token){
        Map<Id, Cloufi__UW_Document__c> uwDocumentMap = new Map<Id, Cloufi__UW_Document__c>();
        List<Attachment> attachmentList = new List<Attachment>();
        String attachmentName;
        String randomString;
        List<Cloufi__UW_Document__c> uwDocumentList = New List<Cloufi__UW_Document__c>();
        
        for(Cloufi__UW_Document__c objUWDocument : [SELECT Id, Name, Cloufi__Opportunity__c, Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c, Cloufi__URL__c FROM Cloufi__UW_Document__c WHERE Id IN : uwDocumentIdSet]){
            uwDocumentMap.put(objUWDocument.Id, objUWDocument);
        }
        
        for(Attachment objAttach : [SELECT Id, Name, Body, BodyLength, ParentId FROM Attachment WHERE Id IN: attachment_Ids]){
            Cloufi__UW_Document__c objUWDocument = uwDocumentMap.get(objAttach.ParentId);
            randomString = generateRandomString(10);
            
            attachmentName = objUWDocument.Name + ' ' +randomString + '.' + objAttach.Name.substringAfterLast('.');
            System.debug('attachmentName ->'+attachmentName);
            String uploadOppAttach = 'https://content.dropboxapi.com/2/files/upload';
            String pathOppUpload = '{"path":"'+objUWDocument.Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c+'/'+attachmentName+'","mode": "add","autorename": true,"mute": false}';
            HttpRequest requestupload = new HttpRequest();
            requestupload.setEndpoint(uploadOppAttach);
            requestupload.setMethod('POST');
            requestupload.setHeader('Authorization','Bearer '+token);
            requestupload.setHeader('Dropbox-API-Arg', pathOppUpload);
            requestupload.setHeader('Content-Type', 'application/octet-stream');
            requestupload.setBodyAsBlob(objAttach.Body);
            requestupload.setTimeout(12000);
            Http hpPutUpload = new Http();
            HttpResponse responseFileUpload;
            String jsonFileResUpload;
            system.debug('requestupload >>'+requestupload);
            //responseFileUpload = hpPutUpload.send(requestupload);
            //jsonFileResUpload = responseFileUpload.getBody();
            //System.debug('jsonFileResUpload -> '+jsonFileResUpload);
            if(!Test.isRunningTest()){
                responseFileUpload = hpPutUpload.send(requestupload);
                jsonFileResUpload = responseFileUpload.getBody();
            }else{
                jsonFileResUpload = '{"name": "Test Image GMEg1WU6r6.png", "path_lower": "/salesforce%20documents/test image gmeg1wu6r6.png", "path_display": "/Salesforce%20Documents/Test Image GMEg1WU6r6.png", "id": "id:ZjFvMRv6-XAAAAAAAAApwA", "client_modified": "2019-01-30T11:11:09Z", "server_modified": "2019-01-30T11:11:09Z", "rev": "38b74b6d9665", "size": 30548, "content_hash": "3169da6d6cc31a8f04ce2f9316b7177d969ba650f86ca1bbe242a4ea766c1b69"}';
            }
            system.debug('jsonFileResUpload >>'+jsonFileResUpload);
            String path_lowerFile;
            Map<String, Object> jsonURLMapUpload = (Map<String, Object>)JSON.deserializeUntyped(jsonFileResUpload);
            if(jsonURLMapUpload.get('path_lower')!= null){
                path_lowerFile = (String)jsonURLMapUpload.get('path_lower');
                System.debug('path_lowerFile -->> '+path_lowerFile);
                
                //callout to create shared link of uploaded file
                String ShareOppUrl = 'https://api.dropboxapi.com/2/sharing/create_shared_link_with_settings';
                String inputSharePath = '{"path":"'+path_lowerFile+'" ,"settings": {"requested_visibility": "public"}}';
                HttpRequest requestForSearchUrl = new HttpRequest();
                requestForSearchUrl.setEndpoint(ShareOppUrl);
                requestForSearchUrl.setMethod('POST');
                requestForSearchUrl.setHeader('Authorization','Bearer '+token);
                requestForSearchUrl.setHeader('Content-Type','application/json');        
                requestForSearchUrl.setBody(inputSharePath);        
                requestForSearchUrl.setTimeout(12000);
                Http hpShare = new Http();
                HttpResponse responseShare;
                String jsonResShare;
                //responseShare = hpShare.send(requestForSearchUrl);
                //jsonResShare = responseShare.getBody();
                if(!Test.isRunningTest()){
                    responseShare = hpShare.send(requestForSearchUrl);
                    jsonResShare = responseShare.getBody();
                }
                System.debug('response body -->> '+jsonResShare);
                
                String jsonSearchURL;
                Map<String, Object> jsonURLShareNew = (Map<String, Object>)JSON.deserializeUntyped(jsonResShare);
                if(jsonURLShareNew.get('url')!= null){
                    jsonSearchURL = (String)jsonURLShareNew.get('url');
                    jsonSearchURL = jsonSearchURL.replace('?dl=0', '?dl=1');
                    System.debug('url -->> '+jsonSearchURL);
                    
                    objUWDocument.Cloufi__URL__c = jsonSearchURL;
                    uwDocumentList.add(objUWDocument);
                } 
            } 
            attachmentList.add(objAttach);          
        }
        
        if(!uwDocumentList.isEmpty()){
            update uwDocumentList;
        }
        
        if(!attachmentList.isEmpty()){
            delete attachmentList;
        }        
    }*/  
    
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }    
}