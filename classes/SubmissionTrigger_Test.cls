/******************************************************************************
Author             | Date           | Description
Aditya Mukkawar    | 14-Feb-2019    | Test class for SubmissionTrigger
******************************************************************************
 Updates
* Author            | Date            | Description

**********************************************************************************/
@isTest
public class SubmissionTrigger_Test{
    static testMethod void SubmissionTrigger_Test(){
        Account acc=new Account(Name='Test');
        insert acc;
        
        Opportunity loan=new Opportunity(Name='Test',AccountID = acc.ID,StageName = 'Qualified',CloseDate = System.today(),Cloufi__Payback_Amount__c=2000,Cloufi__Monthly_Gross_Sale__c=3000,Cloufi__Funder__c=acc.id,Amount =151250,Cloufi__Loan_Term__c=7,Cloufi__Account__c=acc.Id);
        insert loan;
        
       // Cloufi__Submission__c objSubmission = new Cloufi__Submission__c(Cloufi__Status__c='Requested',Decline_Reason__c = 'test',Cloufi__Opportunity__c = loan.Id,Cloufi__Lender__c = acc.Id);
        Cloufi__Submission__c objSubmission = new Cloufi__Submission__c(Cloufi__Status__c='Requested',Cloufi__Opportunity__c = loan.Id,Cloufi__Lender__c = acc.Id);
        insert objSubmission;
        objSubmission.Cloufi__Status__c='Declined';
        update objSubmission;

    }
}