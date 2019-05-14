/*********************************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: TaskTrigger
* Created Date: 10-July-2018
* Description: Task Trigger to update Total calls and Total tasks on lead
**********************************************************************************
* Updates
* Author            | Date          | Description
* Aditya Mukkawar   | 10/16/2018    | For Lead/Opportunity send an alert to Opp owner for Incoming message
**********************************************************************************/
trigger TaskTrigger on Task (after insert,after Delete,after Undelete,after Update) {
    set<Id> leadIds = new set<Id>();
    set<Id> taskIds = new set<Id>();
    
    if(trigger.isInsert){
        for(Task objTask : trigger.New){
            if(objTask.whoId!=null){
               if(objTask.whoId.getSobjectType().getDescribe().getName() == 'Lead'){
                    leadIds.add(objTask.whoId);
                } 
            }
            if((objTask.WhoId !=null && objTask.whoId.getSobjectType().getDescribe().getName() == 'Lead') || (objTask.WhatId !=null && objTask.WhatId.getSobjectType().getDescribe().getName() == 'opportunity')){
                system.debug('objTask=>'+objTask);
                if(objTask.Cloufi_Twilio__Type__c == 'Incoming'){
                    system.debug('Incoming=>'+objTask.Cloufi_Twilio__Type__c);
                    taskIds.add(objTask.id);
                }
            }
        }    
    }
    
    if(trigger.isUpdate){
        for(Task objTask : trigger.New){
            if(objTask.whoId!=null){
                system.debug('Inside Update=>');
                system.debug('Inside Update objTask.whoId.getSobjectType().getDescribe().getName() >>'+objTask.whoId.getSobjectType().getDescribe().getName());
                //system.debug('Inside Update trigger.oldMap.get(objTask.Id).whoId >>'+trigger.oldMap.get(objTask.Id).whoId);
                //system.debug('Inside Update trigger.oldMap.get(objTask.Id).whoId.getSobjectType().getDescribe().getName() >>'+trigger.oldMap.get(objTask.Id).whoId.getSobjectType().getDescribe().getName());
                
                if(objTask.whoId.getSobjectType().getDescribe().getName() == 'Lead'){
                    leadIds.add(objTask.whoId);
                }else if(objTask.whoId.getSobjectType().getDescribe().getName() == 'Lead'){
                    leadIds.add(objTask.whoId);
                    leadIds.add(trigger.oldMap.get(objTask.Id).whoId);
                }else if(objTask.whoId.getSobjectType().getDescribe().getName() != 'Lead'){
                    leadIds.add(trigger.oldMap.get(objTask.Id).whoId);
                }else if(objTask.whoId.getSobjectType().getDescribe().getName() == 'Lead'){
                    leadIds.add(objTask.whoId);
                    system.debug('leadIds=>'+leadIds);
                }
            }
        }    
    }
    
    if(trigger.isDelete){
        for(Task objTask : trigger.old){
            if(objTask.whoId!=null){
                if(objTask.whoId.getSobjectType().getDescribe().getName() == 'Lead'){
                    leadIds.add(objTask.whoId);
                }
            }
        }
    }
    
    if(trigger.isUnDelete){
        for(Task objTask : trigger.New){
            if(objTask.whoId!=null){
                if(objTask.whoId!=null){
                    if(objTask.whoId.getSobjectType().getDescribe().getName() == 'Lead'){
                        leadIds.add(objTask.whoId);
                    }
                }
            }
        }
    }
    
    if(leadIds.size()>0){
        system.debug('leadIds=>'+leadIds);
        TaskTriggerHandler.updateLead(leadIds);
    }
    if(taskIds.size()>0){
        system.debug('taskIds=>'+taskIds);
        TaskTriggerHandler.handleAfterInsert(taskIds);
    }
}