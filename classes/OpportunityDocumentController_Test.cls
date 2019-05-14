/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Test Class Name: OpportunityDocumentController_Test
* Created Date: 1-October-2018
* Description:  Test class for OpportunityDocumentController
*******************************************************************/
@isTest
public class OpportunityDocumentController_Test {

    public static testMethod void testOpportunityDocument(){
        // Insert Custom setting
		Cloufi__LendingXL_Settings__c objSettings = new Cloufi__LendingXL_Settings__c(Name='Site_URL',Cloufi__Value__c ='test1');
        insert objSettings;
        
        //Insert Account
        Account objAccount = new Account(Name='Test Funder');
        insert objAccount;
        
        // Insert Opportunity
        Opportunity objOpp = new Opportunity(Name = 'Test Opportunity',CloseDate = system.today(),StageName = 'Closed Won',Owner_1_Email__c ='test@gmail.com',Cloufi__Email_Address__c ='test1@gmail.com' , Cloufi__Funder__c = objAccount.Id);
        insert objOpp;
        
        // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(cloufi__Opportunity__c =objOpp.id,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;
        
                
         // Insert Offers
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c(Cloufi__Opportunity__c = objOpp.Id,Cloufi__Offer_Status__c = 'Chosen');
        insert objOffer;
        
        // Insert Document
        List<string> otherStipIds = new List<string>();
        List<string> stipIds = new List<string>();
        List<Cloufi__UW_Document__c> lstDocument = new List<Cloufi__UW_Document__c>();
        Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c(Status__c='Requested',Cloufi__Type__c='Stip',Name='Signed Application',Stip_Name__c='Signed Application',Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application__c=objApp.id);
        insert objUW;
        Cloufi__UW_Document__c objUW1 = new Cloufi__UW_Document__c(Status__c='Requested',Cloufi__Type__c='Stip',Name='Signed Application',Stip_Name__c='Signed Application',Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application__c=objApp.id);
        insert objUW1;
        //Insert UW_Document_Share__c
        UW_Document_Share__c objUWDOC = new UW_Document_Share__c(UW_Documents__c = objUW.id, Opportunity__c = objOpp.id);
        insert objUWDOC;
        
        lstDocument.add(objUW);
        stipIds.add(objUW.id);
        otherStipIds.add(objUW1.id);
        Test.startTest();
            OpportunityDocumentController objCtrl = new OpportunityDocumentController();
            OpportunityDocumentController.fetchDocument(objOpp.id);
            OpportunityDocumentController.checkOppStage(objOpp.id);
        	OpportunityDocumentController.requestStipVisibleCtrl(objOpp.id);
            OpportunityDocumentController.allDocumentsCompleted(objOpp.id);
        	OpportunityDocumentController.getOtherUWDocumentList(objOpp.id);
        	OpportunityDocumentController.createShareForLender(objOpp.id,otherStipIds,objAccount.id);
        
            OpportunityDocumentController.saveDocument(lstDocument);
            OpportunityDocumentController.cancelDocument(lstDocument);
        	String fld = 'Status__c';
            OpportunityDocumentController.getselectOptions(objOpp, fld);
            
            OpportunityDocumentController.showHideReqDocButtonC(objOpp.Id);
            OpportunityDocumentController.sendemailToOppOwner(objOpp.Id);
            OpportunityDocumentController.showRequDocResult(objOpp.Id);
            OpportunityDocumentController.getUWDocumentList(objOpp.Id);
            OpportunityDocumentController.getSharedUWDocumentList(objOpp.Id,objAccount.id);
            OpportunityDocumentController.getUnsharedUWDocumentList(objOpp.Id,objAccount.id);
            OpportunityDocumentController.sendEmailToLender(stipIds,objOpp.Id,'Test Note',otherStipIds);
            OpportunityDocumentController.RequestStipAlertToMerchant(objOpp.Id);
        	OpportunityDocumentController.RequestStipAlertToSupport(objOpp.Id);
        	//OpportunityDocumentController.getReqLenders(objOpp.Id);
        	OpportunityDocumentController.getReqLendersName(objOpp.Id);
        	OpportunityDocumentController.getUWNameCtrl(objUW.id);
            OpportunityDocumentController.isFunderAvailable(objOpp.Id);
            OpportunityDocumentController.fetchUser();
        	OpportunityDocumentController.deleteUWDocument(objUW.id);
            OpportunityDocumentController.getReqLenders(objOpp.Id);
            OpportunityDocumentController.dealSubmissionList(objOpp.Id);
        	//OpportunityDocumentController.getAllUWDocuments(objOpp.Id);
        	//OpportunityDocumentController.getUWDocuments(objOpp.Id);
        	//OpportunityDocumentController.getHiearchySettings();
       	Test.stopTest();
    }
    
    public static testMethod void testSendForFinalUW(){
        // Insert Custom setting
		Cloufi__LendingXL_Settings__c objSettings = new Cloufi__LendingXL_Settings__c(Name='Site_URL',Cloufi__Value__c ='test1');
        insert objSettings;
        
        //Insert Account
        Account objAccount = new Account(Name='Test Funder');
        insert objAccount;
        
        //Insert Contact
        contact objContact = new contact(Submission__c=true,AccountId=objAccount.id,LastName='Test Name',Email='test@sfdc.com');
		insert objContact;
        
        // Insert Opportunity
        Opportunity objOpp = new Opportunity(accountId=objAccount.id,Name = 'Test Opportunity',CloseDate = system.today(),StageName = 'Closed Won',Owner_1_Email__c ='test@gmail.com',Cloufi__Email_Address__c ='test1@gmail.com');
        insert objOpp;
        
         // Insert Offers
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c(Cloufi__Funder__c=objAccount.Id,Cloufi__Opportunity__c = objOpp.Id,Cloufi__Offer_Status__c = 'Chosen');
        insert objOffer;
        
        // Insert Document
        List<string> stipIds = new List<string>();
        List<string> otherStipIds = new List<string>();
        List<Cloufi__UW_Document__c> lstDocument = new List<Cloufi__UW_Document__c>();
        Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c(Cloufi__URL__c='www.salesforce.com',Status__c='Completed',Cloufi__Type__c='Stip',Name='Signed Application',Stip_Name__c='Signed Application',Cloufi__Opportunity__c=objOpp.Id);
        insert objUW;
        
        Cloufi__UW_Document__c objUW1 = new Cloufi__UW_Document__c(Status__c='Requested',Cloufi__Type__c='Stip',Name='Signed Application',Stip_Name__c='Signed Application',Cloufi__Opportunity__c=objOpp.Id);
        insert objUW1;
        
        lstDocument.add(objUW);
        stipIds.add(objUW.id);
        otherStipIds.add(objUW.id);
        Test.startTest();
        OpportunityDocumentController objCtrl = new OpportunityDocumentController();
        OpportunityDocumentController.fetchDocument(objOpp.id);
        OpportunityDocumentController.checkOppStage(objOpp.id);
        OpportunityDocumentController.allDocumentsCompleted(objOpp.id);
        OpportunityDocumentController.sendEmailToLender(stipIds,objOpp.Id,'Test Note',otherStipIds);
        test.stopTest();
    }
}