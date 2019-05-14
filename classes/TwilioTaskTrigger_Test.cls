@isTest
public class TwilioTaskTrigger_Test {
    public static testmethod void executeTwilioTaskTrigger(){
        // Insert Lead
        Lead objLead = New Lead(Email='test@gmail.com',LastName='Test1',Status='New',Company='TestCompany',Average_Monthly_Revenue__c='$10,000 - $24,999',Time_in_Business__c='1-3 Years',Phone='9632587410',country='Canada');
        insert objLead;
        
        // Insert Opportunity
        Opportunity objOpp = new Opportunity(Name = 'Test Opportunity',CloseDate = system.today(),StageName = 'Closed Won',Cloufi__Email_Address__c='test@gmail.com');
        insert objOpp;
        
        // Insert Task for Opportunity
        Task objTask = new Task(whatid=objOpp.id,OwnerId = UserInfo.getUserId(),Subject='Donni',Status='Not Started',Priority='Normal',Cloufi_Twilio__Type__c = 'Incoming');
        insert objTask;
        
        // Insert Task for Lead
        Task objTask1 = new Task(whoId=objLead.id,OwnerId = UserInfo.getUserId(),Subject='Donni',Status='Not Started',Priority='Normal',Cloufi_Twilio__Type__c = 'Incoming');
        insert objTask1;
    }
}