/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: SubmissionOfferCompController_Test
* Created Date: 02-October-2018
* Description:  Test class for SubmissionOfferCompController
*******************************************************************/

@isTest
public class SubmissionOfferCompController_Test {
	public static testMethod void testSubmissionOffer(){
        Account objAcc = new Account();
        objAcc.Name= 'Test Account';
        insert objAcc;
           
        // Insert Opportunity
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Test Opportunity';
        objOpp.CloseDate = system.today();
        objOpp.StageName = 'Closed Won';
        objOpp.Owner_1_Email__c ='test@gmail.com';
        objOpp.AccountId = objAcc.id;
        insert objOpp;
        
        Cloufi__Submission__c objSub = new Cloufi__Submission__c();
        objSub.Cloufi__Opportunity__c = objOpp.id;
        objSub.Cloufi__Status__c = 'New';
        objSub.Cloufi__Lender__c = objAcc.id;
        insert objSub;
        
        // Insert Offers
        List<Cloufi__Offers__c> lstOffers = new List<Cloufi__Offers__c>();
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c();
        objOffer.Cloufi__Opportunity__c = objOpp.Id;
        objOffer.Cloufi__Submission__c =objSub.id;
        insert objOffer;
        lstOffers.add(objOffer);
        
        SubmissionOfferCompController objCtrl = new SubmissionOfferCompController();
        SubmissionOfferCompController.fetchUser();
        SubmissionOfferCompController.fetchOffer(objOpp.id);
        SubmissionOfferCompController.saveOffer(lstOffers);
        SubmissionOfferCompController.cancelOffer(lstOffers);
        SubmissionOfferCompController.getselectOptions(objOffer,'Cloufi__Offer_Status__c');
        
    }
}