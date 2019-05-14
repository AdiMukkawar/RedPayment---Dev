/*********************************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar/Gaurav Agrawal)
* Class Name: ApplicationTrigger
* Created Date: 21-August-2018
* Description: Application Trigger
**********************************************************************************
* Updates
* Author            | Date          | Description
* 
**********************************************************************************/

trigger ApplicationTrigger on Cloufi__Application__c (after insert, after update) {
    if(TRIGGER.IsAfter){
        if(TRIGGER.IsInsert){
            if(TriggerRecursionCheck.RunOnce('ApplicationTrigger-AfterInsert-createDefaultUWDocuments')){
                ApplicationTriggerHandler.createDefaultUWDocuments(Trigger.New);
            }
            if(TriggerRecursionCheck.RunOnce('ApplicationTrigger-AfterInsert-updateApplicationIdOnLead')){
                ApplicationTriggerHandler.updateApplicationIdOnLead(Trigger.New);
            }
        }else if(TRIGGER.IsUpdate){
            if(TriggerRecursionCheck.RunOnce('ApplicationTrigger-AfterUpdate-createDefaultUWDocuments')){
                ApplicationTriggerHandler.createDefaultUWDocuments(Trigger.New);
            }            
        }
    }    
}