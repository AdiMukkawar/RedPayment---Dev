/**
Author | Date       | Description
Neha   | 08/27/2018 | Test class for ControlSheetUploadController
*/

@isTest
public class ControlSheetUploadController_Test implements HttpCalloutMock{

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
    
    public static testMethod void TestControlSheetUploadController(){
        //Insert Control sheet department account
        Account objAccount = new Account(Name='Control Sheet Department');
        insert objAccount;
        
        //Insert contacts under account
        Contact objContact = new Contact(FirstName='Test',Lastname='TestLast',Email='test@test.com',AccountId=objAccount.Id);
        insert objContact;
        
        //Insert Opportunity
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'test';
        oppObj.StageName = 'Application';
        oppobj.CloseDate = system.today();
        oppobj.isPrivate=true;
        oppobj.Cloufi__Monthly_Revenue__c = 10000;
        oppobj.Cloufi__Type_of_Business__c = 'test';
        oppobj.CloufiServicing__Submission_Country__c = 'United States';
        oppobj.Cloufi__Dropbox_Folder_Path__c = 'Test';
        insert oppObj;
        
        Cloufi__UW_Document__c ObjStips = new Cloufi__UW_Document__c();
        ObjStips.name = 'Control Sheet';   
        ObjStips.Stip_Name__c = 'Control Sheet';
        ObjStips.Cloufi__Type__c = 'Control Sheet';
        ObjStips.Cloufi__Opportunity__c = oppObj.id;
        ObjStips.Cloufi__URL__c ='https://www.dropbox.com/s/6pvxabx1plkjvx6/Control%20Sheet%205%20O9s23Zxlpg.jpg?dl=1';          
        insert ObjStips;
        
        //Insert UW share Document
        UW_Document_Share__c objUWShare = new UW_Document_Share__c(Opportunity__c = oppobj.Id, UW_Documents__c = ObjStips.Id);
        insert objUWShare;
        
        ObjStips = new Cloufi__UW_Document__c();
        ObjStips.name = 'Control Sheet Completed';  
        ObjStips.Stip_Name__c = 'Control Sheet Completed';
        ObjStips.Cloufi__Type__c = 'Control Sheet Completed';
        ObjStips.Cloufi__Opportunity__c = oppObj.id;
        ObjStips.Cloufi__URL__c ='https://www.dropbox.com/s/6pvxabx1plkjvx6/Control%20Sheet%205%20O9s23Zxlpg.jpg?dl=1';          
        insert ObjStips;
        
        PageReference myVfPage = Page.ControlSheetUpload;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id',oppObj.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(oppObj);
        ControlSheetUploadController objContrlSheetCtrl  = new ControlSheetUploadController(sc);
        Test.setMock( HttpCalloutMock.class, new ControlSheetUploadController_Test());
        Test.startTest();

            objContrlSheetCtrl.customStipFileName = 'Test Attachment';
            objContrlSheetCtrl.customStipFileBody = Blob.valueOf('Unit Test Attachment Body');
            objContrlSheetCtrl.uploadControlSheet();
            List<String> opportunityFields = DevUtil.getFieldsOfsObject('Opportunity');
            List<String> uwFields = DevUtil.getFieldsOfsObject('cloufi__payments__c');            
            List<Cloufi__UW_Document__c> uwList = DevUtil.fetchDocument(oppObj.Id);
        Test.stopTest();
    }
}