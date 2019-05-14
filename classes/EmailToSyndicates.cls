/*********************************************************************************
Class Name : EmailToSyndicates 
----------------------------------------------------------------------------------
Author          | Project     |  Date       | Description
----------------------------------------------------------------------------------
Aditya Mukkawar | Red Payment | 12/14/2018  | Batch class to send email to Syndicates 
                                            for their settled payments for the day
**********************************************************************************/
global class EmailToSyndicates implements Database.Batchable<sObject>, Database.Stateful {
    private Integer numDays;
    List<String> emailIds = new List<String>();
    public EmailToSyndicates(Integer nDays) {
        numDays = nDays;
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {      
        String query = 'SELECT id,CloufiServicing__Opportunity__c,CloufiServicing__Syndicating_Account__c,CreatedDate,CloufiServicing__Running_Balance__c FROM CloufiServicing__Syndication__c';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<CloufiServicing__Syndication__c> syndList) {
        /*if(numDays==0){
            numDays = 1;
        }*/
        String sNumDays = String.valueOf(numDays);
        Date d = System.today() - numDays;
        system.debug('d =>'+d); 
        set<Id> syndIds = new set<Id>();
        set<Id> accountIds = new set<Id>();
        for(CloufiServicing__Syndication__c objSyn : syndList){
            accountIds.add(objSyn.CloufiServicing__Syndicating_Account__c);
            syndIds.add(objSyn.id);
        }
        system.debug('accountIds=>'+accountIds);
        
        Map<Id,List<Cloufi__Payments__c>> mapSyndIdPayments = new Map<Id,List<Cloufi__Payments__c>>();      
        for(Cloufi__Payments__c objPay:[SELECT id,Cloufi__Payment_Type__c,RecordType.Name,Cloufi__Status__c,Cloufi__Account__c,CloufiServicing__Syndication__c,CloufiServicing__Expected_Settlement_Date__c FROM Cloufi__Payments__c WHERE RecordType.Name='Payment Out' AND Cloufi__Status__c='Settled' AND CloufiServicing__Syndication__c IN:syndIds AND CloufiServicing__Expected_Settlement_Date__c = yesterday AND Cloufi__Payment_Type__c='Syndication Payment']){
            system.debug('objPay >>'+objPay);
            if(!mapSyndIdPayments.containsKey(objPay.CloufiServicing__Syndication__c))
                mapSyndIdPayments.put(objPay.CloufiServicing__Syndication__c,new List<Cloufi__Payments__c>());
            mapSyndIdPayments.get(objPay.CloufiServicing__Syndication__c).add(objPay);
        }
        Map<Id,List<String>> mapAccIdContacts = new Map<Id,List<String>>();
        if(accountIds.size()>0){
            for(Account objAcc:[SELECT id,(SELECT id,Email FROM Contacts) FROM Account WHERE id IN:accountIds AND Cloufi__Syndicator__c=true]){
                for(Contact objCon:objAcc.Contacts){
                    if(!mapAccIdContacts.containsKey(objAcc.id))
                        mapAccIdContacts.put(objAcc.id,new List<String>());
                    mapAccIdContacts.get(objAcc.id).add(objCon.Email);
                }
            }
            system.debug('mapAccIdContacts=>'+mapAccIdContacts);
            system.debug('mapSyndIdPayments=>'+mapSyndIdPayments);
            system.debug('syndIds=>'+syndIds);
            system.debug('syndList=>'+syndList);
            if(syndIds.size()>0){
                List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
                List<EmailTemplate> emailTemp = [select id from EmailTemplate where Name = 'Alert to Syndicator'];
                for(CloufiServicing__Syndication__c objSynd:syndList){
                    system.debug('objSynd.id >>'+objSynd.id);
                    if(mapSyndIdPayments.size()>0){
                        if(mapSyndIdPayments.containsKey(objSynd.id) && mapSyndIdPayments.get(objSynd.id).size()>0){
                            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                            emailIds = mapAccIdContacts.get(objSynd.CloufiServicing__Syndicating_Account__c);
                            system.debug('emailIds=>'+emailIds);
                            emailMsg.setToAddresses(emailIds);
                            emailMsg.setTargetObjectId(UserInfo.getUserId());
                            emailMsg.setWhatId(objSynd.id);   
                            emailMsg.SaveAsActivity = false;  
                            emailMsg.setTemplateId(emailTemp[0].id);
                            emailMsg.setTreatTargetObjectAsRecipient(false);
                            PageReference pdf = Page.emailToSyndicatesPDF;
                            pdf.getParameters().put('id',(String)objSynd.id);
                            pdf.getParameters().put('days',sNumDays);
                            pdf.setRedirect(true);
                            blob b;
                            
                            if(!test.isRunningTest()){
                                b = pdf.getContent();
                            }else{
                                b = blob.valueof('TEST');
                            }
                            Messaging.EmailFileAttachment[] objEmailAttachments = new Messaging.EmailFileAttachment[1];
                            Messaging.EmailFileAttachment objPDFAttachment = new Messaging.EmailFileAttachment();
                            objPDFAttachment.setBody(b);
                            objPDFAttachment.setFileName('Payments'+ '.pdf');
                            objEmailAttachments[0] = objPDFAttachment;
                            emailMsg.setFileAttachments(objEmailAttachments);
                            if(emailIds!=null){
                                lstEmailMsg.add(emailMsg);
                            }
                        }
                    }
                }
                
                if(lstEmailMsg.size()>0){
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmailMsg);
                }
            }
        }
    }   
     
    global void finish(Database.BatchableContext BC) {
        
    }
}