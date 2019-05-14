/*****************************************************************
* Author: Techila Global Services Pvt Ltd.(Aditya Mukkawar)
* Class Name: 
* Created Date: 14-September-2018
* Description: Extension to send Missing Document list to Merchant
*******************************************************************
* Updates
* Author            | Date          | Description
*
**********************************************************************************/

public class RequestMissingStipsController {
    public id OpportunityId{get;set;}
    
    
    public RequestMissingStipsController(ApexPages.StandardController ctrl){
        OpportunityId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('OpportunityId=>'+OpportunityId);
        if(OpportunityId == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please open this page from opportunity'));
        }/*else{
            sendMissingDocs();          
        }*/
    }
    
    public void sendMissingDocs(){
        try{
            Opportunity objOpp = [SELECT id,Owner.Email,Lead__c,Owner_1_Email__c,(SELECT id,Cloufi__URL__c FROM Cloufi__Dropbox_Attachments__r) FROM Opportunity WHERE id=:OpportunityId];
            system.debug('objOpp=>'+objOpp);
            Boolean stipMissing = false;
            Boolean allStipsUploaded = true;
            if(objOpp.Cloufi__Dropbox_Attachments__r.size()>0){
                for(Cloufi__UW_Document__c objUW:objOpp.Cloufi__Dropbox_Attachments__r){
                    if(objUW.Cloufi__URL__c == null){
                        stipMissing = true;
                        allStipsUploaded = false;
                        break;
                    }
                }
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'There is no Document to upload'));
            }
            
            if(stipMissing){
                Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                List<String> emailIds = new List<String>();
                if(objOpp.Owner_1_Email__c !=null){
                    emailIds.add(objOpp.Owner_1_Email__c);
                }else{
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Merchant email id is blank.'));
                }
                emailMsg.setToAddresses(emailIds);
                emailMsg.setTargetObjectId(UserInfo.getUserId());
                emailMsg.setWhatId(objOpp.id);   
                emailMsg.SaveAsActivity = false;  
                emailMsg.setTemplateId([select id from EmailTemplate where DeveloperName = 'Request_Missing_Stips'].id);
                emailMsg.setTreatTargetObjectAsRecipient(false);
                system.debug('emailMsg=>'+emailMsg);
                List<Messaging.SendEmailResult> results =  Messaging.sendEmail(new Messaging.Email[] {emailMsg});
                system.debug('results=>'+results);
                if (results.get(0).isSuccess()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Missing Document mail has been sent to ' +objOpp.Owner_1_Email__c));
                }
            }
            if(allStipsUploaded && objOpp.Cloufi__Dropbox_Attachments__r.size()>0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'All Documents are already Uploaded.'));
            }
        }catch(exception e){
            system.debug('error'+e.getMessage());
        }
        
    }
}