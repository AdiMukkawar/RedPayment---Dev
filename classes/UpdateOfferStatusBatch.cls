/*********************************************************
Author  | Date       | Description 
Neha   | 08/21/2018 | Controller for submitToSalesSupport VF Page
**********************************************************/

global class UpdateOfferStatusBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('select id,Name,Cloufi__Offer_Status__c from Cloufi__Offers__c where Cloufi__Offer_Status__c NOT IN (\'Approved\',\'Rejected\',\'Expired\') AND createdDate < LAST_N_DAYS:30');  
    }
    global void execute(Database.BatchableContext bc, List<Cloufi__Offers__c> scope){
        try{
            System.debug('scope-->'+scope);
            // process each batch of records
            if(scope.size()>0){
                for (Cloufi__Offers__c objOffer : scope) {
                    objOffer.Cloufi__Offer_Status__c = 'Expired';
                }
                update scope;
            }  
        }catch(Exception ex){
            System.debug('Error-->'+ex.getMessage());
            System.debug('On line-->'+ex.getLineNumber());
        }             
    }    
    global void finish(Database.BatchableContext bc){
        
    }    
}