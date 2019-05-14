/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Prashant Mahajan)
* Class Name: OpportunityOffersController_Test
* Created Date: 24-August-2018
* Description:  Test class for OpportunityOffersController
*******************************************************************
*Aditya Mukkawar | 18-September-2018 | Increased test class code coverage
*******************************************************************/
@isTest
public class OpportunityOffersController_Test {

    public static testMethod void testOpportunityOffer(){
        
        // Insert Opportunity
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Test Opportunity';
        objOpp.CloseDate = system.today();
        objOpp.StageName = 'Closed Won';
        objOpp.Owner_1_Email__c ='test@gmail.com';
        insert objOpp;
        
        // Insert Offers
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c();
        objOffer.Cloufi__Opportunity__c = objOpp.Id;
        insert objOffer;
        
        List<string> stipIds = new List<string>();
        //Insert UW Document
        Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c(Cloufi__Type__c='Stip',Name='Signed Application',Stip_Name__c='Signed Application',Cloufi__Opportunity__c=objOpp.Id);
        insert objUW;
        stipIds.add(objUW.id);

        
        OpportunityOffersController obj = new OpportunityOffersController();
        OpportunityOffersController.fetchUser();
        OpportunityOffersController.getFieldSet('Cloufi__Offers__c', 'OpportunityOffers');
        OpportunityOffersController.getsObjRecords('Cloufi__Offers__c', 'OpportunityOffers',objOpp.Id,'Cloufi__Offers__c');
        
        OpportunityOffersController.getFieldSet('Cloufi__Submission__c', 'OpportunitySubmissions');
        OpportunityOffersController.getsObjRecords('Cloufi__Submission__c', 'OpportunitySubmissions',objOpp.Id,'Cloufi__Submission__c');
        
        OpportunityOffersController.getFieldSet('CloufiServicing__Syndication__c', 'OpportunitySyndications');
        OpportunityOffersController.getsObjRecords('CloufiServicing__Syndication__c', 'OpportunitySyndications',objOpp.Id,'CloufiServicing__Syndication__c');
        
        OpportunityOffersController.getFieldSet('Cloufi__UW_Document__c', 'OpportunityDocuments');
        OpportunityOffersController.getsObjRecords('Cloufi__UW_Document__c', 'OpportunityDocuments',objOpp.Id,'Cloufi__UW_Document__c');
        
        //OpportunityOffersController.showHideSendStipButtonC(objOpp.Id);
        OpportunityOffersController.showHideReqDocButtonC(objOpp.Id);
        OpportunityOffersController.sendemailToOppOwner(objOpp.Id);
        OpportunityOffersController.showRequDocResult(objOpp.Id);
        OpportunityOffersController.getUWDocumentList(objOpp.Id);
        OpportunityOffersController.sendEmailToLender(stipIds,objOpp.Id);
        OpportunityOffersController.RequestStipAlertToMerchant(objOpp.Id);
        
    }
    
    public static testMethod void testOpportunityOfferOne(){
		//Insert Account
        Account objAcc = new Account(Name='Test Account');
        insert objAcc;
        
        //Insert Contact
        Contact objCon = new Contact(FirstName='Test Name',LastName='Test ',Accountid= objAcc.id,Submission__c=true,email='test@gmail.com');
        insert objCon;
		
        // Insert Opportunity
        Opportunity objOpp = new Opportunity(Name = 'Test Opportunity',CloseDate = system.today(),StageName = 'Closed Won',AccountId=objAcc.id,
        Cloufi__Funder__c = objAcc.id);
        insert objOpp;
        
        // Insert Offers
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c(Cloufi__Opportunity__c = objOpp.Id,Cloufi__Offer_Status__c='Approved',Cloufi__Funder__c=objAcc.id);
        insert objOffer;
        
		List<string> stipIds = new List<string>();
        //Insert UW Document
        Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c(Cloufi__Type__c='Stip',Cloufi__URL__c='www.salesforce.com',Name='Signed Application',Stip_Name__c='Signed Application',Cloufi__Opportunity__c=objOpp.Id);
        insert objUW;
		stipIds.add(objUW.id);
        
        OpportunityOffersController obj = new OpportunityOffersController();
        OpportunityOffersController.showRequDocResult(objOpp.Id);
		OpportunityOffersController.sendEmailToLender(stipIds,objOpp.Id);
        OpportunityOffersController.isFunderAvailable(objOpp.Id);
    }
}