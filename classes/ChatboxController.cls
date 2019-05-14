/*****************************************************************
* Author: Techila Global Services Pvt Ltd(Aditya Mukkawar).
* Class Name: ChatboxController
* Created Date: 
* Description: Controller class for Chatbox component
*******************************************************************/
public class ChatboxController {
    @AuraEnabled 
    public static user fetchUser(){
        // query current user information  
        User oUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }

    // Header Label for Support-Agent Component
    @AuraEnabled
    public static string showLabel(Id oppId){
        string header='';
        User objUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
        opportunity objOpp = [SELECT id,OwnerId,Owner.CompanyName,Owner.Sales_Support_Email__c,Owner.Email FROM Opportunity Where id=:oppId];
        if(objUser.Profile.Name == 'Cash Advance Sales Agent' || objUser.Profile.Name == 'Customer Success'){
            header = 'Sales Support Correspondence';
        }else if(objUser.Profile.Name == 'Sales Support'){
            header = 'Sales Rep Correspondence';
        }else if(objUser.Profile.Name == 'Cash Advance Sales Manager' || objUser.Profile.Name == 'Customer Success Manager'){
            header = 'Sales Support Correspondence';
        }else{
            header = 'Sales Rep - Sales Support Correspondence';
        }
        return header;
    }

    // Header Label for Support-Lender Component
    @AuraEnabled
    public static string showSupportLenderLabelCtrl(Id oppId){
        string header='';
        User objUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
        system.debug('objUser=>'+objUser);
        if(objUser.Profile.Name == 'Sales Support'){
            header = 'Internal Lender Correspondance';//Send Message to Lender (Internal)
        }else if(objUser.Profile.Name == 'Under Writing'){          
            header = 'Sales Support Correspondence';
        }else{
            header = 'Internal UW - Sales Support Correspondence';
        }
        return header;
    }

    // Send Message to Sales agent / Support
    @AuraEnabled
    public static Map<String,string> SendMessageToSalesCtrl(Id oppId, String inputmsg){
        system.debug('oppId==>>'+oppId+'inputmsg==>>'+inputmsg);
        Map<String,string> msg= new Map<String,string>();
        if(inputmsg.trim() !=null && !String.isBlank(inputmsg)){
            
            opportunity objOpp = [SELECT id,OwnerId,Owner.CompanyName,Owner.Sales_Support_Email__c,Owner.Email,Owner.ManagerId, Owner.Manager.Email,Owner.Profile.Name FROM Opportunity Where id=:oppId];
            User objUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
            Chat__c objChat = new Chat__c();
            if(objUser.Profile.Name == 'Cash Advance Sales Agent' || objUser.Profile.Name == 'Customer Success'){//UserInfo.getUserId() == objOpp.OwnerId
                objChat.Source__c = 'Sales';
                objChat.Destination__c = 'Support';
                if(objOpp.Owner.Profile.Name == 'Cash Advance Sales Agent'){
                    objChat.Subject__c = 'Task Assign to Sales Support';
                }else{
                    objChat.Subject__c = 'Message from Customer Success to Sales Support';
                }
                objChat.Template_Id__c =  [select id from EmailTemplate where DeveloperName = 'Message_to_Support_From_Sales_Rep'].id;
                if(objOpp.Owner.Sales_Support_Email__c !=null){
                    objChat.To__c = objOpp.Owner.Sales_Support_Email__c;
                }
                if(objOpp.Owner.ManagerId!=null && objOpp.Owner.Manager.Email!=null){
                    objChat.CC__c = objOpp.Owner.Manager.Email;
                }
            }else if(objUser.Profile.Name == 'Sales Support'){                
                objChat.Source__c= 'Support';
                objChat.Destination__c = 'Sales';
                if(objOpp.Owner.Profile.Name == 'Cash Advance Sales Agent'){
                    objChat.Subject__c = 'Task Assign to Sales Rep';
                }else{
                    objChat.Subject__c = 'Message from Sales Support to Customer Success';
                } 
                objChat.Template_Id__c =  [select id from EmailTemplate where DeveloperName = 'Message_to_Sales_Rep_From_Support'].id;
                if(objOpp.Owner.Email !=null){
                    objChat.To__c = objOpp.Owner.Email;
                }
                if(objOpp.Owner.ManagerId!=null && objOpp.Owner.Manager.Email!=null){
                    objChat.CC__c = objOpp.Owner.Manager.Email;
                }
            }else{
                objChat.Source__c= 'Sales Manager';
                objChat.Destination__c = 'Sales & Support';
                if(objOpp.Owner.Profile.Name == 'Cash Advance Sales Agent'){
                    objChat.Subject__c = 'Task Assign to Sales Rep and Sales Support';
                }else{
                    objChat.Subject__c = 'Message from Customer Success Manager to Customer Success and Support';
                }
                objChat.Template_Id__c =  [select id from EmailTemplate where DeveloperName = 'Message_to_Support_From_Sales_Manager'].id;
                if(objOpp.Owner.Email !=null){
                    objChat.To__c = objOpp.Owner.Email;
                }
                if(objOpp.Owner.Sales_Support_Email__c !=null){
                    objChat.CC__c = objOpp.Owner.Sales_Support_Email__c;
                } 
            }
            objChat.Type__c = 'Chat';
            objChat.Opportunity__c = oppId;
            objChat.Message__c = inputmsg;
            objChat.user__c = UserInfo.getUserId();
            insert objChat;
            system.debug('objChat==>>'+objChat);
            msg.put('Success','Message has been sent successfully');
        }else{
            msg.put('Warning','Please Type message');
        }
        return msg;   
    }

