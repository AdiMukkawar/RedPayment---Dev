/*****************************************************************
Test Class Name : ControlSheetReminder_Test 
-------------------------------------------------------------------------------------------
Author           | Project       |    Date       | Description
-------------------------------------------------------------------------------------------
Aditya Mukkawar  | Red Payment   |   04/01/2019  | Test class for ControlSheetReminder and ScheduleControlSheetReminder
********************************************************************/

@isTest
public class ControlSheetReminder_Test {
    
    public static testMethod void ControlSheetReminderExecute(){
        
        // Insert Bank Holiday
        Cloufi__Bank_Holiday__c objBank = new Cloufi__Bank_Holiday__c();
        objBank.Name = 'Test';
        objBank.Cloufi__Holiday_Date__c = system.today();
        objBank.Cloufi__Payment_Processor__c = 'ACH.com';
        insert objBank;
        
        //Insert Control sheet department account
        Account objAccount = new Account(Name='Control Sheet Department');
        insert objAccount;
        
        //Insert contacts under account
        Contact objContact = new Contact(FirstName='Test',Lastname='TestLast',Email='test@test.com',AccountId=objAccount.Id);
        insert objContact;
        
        //Insert Opportunity
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'test';
        oppObj.StageName = 'Application';
        oppobj.CloseDate = system.today();
        oppobj.Cloufi__Monthly_Revenue__c = 10000;
        oppobj.Cloufi__Type_of_Business__c = 'test';
        oppobj.CloufiServicing__Submission_Country__c = 'United States';
        insert oppObj;
        

        List<cloufi__Uw_Document__c> UWList = new List<cloufi__Uw_Document__c>();
        // Insert UW Doc
        cloufi__Uw_Document__c objUW = new cloufi__Uw_Document__c();
        objUW.Cloufi__Opportunity__c = oppObj.id;
        objUW.Stip_Name__c = 'Control Sheet';
        objUW.Control_Sheet_Recipients__c = 'test@gmail.com,test123@gmail.com';
        objUW.Control_Sheet_requested_Date_Time__c = System.now().addHours(-3);
        objUW.Status__c = 'Requested';
        objUW.Cloufi__Type__c = 'Control Sheet';
        objUW.Sent_to_Control_Sheet_Dept__c = true;
        UWList.add(objUW);

       	cloufi__Uw_Document__c objUW2 = new cloufi__Uw_Document__c();
        objUW2.Cloufi__Opportunity__c = oppObj.id;
        objUW2.Control_Sheet_Recipients__c = 'test@gmail.com,test123@gmail.com';
        objUW2.Control_Sheet_requested_Date_Time__c = System.now().addHours(3);
        objUW.Status__c = 'Requested';
        objUW.Cloufi__Type__c = 'Control Sheet';
        objUW2.Sent_to_Control_Sheet_Dept__c = true;
        UWList.add(objUW2);

        insert UWList;
   
        system.debug('UWList=>'+UWList);
        Test.startTest();
        	ControlSheetReminder objBatch = new ControlSheetReminder();
          	Database.executeBatch(objBatch, 200);

            ScheduleControlSheetReminder shReminder = new ScheduleControlSheetReminder();
            String sch = '0 0 23 * * ?'; 
            system.schedule('Test', sch, shReminder);

        Test.stopTest();
        
    }
}