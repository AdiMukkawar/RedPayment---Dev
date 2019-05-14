/*********************************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: AttachmentTrigger
* Created Date: 
* Description: Attachment Trigger
**********************************************************************************
* Updates
* Author            | Date          | Description
* 
**********************************************************************************/
trigger AttachmentTrigger on Attachment (after insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            //Method used to create Attachment for Signed Application
            AttachmentTriggerHandler.createSignedApplication(Trigger.New);
            //Upload Attachment to Dropbox which are created under UW Document
            /*System.debug('Cloufi__LendingXL_Trigger_Settings__c.getOrgDefaults().Cloufi__Attachment_Trigger__c -> '+Cloufi__LendingXL_Trigger_Settings__c.getOrgDefaults().Cloufi__Attachment_Trigger__c);
            if(!Cloufi__LendingXL_Trigger_Settings__c.getOrgDefaults().Cloufi__Attachment_Trigger__c){
                System.debug('Cloufi__LendingXL_Trigger_Settings__c.getOrgDefaults().Cloufi__Attachment_Trigger__c -> '+Cloufi__LendingXL_Trigger_Settings__c.getOrgDefaults().Cloufi__Attachment_Trigger__c);
                AttachmentTriggerHandler.uploadUWAttachment(Trigger.New);
            } */           
        }
    }
}