    @AuraEnabled
    public static Map<String,string> MessageToSalesLenderCtrl(Id oppId, String inputmsg){
        system.debug('oppId==>>'+oppId+'inputmsg==>>'+inputmsg);
        Map<String,string> msg= new Map<String,string>();
        if(inputmsg !=null && !String.isBlank(inputmsg)){
            
            opportunity objOpp = [SELECT id,Assigned_Underwiter__c,Assigned_Underwiter__r.email,Cloufi__Funder__c,OwnerId,Owner.CompanyName,Owner.Sales_Support_Email__c,Owner.Email FROM Opportunity Where id=:oppId];
            User objUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
            Chat__c objChat = new Chat__c();
            if(objUser.Profile.Name=='Under Writing'){
                objChat.Source__c = 'UW';
                objChat.Destination__c = 'Support';
                objChat.Subject__c = 'Message from Lender to Sales Support';
                objChat.Template_Id__c =  [select id from EmailTemplate where DeveloperName = 'Message_to_Sales_Support_From_Lender'].id;
                if(objOpp.Owner.Sales_Support_Email__c !=null){
                    objChat.To__c = objOpp.Owner.Sales_Support_Email__c;
                }
            }else{                
                objChat.Source__c= 'Support';
                objChat.Destination__c = 'UW';
                objChat.Subject__c = 'Message from Sales Support to Lender';
                objChat.Template_Id__c =  [select id from EmailTemplate where DeveloperName = 'Message_to_Lender_From_Sales_Support'].id;
                if(objOpp.Assigned_Underwiter__c != null && objOpp.Assigned_Underwiter__r.email !=null){
                    objChat.To__c = objOpp.Assigned_Underwiter__r.email;
                }else{
                    OrgWideEmailAddress objOWEA = [SELECT Id, Address,DisplayName FROM OrgWideEmailAddress WHERE DisplayName='Internal Lender'];
                    system.debug('objOWEA=>'+objOWEA);
                    if(objOWEA.Address !=null){
                        system.debug('objOWEA Address=>'+objOWEA.Address);
                        objChat.To__c = objOWEA.Address;
                    }
                }
            }
            objChat.Type__c = 'Chat';
            objChat.Opportunity__c = oppId;
            objChat.Message__c = inputmsg;
            objChat.user__c = UserInfo.getUserId();
            insert objChat;
            system.debug('objChat==>>'+objChat);
            msg.put('Success','Message has been sent successfully');
        }else{
            msg.put('Warning','Please Type message');
        }
        return msg;
    }

