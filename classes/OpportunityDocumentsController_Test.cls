/*******************************************************************************************
-------------------------------------------------------------------------------------------
Author           | Project       |Date              | Description
-------------------------------------------------------------------------------------------
Aditya Mukkawar  | Red Payment   |18-September-2018 | Test class for OpportunityDocumentsController
*******************************************************************************************/
@isTest
public class OpportunityDocumentsController_Test {
    public static testmethod void OpportunityDocumentsControlleTest(){
        //Insert Opportunity
        Opportunity objOpp = new Opportunity(Name = 'Test Opportunity',CloseDate = system.today(),StageName = 'Closed Won');
        insert objOpp;
        
        // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Application_Status__c='In Progress',tabnumber__c=2,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',CreditScore__c='700+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;
        
        //Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Cloufi__URL__c='www.google.com',Cloufi__Opportunity__c=objOpp.id,stip_Name__c='September-2018 Bank Statement',Cloufi__Application__c = objApp.id,Name = 'September-2018 Bank Statement',Cloufi__Type__c = 'Bank Statement');
        insert objUWDocument ;
        
        Attachment objAttachment = new Attachment();
        objAttachment.Name = 'September-2018 Bank Statement';
        objAttachment.Body = blob.valueOf('September-2018 Bank Statement');
        objAttachment.ParentId = objUWDocument.Id;
        //insert objAttachment;

        //Insert UW document
        objUWDocument = new Cloufi__UW_Document__c(Cloufi__URL__c='www.google.com',Cloufi__Opportunity__c=objOpp.id,stip_Name__c='Copy of the lease with rent checks',Cloufi__Application__c = objApp.id,Name = 'September-2018 Bank Statement',Cloufi__Type__c = 'Stip',Status__c='Completed');
        insert objUWDocument ;
        
        objAttachment = new Attachment();
        objAttachment.Name = 'Copy of the lease with rent checks';
        objAttachment.Body = blob.valueOf('Copy of the lease with rent checks');
        objAttachment.ParentId = objUWDocument.Id;
        //insert objAttachment;
        
        Test.startTest();
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objOpp);
            ApexPages.currentPage().getParameters().put('Id',objOpp.id);
            OpportunityDocumentsController objCtl = new OpportunityDocumentsController(new ApexPages.StandardController(objOpp));
            OpportunityDocumentsController.StipAttachment cmp = new OpportunityDocumentsController.StipAttachment(objUWDocument);
        	List <OpportunityDocumentsController.StipAttachment> cmpList = new List <OpportunityDocumentsController.StipAttachment>();
        	cmp.attachmentBlob = blob.valueOf('Copy of the lease with rent checks');
        	cmp.fileNameStr = 'Test';
        	cmpList.add(cmp);
            objCtl.listStipAttachment = cmpList;
            objCtl.uploadDocuments();
        Test.stopTest();
    }

}