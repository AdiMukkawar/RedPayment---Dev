public with sharing class RequestContractFromLenderControllerX {

    public Opportunity objOpportunity{get;set;}

    public RequestContractFromLenderControllerX(ApexPages.StandardController controller) {      
        if(Apexpages.currentPage().getParameters().get('id') != null){
            objOpportunity = [SELECT Id, Name, Cloufi__Funder__c, Cloufi__Funder__r.Name, Company_Logo__c, StageName FROM Opportunity WHERE Id =: Apexpages.currentPage().getParameters().get('id') LIMIT 1];
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Page must be invoked from Opportunity'));
        }       
    }

    public PageReference requestContract(){
        try{
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: Label.CPS_Sales_Support_Email];
            List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
            if(objOpportunity.Cloufi__Funder__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No funder is selected for this deal'));
                return null;    
            }else{
                Account objAccount = [SELECT Id, Name, (SELECT Id, Name, Email FROM Contacts WHERE Email != null AND Contract__c = true) FROM Account WHERE ID =: objOpportunity.Cloufi__Funder__c];
                
                List<EmailTemplate> templateList = [SELECT Id, Body FROM EmailTemplate WHERE DeveloperName = 'Request_Contract'];
                if(objAccount.Contacts.size()>0 && templateList.size()>0){
                    List<String> emailIds = new List<String>();
                    for(Contact objContact : objAccount.Contacts){
                        emailIds.add(objContact.Email);
                    }
                    /*String htmlBody = templateList[0].Body;
                    htmlBody = htmlBody.replace('{!Opportunity.Cloufi__Funder__r}', objOpportunity.Cloufi__Funder__r.Name);
                    htmlBody = htmlBody.replace('{!Opportunity.Name}', objOpportunity.Name);
                    htmlBody = htmlBody.replace('{!Opportunity.Company_Logo__c}', objOpportunity.Company_Logo__c);
                    emailMsg.setHtmlBody(htmlBody);*/
                    Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                    emailMsg.setTargetObjectId(objAccount.Contacts[0].id);
                    emailMsg.setWhatId(objOpportunity.id);
                    emailMsg.setTemplateId(templateList[0].id);
                    emailMsg.SaveAsActivity = False;
                    emailMsg.setTreatTargetObjectAsRecipient(false);
                    emailMsg.setToAddresses(emailIds);
                    if ( owea.size() > 0 ) {
                        emailMsg.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    system.debug('emailMsg=>'+emailMsg);
                    lstEmailMsg.add(emailMsg);
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Please select Contract checkbox under desired Contact to get Email notification'));
                    return null;
                }
                if(lstEmailMsg.size()>0){
                    Messaging.sendEmail(lstEmailMsg);
                    if(objOpportunity.StageName == 'Approved'){
                        objOpportunity.StageName = 'Contract Requested';
                        update objOpportunity;
                    }
                }
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Contract Requested from '+objOpportunity.Cloufi__Funder__r.Name));
            } 
        }catch(Exception e){   
            /*CloufiServicing__Error_Log__c log = new CloufiServicing__Error_Log__c();
            log.CloufiServicing__Class_Name__c ='RequestContractFromLenderControllerX';
            log.CloufiServicing__ErrorMessage__c= e.getMessage()+' '+e.getLineNumber();
            log.CloufiServicing__Stack_Trace__c = e.getStackTraceString();
            log.CloufiServicing__Method_Name__c = 'requestContract';
            insert log;*/
            System.debug('Exception '+e.getMessage());
            System.debug('Exception '+e.getStackTraceString());
            System.debug(e.getLineNumber());
        }
        return null;
    }
}