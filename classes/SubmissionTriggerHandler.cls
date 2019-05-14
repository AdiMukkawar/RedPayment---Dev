/******************************************************************************
Author             | Date           | Description
Aditya Mukkawar    | 14-Feb-2019    | 
******************************************************************************
 Updates
* Author            | Date            | Description

**********************************************************************************/
public with sharing class SubmissionTriggerHandler {
	 public static void emailToAgentAndSupport(set<Id> declSubIds){
        try{
        	List<Cloufi__Submission__c> declinedSubmissions = [SELECT id,Cloufi__Status__c,Cloufi__Opportunity__c,Cloufi__Opportunity__r.Owner.Email,Cloufi__Opportunity__r.Owner.Sales_Support_Email__c FROM Cloufi__Submission__c WHERE Id IN:declSubIds];
        	List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
        	List<EmailTemplate> emailTemp = [select id from EmailTemplate where DeveloperName = 'Submission_Decline_For_Sales_and_Support'];
            for(Cloufi__Submission__c objSubmission:declinedSubmissions){
            	System.debug('Opp Owner Email'+objSubmission.Cloufi__Opportunity__r.Owner.Email);
            	System.debug('Opp Owner Support Email'+objSubmission.Cloufi__Opportunity__r.Owner.Sales_Support_Email__c);
            	Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
	            List<String> emailIds = new List<String>();
	            if(objSubmission.Cloufi__Opportunity__r.Owner.Email !=null){
	            	emailIds.add(objSubmission.Cloufi__Opportunity__r.Owner.Email);
	            }
	            if(objSubmission.Cloufi__Opportunity__r.Owner.Sales_Support_Email__c !=null){
	            	emailIds.add(objSubmission.Cloufi__Opportunity__r.Owner.Sales_Support_Email__c);
	            }          
	            emailMsg.setToAddresses(emailIds);
	            emailMsg.setTargetObjectId(UserInfo.getUserId());
	            emailMsg.setWhatId(objSubmission.Id);   
	            emailMsg.SaveAsActivity = false;
	            emailMsg.setTreatTargetObjectAsRecipient(false);
	            emailMsg.setTemplateId(emailTemp[0].id);
	            System.debug('Email Message' +emailMsg);
	            if(emailIds !=null){
	            	lstEmailMsg.add(emailMsg);
	            }
            	Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmailMsg);
            	System.debug('results' +results);
            }
        }catch(exception ex){
            System.debug('Message=>'+ex.getMessage());
            System.debug('on line=>'+ex.getLineNumber());
            System.debug('=>'+ex.getStackTraceString());
        }
    }
}