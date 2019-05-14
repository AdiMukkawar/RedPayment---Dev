/**
Author            | Date       | Description
Aditya Mukkawar   | 03/07/2019 | Test class for ChatTrigger
**/
@isTest
public class ChatTrigger_Test {
    public static testmethod void ChatTriggerTest(){
        
        // Insert Chat trigger custom setting
        Cloufi__LendingXL_Trigger_Settings__c objTriggerSett = new Cloufi__LendingXL_Trigger_Settings__c();
        objTriggerSett.Custom_Chat_Trigger__c = true;
        insert objTriggerSett;
        
        //Insert opportunity
        Opportunity objOpp = new Opportunity(); 
        objOpp.Name = 'Test Opp';
        objOpp.CloseDate = System.today();
        objOpp.StageName = 'Qualified';
        insert objOpp;
        
        Chat__c objChat = new Chat__c();
        objChat.Source__c = 'Sales';
        objChat.Destination__c = 'Support';
        objChat.Subject__c = 'Task Assign to Sales Support';
        objChat.Template_Id__c =  [select id from EmailTemplate where DeveloperName = 'Message_to_Support_From_Sales_Rep'].id;
        objChat.To__c = 'test@gmail.com';
        objChat.CC__c = 'test1@gmail.com';
        objChat.Type__c = 'Chat';
        objChat.Opportunity__c = objOpp.id;
        objChat.Message__c = '<p>Hello There !!</p><p><br></p><p><img src="https://merchantservices--dev--c.cs23.content.force.com/sfc/servlet.shepherd/version/download/06818000000JQQh?asPdf=false&amp;operationContext=CHATTER"></img></p>';
        objChat.user__c = UserInfo.getUserId();
        insert objChat;
        
    }

}