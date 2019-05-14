trigger MoveDropboxFilesToCancelledFolder on Cancelled_UW_Document__c (after insert) {      
    if(trigger.isAfter && trigger.isInsert){
        CancelledUWDocumentsTriggerHandler.moveDropboxFile(Trigger.New);
    }
}