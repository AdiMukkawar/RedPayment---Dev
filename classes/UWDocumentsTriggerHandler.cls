/******************************************************************************
Author             | Date           | Description
Aditya Mukkawar    | 16-August-2018 | Update Opportunity stage depending on UW docs
******************************************************************************
 Updates
* Author            | Date            | Description
* Aditya Mukkawar   | 12-October-2018 | Once Signed Application UW Document is Signed make Application completed
* Aditya Mukkawar   | 12-February-2019| Send an email to Sales support address and avoid to send mail to sales support when Signed application is completed
**********************************************************************************/

public class UWDocumentsTriggerHandler{
    public static void handleAfterInsertUpdate(set<Id> uwIds){//List<Cloufi__UW_Document__c> uwDocumentList
        List<Cloufi__UW_Document__c> updateListUWDocs = new List<Cloufi__UW_Document__c>();
      
        List<Opportunity> updateOppList = new List<Opportunity>();
        List<Cloufi__UW_Document__c> listUWDocs = [SELECT id,Stip_Name__c,Status__c,Cloufi__URL__c,Cloufi__Opportunity__c,Cloufi__Opportunity__r.StageName,Cloufi__Opportunity__r.AccountId,Cloufi__Opportunity__r.Opportunity_Owner_Manager__r.Email,Cloufi__Opportunity__r.Owner.Email,Cloufi__Opportunity__r.Lead__c,Cloufi__Opportunity__r.Owner.Sales_Support_Email__c,Cloufi__Application__c,Cloufi__Application__r.Cloufi__Application_Status__c,Cloufi__Type__c FROM Cloufi__UW_Document__c WHERE id IN:uwIds];
        system.debug('listUWDocs=>'+listUWDocs);
        
        Map<Id,Opportunity> mapOpportunity = new Map<Id,Opportunity>();
        Map<Id,Cloufi__Application__c> mapApplication = new Map<Id,Cloufi__Application__c>();
        set<Id> oppIds = new set<Id>();
        set<Id> appIds = new set<Id>();
        Map<Id,Id> mapOppAppId = new Map<Id,Id>();
        Map<Id,List<Cloufi__UW_Document__c>> mapOppIdUWList = new Map<Id,List<Cloufi__UW_Document__c>>();
        List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
        
        for(Cloufi__UW_Document__c objUW:listUWDocs){
            if(objUW.Cloufi__Opportunity__c !=null){
                oppIds.add(objUW.Cloufi__Opportunity__c);
                appIds.add(objUW.Cloufi__Application__c);
               
            }
        }

        if(oppIds.size()>0){
            for(Opportunity objOpp:[SELECT id,StageName,Sales_Support_Email__c,Bank_statements_Email_to_Sales_Support__c FROM Opportunity WHERE id IN:oppIds]){
                mapOpportunity.put(objOpp.id,objOpp);
            }

            for(Cloufi__UW_Document__c objUW:[SELECT id,Cloufi__Opportunity__c,Cloufi__Type__c,Status__c FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c IN:oppIds AND Cloufi__Type__c='Bank Statement' AND Status__c='Pending']){
                system.debug('objUW=>'+objUW);
                 // Aditya - 12-February-2019 crate map with opp id and list of UW docs
                if(mapOppIdUWList.get(objUW.Cloufi__Opportunity__c) == null){
                    mapOppIdUWList.put(objUW.Cloufi__Opportunity__c, new List<Cloufi__UW_Document__c>{objUW});
                }else{
                    mapOppIdUWList.get(objUW.Cloufi__Opportunity__c).add(objUW);
                }
            }
            system.debug('mapOppIdUWList=>'+mapOppIdUWList);
        }
        // Aditya - 12-February-2019 - Send an email to Sales support address when all mandatory 4 Bank statements are in Salesforce - "Pending" status.
        if(mapOppIdUWList.size()>0){
            List<EmailTemplate> emailTemp = [select id from EmailTemplate where DeveloperName = 'Bank_statements_alert_to_Sales_Support'];
            for(Id oppId:oppIds){
                system.debug('mapOppIdUWList.get(oppId)=>'+mapOppIdUWList.get(oppId));
                if(mapOppIdUWList.get(oppId) !=null){
                    Integer bankStmtCount = mapOppIdUWList.get(oppId).size();
                    system.debug('bankStmtCount=>'+bankStmtCount);
                    Opportunity objOpportunity = mapOpportunity.get(oppId);
                    if(bankStmtCount >= 4 && objOpportunity.StageName=='App In Missing Info' && !objOpportunity.Bank_statements_Email_to_Sales_Support__c){
                        Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                        List<String> emailIds = new List<String>();
                        if(objOpportunity.Sales_Support_Email__c != null){
                            emailIds.add(objOpportunity.Sales_Support_Email__c);
                        }
                        system.debug('emailIds=>'+emailIds);
                        emailMsg.setToAddresses(emailIds);
                        emailMsg.setTargetObjectId(UserInfo.getUserId());
                        emailMsg.setWhatId(objOpportunity.id);
                        emailMsg.SaveAsActivity = false;
                        emailMsg.setTreatTargetObjectAsRecipient(false);
                        emailMsg.setTemplateId(emailTemp[0].id);
                        system.debug('emailMsg=>'+emailMsg);
                        if(emailIds.size()>0 && emailTemp.size()>0){
                            lstEmailMsg.add(emailMsg);
                            mapOpportunity.get(oppId).Bank_statements_Email_to_Sales_Support__c = true;
                        }
                    }
                }
            }
        }

        if(oppIds.size()>0){
            for(Cloufi__Application__c objApp:[SELECT id,Cloufi__Application_Status__c,Cloufi__Opportunity__c FROM Cloufi__Application__c WHERE Cloufi__Opportunity__c IN: oppIds]){
                system.debug('objApp=>'+objApp);
                if(objApp.Cloufi__Opportunity__c !=null){
                    mapOppAppId.put(objApp.Cloufi__Opportunity__c,objApp.id);
                }
                mapApplication.put(objApp.id,objApp);
            }
        }
        // Get Email Template for 'signed Application'
        //List<EmailTemplate> emailTempSignedApp = [select id from EmailTemplate where DeveloperName = 'Signed_Application'];
        List<EmailTemplate> emailTempContract = [select id from EmailTemplate where DeveloperName = 'Contract_Uploaded_Email_Templates'];
        
        for(Cloufi__UW_Document__c objUW:listUWDocs){
            
            //When we have the application signed update the Opportunity stage to App In Missing Info
            if((objUW.Cloufi__Opportunity__r.StageName == 'App Sent' || objUW.Cloufi__Opportunity__r.StageName == 'Prospecting' || objUW.Cloufi__Opportunity__r.StageName == 'Revived') && objUW.Cloufi__Opportunity__c !=null && objUW.Stip_Name__c=='Signed Application' && objUW.Cloufi__URL__c != null && objUW.Status__c == 'Completed'){               
                if(mapOpportunity.size()>0 && mapOpportunity.get(objUW.Cloufi__Opportunity__c)!=null){
                    mapOpportunity.get(objUW.Cloufi__Opportunity__c).StageName = 'App In Missing Info';
                }
                // Update Application status once Application signed completed
                Id appId = mapOppAppId.get(objUW.Cloufi__Opportunity__c);
                system.debug('appId=>'+appId);
                if(mapApplication.size()>0 && appId!=null){
                    system.debug('Update App Status=>');
                    mapApplication.get(appId).Cloufi__Application_Status__c = 'Completed';
                }
              
                //Send alert to sales Rep and Sales support once Signed Application is uploaded
                /*Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                List<String> emailIdsForApp = new List<String>();
                emailIdsForApp.add(objUW.Cloufi__Opportunity__r.Owner.Email);
                if(objUW.Cloufi__Opportunity__r.Owner.Sales_Support_Email__c != null && !emailIdsForApp.contains(objUW.Cloufi__Opportunity__r.Owner.Sales_Support_Email__c)){
                  emailIdsForApp.add(objUW.Cloufi__Opportunity__r.Owner.Sales_Support_Email__c);
                }
                system.debug('emailIdsForApp=>'+emailIdsForApp);
                emailMsg.setToAddresses(emailIdsForApp);
                emailMsg.setTargetObjectId(UserInfo.getUserId());
                emailMsg.setWhatId(objUW.Cloufi__Opportunity__c);   
                emailMsg.SaveAsActivity = false;
                emailMsg.setTreatTargetObjectAsRecipient(false);
                emailMsg.setTemplateId(emailTempSignedApp[0].id);
                if(emailIdsForApp.size()>0 && emailTempSignedApp.size()>0){
                  lstEmailMsg.add(emailMsg);
                }*/
            }
            
            //Once UW Document of type 'Contract' is uploaded for an Opportunity update stage to Contract Received
            if(objUW.Cloufi__Opportunity__r.StageName == 'Contract Requested' && objUW.Cloufi__Opportunity__c !=null && objUW.Stip_Name__c=='Contract' && objUW.Cloufi__URL__c != null && objUW.Status__c != 'Completed'){
                if(mapOpportunity.size()>0 && mapOpportunity.get(objUW.Cloufi__Opportunity__c)!=null){
                    mapOpportunity.get(objUW.Cloufi__Opportunity__c).StageName = 'Contract Received';
                    Cloufi__UW_Document__c objUpdateUW = new Cloufi__UW_Document__c();
                    objUpdateUW.id = objUW.id;
                    objUpdateUW.Status__c='Completed';
                    updateListUWDocs.add(objUpdateUW);
                    //Send alert to sales Rep once Contract is uploaded
                    Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                    List<String> emailIdsForApp = new List<String>();
                    emailIdsForApp.add(objUW.Cloufi__Opportunity__r.Owner.Email);
                    system.debug('emailIdsForApp=>'+emailIdsForApp);
                    emailMsg.setToAddresses(emailIdsForApp);
                    emailMsg.setTargetObjectId(UserInfo.getUserId());
                    emailMsg.setWhatId(objUW.Id);   
                    emailMsg.SaveAsActivity = false;
                    emailMsg.setTreatTargetObjectAsRecipient(false);
                    emailMsg.setTemplateId(emailTempContract[0].id);
                    if(emailIdsForApp.size()>0 && emailTempContract.size()>0){
                      lstEmailMsg.add(emailMsg);
                    }

                }
            }

            //Once UW Document of type 'Signed Contract' is uploaded for an Opportunity update stage to 'Contract Signed Partial'
            if(objUW.Cloufi__Opportunity__r.StageName == 'Contract Sent' && objUW.Cloufi__Opportunity__c !=null && objUW.Stip_Name__c=='Signed Contract' && objUW.Cloufi__URL__c != null && objUW.Status__c == 'Completed'){
                if(mapOpportunity.size()>0 && mapOpportunity.get(objUW.Cloufi__Opportunity__c)!=null){
                    mapOpportunity.get(objUW.Cloufi__Opportunity__c).StageName = 'Contract Signed Partial';
                }
            }
        }
        
        if(lstEmailMsg.size()>0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmailMsg);
        }
        system.debug('updateListUWDocs >>'+updateListUWDocs);
        if(updateListUWDocs.size()>0){
            update updateListUWDocs;
        }
        
