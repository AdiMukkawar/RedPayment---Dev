/*********************************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: TwilioTaskTrigger
* Created Date: 04-September-2018
* Description: Twilio Task Trigger
**********************************************************************************
* Updates
* Author            | Date          | Description
* 
**********************************************************************************/

trigger TwilioTaskTrigger on Task (after insert) {
    Set<Id> taskIds = new Set<Id>();
    if(trigger.isAfter && Trigger.isInsert){
        for(Task objTask: trigger.New){
            if(objTask.Cloufi_Twilio__Type__c == 'Incoming'){
                taskIds.add(objTask.id);
            }
        }
    }
    //Process After Update
    if(taskIds.size()>0){
        TwilioTaskTriggerHandler.handleAfterInsert(taskIds);
    }
}