/*********************************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: EventTrigger
* Created Date: 10-July-2018
* Description: Event Trigger to update Total events on lead
**********************************************************************************
* Updates
* Author            | Date          | Description
* 
**********************************************************************************/
trigger EventTrigger on Event (after insert,after Delete,after Undelete,after Update) {
    Set<Id> leadIds = New Set<Id>();
    
    if(trigger.isInsert){
        for(Event objEvent : trigger.New){
			if(objEvent.whoId!=null){
				if(objEvent.whoId.getSobjectType().getDescribe().getName() == 'Lead'){
					leadIds.add(objEvent.whoId);
				}
			}
        }    
    }
    
    if(trigger.isUpdate){
        for(Event objEvent : trigger.New){
			if(objEvent.whoId!=null){
				if(objEvent.whoId.getSobjectType().getDescribe().getName() == 'Lead' && trigger.oldMap.get(objEvent.Id).whoId != objEvent.whoId && trigger.oldMap.get(objEvent.Id).whoId.getSobjectType().getDescribe().getName() != 'Lead'){
					leadIds.add(objEvent.whoId);
				}else if(objEvent.whoId.getSobjectType().getDescribe().getName() == 'Lead' && trigger.oldMap.get(objEvent.Id).whoId != objEvent.whoId && trigger.oldMap.get(objEvent.Id).whoId.getSobjectType().getDescribe().getName() == 'Lead'){
					leadIds.add(objEvent.whoId);
					leadIds.add(trigger.oldMap.get(objEvent.Id).whoId);
				}else if(objEvent.whoId.getSobjectType().getDescribe().getName() != 'Lead' && trigger.oldMap.get(objEvent.Id).whoId != objEvent.whoId && trigger.oldMap.get(objEvent.Id).whoId.getSobjectType().getDescribe().getName() == 'Lead'){
					leadIds.add(trigger.oldMap.get(objEvent.Id).whoId);
				}
			}
        }    
    }
    
    if(trigger.isDelete){
        for(Event objEvent : trigger.old){
			if(objEvent.whoId!=null){
				if(objEvent.whoId.getSobjectType().getDescribe().getName() == 'Lead'){
					leadIds.add(objEvent.whoId);
				}
			}
        }
    }
    
    if(trigger.isUnDelete){
        for(Event objEvent : trigger.New){
			if(objEvent.whoId!=null){
				if(objEvent.whoId.getSobjectType().getDescribe().getName() == 'Lead'){
					leadIds.add(objEvent.whoId);
				}
			}
        }
    }
    
    if(!leadIds.isEmpty()){
        EventTriggerHandler.updateLead(leadIds);
    }
}