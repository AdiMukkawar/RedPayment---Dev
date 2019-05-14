/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: SubmissionEmailAlerts_ctl
* Created Date: 25-September-2018
* Description:  Test class for OpportunityOffersController
*******************************************************************/
@isTest
public class SubmissionEmailAlerts_ctl_Test {
    public static testMethod void testSubmissionEmailAlerts(){
        //Insert Account
        Account objAcc = new Account(Name='Test Account');
        insert objAcc;
        
        //Insert Contact
        Contact objCon = new Contact(FirstName='Test Name',LastName='Test ',Accountid= objAcc.id,Revision__c=true,Submission__c=true,Contract__c=true,email='test@gmail.com');
        insert objCon;
        
        // Insert Opportunity
        Opportunity objOpp = new Opportunity(Name = 'Test Opportunity',CloseDate = system.today(),StageName = 'Closed Won',AccountId=objAcc.id);
        insert objOpp;
        
        //Insert Submission
        Cloufi__Submission__c objSub = new Cloufi__Submission__c(Cloufi__Lender__c=objAcc.Id,Cloufi__Opportunity__c=objOpp.id);
        insert objSub;
        
        SubmissionEmailAlerts_ctl objCtrl = new SubmissionEmailAlerts_ctl();
        SubmissionEmailAlerts_ctl.AlertToLender(objSub.id, 'Submission');
        SubmissionEmailAlerts_ctl.AlertToLender(objSub.id, 'Contract');
        SubmissionEmailAlerts_ctl.AlertToLender(objSub.id, 'General');
        SubmissionEmailAlerts_ctl.AlertToLender(objSub.id, 'Funding');
        SubmissionEmailAlerts_ctl.AlertToLender(objSub.id, 'Commission');
        SubmissionEmailAlerts_ctl.sendSelectedOptionMail(objSub.id, 'Submission', 'Testing');
        SubmissionEmailAlerts_ctl.sendSelectedOptionMail(objSub.id, 'Contract', 'Testing');
        SubmissionEmailAlerts_ctl.sendSelectedOptionMail(objSub.id, 'Revision', 'Testing');
        SubmissionEmailAlerts_ctl.isLenderAvailable(objSub.id);
    }
    
}