        system.debug('mapOpportunity.values=>'+mapOpportunity.values());
        if(mapOpportunity.values().size()>0){
            update mapOpportunity.values();
        }
        
        system.debug('mapApplication.values=>'+mapApplication.values());
        if(mapApplication.values().size()>0){
            update mapApplication.values();
        }
    }
    
    public static void createUWShare(List<Cloufi__UW_Document__c> uwDocumentList){
        Map<Id, Id> opportunityManagerMap = new Map<Id, Id>();
        Set<Id> opportunityIdSet = new Set<Id>();
        List<Cloufi__UW_Document__Share> uwShareList = new List<Cloufi__UW_Document__Share>();

        for(Cloufi__UW_Document__c objUWDocument : uwDocumentList){
            opportunityIdSet.add(objUWDocument.Cloufi__Opportunity__c);
        }

        for(Opportunity objOpportunity : [SELECT Id, OwnerId, Owner.ManagerId FROM Opportunity WHERE Id IN : opportunityIdSet]){
            if(objOpportunity.Owner.ManagerId != null){
                opportunityManagerMap.put(objOpportunity.Id, objOpportunity.Owner.ManagerId);
            }
        }

        for(Cloufi__UW_Document__c objUWDocument : uwDocumentList){
            if(opportunityManagerMap.get(objUWDocument.Cloufi__Opportunity__c) != null){
                Cloufi__UW_Document__Share objUWShare = new Cloufi__UW_Document__Share();
                objUWShare.UserOrGroupId = opportunityManagerMap.get(objUWDocument.Cloufi__Opportunity__c);
                objUWShare.ParentId = objUWDocument.Id;
                objUWShare.AccessLevel = 'Edit';
                objUWShare.RowCause = 'Manual';
                uwShareList.add(objUWShare);  
            }          
        } 

        if(uwShareList.size()>0){
            if(!test.isRunningTest()){
                insert uwShareList;
            }
        }          
    }
    
    
    public static void checkOpportunityStage(set<Id> oppIds){
        List <Opportunity> existingOpportunityList = new List <Opportunity>();
        List <Opportunity> updateOppList = new List <Opportunity>();
        existingOpportunityList = [SELECT Id, StageName FROM Opportunity WHERE ID IN: oppIds];
        
        for(Opportunity opp: existingOpportunityList){
            if(opp.StageName == 'Prospecting'){
                opp.StageName = 'App In Missing Info';
                updateOppList.add(opp);
            }
        }
        
        if(!updateOppList.isEmpty()){
            update updateOppList;
        }
    }
}