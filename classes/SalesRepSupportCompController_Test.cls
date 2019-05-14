/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: SalesRepSupportCompController_Test 
* Created Date: 24-September-2018
* Description:  Test class for SalesRepCompController and SalesRepSupportController
*******************************************************************/
@isTest
public class SalesRepSupportCompController_Test {
    public static testMethod void testSalesRepSupportCompController(){
        // Insert Opportunity
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Test Opportunity';
        objOpp.CloseDate = system.today();
        objOpp.StageName = 'Closed Won';
        insert objOpp;
        
        //Insert Task
        Task objTask = new Task();
        objTask.whatid = objOpp.Id;
        objTask.Description = 'Testing Msg';
        objTask.Subject = 'Task Assign to Sales Support';
        objTask.ActivityDate = system.today();
        insert objTask;
        
        Task objTask1 = new Task();
        objTask1.whatid = objOpp.Id;
        objTask1.Description = 'Testing Msg';
        objTask1.Subject = 'Task Assign to Sales Rep';
        objTask1.ActivityDate = system.today();
        insert objTask1;
        
        Test.startTest();
        	SalesRepCompController objCtrl = new SalesRepCompController();
        	objCtrl.oppId = objopp.id;
            objCtrl.getOppLink();
            objCtrl.getMessageFroSupport();
        
        	SalesRepSupportController objCtl = new SalesRepSupportController();
        	objCtl.oppId = objopp.id;
        	objCtl.getOppLink();
        	objCtl.getMessageFormSalesRep();
        Test.stopTest();
    }
    @isTest
    public static void testSalesRepSupportCompController2()
    {
        SalesRepCompController objSales = new SalesRepCompController();
        objSales.getMessageFroSupport();
        objSales.getOppLink();
        
        SalesRepSupportController objSales1 = new SalesRepSupportController();
        objSales1.getMessageFormSalesRep();
        objSales1.getOppLink();
    }
}