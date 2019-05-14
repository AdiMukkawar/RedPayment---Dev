/*****************************************************************
* Author: Techila Global Services Pvt Ltd(Aditya Mukkawar).
* Class Name: ChatboxController
* Created Date: 03/15/2019
* Description: Controller class for Lead Notebox component
*******************************************************************/
public class LeadNoteboxController {
	 @AuraEnabled 
    public static user fetchUser(){
        // query current user information  
        User oUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }

    // Create Sales Representative Note
    @AuraEnabled
    public static Map<String,string> createSalesRepNoteCtrl(Id leadId, String inputmsg){
        Map<String,string> msg= new Map<String,string>();
        if(inputmsg !=null && !String.isBlank(inputmsg)){
            User objUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
            Chat__c objChat = new Chat__c();
            if(objUser.Profile.Name=='Cash Advance Sales Agent'){
                objChat.Subject__c = 'Representative note created by Sales Agent';
            }else{
                objChat.Subject__c = 'Representative note created by Sales Manager';
            }
            objChat.Type__c = 'Note';
            objChat.Lead__c = leadId;
            objChat.Message__c = inputmsg;
            objChat.user__c = UserInfo.getUserId();
            insert objChat;
            msg.put('Success','Note has been saved successfully');
        }else{
            msg.put('Warning','Please Type message');
        }
        return msg;
    }

    // Get Sales Representative Note List
    @AuraEnabled
    public static List<Chat__c> salesRepNoteListCtrl(Id leadId){
        List<Chat__c> chatList = [SELECT id,Message__c,Opportunity__c,Type__c,CreatedDate,Subject__c,User__r.name,User__c,User__r.id FROM Chat__c WHERE Lead__c=:leadId AND (Subject__c='Representative note created by Sales Agent' OR Subject__c='Representative note created by Sales Manager') Order by CreatedDate Desc];
        system.debug('chatList=>'+chatList);
        if(chatList.size()>0){
            return chatList;
        }else{
            return null;
        }
    }
}