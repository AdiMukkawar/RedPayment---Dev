/*****************************************************************
Test Class Name : TaskTrigger_Test 
-------------------------------------------------------------------------------------------
Author           | Project       |    Date       | Description
-------------------------------------------------------------------------------------------
Aditya Mukkawar  | Red Payment   |   10/07/2018  | Test class for TaskTrigger and TaskTriggerHandler
********************************************************************/
@isTest
public class TaskTrigger_Test {
    public static testMethod void executeTaskTrigger(){
        //Insert Lead
        Lead objLead = New Lead(LastName='Test1',Status='New',Company='TestCompany',Phone='9632587410');
        insert objLead;
        
        //Insert Task
        List<Task> lstTasks = new List<Task>();
        Task objTask = new Task(subject='call',whoId=objLead.id);
        lstTasks.add(objTask);
        
       	Task objTask1 = new Task(subject='Other',whoId=objLead.id);
        lstTasks.add(objTask1); 
        insert lstTasks;
        
        // Update Task 
        lstTasks[0].subject='Other';
        update lstTasks[0];
        
        // delete Task 
        delete lstTasks[0];
        
        // delete Task 
        undelete lstTasks[0];
        
        // Insert Opportunity
        Opportunity objOpp = new Opportunity(Name = 'Test Opportunity',CloseDate = system.today(),StageName = 'Closed Won',Cloufi__Email_Address__c='test@gmail.com');
        insert objOpp;
        
        // Insert Task for Opportunity
        Task objTask2 = new Task(whatid=objOpp.id,OwnerId = UserInfo.getUserId(),Subject='Donni',Status='Not Started',Priority='Normal',Cloufi_Twilio__Type__c = 'Incoming');
        insert objTask2;
        
         // Insert Lead
        Lead objLead1 = New Lead(Email='test@gmail.com',LastName='Test1',Status='New',Company='TestCompany',Average_Monthly_Revenue__c='$10,000 - $24,999',Time_in_Business__c='1-3 Years',Phone='9632587410',country='Canada');
        insert objLead1;
        
        // Insert Task for Lead
        Task objTask3 = new Task(whoId=objLead1.id,OwnerId = UserInfo.getUserId(),Subject='Donni',Status='Not Started',Priority='Normal',Cloufi_Twilio__Type__c = 'Incoming');
        insert objTask3;
    }
}