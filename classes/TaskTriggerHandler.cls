/******************************************************************************
Author                             | Date           | Description
Techila Global Services Pvt Ltd.   | 10-July-2018   | To update Total calls and Total tasks on lead
**********************************************************************************
* Updates
* Author            | Date          | Description
* Aditya Mukkawar   | 10/16/2018    | For Opportunity Incoming message send an alert to Opp owner
**********************************************************************************/
public class TaskTriggerHandler {
    //For Opportunity Incoming message send an alert to Opp owner
    public static void handleAfterInsert(Set<Id> taskIds){
        List<Task> taskList = [SELECT id,Cloufi_Twilio__Type__c,Cloufi_Twilio__Message__c,WhoId,whatId FROM Task WHERE id in:taskIds];
        system.debug('taskList=>'+taskList);
        List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
        set<Id> leadIds = new set<Id>();
        set<Id> OpportunityIDs = new set<Id>();
        Map<Id, Lead> leadMap = new Map<Id, Lead>();
        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>();
        for(Task objTask:taskList){
            if(objTask.WhoId !=null && objTask.whoId.getSobjectType().getDescribe().getName() == 'Lead'){
                leadIds.add(objTask.WhoId);
            }
            if(objTask.WhatId !=null && objTask.WhatId.getSobjectType().getDescribe().getName() == 'opportunity'){ 
                OpportunityIDs.add(objTask.WhatId);
            }
        }
        if(leadIds.size()>0){
            List<Lead> taskLeads = [Select Id,Email,LastName,FirstName,Owner.Email from Lead where Id in :leadIds];
            for(Lead objLead : taskLeads){
                leadMap.put(objLead.Id,objLead); 
            } 
        }
        
        if(OpportunityIDs.size()>0){
            List<Opportunity> taskOpportunities = [Select Id,Cloufi__Email_Address__c,Name,Owner.Email, Owner.Manager.Email from Opportunity where Id in :OpportunityIDs];
            for(Opportunity objOpp : taskOpportunities){
                opportunityMap.put(objOpp.Id,objOpp); 
            } 
        }
        for(Task objTask:taskList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<string> toaddress = new List<string>();
            string emailBody ='';
            String baseUrl = Label.Base_URL;
            system.debug('opportunityMap =>'+opportunityMap);
            system.debug('leadMap =>'+leadMap);
            
            if(objTask.WhoId <> NULL && objTask.WhoId.getSobjectType() == Lead.getSObjectType()){
                Lead objLead =  leadMap.get(objTask.WhoId);
                if(leadMap.get(objTask.WhoId) !=null){
                  leadMap.get(objTask.WhoId);
                }
                system.debug('objLead.Owner.Email=>'+objLead.Owner.Email);
                if(objLead.Owner.Email !=null && objLead.Email!=null){
                    toaddress.add(objLead.Owner.Email);
                    toaddress.add(objLead.Email);
                }
                mail.setSubject('Incoming Message');
                emailBody = 'Hello ' + objLead.FirstName+' '+objLead.LastName+','+'<br><br>'+'Message - '+objTask.Cloufi_Twilio__Message__c+'<br><br>'+' To view your Lead <a href='+baseUrl+'/'+objLead.Id+'>click here</a>.';      
            }
            if(objTask.WhatId <> NULL && objTask.WhatId.getSobjectType() == opportunity.getSObjectType()){
                opportunity objopp = opportunityMap.get(objTask.WhatId);
                if(opportunityMap.get(objTask.WhatId) !=null){
                  opportunityMap.get(objTask.WhatId);
                }
                system.debug('objopp.Owner.Email>>'+objopp.Owner.Email);
                system.debug('objopp.Owner.Manager.Email>>'+objopp.Owner.Manager.Email);
                system.debug('objopp.Owner.Email>>'+objopp.Owner.Email);
                if(objopp.Owner.Email !=null && objopp.Cloufi__Email_Address__c!=null){
                    toaddress.add(objopp.Owner.Email);
                    toaddress.add(objopp.Cloufi__Email_Address__c);
                    if(objopp.Owner.Manager.Email!=null){
                        toaddress.add(objopp.Owner.Manager.Email);
                    }
                }
                system.debug('baseUrl =>'+baseUrl);
                mail.setSubject('Incoming Message');
                emailBody = 'Hello ' + objopp.Name+','+'<br><br>'+'Message - '+objTask.Cloufi_Twilio__Message__c+'<br><br>'+' To view your Opportunity <a href='+baseUrl+'/'+objopp.Id+'>click here</a>.';
            }
            system.debug('toaddress=>'+toaddress);
            mail.setToAddresses(toaddress);
            mail.setTargetObjectId(UserInfo.getUserId()); 
            mail.setSaveAsActivity(false);
            mail.setHtmlBody(emailBody);
            mail.setTreatTargetObjectAsRecipient(false);
            system.debug('mail=>'+mail);
            if(toaddress.size()>0){
                lstEmailMsg.add(mail);
            }
        }
        system.debug('lstEmailMsg=>'+lstEmailMsg);
        if(lstEmailMsg.size()>0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmailMsg);
            system.debug('results=>'+results);
        }
    }
    
    public static void updateLead(Set<Id> lead_Ids){
        system.debug('lead_Ids=>'+lead_Ids);
        List<Lead> leadList = New List<Lead>();
        Map<Id,List<Task>> taskMap = New Map<Id,List<Task>>();
        
        for(Task objTask : [SELECT Id, Subject, whoId FROM Task WHERE whoId IN: lead_Ids]){
            if(!taskMap.containskey(objTask.whoId) && objTask.whoId!=null){
                taskMap.put(objTask.whoId,New List<Task>());
            }
            taskMap.get(objTask.whoId).add(objTask);
        }
        For(Lead objLead : [SELECT Id, Total_Task__c, Total_Calls__c FROM Lead WHERE Id IN: lead_Ids AND IsConverted=false]){
            objLead.Total_Calls__c = 0;
            objLead.Total_Task__c = 0; 
            List<Task> taskList = New List<Task>();
            system.debug('objLead.Id=>'+objLead.Id);
            if(taskMap.get(objLead.Id)!=null){
                taskList = taskMap.get(objLead.Id);
            }
            if(taskList.size()>0){
                for(Task objTask : taskList){
                    If(objTask.Subject == 'Call'){
                        objLead.Total_Calls__c += 1;
                        system.debug('objTask.Subject=>'+objTask.Subject);
                    }else{
                        system.debug('objTask.Subject=>'+objTask.Subject);
                        objLead.Total_Task__c += 1;
                    }
                }
                leadList.add(objLead);  
            }
        }
        if(!leadList.isEmpty()){
            update leadList;
        }
    }
}