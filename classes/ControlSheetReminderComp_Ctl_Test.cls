/*****************************************************************
Test Class Name : ControlSheetReminderComp_Ctl_Test 
-------------------------------------------------------------------------------------------
Author           | Project       |    Date       | Description
-------------------------------------------------------------------------------------------
Aditya Mukkawar  | Red Payment   |   04/01/2019  | Test class for ControlSheetReminderComp_Ctl
********************************************************************/
@isTest
public class ControlSheetReminderComp_Ctl_Test {
    
    public static testMethod void ControlSheetReminderCompExecute(){
        //Insert Opportunity
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'test';
        oppObj.StageName = 'Application';
        oppobj.CloseDate = system.today();
        oppobj.Cloufi__Monthly_Revenue__c = 10000;
        oppobj.Cloufi__Type_of_Business__c = 'test';
        oppobj.CloufiServicing__Submission_Country__c = 'United States';
        insert oppObj;
        
        // Insert UW Doc
        cloufi__Uw_Document__c objUW = new cloufi__Uw_Document__c();
        objUW.Cloufi__Opportunity__c = oppObj.id;
        objUW.Control_Sheet_Recipients__c = 'test@gmail.com,test123@gmail.com';
        objUW.Control_Sheet_requested_Date_Time__c = System.now().addHours(-3);
        objUW.Stip_name__c = 'Control Sheet';
        objUW.Sent_to_Control_Sheet_Dept__c = true;
        insert objUW;
        
        Test.startTest();
        	ControlSheetReminderComp_Ctl objCtrl = new ControlSheetReminderComp_Ctl();
        	objCtrl.getUWList();
        Test.stopTest();
    }

}