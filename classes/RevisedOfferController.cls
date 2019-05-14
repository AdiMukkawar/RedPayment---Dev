public class RevisedOfferController {
    
    public Cloufi__Offers__c objOffers{get;set;}
    public id OfferId{get;set;}

    
    public RevisedOfferController (ApexPages.StandardController controller){
        
        objOffers = new Cloufi__Offers__c ();
        OfferId =  ApexPages.currentPage().getParameters().get('id');

    }  
    public void notifyLender(){
        try{  
            objOffers = [SELECT Id, Name, Cloufi__Offer_Status__c,Cloufi__Opportunity__r.Lead__c,Cloufi__Funder__c,Cloufi__Submission__r.Cloufi__Status__c FROM Cloufi__Offers__c WHERE Cloufi__Offer_Status__c = 'Revision' AND Cloufi__Funder__c != null AND  Id =: OfferId LIMIT 1];      
            
            /*if(objOffers.Cloufi__Submission__r.Cloufi__Status__c == 'Approved'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Cannot revised approved submission offer' ));
                return;
            }*/
            
            List<Messaging.SingleEmailMessage> lstLenderEmailMsg = new List<Messaging.SingleEmailMessage>();
            List<EmailTemplate> EmailTemp = [select id from EmailTemplate where DeveloperName = 'Revise_Offer_Alert'];                               
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: Label.CPS_Sales_Support_Email];
            if(objOffers != null && objOffers.Cloufi__Funder__c != null){
                // To get Revision contacts to send an alert
                Map<Id,List<Contact>> mapAccIdContacts = new Map<Id,List<Contact>>();
                for(Account objAcc : [SELECT id,Cloufi__Syndicator__c,(SELECT id,Email,Revision__c FROM Contacts WHERE Revision__c=true) FROM Account WHERE Id =: objOffers.Cloufi__Funder__c]){
                    if(objAcc.Contacts.size()>0){
                        mapAccIdContacts.put(objAcc.Id, objAcc.Contacts);
                    }
                }
                System.debug('mapAccIdContacts ->'+mapAccIdContacts);
                // To Send an email to contacts
                if(mapAccIdContacts.size()>0){
                    if(mapAccIdContacts.get(objOffers.Cloufi__Funder__c).size()>0){
                        List<String> sendEmailIds = new List<String>();
                        for(Contact objC:mapAccIdContacts.get(objOffers.Cloufi__Funder__c)){
                            sendEmailIds.add(objC.Email);
                        }
                        if(sendEmailIds.size()>0){
                            Messaging.SingleEmailMessage sendMsg = new Messaging.SingleEmailMessage();
                            System.debug('sendEmailIds ->'+sendEmailIds+' Size ->'+sendEmailIds.size());
                            sendMsg.setToAddresses(sendEmailIds);
                            if(objOffers.Cloufi__Opportunity__r.Lead__c != null){
                                sendMsg.setTargetObjectId(objOffers.Cloufi__Opportunity__r.Lead__c);
                            }else{
                                sendMsg.setTargetObjectId(UserInfo.getUserId());
                            }
                            if ( owea.size() > 0 ) {
                                sendMsg.setOrgWideEmailAddressId(owea.get(0).Id);
                            }
                            sendMsg.setWhatId(objOffers.id);   
                            sendMsg.SaveAsActivity = false;
                            sendMsg.setTreatTargetObjectAsRecipient(false);
                            sendMsg.setTemplateId(EmailTemp[0].id);
                            lstLenderEmailMsg.add(sendMsg);
                            
                        }
                    }
                }
            }
            if(lstLenderEmailMsg.size()>0){
                system.debug('lstLenderEmailMsg==>'+lstLenderEmailMsg);
                Messaging.SendEmailResult[] results = Messaging.sendEmail(lstLenderEmailMsg);
                System.debug('results' +results);
                if(results[0].success){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Email has been sent to Funder.'));
                }
            }
        }Catch(Exception ex) {
            System.debug('Error Message ->' + ex.getMessage());
            System.debug('Error Stack Trace ->' + ex.getStackTraceString());
            if(objOffers.Cloufi__Funder__c == null && objOffers.Cloufi__Offer_Status__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please Select Revision & Funder.' ));
            }
        }
    }
}