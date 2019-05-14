/*****************************************************************
Test Class Name : ApplicationDocumentController_Test 
-------------------------------------------------------------------------------------------
Author           | Project       |    Date       | Description
-------------------------------------------------------------------------------------------
Aditya           | Red Payment   | 04-10-18      | Test class for ApplicationDocumentController
********************************************************************/
@isTest
public class ApplicationDocumentController_Test {
    public static testMethod void testApplicationDocument(){
        
        //Insert Opportunity
        Opportunity objOpp = new opportunity(Name = 'Test Opportunity',CloseDate = system.today(),StageName = 'Closed Won');
        insert objOpp;
        
         // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application_Status__c='In Progress',tabnumber__c=2,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',CreditScore__c='700+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;
        
        // Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Cloufi__Opportunity__c=objOpp.id,stip_Name__c='Copy of the lease with rent Copy of the lease with rent Copy of the lease with rent Copy of the lease with rent checks Copy of the lease with rent checks Copy of the lease with rent checks',Cloufi__Application__c = objApp.id,Name = 'Test UW Docu',Cloufi__Type__c = '6 month bank');
        insert objUWDocument ;
        
        //Insert Docusign Envelope
        dsfs__DocuSign_Envelope__c objEnvelope = new dsfs__DocuSign_Envelope__c(dsfs__DocuSign_Email_Message__c='Test',dsfs__Source_Object__c =objOpp.id);
        insert objEnvelope;
        
        // Insert Docusign for Opportunity
        dsfs__DocuSign_Status__c objDocuSign = new dsfs__DocuSign_Status__c(dsfs__DocuSign_Envelope_ID__c=objEnvelope.id,dsfs__Opportunity__c=objOpp.id);
        insert objDocuSign;
        
        Test.startTest();
        	PageReference pageRef = Page.ApplicationDocuments;
			pageRef.getParameters().put('envelopeId', String.valueOf(objEnvelope.Id));
			Test.setCurrentPage(pageRef);

			ApplicationDocumentController objCtrl = new ApplicationDocumentController();
        	List <ApplicationDocumentController.StipAttachment> cmpList = new List <ApplicationDocumentController.StipAttachment>();
        	ApplicationDocumentController.StipAttachment cmp = new ApplicationDocumentController.StipAttachment(objUWDocument);
        	cmp.attachmentBlob = blob.valueOf('Test');
        	cmp.fileNameStr = 'Copy of the lease with rent Copy of the lease with rent Copy of the lease with rent Copy of the lease with rent checks Copy of the lease with rent checks Copy of the lease with rent checks';
        	cmpList.add(cmp);
            objCtrl.listStipAttachment = cmpList;
			objCtrl.uploadDocuments();	
        Test.stopTest();
    }
	
	public static testMethod void testApplicationDocument1(){
        
        //Insert Opportunity
        Opportunity objOpp = new opportunity(Name = 'Test Opportunity',CloseDate = system.today(),StageName = 'Closed Won');
        insert objOpp;
        
         // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application_Status__c='In Progress',tabnumber__c=2,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',CreditScore__c='700+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;
        
        // Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Cloufi__Opportunity__c=objOpp.id,stip_Name__c='Copy of the lease with rent Copy of the lease with rent Copy of the lease with rent Copy of the lease with rent checks Copy of the lease with rent checks Copy of the lease with rent checks',Cloufi__Application__c = objApp.id,Name = 'Test UW Docu',Cloufi__Type__c = '6 month bank');
        insert objUWDocument ;
        
        //Insert Docusign Envelope
        dsfs__DocuSign_Envelope__c objEnvelope = new dsfs__DocuSign_Envelope__c(dsfs__DocuSign_Email_Message__c='Test',dsfs__Source_Object__c =objOpp.id);
        insert objEnvelope;
        
        // Insert Docusign for Opportunity
        dsfs__DocuSign_Status__c objDocuSign = new dsfs__DocuSign_Status__c(dsfs__DocuSign_Envelope_ID__c=objEnvelope.id,dsfs__Opportunity__c=objOpp.id);
        insert objDocuSign;
        
        Test.startTest();
        	PageReference pageRef = Page.ApplicationDocuments;
			pageRef.getParameters().put('opportunityId', objOpp.Id);
			Test.setCurrentPage(pageRef);

			ApplicationDocumentController objCtrl = new ApplicationDocumentController();
        	List <ApplicationDocumentController.StipAttachment> cmpList = new List <ApplicationDocumentController.StipAttachment>();
        	ApplicationDocumentController.StipAttachment cmp = new ApplicationDocumentController.StipAttachment(objUWDocument);
        	cmp.attachmentBlob = blob.valueOf('Test');
        	cmp.fileNameStr = 'Copy of the lease with rent Copy of the lease with rent Copy';
        	cmpList.add(cmp);
            objCtrl.listStipAttachment = cmpList;
			objCtrl.uploadDocuments();	
        Test.stopTest();
    }
}