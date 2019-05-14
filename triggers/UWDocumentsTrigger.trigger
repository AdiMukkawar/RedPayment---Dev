/*********************************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: UWDocumentsTrigger
* Created Date: 16-August-2018
* Description: UW Document Trigger
**********************************************************************************
* Updates
* Author            | Date          | Description
* 
**********************************************************************************/

trigger UWDocumentsTrigger on Cloufi__UW_Document__c (after insert,after update, before delete) {
    
    Set<Id> uwIds = new Set<Id>();
    if(trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)){
        for(Cloufi__UW_Document__c objUW: trigger.New){
            uwIds.add(objUW.id);
        }
    }
    if(TRIGGER.isAfter){
        if(TRIGGER.isInsert){
            if(TriggerRecursionCheck.RunOnce('UWDocumentsTrigger-AfterInsert-createUWShare')){
                UWDocumentsTriggerHandler.createUWShare(Trigger.New);
            }
        }
        
    }
    if(Trigger.isBefore){
        if(TRIGGER.isDelete){
            for(Cloufi__UW_Document__c objUW: [SELECT ID, Cloufi__URL__c, Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c, Cloufi__Opportunity__r.Cancelled_Dropbox_Folder_Path__c FROM Cloufi__UW_Document__c WHERE ID IN : trigger.old]){                
                CancelledUWDocumentsTriggerHandler.deleteDropboxFile(objUW.Cloufi__URL__c,objUW.Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c,objUW.Cloufi__Opportunity__r.Cancelled_Dropbox_Folder_Path__c);
            }
        }
    }
    
    //Process After Update
    if(uwIds.size()>0){
        UWDocumentsTriggerHandler.handleAfterInsertUpdate(uwIds);
    }


    /*if(TRIGGER.isAfter){
        if(TRIGGER.isInsert){
            if(TriggerRecursionCheck.RunOnce('UWDocumentsTrigger-AfterInsert-handleAfterInsertUpdate')){
                UWDocumentsTriggerHandler.handleAfterInsertUpdate(Trigger.New);     
                system.debug('Inside After Insert');
            }
            if(TriggerRecursionCheck.RunOnce('UWDocumentsTrigger-AfterInsert-createUWShare')){
                UWDocumentsTriggerHandler.createUWShare(Trigger.New);
            }
        }else if(TRIGGER.isUpdate){
            if(TriggerRecursionCheck.RunOnce('UWDocumentsTrigger-AfterUpdate-handleAfterInsertUpdate')){
                UWDocumentsTriggerHandler.handleAfterInsertUpdate(Trigger.New);
                system.debug('Inside After Update');                
            }
        }
    }*/
}