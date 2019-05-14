/*********************************************************************************
* Author: Techila Global Services Pvt Ltd. (Gaurav Agrawal)
* Trigger Name: LeadTrigger
* Created Date: 30-August-2018
* Description: Trigger on Lead object 
**********************************************************************************
* Updates
* Author            | Date          | Description
* Aditya            | 12-Sep-2018   | Insert Application under lead if manually created
**********************************************************************************/

trigger LeadTrigger on Lead (before insert, before update,after insert,after update) {
    List<Lead> leadList;
    if(Trigger.ISBEFORE){
        if(Trigger.ISINSERT){
            leadList = new List<Lead>();
            for(Lead objLead : Trigger.New){
                if(objLead.Phone != null){
                  leadList.add(objLead);
                }
            }
            //Call helper method for mapping timezone based on first 3 digits of Phone number
            LeadTriggerHandler.mapTimeZone(leadList);
        }else if(Trigger.ISUPDATE){
            leadList = new List<Lead>();
            for(Lead objLead : Trigger.New){
                if(objLead.Phone != null && objLead.Phone != Trigger.oldMap.get(objLead.Id).Phone){
                  leadList.add(objLead);
                }
            }
            //Call helper method for mapping timezone based on first 3 digits of Phone number
            LeadTriggerHandler.mapTimeZone(leadList);
        }   
    }
    // Aditya - get Leads after insert
    set<Id> leadListAfterInsert = new set<Id>();
    set<Id> leadIdsToShareRecord = new set<Id>();
    if(Trigger.ISAFTER){
        if(Trigger.ISINSERT){
            for(Lead objLead : Trigger.New){
                leadListAfterInsert.add(objLead.id);
                if(String.valueOf(objLead.OwnerId).startsWith('005')){
                    leadIdsToShareRecord.add(objLead.id);
                }
            }
        }
        if(Trigger.ISUPDATE){
            for(Lead objLead : Trigger.New){
                if(objLead.OwnerId != Trigger.oldMap.get(objLead.Id).OwnerId && String.valueOf(objLead.OwnerId).startsWith('005')){
                    leadIdsToShareRecord.add(objLead.id);
                }
            }
        }
    }
    if(leadListAfterInsert.size()>0){
        LeadTriggerHandler.afterInsert(leadListAfterInsert);
    }
    if(leadIdsToShareRecord.size()>0){
        LeadTriggerHandler.createLeadShare(leadIdsToShareRecord);
    }
    
    //Anuradha - Application Checklist Verification
    Map <Id, Lead> applicationCheckListMap = new Map <Id, Lead>();
    if(Trigger.isBefore && Trigger.isUpdate){
        for(Lead leadRecord: Trigger.new){
            if(Trigger.oldMap.get(leadRecord.Id).Is_Application_Checklist_Completed__c!=leadRecord.Is_Application_Checklist_Completed__c &&  leadRecord.Is_Application_Checklist_Completed__c==true && leadRecord.Owner_Profile_Name__c =='Cash Advance Sales Agent OffShore'){
                applicationCheckListMap.put(leadRecord.Id, leadRecord);
            }
        }
    }
    if(applicationCheckListMap.size()>0){
        LeadTriggerHandler.verifyAppCheckList(applicationCheckListMap);
    }
}