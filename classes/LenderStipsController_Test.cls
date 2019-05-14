/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: LenderStipsController_Test
* Created Date: 01-09-2019
* Description:  Test class for LenderStipsController
*******************************************************************/

@isTest
public class LenderStipsController_Test {

    public static testMethod void testLenderStipsController(){
        
        // Insert Account
        Account objAccount = new Account(Name = 'Test');
        insert objAccount;
        
        //Insert Opportunity
        Opportunity objOpp = new Opportunity(Name = 'Test Opportunity',CloseDate = system.today(),StageName = 'Closed Won', Cloufi__Funder__c = objAccount.Id, Cloufi__Dropbox_Folder_Path__c = 'Test');
        insert objOpp;
        
        // Insert Submission
        //Cloufi__Submission__c objSubmission = new Cloufi__Submission__c(Cloufi__Status__c='Approved',Decline_Reason__c = 'test',Cloufi__Opportunity__c = objOpp.Id, Cloufi__Lender__c = objOpp.Cloufi__Funder__c);
        Cloufi__Submission__c objSubmission = new Cloufi__Submission__c(Cloufi__Status__c='Approved',Cloufi__Opportunity__c = objOpp.Id, Cloufi__Lender__c = objOpp.Cloufi__Funder__c);
        insert objSubmission;
        
        //Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Status__c='Completed',Sent_for_Contract__c=true,Cloufi__URL__c='www.salesforce.com',Cloufi__Type__c='Stip',Cloufi__Opportunity__c=objOpp.id,stip_Name__c='Test',Name = 'Test UW Docu');
        insert objUWDocument ;
        
        // Insert UW Document share
        UW_Document_Share__c objShare = new UW_Document_Share__c(Account__c = objOpp.Cloufi__Funder__c, Opportunity__c=objOpp.id, UW_Documents__c=objUWDocument.id);
        insert objShare;
        
        Test.startTest();
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objOpp);
            ApexPages.currentPage().getParameters().put('Id',objOpp.id);
            LenderStipsController objCtl = new LenderStipsController(new ApexPages.StandardController(objOpp));
            objCtl.AddCustomStip();
            objCtl.AddCustomStipCancel();
            objCtl.AddcustomStipsSave();
            objCtl.requestStipShowCancel();
            objCtl.requestStipShow();
            objCtl.requestStipsSave();
        Test.stopTest();
        
    }
}