    // Update edited Notes
    @AuraEnabled
    public static Map<String,String> updateNotes(Id oppId,List<Chat__c> chatList){
        system.debug('oppId >>'+oppId);
        Map<String,String> msg = new Map<String,String>();
        List<Chat__c> updateChatList = new List<Chat__c>();
        Map<Id,Chat__c> mapOldChats = new Map<Id,Chat__c>();
        Boolean blankNote = false;
        if(chatList.size()>0){
            for(Chat__c objOldChat:[SELECT id,Message__c,Opportunity__c FROM Chat__c WHERE Opportunity__c =:oppId]){
                mapOldChats.put(objOldChat.id,objOldChat);
            }
        }
        system.debug('mapOldChats >>'+mapOldChats);
        for(integer i=0;i<chatList.size();i++){
            Chat__c oldChat = mapOldChats.get(chatList[i].id);
            if(oldChat.id == chatList[i].id && oldChat.Message__c != chatList[i].Message__c){
                if(chatList[i].Message__c.trim() !=null && !String.isBlank(chatList[i].Message__c)){
                    updateChatList.add(chatList[i]);
                }else{
                    blankNote = true;
                    break;
                }
            }
        }
        system.debug('updateChatList >>'+updateChatList);
        if(updateChatList.size()>0){
            update updateChatList;
            msg.put('Success','Note Updated');
        }else if(blankNote){
            msg.put('Warning','Please Type Message.');
        }else{
            msg.put('Warning','No Note has been Update');
        }
       
        return msg;
    }

    // Create  Internal UW Notes
    @AuraEnabled
    public static Map<String,string> internalUWNoteCtrl(Id oppId, String inputmsg){
        Map<String,string> msg= new Map<String,string>();
        if(inputmsg !=null && !String.isBlank(inputmsg)){
            opportunity objOpp = [SELECT id,Assigned_Underwiter__c,Assigned_Underwiter__r.email,Cloufi__Funder__c,OwnerId,Owner.CompanyName,Owner.Sales_Support_Email__c,Owner.Email FROM Opportunity Where id=:oppId];
            User objUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
            Chat__c objChat = new Chat__c();
            if(objUser.Profile.Name=='Under Writing'){
                objChat.Source__c = 'UW';
                objChat.Destination__c = 'Support';
                objChat.Subject__c = 'Internal note created by UW';
                
            }else{                
                objChat.Source__c= 'Support';
                objChat.Destination__c = 'UW';
                objChat.Subject__c = 'Internal note created by Support';
            }
            objChat.Type__c = 'Note';
            objChat.Opportunity__c = oppId;
            objChat.Message__c = inputmsg;
            objChat.user__c = UserInfo.getUserId();
            insert objChat;
            msg.put('Success','Note has been saved successfully');
        }else{
            msg.put('Warning','Please Type message');
        }
        return msg;
    }

    // Create  Operational and UW Notes
    @AuraEnabled
    public static Map<String,string> operationalUWNoteCtrl(Id oppId, String inputmsg){
        Map<String,string> msg= new Map<String,string>();
        if(inputmsg !=null && !String.isBlank(inputmsg)){
            opportunity objOpp = [SELECT id,Assigned_Underwiter__c,Assigned_Underwiter__r.email,Cloufi__Funder__c,OwnerId,Owner.CompanyName,Owner.Sales_Support_Email__c,Owner.Email FROM Opportunity Where id=:oppId];
            User objUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
            Chat__c objChat = new Chat__c();
            if(objUser.Profile.Name=='Under Writing'){
                objChat.Subject__c = 'Operational note created by UW';
            }else if(objUser.Profile.Name == 'Sales Support'){ 
                objChat.Subject__c = 'Operational note created by Support';
            }else if(objUser.Profile.Name=='Funding Operations' || objUser.Profile.Name=='Funding Receiver'){
                objChat.Subject__c = 'Operational note created by Funding Department';
            }else if(objUser.Profile.Name == 'Customer Success'){
                objChat.Subject__c = 'Operational note created by Customer Success';
            }else if(objUser.Profile.Name == 'Customer Success Manager'){
                objChat.Subject__c = 'Operational note created by Customer Success Manager';
            }else{
                objChat.Subject__c = 'Operational note created by Sales Manager';
            }
            objChat.Type__c = 'Note';
            objChat.Opportunity__c = oppId;
            objChat.Message__c = inputmsg;
            objChat.user__c = UserInfo.getUserId();
            insert objChat;
            msg.put('Success','Note has been saved successfully');
        }else{
            msg.put('Warning','Please Type message');
        }
        return msg;
    }

