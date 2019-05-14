/**
Author            | Date       | Description
Aditya Mukkawar   | 03/07/2019 | Test class for ChatboxController
**/
@isTest
public class ChatboxController_Test 
{
    @isTest
    public static void ChatboxControllerTest(){
        
        // Insert Chat trigger custom setting
        Cloufi__LendingXL_Trigger_Settings__c objTriggerSett = new Cloufi__LendingXL_Trigger_Settings__c();
        objTriggerSett.Custom_Chat_Trigger__c = true;
        insert objTriggerSett;
       
        //Insert opportunity
        Opportunity objOpp = new Opportunity(); 
        objOpp.Name = 'Test Opp';
        objOpp.CloseDate = System.today();
        objOpp.StageName = 'Qualified';
        //objOpp.Assigned_Underwiter__r.email = 'test@gmail.com';
        insert objOpp;
        
        //Insert Note
        List<Chat__c> chatList = new List<Chat__c>();
        Chat__c objNote = new Chat__c();
        objNote.Message__c = 'Test list';
        objNote.Subject__c = 'Repayment note created by Funding Department';
        objNote.Opportunity__c = objOpp.Id;
        chatList.add(objNote);
        insert chatList;

        //Insert Chat
        Chat__c objChat = new Chat__c();
        objChat.Subject__c = 'Repayment note created by Funding Department';
        objChat.Opportunity__c = objOpp.Id;
        objChat.Message__c = 'Test';
        insert objChat;
        
        String inputMessage = 'Test Method';
        Test.startTest();
	        ChatboxController.fetchUser();
            ChatboxController.showLabel(objOpp.Id);
            ChatboxController.SendMessageToSalesCtrl(objOpp.Id,'<p>Test</p>');
            ChatboxController.showSupportLenderLabelCtrl(objOpp.Id);
            ChatboxController.MessageToSalesLenderCtrl(objOpp.Id,'<p>Test</p>');
            ChatboxController.operationalUWNoteCtrl(objOpp.Id,'<p>Test</p>');
            ChatboxController.repymentNoteCtrl(objOpp.Id,'<p>Test</p>');
            
            ChatboxController.supportSalesChatListCtrl(objOpp.Id); 
            ChatboxController.supportLenderChatListCtrl(objOpp.Id); 
            ChatboxController.operationalUWNoteListCtrl(objOpp.Id);
            ChatboxController.repaymentNoteListCtrl(objOpp.Id);
        	ChatboxController.createSalesRepNoteCtrl(objOpp.Id, inputMessage);
        	ChatboxController.salesRepNoteListCtrl(objOpp.Id);
        	ChatboxController.internalUWNoteCtrl(objOpp.Id,'<p>Test</p>');
        	ChatboxController.updateNotes(objOpp.Id, chatList);
			ChatboxController.legalNoteCtrl(objOpp.Id, '<p>Test</p>');
        	ChatboxController.legalNoteListCtrl(objOpp.Id);
        Test.stopTest();
        
        Profile objProfile = [SELECT Id FROM Profile WHERE Name='Under Writing' LIMIT 1]; 
        User objUser = new User(Alias = 'standt', Email='UnderWriting@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Writing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = objProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testUser@UW.com');

        System.runAs(objUser) {
            ChatboxController.MessageToSalesLenderCtrl(objOpp.Id,'<p>Test</p>');
			ChatboxController.operationalUWNoteCtrl(objOpp.Id,'<p>Test</p>');
			ChatboxController.internalNoteListCtrl(objOpp.Id);            
        }
    }
    
    /*@isTest
    public static void ChatboxControllerTest1(){
        
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
        
        Profile objProfile = [SELECT Id FROM Profile WHERE Name='Sales Support' LIMIT 1]; 
        User objUser = new User(Alias = 'standt', Email='UnderWriting@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Support', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = objProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testUser@UW.com');

        System.runAs(objUser) {
            ChatboxController.MessageToSalesLenderCtrl(objOpp.Id,'<p>Test</p>');
			ChatboxController.operationalUWNoteCtrl(objOpp.Id,'<p>Test</p>');            
        }
    }
    
   	@isTest
    public static void ChatboxControllerTest2(){
       
        //Insert opportunity
        Opportunity objOpp = new Opportunity(); 
        objOpp.Name = 'Test Opp';
        objOpp.CloseDate = System.today();
        objOpp.StageName = 'Qualified';
        insert objOpp;
        
        //Insert Chat
        Chat__c objChat = new Chat__c();
        objChat.Subject__c = 'Task Assign to Sales Support';
        objChat.Opportunity__c = objOpp.Id;
        insert objChat;
        
        Profile objProfile = [SELECT Id FROM Profile WHERE Name='Sales Support' LIMIT 1]; 
        User objUser = new User(Alias = 'standt', Email='UnderWriting@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Support', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = objProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testUser@UW.com');

        System.runAs(objUser) {
            ChatboxController.MessageToSalesLenderCtrl(objOpp.Id,'<p>Test</p>');
			ChatboxController.operationalUWNoteCtrl(objOpp.Id,'<p>Test</p>');            
        }
    }*/
}