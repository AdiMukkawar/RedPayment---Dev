Public class TwilioTaskTriggerHandler{
    
    public static void handleAfterInsert(Set<Id> taskIds){
        List<Task> taskList = [SELECT id,Cloufi_Twilio__Type__c,Cloufi_Twilio__Message__c,WhoId,whatId FROM Task WHERE id in:taskIds];
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
            List<Lead> taskLeads = [Select Id,Email,LastName,FirstName,Owner.Email  from Lead where Id in :leadIds]; 
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
            //String baseUrl = system.URL.getSalesforceBaseUrl().toExternalForm();
            String baseUrl = Label.Base_URL;
            system.debug('opportunityMap =>'+opportunityMap);
            system.debug('leadMap =>'+leadMap);
            
            if(objTask.WhoId <> NULL && objTask.WhoId.getSobjectType() == Lead.getSObjectType()){
                Lead objLead = leadMap.get(objTask.WhoId);
                if(objLead.Owner.Email !=null){
                    toaddress.add(objLead.Owner.Email);
                    toaddress.add(objLead.Email);
                }
                system.debug('baseUrl =>'+baseUrl);
                mail.setSubject('Incoming Message');
                emailBody = 'Hello ' + objLead.FirstName+' '+objLead.LastName+','+'<br><br>'+'Message - '+objTask.Cloufi_Twilio__Message__c+'<br><br>'+' To view your Lead <a href='+baseUrl+'/'+objLead.Id+'>click here</a>.';      
            }
            if(objTask.WhatId <> NULL && objTask.WhatId.getSobjectType() == opportunity.getSObjectType()){
                opportunity objopp = opportunityMap.get(objTask.WhatId);
                if(objopp.Owner.Email !=null){
                    toaddress.add(objopp.Owner.Email);
                    toaddress.add(objopp.Cloufi__Email_Address__c);
                    toaddress.add(objopp.Owner.Manager.Email);
                }
                system.debug('baseUrl =>'+baseUrl);
                mail.setSubject('Incoming Message');
                emailBody = 'Hello ' + objopp.Name+','+'<br><br>'+'Message - '+objTask.Cloufi_Twilio__Message__c+'<br><br>'+' To view your Opportunity <a href='+baseUrl+'/'+objopp.Id+'>click here</a>.';
            }
            mail.setToAddresses(toaddress);
            mail.setTargetObjectId(UserInfo.getUserId()); 
            mail.setSaveAsActivity(false);
            mail.setHtmlBody(emailBody);
            mail.setTreatTargetObjectAsRecipient(false);
            if(toaddress.size()>0){
                lstEmailMsg.add(mail);
            }
        }
        
        if(lstEmailMsg.size()>0){
            system.debug('lstEmailMsg=>'+lstEmailMsg);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmailMsg);
        }
        
    }

}