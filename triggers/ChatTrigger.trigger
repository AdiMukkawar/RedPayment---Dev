/*********************************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: ChatTrigger
* Created Date: 05-March-2019
* Description: Chat Trigger
**********************************************************************************
* Updates
* Author            | Date          | Description
* 
**********************************************************************************/
trigger ChatTrigger on Chat__c (after insert) {
	system.debug('Chat CS'+Cloufi__LendingXL_Trigger_Settings__c.getOrgDefaults().Custom_Chat_Trigger__c);
	if(Cloufi__LendingXL_Trigger_Settings__c.getOrgDefaults() != null && Cloufi__LendingXL_Trigger_Settings__c.getOrgDefaults().Custom_Chat_Trigger__c){
		set<id> chatIds = new set<Id>();
	    if(TRIGGER.isAfter){
	        if(TRIGGER.isInsert){
	        	for(Chat__c objChat: trigger.new){
	        		if(objChat.To__c !=null && objChat.Template_Id__c !=null && objChat.Opportunity__c!=null && objChat.Message__c!=null && objChat.Type__c=='Chat'){
	        			chatIds.add(objChat.id);
	        		}
	        	}
	        }
	    }

	    if(chatIds.size()>0){
	    	if(TriggerRecursionCheck.RunOnce('ChatTrigger-AfterInsert-sendEmail')){
	    		ChatTriggerHandler.sendEmail(chatIds);
	    	}
	    }
	}
}