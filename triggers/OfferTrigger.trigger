/**
Author  | Date       | Description
Neha    | 08/09/2018 | Trigger to update submission status on offer approved       
Neha    | 10/10/2018 | Re-write trigger          
**/

Trigger OfferTrigger on Cloufi__Offers__c(after insert,after update,before delete)
{
    if(trigger.isAfter){ 
        List<Cloufi__Offers__c> chosenOffers;
        List<Cloufi__Offers__c> rejectedOffers;
        List<Cloufi__Offers__c> newOffers;
        List<Cloufi__Offers__c> allOffers;
        List<Cloufi__Offers__c> revisionOffers;
        List<Cloufi__Offers__c> expiredOffers;
        List<Cloufi__Offers__c> oldChosenOffers;
        List<Cloufi__Offers__c> oldRejectedOffers;
        
        Map <Id, List<Cloufi__Offers__c>> mapOfChosenOffers = new Map <Id, List<Cloufi__Offers__c>>();
        
        
        Set<Id> OpportunityIdSet;

        if(Trigger.isUpdate){
            chosenOffers = new List<Cloufi__Offers__c>();
            rejectedOffers = new List<Cloufi__Offers__c>();  
            revisionOffers = new List<Cloufi__Offers__c>();
            expiredOffers = new List<Cloufi__Offers__c>();
            oldChosenOffers = new List<Cloufi__Offers__c>();
            oldRejectedOffers = new List<Cloufi__Offers__c>();
            OpportunityIdSet = new Set<Id>();
            newOffers = new List<Cloufi__Offers__c>();
            
            for(Cloufi__Offers__c objOffer : Trigger.New){
                revisionOffers.add(objOffer);
                if(trigger.oldMap.get(objOffer.Id).Cloufi__Offer_Status__c == 'Rejected' && objOffer.Cloufi__Offer_Status__c == 'New'){
                    newOffers.add(objOffer);
                }
                if(trigger.oldMap.get(objOffer.Id).Cloufi__Offer_Status__c == 'Chosen' && objOffer.Cloufi__Offer_Status__c != 'Chosen'){
                    oldChosenOffers.add(objOffer);
                }
                if(trigger.oldMap.get(objOffer.Id).Cloufi__Offer_Status__c == 'Rejected' && objOffer.Cloufi__Offer_Status__c != 'Rejected'){
                    oldRejectedOffers.add(objOffer);
                }
                if(trigger.oldMap.get(objOffer.Id).Cloufi__Offer_Status__c != 'Chosen' && objOffer.Cloufi__Offer_Status__c == 'Chosen'){
                    if(mapOfChosenOffers.containsKey(objOffer.Cloufi__Opportunity__c)){
                        objOffer.addError('Multiple Offers cannot be marked Chosen');
                        /* chosenOffers.add(objOffer);
                        mapOfChosenOffers.put(objOffer.Cloufi__Opportunity__c,chosenOffers); */
                    }else{
                        chosenOffers = new List <Cloufi__Offers__c>();
                        chosenOffers.add(objOffer);
                        mapOfChosenOffers.put(objOffer.Cloufi__Opportunity__c,chosenOffers);
                    }
                    
                }else if(objOffer.Cloufi__Offer_Status__c == 'Rejected'){
                    rejectedOffers.add(objOffer);
                    OpportunityIdSet.add(objOffer.Cloufi__Opportunity__c);
                }else if(objOffer.Cloufi__Offer_Status__c == 'Expired'){
                    expiredOffers.add(objOffer);
                    OpportunityIdSet.add(objOffer.Cloufi__Opportunity__c);
                }
            }
            if(oldChosenOffers.size()>0){
                if(TriggerRecursionCheck.RunOnce('OfferTrigger-AfterUpdate-oldChosenToReceivedSubmission')){
                    OfferTriggerHandler.oldChosenToReceivedSubmission(oldChosenOffers);
                }
            }
            if(oldRejectedOffers.size()>0){
                if(TriggerRecursionCheck.RunOnce('OfferTrigger-AfterUpdate-oldRejectedToReceivedSubmission')){
                    OfferTriggerHandler.oldRejectedToReceivedSubmission(oldRejectedOffers);
                }
            }
            
            if(newOffers.size()>0){
                if(TriggerRecursionCheck.RunOnce('OfferTrigger-AfterUpdate-rejectToNewSubmission')){
                    OfferTriggerHandler.rejectToNewSubmission(newOffers);
                }
            }
            
            if(!chosenOffers.isEmpty()){
                if(TriggerRecursionCheck.RunOnce('OfferTrigger-AfterUpdate-updateStatus')){
                    OfferTriggerHandler.updateStatus(chosenOffers);
                }
                if(TriggerRecursionCheck.RunOnce('OfferTrigger-AfterUpdate-updateOpportunity')){
                    OfferTriggerHandler.updateOpportunity(chosenOffers);
                }
            }
            
            if(rejectedOffers.size()>0){
                if(TriggerRecursionCheck.RunOnce('OfferTrigger-AfterUpdate-rejectExpireSubmission')){
                    OfferTriggerHandler.rejectExpireSubmission(rejectedOffers);
                }
            }
            
            if(expiredOffers.size()>0){
                if(TriggerRecursionCheck.RunOnce('OfferTrigger-AfterUpdate-rejectExpireSubmission')){
                    OfferTriggerHandler.rejectExpireSubmission(expiredOffers);
                }
            }
            
            if(OpportunityIdSet.size()>0){
                if(TriggerRecursionCheck.RunOnce('OfferTrigger-AfterUpdate-notifySalesSupport')){
                    OfferTriggerHandler.notifySalesSupport(OpportunityIdSet);
                }
            }
        }
        else if(trigger.isInsert){
            chosenOffers = new List<Cloufi__Offers__c>();
            newOffers = new List<Cloufi__Offers__c>();
            allOffers = new List<Cloufi__Offers__c>();
            
            //loop through the offers and filter chosen offers and having funders
            for(Cloufi__Offers__c objOffer : Trigger.New){
                allOffers.add(objOffer);
                if(objOffer.Cloufi__Funder__c != null){
                    newOffers.add(objOffer);
                }
                if(objOffer.Cloufi__Offer_Status__c == 'Chosen'){
                    chosenOffers.add(objOffer);
                }
            }
            
            if(newOffers.size()>0){
                if(TriggerRecursionCheck.RunOnce('OfferTrigger-AfterInsert-AddUWDocuments')){
                    OfferTriggerHandler.AddUWDocuments(newOffers);
                }
            }
            
            if(chosenOffers.size()>0){
                if(TriggerRecursionCheck.RunOnce('OfferTrigger-AfterInsert-updateStatus')){
                    OfferTriggerHandler.updateStatus(chosenOffers);
                }
                if(TriggerRecursionCheck.RunOnce('OfferTrigger-AfterInsert-updateOpportunity')){
                    OfferTriggerHandler.updateOpportunity(chosenOffers);
                }
            }
            
            if(allOffers.size()>0){
                if(TriggerRecursionCheck.RunOnce('OfferTrigger-AfterInsert-sendMailToSupportGroup')){
                    OfferTriggerHandler.sendMailToSupportGroup(allOffers);
                }
            }
        }
    }else{
        List<Cloufi__Offers__c> submissionOffers;
        if(trigger.isDelete){            
            for(Cloufi__Offers__c objOffer : trigger.old){
                if(objOffer.Cloufi__Offer_Status__c == 'Chosen'){
                    objOffer.AddError('Cannot delete chosen offer');
                }
            }
        }/* else if(trigger.isInsert){
            submissionOffers = new List<Cloufi__Offers__c>();           
            //Get offers
            for(Cloufi__Offers__c objOffer : trigger.New){
                submissionOffers.add(objOffer);
            }

            if(submissionOffers.size()>0){
                if(TriggerRecursionCheck.RunOnce('OfferTrigger-BeforeInsert-restrictOffers')){
                    OfferTriggerHandler.restrictOffers(submissionOffers);
                }
            }
        } */
    }  
}