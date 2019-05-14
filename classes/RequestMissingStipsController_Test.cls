/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: RequestMissingStipsController_Test
* Created Date: 14-September-2018
* Description:  Test class for RequestMissingStipsController
*******************************************************************/
@isTest
public class RequestMissingStipsController_Test {
    public static testMethod void executeRequestMissingStipsController(){
        //Insert Control sheet department account
        Account objAccount = new Account(Name='Test Acc');
        insert objAccount;
        
        //Insert contacts under account
        Contact objContact = new Contact(FirstName='Test',Lastname='TestLast',Email='test@test.com',AccountId=objAccount.Id);
        insert objContact;
        
        //Insert Opportunity
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'test';
        objOpp.StageName = 'Application';
        objOpp.CloseDate = system.today();
        objOpp.Owner_1_Email__c = 'test@gmail.com';
        insert objOpp;
        
        //Insert UW Document
        Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c(Name='Test',Stip_Name__c='Signed Application',Cloufi__Opportunity__c=objOpp.Id);
        insert objUW;
        
        PageReference myVfPage = Page.RequestMissingStips;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id',objOpp.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpp);
        RequestMissingStipsController objContrl = new RequestMissingStipsController(sc);
        objContrl.OpportunityId = objOpp.id;
        objContrl.sendMissingDocs();
    }

}