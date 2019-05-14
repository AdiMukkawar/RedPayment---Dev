/*********************************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: OpportunityTrigger
* Created Date: 17-August-2018
* Description: Opportunity Trigger
**********************************************************************************
* Updates
* Author            | Date          | Description
* Gaurav Agrawal    
**********************************************************************************/

trigger OpportunityTrigger on Opportunity(after insert, after update, before update){   
    if(Cloufi__LendingXL_Trigger_Settings__c.getOrgDefaults() != null && Cloufi__LendingXL_Trigger_Settings__c.getOrgDefaults().Custom_Opportunity_Trigger__c){
        if(TRIGGER.IsAfter){
            if(TRIGGER.IsInsert){
                if(Cloufi__LendingXL_Trigger_Settings__c.getOrgDefaults() != null && Cloufi__LendingXL_Trigger_Settings__c.getOrgDefaults().Custom_Opportunity_Create_UW_Doc_Trigger__c){
                    if(TriggerRecursionCheck.RunOnce('OpportunityTrigger-AfterInsert-createDefaultUWDocuments')){
                        OpportunityTriggerHandler.createDefaultUWDocuments(Trigger.New);                
                    }
                }
                if(TriggerRecursionCheck.RunOnce('OpportunityTrigger-AfterInsert-createDropboxFolder')){
                    if(!test.isRunningTest()){
                        OpportunityTriggerHandler.createDropboxFolder(Trigger.New);                
                    }
                }
                if(TriggerRecursionCheck.RunOnce('OpportunityTrigger-AfterInsert-createOpportunityShare')){
                    OpportunityTriggerHandler.createOpportunityShare(Trigger.New);
                }           
            }else if(TRIGGER.IsUpdate){
                if(Cloufi__LendingXL_Trigger_Settings__c.getOrgDefaults() != null && Cloufi__LendingXL_Trigger_Settings__c.getOrgDefaults().Custom_Opportunity_Create_UW_Doc_Trigger__c){
                    if(TriggerRecursionCheck.RunOnce('OpportunityTrigger-AfterUpdate-createDefaultUWDocuments')){
                        OpportunityTriggerHandler.createDefaultUWDocuments(Trigger.New);
                    }
                }

                Map<Id, Opportunity> contractRequestedOppMap = new Map<Id, Opportunity>();
                Map<Id, Opportunity> signedContractReqOppMap = new Map<Id, Opportunity>();

                for(Opportunity objOpportunity : Trigger.New){
                    if(objOpportunity.StageName == 'Contract Requested' && objOpportunity.StageName != Trigger.oldMap.get(objOpportunity.Id).StageName){
                        contractRequestedOppMap.put(objOpportunity.Id, objOpportunity);
                    }

                    if(objOpportunity.StageName == 'Contract Sent' && objOpportunity.StageName != Trigger.oldMap.get(objOpportunity.Id).StageName){
                        signedContractReqOppMap.put(objOpportunity.Id, objOpportunity);
                    }
                }


                if(TriggerRecursionCheck.RunOnce('OpportunityTrigger-AfterUpdate-createContractUWDocument')){
                    OpportunityTriggerHandler.createContractUWDocument(contractRequestedOppMap);
                }

                if(TriggerRecursionCheck.RunOnce('OpportunityTrigger-AfterUpdate-createSignedContractUWDocument')){
                    OpportunityTriggerHandler.createSignedContractUWDocument(signedContractReqOppMap);
                } 

                if(TriggerRecursionCheck.RunOnce('OpportunityTrigger-AfterUpdate-createOpportunityShare')){
                    OpportunityTriggerHandler.createOpportunityShare(Trigger.New, Trigger.oldMap);
                }                            
            }
        }
        
        if(trigger.isBefore){
            /*Start: Update Servicing White Label field with custom Lookup filtered White Label*/
            if(trigger.isUpdate){
                if(TriggerRecursionCheck.RunOnce('OpportunityTrigger-BeforeUpdate-checkOpportunityOwnerChange')){
                    OpportunityTriggerHandler.checkOpportunityOwnerChange(Trigger.New, Trigger.oldMap);
                } 

                if(TriggerRecursionCheck.RunOnce('OpportunityTrigger-BeforeUpdate-updateWhiteLabelServicing')){
                    OpportunityTriggerHandler.updateWhiteLabelServicing(Trigger.New, Trigger.oldMap);
                }                          
            }
            /*End: Update Servicing White Label field with custom Lookup filtered White Label*/
        }
    }
}