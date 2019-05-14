/*****************************************************************
Test Class Name : EventTrigger_Test 
-------------------------------------------------------------------------------------------
Author           | Project       |    Date       | Description
-------------------------------------------------------------------------------------------
Aditya Mukkawar  | Red Payment   |   10/07/2018  | Test class for EventTrigger and EventTriggerHandler
********************************************************************/
@isTest
public class EventTrigger_Test {
	public static testMethod void executeEventTrigger(){
        //Insert Lead
        Lead objLead = New Lead(LastName='Test1',Status='New',Company='TestCompany',Phone='9632587410');
        insert objLead;
        
        //Insert Event
        List<Event> lstEvents = new List<Event>();
        Event objEvent = new Event(subject='call',whoId=objLead.id,StartDateTime=system.today(),EndDateTime=system.today()+5);
        lstEvents.add(objEvent);
        
       	Event objEvent1 = new Event(subject='Other',whoId=objLead.id,StartDateTime=system.today(),EndDateTime=system.today()+5);
        lstEvents.add(objEvent1); 
        insert lstEvents;
        
       // Update Event 
        lstEvents[0].subject='Other';
        update lstEvents[0];
        
         // delete Event 
        delete lstEvents[0];
        
        // delete Task 
        undelete lstEvents[0];
    }
}