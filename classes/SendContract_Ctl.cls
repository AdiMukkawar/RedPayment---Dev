/*
Send Contract page Controller
Test Class: 
-------------------------------------------------------------------------------------------
Author           | Project       |Date           | Description
-------------------------------------------------------------------------------------------
Aditya           | Red Payment   | 08/16/2018    | Controller for SendContract
-------------------------------------------------------------------------------------------
*/
public class SendContract_Ctl {
    public id oppid{get;set;}

    public SendContract_Ctl(ApexPages.StandardController controller) {
         oppid = ApexPages.currentPage().getParameters().get('id');
    }
    public Pagereference SendContract(){
        try{
            List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
            List<Cloufi__UW_Document__c> uwList = [SELECT id,Stip_Name__c,Cloufi__URL__c FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c =:oppid AND Stip_Name__c='Contract'];
            Opportunity objOpp = [select Id,Name,Cloufi__Email_Address__c,AccountId,Lead__c,stageName, OwnerId from Opportunity where id=:oppId];
            if(objOpp.Cloufi__Email_Address__c == null){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Please insert Opportunity Email Id'));
            }else if(objOpp.stageName != 'Contract Received'){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'To send a contract Opportunity stage should be Contract Received'));
            }
            
            if(objOpp.id != null && objOpp.Cloufi__Email_Address__c != null && objOpp.stageName == 'Contract Received'){ 
                Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                List<String> emailIds = new List<String>();
                emailIds.add(objOpp.Cloufi__Email_Address__c);
                emailMsg.setToAddresses(emailIds);
                emailMsg.setTargetObjectId(UserInfo.getUserId());
                emailMsg.setWhatId(objOpp.id);   
                emailMsg.SaveAsActivity = false;  
                emailMsg.setTreatTargetObjectAsRecipient(false);
                emailMsg.setTemplateId([select id from EmailTemplate where DeveloperName = 'SendContract'].id);
                lstEmailMsg.add(emailMsg);
                System.debug('Email Message' +emailMsg);
                Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmailMsg);
                System.debug('results' +results);
                if(results[0].success){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Contract has been sent to ' +objOpp.Cloufi__Email_Address__c ));
                    objOpp.stageName = 'Contract Sent';
                    update objOpp;
                }
            }   
         
        }catch(Exception ex){
            System.debug('Exception '+ex.getMessage());
            System.debug('Exception '+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
        }
        return null;
    }
}