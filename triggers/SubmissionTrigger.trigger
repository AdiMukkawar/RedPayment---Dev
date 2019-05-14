/*********************************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: SubmissionTrigger
* Created Date: 14-Feb-2019
* Description: Submission Trigger to send Decline email to sales agent and support
**********************************************************************************
* Updates
* Author            | Date          | Description
* 
**********************************************************************************/
trigger SubmissionTrigger on Cloufi__Submission__c (after update) {
	if(trigger.isAfter){
		set<Id> declineSubmissions;
		if(Trigger.isUpdate){
			declineSubmissions = new set<Id>();
			for (Cloufi__Submission__c objSub : Trigger.new) {
				if(trigger.oldMap.get(objSub.Id).Cloufi__Status__c != 'Declined' && objSub.Cloufi__Status__c =='Declined'){
					declineSubmissions.add(objSub.Id);
				}
			}
		}

		if(declineSubmissions.size()>0){
            SubmissionTriggerHandler.emailToAgentAndSupport(declineSubmissions);
        }
	}
}