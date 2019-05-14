public class ApplicationTriggerHandler{
    public static void createDefaultUWDocuments(List<Cloufi__Application__c> applicationList){
        Map<Id, Set<String>> applicationUWDocumentMap = new Map<Id, Set<String>>();
        Set<Id> applicationIdSet = new Set<Id>();
        Set<Id> opportunityIdSet = new Set<Id>();
        Map<Id, Set<String>> opportunityUWDocumentMap = new Map<Id, Set<String>>();
        Map<Id, Id> applicationOpportunityMap = new Map<Id, Id>();
	//Test
        for(Cloufi__Application__c objApplication : applicationList){
            applicationIdSet.add(objApplication.Id);
            if(objApplication.Cloufi__Opportunity__c != null){
                opportunityIdSet.add(objApplication.Cloufi__Opportunity__c);
            }
        }        
        for(Cloufi__Application__c objApplication : [SELECT Id, Cloufi__Opportunity__c, (SELECT Id, Name, Stip_Name__c FROM Cloufi__Stips__r) FROM Cloufi__Application__c WHERE Id IN : applicationIdSet AND Cloufi__Opportunity__c != null]){
             system.debug('objApplication App Trigger=>'+objApplication);
            if(objApplication.Cloufi__Opportunity__c != null){
                applicationOpportunityMap.put(objApplication.Id, objApplication.Cloufi__Opportunity__c);
            }
            if(objApplication.Cloufi__Stips__r.size()>0){
                for(Cloufi__UW_Document__c objUWDocument : objApplication.Cloufi__Stips__r){
                    if(applicationUWDocumentMap.get(objApplication.Id) == null){
                        applicationUWDocumentMap.put(objApplication.Id, new Set<String>{objUWDocument.Stip_Name__c});
                    }else{
                        applicationUWDocumentMap.get(objApplication.Id).add(objUWDocument.Stip_Name__c);
                    }
                }
            }else{
                applicationUWDocumentMap.put(objApplication.Id, new Set<String>());
            }
        }
        system.debug('applicationUWDocumentMap=>'+applicationUWDocumentMap);
        for(Opportunity objOpportunity : [SELECT Id, (SELECT Id, Name, Stip_Name__c FROM Cloufi__Dropbox_Attachments__r) FROM Opportunity WHERE Id IN : opportunityIdSet]){
            if(objOpportunity.Cloufi__Dropbox_Attachments__r.size()>0){
                for(Cloufi__UW_Document__c objUWDocument : objOpportunity.Cloufi__Dropbox_Attachments__r){
                    if(opportunityUWDocumentMap.get(objOpportunity.Id) == null){
                        opportunityUWDocumentMap.put(objOpportunity.Id, new Set<String>{objUWDocument.Stip_Name__c});
                    }else{
                        opportunityUWDocumentMap.get(objOpportunity.Id).add(objUWDocument.Stip_Name__c);
                    }
                }
            }else{
                opportunityUWDocumentMap.put(objOpportunity.Id, new Set<String>());
            }            
        }
        system.debug('opportunityUWDocumentMap=>'+opportunityUWDocumentMap);
        /*List<Cloufi__UW_Document__c> uwDocumentToInsertList = new List<Cloufi__UW_Document__c>();
        List<Cloufi__UW_Document__c> uwDocList = OpportunityTriggerHandler.getUWDocuments();

        for(String applicationId : applicationUWDocumentMap.keyset()){
            for(Cloufi__UW_Document__c objUWDocument : uwDocList){                
                if(!applicationUWDocumentMap.get(applicationId).contains(objUWDocument.Stip_Name__c)){
                    Cloufi__UW_Document__c objNewUWDoc = new Cloufi__UW_Document__c();
                    objNewUWDoc.Name = objUWDocument.Stip_Name__c;
                    objNewUWDoc.Stip_Name__c = objUWDocument.Stip_Name__c;
                    objNewUWDoc.Cloufi__Application__c = applicationId;                       
                    objNewUWDoc.Cloufi__Type__c = objUWDocument.Cloufi__Type__c;                    
                    uwDocumentToInsertList.add(objNewUWDoc);
                }
            }
        }           
        if(uwDocumentToInsertList.size()>0){
            insert uwDocumentToInsertList;
        }*/    
    } 

    public static void updateApplicationIdOnLead(List<Cloufi__Application__c> applicationList){
        
    } 
}