     // Create Repayment Notes
    @AuraEnabled
    public static Map<String,string> repymentNoteCtrl(Id oppId, String inputmsg){
        Map<String,string> msg= new Map<String,string>();
        if(inputmsg !=null && !String.isBlank(inputmsg)){
            opportunity objOpp = [SELECT id,Assigned_Underwiter__c,Assigned_Underwiter__r.email,Cloufi__Funder__c,OwnerId,Owner.CompanyName,Owner.Sales_Support_Email__c,Owner.Email FROM Opportunity Where id=:oppId];
            User objUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
            Chat__c objChat = new Chat__c();
            if(objUser.Profile.Name=='Funding Operations' || objUser.Profile.Name=='Funding Receiver'){
                objChat.Subject__c = 'Repayment note created by Funding Department';
            }else{
                objChat.Subject__c = 'Repayment note created by UW';
            }
            objChat.Type__c = 'Note';
            objChat.Opportunity__c = oppId;
            objChat.Message__c = inputmsg;
            objChat.user__c = UserInfo.getUserId();
            insert objChat;
            msg.put('Success','Note has been saved successfully');
        }else{
            msg.put('Warning','Please Type message');
        }
        return msg;
    }

     // Create Legal Notes
    @AuraEnabled
    public static Map<String,string> legalNoteCtrl(Id oppId, String inputmsg){
        Map<String,string> msg= new Map<String,string>();
        if(inputmsg !=null && !String.isBlank(inputmsg)){
            opportunity objOpp = [SELECT id,Assigned_Underwiter__c,Assigned_Underwiter__r.email,Cloufi__Funder__c,OwnerId,Owner.CompanyName,Owner.Sales_Support_Email__c,Owner.Email FROM Opportunity Where id=:oppId];
            User objUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
            Chat__c objChat = new Chat__c();
            if(objUser.Profile.Name=='Funding Operations' || objUser.Profile.Name=='Funding Receiver'){
                objChat.Subject__c = 'Legal note created by Funding Department';
            }else{
                objChat.Subject__c = 'Legal note created by UW';
            }
            objChat.Type__c = 'Note';
            objChat.Opportunity__c = oppId;
            objChat.Message__c = inputmsg;
            objChat.user__c = UserInfo.getUserId();
            insert objChat;
            msg.put('Success','Note has been saved successfully');
        }else{
            msg.put('Warning','Please Type message');
        }
        return msg;
    }

     // Create Sales Representative Note
    @AuraEnabled
    public static Map<String,string> createSalesRepNoteCtrl(Id oppId, String inputmsg){
        Map<String,string> msg= new Map<String,string>();
        if(inputmsg !=null && !String.isBlank(inputmsg)){
            opportunity objOpp = [SELECT id,Assigned_Underwiter__c,Assigned_Underwiter__r.email,Cloufi__Funder__c,OwnerId,Owner.CompanyName,Owner.Sales_Support_Email__c,Owner.Email FROM Opportunity Where id=:oppId];
            User objUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
            Chat__c objChat = new Chat__c();
            if(objUser.Profile.Name=='Cash Advance Sales Agent'){
                objChat.Subject__c = 'Representative note created by Sales Agent';
            }else{
                objChat.Subject__c = 'Representative note created by Sales Manager';
            }
            objChat.Type__c = 'Note';
            objChat.Opportunity__c = oppId;
            objChat.Message__c = inputmsg;
            objChat.user__c = UserInfo.getUserId();
            insert objChat;
            msg.put('Success','Note has been saved successfully');
        }else{
            msg.put('Warning','Please Type message');
        }
        return msg;
    }
    
    
    // Get Support-Agent chat List
    @AuraEnabled
    public static List<Chat__c> supportSalesChatListCtrl(Id oppId){
        List<Chat__c> chatList = [SELECT id,Message__c,Opportunity__c,Type__c,CreatedDate,Subject__c,User__r.name FROM Chat__c WHERE Opportunity__c=:oppId AND (Subject__c='Task Assign to Sales Support' OR Subject__c='Task Assign to Sales Rep' OR Subject__c='Task Assign to Sales Rep and Sales Support' OR Subject__c='Message from Customer Success to Sales Support' OR Subject__c='Message from Sales Support to Customer Success' OR Subject__c='Message from Customer Success Manager to Customer Success and Support') Order by CreatedDate Desc];
        system.debug('chatList=>'+chatList);
        if(chatList.size()>0){
            return chatList;
        }else{
            return null;
        }
    }

