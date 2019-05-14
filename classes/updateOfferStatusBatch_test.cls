/*Author | Date       | Description
Neha     | 08/22/2018 | Test class for updateOfferStatusBatch
*/

@isTest
public class updateOfferStatusBatch_test {
    static testmethod void TestupdateOfferStatusBatch() {
        Account objAccount = new Account();
        objAccount.Name = 'Test Funder';
        insert objAccount;
        
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'test';
        oppObj.StageName = 'Application';
        oppobj.CloseDate = system.today();
        oppobj.isPrivate=true;
        oppobj.Cloufi__Monthly_Revenue__c = 10000;
        oppobj.Cloufi__Type_of_Business__c = 'test';
        oppobj.CloufiServicing__Submission_Country__c = 'United States';
        insert oppObj;
        
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c();
        objOffer.Cloufi__Opportunity__c = oppObj.id;
        objOffer.Cloufi__Funder__c = objAccount.id;
        //objOffer.Cloufi__Submission__c = objSubmission.id;
        objOffer.Cloufi__Offer_Status__c = 'New';
        insert objOffer;
        
        Test.setCreatedDate(objOffer.Id, System.today()-31);

        
        Test.startTest();
        UpdateOfferStatusBatch objBatch = new UpdateOfferStatusBatch();
        Database.executeBatch(objBatch);
        Test.stopTest();
    }
}