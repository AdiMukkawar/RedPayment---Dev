/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: RevisedOfferController_Test
* Created Date: 28-September-2018
* Description:  Test class for RevisedOfferController
*******************************************************************/

@isTest
public class RevisedOfferController_Test {
    public static testMethod void testRevisedOffer(){
        
        // Insert Account
        Account objAcc = new Account(Name='Test Acc');
        insert objAcc;
        
        //Insert contacts under account
        Contact objContact = new Contact(FirstName='Test',Lastname='TestLast',Email='test@test.com',AccountId=objAcc.Id,Revision__c=true);
        insert objContact;
        
        // Insert Opportunity
        Opportunity objOpp =new Opportunity(Name='Test',AccountID = objAcc.ID,StageName = 'Qualified',CloseDate = System.today(),Cloufi__Payback_Amount__c=2000,Cloufi__Monthly_Gross_Sale__c=3000,Cloufi__Funder__c=objAcc.id,Amount =151250,Cloufi__Loan_Term__c=7,Cloufi__Account__c=objAcc.Id);
        insert objOpp;
        
        // Insert Submission
        Cloufi__Submission__c ObjSub = new Cloufi__Submission__c(Cloufi__Opportunity__c=objOpp.id,Cloufi__Lender__c=objAcc.id,Cloufi__Status__c='Requested');
        insert objSub;
        
        // Insert Offer
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c(Revision_Notes__c='Test',Cloufi__Offer_Status__c = 'Revision',Program_Type__c='MCA',Cloufi__Submission__c=objSub.id,Cloufi__Opportunity__c=objOpp.id,Cloufi__Funder__c = objAcc.id);
        insert objOffer;
        
        PageReference myVfPage = Page.RevisedOfferPage;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id',objOffer.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objOffer);
        RevisedOfferController objContrl = new RevisedOfferController(sc);
        objContrl.notifyLender();
    }

}