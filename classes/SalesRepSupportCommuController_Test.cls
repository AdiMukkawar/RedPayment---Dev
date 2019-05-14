/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: SalesRepSupportCommuController
* Created Date: 24-September-2018
* Description:  Test class for SalesRepSupportCommuController
*******************************************************************/
@isTest
public class SalesRepSupportCommuController_Test {

    public static testMethod void testSalesRepSupportCommuCtrl(){
        
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
      
		Test.startTest();
        
            SalesRepSupportCommuController obj = new SalesRepSupportCommuController();
            SalesRepSupportCommuController.getUserName();
        	SalesRepSupportCommuController.showLabel(objOpp.id);
            SalesRepSupportCommuController.fetchUser();
            SalesRepSupportCommuController.taskList(objOpp.id);
            SalesRepSupportCommuController.SendMessageC(objOpp.id,'Testing Msg');
            
           /* Task objTask1 = new Task();
            objTask1.whatid = objOpp.Id;
            objTask1.Description = 'Testing Msg';
            objTask1.Subject = 'Task Assign to Sales Rep';
            objTask1.ActivityDate = system.today();
            insert objTask1;
        	
           	Profile objProfile =[SELECT Id FROM Profile WHERE Name='Sales Support'];
			User usr = new User(Alias = 'standt', Email='standarduser@testorg.com', 
						EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
						LocaleSidKey='en_US', ProfileId = objProfile.Id, 
						TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1234567890@testorg.com');
			insert usr;
        
			System.runAs(usr){
				objTask1.ownerId = usr.id;
				update objTask1;
                
                SalesRepSupportCommuController.showLabel(objOpp.id);
                SalesRepSupportCommuController.taskList(objOpp.id);
                SalesRepSupportCommuController.SendMessageC(objOpp.id,'Testing Msg');
			}*/
			
          Test.stopTest();
    }
    
    @isTest
    public static void tesMethod2()
    {
         // Insert Opportunity
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Test Opportunity';
        objOpp.CloseDate = system.today();
        objOpp.StageName = 'Closed Won';
        insert objOpp;
        
        //Insert Task
        Task objTask = new Task();
        objTask.Description = 'Testing Msg';
        objTask.Subject = 'Task Assign to Sales Support';
        objTask.ActivityDate = system.today();
        insert objTask;

        Test.startTest();
        SalesRepSupportCommuController.showLabel(objOpp.id);
        SalesRepSupportCommuController.taskList(objOpp.id);
        Test.stopTest();
    }
    
}