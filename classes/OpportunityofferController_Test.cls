/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: OpportunityofferController_Test
* Created Date: 28-September-2018
* Description:  Test class for OpportunityofferController
*******************************************************************/
/*Author  			| Date       | Description
 Neha				| 26-Jan-2019| Increase test class coverage
**/
@isTest
public class OpportunityofferController_Test {
	public static testMethod void testOpportunityOffer(){
        //Insert Account
        Account objAcc= new Account(Name='Test Acc',country__c='Canada');
        insert objAcc;
        
        Cloufi__Product__c program = new Cloufi__Product__c();
        program.Cloufi__Account__c = objAcc.Id;
        program.Average_Monthly_Revenue__c = 1000;
        insert program;
        
        //Insert Contact
        Contact objCon = new Contact(AccountId=objAcc.id,LastName='Test Contact',Email='test@gmail.com',Contract__c=true);
        insert objCon;
        
        // Insert Opportunity
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Test Opportunity';
        objOpp.CloseDate = system.today();
        objOpp.StageName = 'Closed Won';
        objOpp.Owner_1_Email__c ='test@gmail.com';
        objOpp.AccountId = objAcc.id;
        objOpp.Cloufi__Funder__c= objAcc.id;
        objOpp.CloufiServicing__Submission_Country__c = 'Canada';
        insert objOpp;
        
        List<String> otherStipIds = new List<String>();
        List<String> stipIds = new List<String>();
         //Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Status__c='Completed',Sent_for_Contract__c=true,Cloufi__URL__c='www.salesforce.com',Cloufi__Type__c='Stip',Cloufi__Opportunity__c=objOpp.id,stip_Name__c='Test',Name = 'Test UW Docu');
        insert objUWDocument ; 
        
        //Insert UW_Document_Share__c
        UW_Document_Share__c objUWDOC = new UW_Document_Share__c(UW_Documents__c = objUWDocument.id, Opportunity__c = objOpp.id);
        insert objUWDOC;
        
        Cloufi__UW_Document__c objUWDocument1 = new Cloufi__UW_Document__c(Status__c='Completed',Sent_for_Contract__c=true,Cloufi__URL__c='www.salesforce.com',Cloufi__Type__c='Stip',Cloufi__Opportunity__c=objOpp.id,stip_Name__c='Test',Name = 'Test UW Docu');
        insert objUWDocument1 ;
        stipIds.add(objUWDocument.id);
        otherStipIds.add(objUWDocument1.id);
        // Insert Offers
        List<Cloufi__Offers__c> lstOffers = new List<Cloufi__Offers__c>();
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c(Cloufi__Offer_Status__c='New',Cloufi__Opportunity__c = objOpp.Id,Cloufi__Terms_In_Months__c=10,Cloufi__Funding_Amount__c=1000,Cloufi__Payback_Amount__c=1000,Factor_Rate__c=1.2,Cloufi__Daily_PB_Amount__c=100,Cloufi__Percentage_Of_Gross__c=10);
        insert objOffer;
        lstOffers.add(objOffer);
        Test.startTest();
            OpportunityofferController objCtrl = new OpportunityofferController();
            OpportunityofferController.fetchOffer(objOpp.id);
            OpportunityofferController.fetchUser();
        	OpportunityofferController.initNewOffer();
            OpportunityofferController.saveOffer(lstOffers);
            OpportunityofferController.cancelOffer(lstOffers);
            OpportunityofferController.getselectOptions(objOffer,'Cloufi__Offer_Status__c');
        	OpportunityofferController.getOtherUWDocumentList(objOpp.id);
            objOpp.StageName = 'Approved';
            Update objOpp;
        	OpportunityofferController.isOppInApprovedStage(objOpp.id);
        	OpportunityofferController.checkSubmissionCountry(objOpp.id);
        	OpportunityofferController.getCompletedUWDocumentList(objOpp.id);
        	OpportunityofferController.requestContract(stipIds, objOpp.id,otherStipIds);
        	OpportunityofferController.isOfferChosen(objOpp.id);
        	OpportunityofferController.isReqDocsAvailable(objOpp.id);
        	OpportunityofferController.getCurrentOpp(objOpp.id);
        	OpportunityofferController.checkForSignedApp(objOpp.id);
        	OpportunityofferController.getProgramDetails(objAcc.Id);
        	Cloufi__Offers__c objOffer1 = new Cloufi__Offers__c(Cloufi__Offer_Status__c='New',Cloufi__Opportunity__c = objOpp.Id,Cloufi__Terms_In_Months__c=10,Cloufi__Funding_Amount__c=1000,Cloufi__Payback_Amount__c=1000,Factor_Rate__c=1.2,Cloufi__Daily_PB_Amount__c=100,Cloufi__Percentage_Of_Gross__c=10);
        	OpportunityofferController.saveNewOfferController(objOffer1,objOpp.id,program.Id);
        Test.stopTest();
        
    }
}