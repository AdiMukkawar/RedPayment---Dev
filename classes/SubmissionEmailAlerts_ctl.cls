/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: SubmissionEmailAlerts_ctl
* Created Date: 24-September-2018
* Description: 

*******************************************************************/
public class SubmissionEmailAlerts_ctl {
    
    @AuraEnabled
    public static boolean isLenderAvailable(Id subId){
        if(subId !=null){
            Cloufi__Submission__c objSub = [SELECT id,Cloufi__Lender__c FROM Cloufi__Submission__c WHERE id=:subId];
            if(objSub.Cloufi__Lender__c !=null){
                return true;
            }else{
                return false;
            }
        }
        return false;
    }
    
    @AuraEnabled
    public static Map<String,String> AlertToLender(Id subId,string mailFor){
        Map<String,String> msg = new Map<String,String>();
        if(subId !=null){
            Cloufi__Submission__c objSub = [SELECT id,Cloufi__Lender__c FROM Cloufi__Submission__c WHERE id=:subId];
            if(objSub.Cloufi__Lender__c !=null){
                List<Contact> conList = new List<Contact>();
                if(mailFor == 'Submission' || mailFor == 'General' || mailFor == 'Funding' || mailFor == 'Commission'){
                    conList = [SELECT id,Submission__c,Email FROM Contact WHERE accountId=:objSub.Cloufi__Lender__c AND Submission__c=true];
                }
                if(mailFor == 'Contract'){
                    conList = [SELECT id,Contract__c,Email FROM Contact WHERE accountId=:objSub.Cloufi__Lender__c AND Contract__c=true];
                }
                system.debug('conList >>'+conList);
                if(conList.size()>0){
                    List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>();
                    EmailTemplate emailTemp = new EmailTemplate();
                    if(mailFor == 'Submission'){
                        emailTemp = [select id from EmailTemplate where DeveloperName = 'Submission_offer_update'];
                    }
                    if(mailFor == 'Contract'){
                        emailTemp = [select id from EmailTemplate where DeveloperName = 'Submission_Contract_update'];
                    }
                    if(mailFor == 'General'){
                        emailTemp = [select id from EmailTemplate where DeveloperName = 'Submission_General_update'];
                    }
                    if(mailFor == 'Funding'){
                        emailTemp = [select id from EmailTemplate where DeveloperName = 'Submission_Funding_update'];
                    }
                    if(mailFor == 'Commission'){
                        emailTemp = [select id from EmailTemplate where DeveloperName = 'Submission_Commission_update'];
                    }
                    
                    for(Contact objCon:conList){
                        Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                        List<String> ToEmailIds=new List<String>();
                        if(objCon.Email!=null){
                            ToEmailIds.add(objCon.Email);
                        }
                        emailMsg.setToAddresses(ToEmailIds);
                        emailMsg.setTargetObjectId(UserInfo.getUserId());
                        emailMsg.setWhatId(objSub.id);
                        emailMsg.setTemplateId(emailTemp.id);
                        emailMsg.SaveAsActivity = False;
                        emailMsg.setTreatTargetObjectAsRecipient(false);
                        system.debug('UserInfo.getUserId()=>'+UserInfo.getUserId());
                        if(ToEmailIds.size()>0){
                            system.debug('ToEmailIds=>'+ToEmailIds);
                            system.debug('emailMsg=>'+emailMsg);
                            lstMails.add(emailMsg);
                        }
                    }
                    if(lstMails.size()>0){
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(lstMails);
                        msg.put('Success','Mail Sent successfully.');
                    }
                }else{
                    msg.put('Warning','There is no contact for Lender');
                }
            }else{
                msg.put('Warning','There is no Lender for the Submission');
            }
            
        }
        return msg;
    }
    
    @AuraEnabled
    public static Map<String,String> sendSelectedOptionMail(Id subId,string selectedOption,string msgBody){
        Map<String,String> msg = new Map<String,String>();
        Cloufi__Submission__c objSub = [SELECT id,Cloufi__Lender__c FROM Cloufi__Submission__c WHERE id=:subId];
        List<Contact> conList = new List<Contact>();
        if(selectedOption == 'Submission'){
            conList = [SELECT id,Submission__c,Email FROM Contact WHERE accountId=:objSub.Cloufi__Lender__c AND Submission__c=true];
        }
        if(selectedOption == 'Contract'){
            conList = [SELECT id,Contract__c,Email FROM Contact WHERE accountId=:objSub.Cloufi__Lender__c AND Contract__c=true];
        }
        if(selectedOption == 'Revision'){
            conList = [SELECT id,Revision__c,Email FROM Contact WHERE accountId=:objSub.Cloufi__Lender__c AND Revision__c=true];
        }
        if(conList.size()>0){
            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            List<String> ToEmailIds = new List<String>();
            for(Contact objCon:conList){
                if(objCon.Email !=null){
                    ToEmailIds.add(objCon.Email);
                }
            }
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(ToEmailIds);
            mail.setSubject('Submission Update');
            mail.setHtmlBody(msgBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            msg.put('Success','Mail Sent successfully.');
        }else{
            msg.put('Warning','There is no contact for Lender');
        }
        return msg;
    }  
}