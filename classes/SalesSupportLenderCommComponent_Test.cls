/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: SalesSupportLenderCommComponent_Test 
* Created Date: 01/23/2019
* Description:  Test class for SalesSupportToLenderCompCtrl and LenderToSalesSupportCompCtrl
*******************************************************************/
@isTest
public class SalesSupportLenderCommComponent_Test {
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
        objTask.Subject = 'Message from Lender to Sales Support';
        objTask.ActivityDate = system.today();
        insert objTask;
        
        Task objTask1 = new Task();
        objTask1.whatid = objOpp.Id;
        objTask1.Description = 'Testing Msg';
        objTask1.Subject = 'Message from Sales Support to Lender';
        objTask1.ActivityDate = system.today();
        insert objTask1;
        
        Test.startTest();
        	SalesSupportToLenderCompCtrl objCtrl = new SalesSupportToLenderCompCtrl();
        	objCtrl.oppId = objopp.id;
            objCtrl.getOppLink();
            objCtrl.getMessageFroSupport();
        
        	LenderToSalesSupportCompCtrl objCtl = new LenderToSalesSupportCompCtrl();
        	objCtl.oppId = objopp.id;
        	objCtl.getOppLink();
        	objCtl.getMessageFormSalesRep();
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod2()
    {
        LenderToSalesSupportCompCtrl objLender = new LenderToSalesSupportCompCtrl();
        objLender.getOppLink();
        objLender.getMessageFormSalesRep();
    }
}