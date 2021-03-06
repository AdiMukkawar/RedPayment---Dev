/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: ChatboxForSupportLenderCtrl
* Created Date: 01/23/2019
* Description: Controller for ChatboxForSupportLender component
*******************************************************************/
public class ChatboxForSupportLenderCtrl {
    @AuraEnabled
    public static string showLabelCtrl(Id oppId){
        string msg='';
        //opportunity objOpp = [SELECT id,Internal_Lender__c,OwnerId,Owner.CompanyName,Owner.Sales_Support_Email__c,Owner.Email FROM Opportunity Where id=:oppId];
        User objUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
        system.debug('objUser=>'+objUser);
        if(objUser.Profile.Name == 'Sales Support'){
            msg = 'Send Message to Lender (Internal)';
        }else if(objUser.Profile.Name == 'Under Writing'){          
            msg = 'Send Message to Sales Support';
        }else if(objUser.Profile.Name == 'System Administrator'){
            msg = 'Chat between Sales support and Lender (Internal)';
        }
        return msg;
    }

    @AuraEnabled 
    public static user fetchUser(){
        // query current user information  
        User oUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }

    @AuraEnabled
    public static List<Task> taskListCtrl(Id oppId){
        List<Task> taskList = [SELECT id,Description,Status,whatid,Subject,ActivityDate,Owner.Name,CreatedDate FROM Task WHERE whatid=:oppId AND (subject='Message from Sales Support to Lender' OR subject='Message from Lender to Sales Support') Order by CreatedDate Desc];
        if(taskList.size()>0){
            return taskList;
        }else{
            return null;
        }
    }
    @AuraEnabled
    public static Map<String,String> SendMessageCtrl(Id oppId, String inputmsg){
        Map<String,String> msg = new Map<String,String>();
        opportunity objOpp = [SELECT id,chat__c,Assigned_Underwiter__c,Assigned_Underwiter__r.email,Cloufi__Funder__c,OwnerId,Owner.CompanyName,Owner.Sales_Support_Email__c,Owner.Email FROM Opportunity Where id=:oppId];

        objOpp.chat__c = inputmsg;
        update objOpp;
        system.debug('objOpp.Chat__c=>'+objOpp.Chat__c);
        //msg.put('Success','Message has been sent successfully');
        /*system.debug('objOpp.Chat__c=>'+objOpp.Chat__c);
        String chat = objOpp.Chat__c.substringBetween('<img', 'img>');
        String imgsrc = chat.substringBetween('src="', '"');
        imgsrc = imgsrc.replace('amp;', '');
        PageReference page = new PageReference(imgsrc);
        Blob imgblob = page.getContent();
        system.debug('imgblob=>'+imgblob);
        String strBase64;
        strBase64  = EncodingUtil.base64Encode(imgblob);
        system.debug('strBase64=>'+strBase64);*/
        /*Folder objChatFolder = [SELECT Id FROM Folder WHERE Name = 'Chat images' limit 1];
        system.debug('objChatFolder=>'+objChatFolder);
        Document objDocument = new Document();
        objDocument.FolderId = objChatFolder.Id;
        objDocument.AuthorId = UserInfo.getUserId();
        objDocument.Body = imgblob;
        objDocument.Name = 'Image'+system.now();
        insert objDocument;
        system.debug('objDocument=>'+objDocument);*/

        /*EmailTemplate emailTemp = new EmailTemplate();       
        Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
        List<String> ToEmailIds=new List<String>();
       
        ToEmailIds.add('aditya@techilaservices.com');
        emailTemp = [select id from EmailTemplate where DeveloperName = 'Message_to_Sales_Support_From_Lender'];
        system.debug('emailTemp==>>'+emailTemp);
        system.debug('ToEmailIds==>>'+ToEmailIds);
        emailMsg.setToAddresses(ToEmailIds);
        emailMsg.setTargetObjectId(UserInfo.getUserId());
        emailMsg.setWhatId(objOpp.id);
        emailMsg.setTemplateId(emailTemp.id);
        emailMsg.SaveAsActivity = False;
        emailMsg.setTreatTargetObjectAsRecipient(false);
        if(ToEmailIds.size()>0){
            system.debug('emailMsg==>>'+emailMsg);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMsg});
            msg.put('Success','Message has been sent successfully');             
        }else{
            msg.put('Warning','Email is not available.');
        }
        return msg;*/
        msg.put('Success','Message has been sent successfully');
        return msg;
    }

    /*@AuraEnabled
    public static Map<String,String> SendMessageCtrl(Id oppId, String inputmsg){
        system.debug('oppId==>>'+oppId+'inputmsg==>>'+inputmsg);
        Map<String,String> msg = new Map<String,String>();
        if(inputmsg !=null && !String.isBlank(inputmsg)){
            boolean sendmMailToLender = false;
            boolean sendmMailToSalesSupport = false;
            opportunity objOpp = [SELECT id,Assigned_Underwiter__c,Assigned_Underwiter__r.email,Cloufi__Funder__c,OwnerId,Owner.CompanyName,Owner.Sales_Support_Email__c,Owner.Email FROM Opportunity Where id=:oppId];
            User objUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
        
            Task objTask = new Task();
            objTask.whatid = oppId;
            objTask.Description = inputmsg;
            system.debug('objUser.Profile.Name=>'+objUser.Profile.Name);
            if(objUser.Profile.Name=='Under Writing'){
                objTask.Subject = 'Message from Lender to Sales Support';
                sendmMailToSalesSupport = true;
            }
            if(objUser.Profile.Name == 'Sales Support'){
                objTask.Subject = 'Message from Sales Support to Lender';
                sendmMailToLender = true;
            }
            objTask.ActivityDate = system.today();
            insert objTask;
            system.debug('objTask=>'+objTask);
            EmailTemplate emailTemp = new EmailTemplate();       
            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            List<String> ToEmailIds=new List<String>();
            if(sendmMailToSalesSupport){
                ToEmailIds.add(objOpp.Owner.Sales_Support_Email__c);
                emailTemp = [select id from EmailTemplate where DeveloperName = 'Message_to_Sales_Support_From_Lender'];                
            }
            if(sendmMailToLender){
                if(objOpp.Assigned_Underwiter__c != null && objOpp.Assigned_Underwiter__r.email !=null){
                    ToEmailIds.add(objOpp.Assigned_Underwiter__r.email);
                }else{
                    OrgWideEmailAddress objOWEA = [SELECT Id, Address,DisplayName FROM OrgWideEmailAddress WHERE DisplayName='Internal Lender'];
                    if(objOWEA.Address !=null){
                        ToEmailIds.add(objOWEA.Address);
                    }
                }
                emailTemp = [select id from EmailTemplate where DeveloperName = 'Message_to_Lender_From_Sales_Support'];
            }
            system.debug('emailTemp==>>'+emailTemp);
            system.debug('ToEmailIds==>>'+ToEmailIds);
            emailMsg.setToAddresses(ToEmailIds);
            emailMsg.setTargetObjectId(UserInfo.getUserId());
            emailMsg.setWhatId(objOpp.id);
            emailMsg.setTemplateId(emailTemp.id);
            emailMsg.SaveAsActivity = False;
            emailMsg.setTreatTargetObjectAsRecipient(false);
            if(ToEmailIds.size()>0){
                system.debug('emailMsg==>>'+emailMsg);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMsg});
                msg.put('Success','Message has been sent successfully');             
            }else{
                msg.put('Warning','Email is not available.');
            }
        }else{
            msg.put('Warning','Please Type message.');
        }
        return msg;
    }*/
}