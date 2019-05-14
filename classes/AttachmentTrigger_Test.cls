/*****************************************************************
Test Class Name : AttachmentTrigger_Test 
-------------------------------------------------------------------------------------------
Author           | Project       |    Date       | Description
-------------------------------------------------------------------------------------------
Aditya           | Red Payment   | 04-10-18      | Test class for AttachmentTrigger and AttachmentTriggerHandler
********************************************************************/
@isTest
public class AttachmentTrigger_Test implements HttpCalloutMock{
    //class with the code of HttpCalloutMock
    public HTTPResponse respond(HTTPRequest req){
        String Body;
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/octet-stream');
        if(req.getEndpoint().contains('/2/files/upload')){
            res.setBody('{"name": "Test Image GMEg1WU6r6.png", "path_lower": "/salesforce%20documents/test image gmeg1wu6r6.png", "path_display": "/Salesforce%20Documents/Test Image GMEg1WU6r6.png", "id": "id:ZjFvMRv6-XAAAAAAAAApwA", "client_modified": "2019-01-30T11:11:09Z", "server_modified": "2019-01-30T11:11:09Z", "rev": "38b74b6d9665", "size": 30548, "content_hash": "3169da6d6cc31a8f04ce2f9316b7177d969ba650f86ca1bbe242a4ea766c1b69"}');
            res.setStatusCode(200);
        }else if(req.getEndpoint().contains('/2/sharing/create_shared_link_with_settings')){
            res.setBody('{".tag": "file", "url": "https://www.dropbox.com/s/c85zff08k22ah0y/Test%20Image%20GMEg1WU6r6.png?dl=0", "id": "id:ZjFvMRv6-XAAAAAAAAApwA", "name": "Test Image GMEg1WU6r6.png", "path_lower": "/salesforce%20documents/test image gmeg1wu6r6.png", "link_permissions": {"resolved_visibility": {".tag": "public"}, "requested_visibility": {".tag": "public"}, "can_revoke": true, "visibility_policies": [{"policy": {".tag": "public"}, "resolved_policy": {".tag": "public"}, "allowed": true}, {"policy": {".tag": "team_only"}, "resolved_policy": {".tag": "team_only"}, "allowed": false, "disallowed_reason": {".tag": "user_not_on_team"}}, {"policy": {".tag": "password"}, "resolved_policy": {".tag": "password"}, "allowed": false, "disallowed_reason": {".tag": "user_account_type"}}], "can_set_expiry": false, "can_remove_expiry": true, "allow_download": true, "can_allow_download": true, "can_disallow_download": false, "allow_comments": true, "team_restricts_comments": false}, "preview_type": "photo", "client_modified": "2019-01-30T11:11:09Z", "server_modified": "2019-01-30T11:11:09Z", "rev": "38b74b6d9665", "size": 30548}');
            res.setStatusCode(200);
        }
        return res;
    }
    
    
    public static testMethod void testAttachmentTrigger(){
        
        //Insert Opportunity
        Opportunity objOpp = new opportunity(Name = 'Test Opportunity',CloseDate = system.today(),StageName = 'Closed Won',Cloufi__Dropbox_Folder_Path__c='/merchant services/Test Opportunity');
        insert objOpp;
        
        // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application_Status__c='In Progress',tabnumber__c=2,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',CreditScore__c='700+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;
        
        // Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Cloufi__Opportunity__c=objOpp.id,stip_Name__c='Test',Cloufi__Application__c = objApp.id,Name = 'Test UW Docu',Cloufi__Type__c = '6 month bank');
        insert objUWDocument ;
        
        
        //Insert Docusign Envelope
        dsfs__DocuSign_Envelope__c objEnvelope = new dsfs__DocuSign_Envelope__c(dsfs__DocuSign_Email_Message__c='Test',dsfs__Source_Object__c =objOpp.id);
        insert objEnvelope;
        
        // Insert Docusign for Opportunity
        dsfs__DocuSign_Status__c objDocuSign = new dsfs__DocuSign_Status__c(dsfs__DocuSign_Envelope_ID__c=objEnvelope.id,dsfs__Opportunity__c=objOpp.id);
        insert objDocuSign;
        
        // Insert custom setting
        Cloufi__Dropbox_Settings__c dropBoxSetting = new Cloufi__Dropbox_Settings__c(Name = 'Cloufi__Access_Token__c', Cloufi__Access_Token__c = 'Test access Token');
        insert dropBoxSetting;
        
        Cloufi__LendingXL_Trigger_Settings__c test1 = new Cloufi__LendingXL_Trigger_Settings__c(Cloufi__Attachment_Trigger__c = true);
        insert test1;
        
        //Insert Attachment     
        Attachment objAtt = new Attachment();       
        objAtt.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body1');
        objAtt.body = bodyBlob;
        objAtt.parentId = objDocuSign.id;
        insert objAtt; 
        
        //Insert Attachment
        Attachment objAttachment = new Attachment();    
        objAttachment.Name = 'Unit Test Attachment1';
        Blob bodyBlobAttach = Blob.valueOf('Unit Test Attachment Body2');
        objAttachment.body = bodyBlobAttach;
        objAttachment.parentId = objUWDocument.id;
        insert objAttachment;
        
        Test.startTest(); 
        
            Test.setMock( HttpCalloutMock.class, new ControlSheetUploadController_Test());
        
        Test.stopTest();
    }
}