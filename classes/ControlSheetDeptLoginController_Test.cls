/******************************************************************************
Author             | Date           | Description
Aditya Mukkawar    | 15-April-2019  | Test class for ControlSheetDeptLoginController,ControlSheetUtil and ControlSheetGeneratePasswardController
**********************************************************************************/

@isTest
public class ControlSheetDeptLoginController_Test implements HttpCalloutMock{

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

    public static testMethod void executeControlSheetPortal(){

        // Inserting Account
        Account objAccount = new Account(Name='Test Account');
        insert objAccount;

        // Inserting Contact
        Contact objContact=new Contact(AccountId=objAccount.Id,FirstName='fname',LastName = 'lname',Email = 'email@gmail.com',Control_sheet_Portal_Access__c=true,password__c='12345678'); 
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
        //oppobj.Cloufi__Dropbox_Folder_Path__c = 'Test';
        oppObj.AccountId = objAccount.id;
        insert oppObj;
        
        Cloufi__UW_Document__c ObjStips = new Cloufi__UW_Document__c();
        ObjStips.name = 'Control Sheet';   
        ObjStips.Stip_Name__c = 'Control Sheet';
        ObjStips.Cloufi__Type__c = 'Control Sheet';
        ObjStips.Cloufi__Opportunity__c = oppObj.id;
        ObjStips.Status__c = 'Requested';
        insert ObjStips;
        
        //Insert UW share Document
        UW_Document_Share__c objUWShare = new UW_Document_Share__c(Opportunity__c = oppobj.Id, UW_Documents__c = ObjStips.Id,Control_Sheet_Contact__c=objContact.Id);
        insert objUWShare;
        
        Cloufi__UW_Document__c ObjStips2 = new Cloufi__UW_Document__c();
        ObjStips2.name = 'Control Sheet Completed';  
        ObjStips2.Stip_Name__c = 'Control Sheet Completed';
        ObjStips2.Cloufi__Type__c = 'Control Sheet Completed';
        ObjStips2.Cloufi__Opportunity__c = oppObj.id;
        ObjStips2.Cloufi__URL__c ='https://www.dropbox.com/s/6pvxabx1plkjvx6/Control%20Sheet%205%20O9s23Zxlpg.jpg?dl=1';          
        insert ObjStips2;

        
        ApexPages.StandardController sc = new ApexPages.StandardController(objContact);
        apexpages.currentpage().getparameters().put('id',objContact.id);
        ControlSheetDeptLoginController objController = new ControlSheetDeptLoginController(sc);
        Test.setMock( HttpCalloutMock.class, new ControlSheetDeptLoginController_Test());

        Test.startTest();
            objController.username = 'email1@gmail.com';
            objController.password = '12345678';
            objController.LoginUser();

            objController.username = 'email@gmail.com';
            objController.password = '12345678';
            objController.LoginUser();

            objController.accessCode = '12453'; 
            objController.confirmLogin();

            Contact objCon = [SELECT id,Access_code__c FROM Contact WHERE Id=:objContact.id];
            objController.accessCode = objCon.Access_Code__c; 
            objController.confirmLogin();

            objController.forgetPassword();
            objController.initializeOpportunityRecords();
            objController.selectedOppId = oppObj.id;
            objController.fetchConrolSheet();
            /*objController.customStipFileName = 'Test Attachment';
            objController.customStipFileBody = Blob.valueOf('Unit Test Attachment Body');
            objController.uploadControlSheet();*/
        Test.stopTest();

    }

    public static testMethod void executeUploadControlSheet(){

        // Insert custom setting
        Cloufi__Dropbox_Settings__c dropBoxSetting = new Cloufi__Dropbox_Settings__c(Name = 'Cloufi__Access_Token__c', Cloufi__Access_Token__c = 'Test access Token');
        insert dropBoxSetting;

        // Inserting Account
        Account objAccount = new Account(Name='Test Account');
        insert objAccount;

        // Inserting Contact
        Contact objContact=new Contact(AccountId=objAccount.Id,FirstName='fname',LastName = 'lname',Email = 'email@gmail.com',Control_sheet_Portal_Access__c=true,password__c='12345678'); 
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
        //oppobj.Cloufi__Dropbox_Folder_Path__c = 'Test';
        oppObj.AccountId = objAccount.id;
        insert oppObj;
        
        List<Cloufi__UW_Document__c> docList = new List<Cloufi__UW_Document__c>();

        Cloufi__UW_Document__c ObjStips = new Cloufi__UW_Document__c();
        ObjStips.name = 'Control Sheet';   
        ObjStips.Stip_Name__c = 'Control Sheet';
        ObjStips.Cloufi__Type__c = 'Control Sheet';
        ObjStips.Cloufi__Opportunity__c = oppObj.id;
        ObjStips.Status__c = 'Completed';
        ObjStips.Control_Sheet_Version__c = 1;
        ObjStips.Cloufi__URL__c ='https://www.dropbox.com/s/6pvxabx1plkjvx6/Control%20Sheet%205%20O9s23Zxlpg.jpg?dl=1';
        insert ObjStips;
        system.debug('ObjStips=>'+ObjStips);
        docList.add(ObjStips);
        
        //Insert UW share Document
        UW_Document_Share__c objUWShare = new UW_Document_Share__c(Opportunity__c = oppobj.Id, UW_Documents__c = ObjStips.Id,Control_Sheet_Contact__c=objContact.Id);
        insert objUWShare;
        
        PageReference myVfPage = Page.ControlSheetPortal;
        Test.setCurrentPage(myVfPage);
        ApexPages.StandardController sc = new ApexPages.StandardController(objContact);
        apexpages.currentpage().getparameters().put('id',objContact.id);
        ControlSheetDeptLoginController objController = new ControlSheetDeptLoginController(sc);
        Test.setMock( HttpCalloutMock.class, new ControlSheetDeptLoginController_Test());
        Test.startTest();
            objController.customStipFileName = 'Test Attachment';
            objController.customStipFileBody = Blob.valueOf('Unit Test Attachment Body');
            objController.selectedOppId = oppObj.id;
            objController.objControlSheet = ObjStips;
            objController.controlSheet = docList;
            objController.uploadControlSheet();
            objController.Logout();

            objController.username = 'email@gmail.com';
            objController.forgetPassword();
        Test.stopTest();

    }

    public static testMethod void executeGeneratePassword(){

        // Insert custom setting
        Cloufi__Dropbox_Settings__c dropBoxSetting = new Cloufi__Dropbox_Settings__c(Name = 'Cloufi__Access_Token__c', Cloufi__Access_Token__c = 'Test access Token');
        insert dropBoxSetting;

        // Inserting Account
        Account objAccount = new Account(Name='Test Account');
        insert objAccount;

        // Inserting Contact
        Contact objContact=new Contact(AccountId=objAccount.Id,FirstName='fname',LastName = 'lname',Email = 'email@gmail.com',Control_sheet_Portal_Access__c=true,password__c='12345678'); 
        insert objContact;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objContact);
        apexpages.currentpage().getparameters().put('id',objContact.id);
        ControlSheetGeneratePasswardController objController = new ControlSheetGeneratePasswardController(sc);

        Test.startTest();

            objController.saveMethod();
            
            objController.password = '12345679';
            objController.confirmPassword = '12345670';
            objController.saveMethod();

            objController.password = '1234567';
            objController.saveMethod();

            objController.password = '12345678';
            objController.confirmPassword = '12345678';
            objController.saveMethod();
        Test.stopTest();

    }
}