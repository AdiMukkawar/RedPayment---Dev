/******************************************************************************
Author                             | Date           | Description
Techila Global Services Pvt Ltd.   | 10-July-2018   | To update Total events on lead
******************************************************************************/
public class EventTriggerHandler {
    public static void updateLead(Set<Id> lead_Ids){
        List<Lead> leadList = New List<Lead>();
        Map<Id,List<Event>> eventMap = New Map<Id,List<Event>>();
        
        for(Event objEvent : [SELECT Id, Subject, whoId FROM Event WHERE whoId IN: lead_Ids]){
             if(!eventMap.containskey(objEvent.whoId)){
                eventMap.put(objEvent.whoId,New List<Event>());
             }
             eventMap.get(objEvent.whoId).add(objEvent);
        }
        
        For(Lead objLead : [SELECT Id, Total_Event__c FROM Lead WHERE Id IN: lead_Ids AND IsConverted=false]){
            objLead.Total_Event__c = 0;
            List<Event> eventList = New List<Event>();
            if(eventMap.get(objLead.Id)!=null){
                eventList = eventMap.get(objLead.Id);
            }
            System.debug('eventList-->'+eventList);
            for(Event objEvent : eventList){
                objLead.Total_Event__c += 1;
            }
            leadList.add(objLead);
        }
        
        if(!leadList.isEmpty()){
            update leadList;
        }
    }
}