public with sharing class SendFundingEmailToMerchantControllerX {

    public Id opportunityId;
    public Opportunity objOpportunity;
    
    public SendFundingEmailToMerchantControllerX(ApexPages.StandardController controller) {
        opportunityId = ApexPages.currentPage().getParameters().get('id');
        if(opportunityId != null){
            objOpportunity = [SELECT id, Name, Cloufi__Email_Address__c FROM Opportunity WHERE id=:opportunityId];
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Page must be open from Opportunity'));
        }
    }


    public void sendFundingEmailToMerchant(){
        List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();        
        Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
        List<String> emailIds = new List<String>();
        emailIds.add(objOpportunity.Cloufi__Email_Address__c);
        emailMsg.setToAddresses(emailIds);
        emailMsg.setTargetObjectId(UserInfo.getUserId());
        emailMsg.setWhatId(opportunityId);   
        emailMsg.SaveAsActivity = false;  
        emailMsg.setTemplateId([select id from EmailTemplate where DeveloperName = 'FundingEmailToMerchant'].id);
        lstEmailMsg.add(emailMsg);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmailMsg);
        if(results.size()>0){
            if(results[0].success){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Funding email is sent to ' +objOpportunity.Cloufi__Email_Address__c));
            }else{
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
        }
    }    
}