    // Get Support-Lender chat List
    @AuraEnabled
    public static List<Chat__c> supportLenderChatListCtrl(Id oppId){
        List<Chat__c> chatList = [SELECT id,Message__c,Opportunity__c,Type__c,CreatedDate,Subject__c,User__r.name,User__c FROM Chat__c WHERE Opportunity__c=:oppId AND (Subject__c='Message from Sales Support to Lender' OR Subject__c='Message from Lender to Sales Support') Order by CreatedDate Desc];
        system.debug('chatList=>'+chatList);
        if(chatList.size()>0){
            return chatList;
        }else{
            return null;
        }
    }

    // Get Internal Note List
    @AuraEnabled
    public static List<Chat__c> internalNoteListCtrl(Id oppId){
        List<Chat__c> chatList = [SELECT id,Message__c,Opportunity__c,Type__c,CreatedDate,Subject__c,User__r.name,User__c FROM Chat__c WHERE Opportunity__c=:oppId AND (Subject__c='Internal note created by UW' OR Subject__c='Internal note created by Support') Order by CreatedDate Desc];
        system.debug('chatList=>'+chatList);
        if(chatList.size()>0){
            return chatList;
        }else{
            return null;
        }
    }    

    // Get Support-UW Note List
    @AuraEnabled
    public static List<Chat__c> operationalUWNoteListCtrl(Id oppId){
        List<Chat__c> chatList = [SELECT id,Message__c,Opportunity__c,Type__c,CreatedDate,Subject__c,User__r.name,User__c FROM Chat__c WHERE Opportunity__c=:oppId AND (Subject__c='Operational note created by UW' OR Subject__c='Operational note created by Support' OR Subject__c='Operational note created by Funding Department' OR Subject__c='Operational note created by Customer Success' OR Subject__c='Operational note created by Customer Success Manager' OR Subject__c='Operational note created by Sales Manager') Order by CreatedDate Desc];
        system.debug('chatList=>'+chatList);
        if(chatList.size()>0){
            return chatList;
        }else{
            return null;
        }
    }


    // Get Repayment UW Note List
    @AuraEnabled
    public static List<Chat__c> repaymentNoteListCtrl(Id oppId){
        List<Chat__c> chatList = [SELECT id,Message__c,Opportunity__c,Type__c,CreatedDate,Subject__c,User__r.name,User__c,User__r.id FROM Chat__c WHERE Opportunity__c=:oppId AND (Subject__c='Repayment note created by Funding Department' OR Subject__c='Repayment note created by UW') Order by CreatedDate Desc];
        system.debug('chatList=>'+chatList);
        if(chatList.size()>0){
            return chatList;
        }else{
            return null;
        }
    }

    // Get Repayment UW Note List
    @AuraEnabled
    public static List<Chat__c> legalNoteListCtrl(Id oppId){
        List<Chat__c> chatList = [SELECT id,Message__c,Opportunity__c,Type__c,CreatedDate,Subject__c,User__r.name,User__c,User__r.id FROM Chat__c WHERE Opportunity__c=:oppId AND (Subject__c='Legal note created by Funding Department' OR Subject__c='Legal note created by UW') Order by CreatedDate Desc];
        system.debug('chatList=>'+chatList);
        if(chatList.size()>0){
            return chatList;
        }else{
            return null;
        }
    }

    // Get Sales Representative Note List
    @AuraEnabled
    public static List<Chat__c> salesRepNoteListCtrl(Id oppId){
        List<Chat__c> chatList = [SELECT id,Message__c,Opportunity__c,Type__c,CreatedDate,Subject__c,User__r.name,User__c,User__r.id FROM Chat__c WHERE Opportunity__c=:oppId AND (Subject__c='Representative note created by Sales Agent' OR Subject__c='Representative note created by Sales Manager') Order by CreatedDate Desc];
        system.debug('chatList=>'+chatList);
        if(chatList.size()>0){
            return chatList;
        }else{
            return null;
        }
    }

}