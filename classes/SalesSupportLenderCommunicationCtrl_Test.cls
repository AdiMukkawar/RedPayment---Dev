/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: SalesSupportLenderCommunicationCtrl_Test
* Created Date: 01/23/2019
* Description:  Test class for SalesSupportLenderCommunicationCtrl
*******************************************************************/
@isTest
private class SalesSupportLenderCommunicationCtrl_Test
{
	@isTest
	static void testSalesSupportLenderCommunicationCtrl(){
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
        objTask.Subject = 'Message from Sales Support to Lender';
        objTask.ActivityDate = system.today();
        insert objTask;

        User objUser = [SELECT Id FROM User WHERE Profile.Name='Sales Support' AND ISActive = true LIMIT 1];
      
		Test.startTest();
			System.runAs(objUser) {	    
	            SalesSupportLenderCommunicationCtrl obj = new SalesSupportLenderCommunicationCtrl();
	            SalesSupportLenderCommunicationCtrl.showLabelCtrl(objOpp.id);
	            SalesSupportLenderCommunicationCtrl.fetchUser();
	            SalesSupportLenderCommunicationCtrl.taskListCtrl(objOpp.id);
	            SalesSupportLenderCommunicationCtrl.SendMessageCtrl(objOpp.id,'Testing Msg');
	        }
         Test.stopTest();

	}
}