/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: SalesRepSupportCommuController
* Created Date: 21-September-2018
* Description: 
-------------------------------------------------------------------

*******************************************************************/
public class SalesRepSupportCommuController {
  
    @AuraEnabled
    public static String getUserName() {
      return userinfo.getName();
    }
    
    @AuraEnabled
    public static Double dateTimeUserZone{get{
        TimeZone tz = UserInfo.getTimeZone();
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
    }}
    
  @AuraEnabled
  public static string showLabel(Id oppId){
    string msg='';
    opportunity objOpp = [SELECT id,OwnerId,Owner.CompanyName,Owner.Sales_Support_Email__c,Owner.Email FROM Opportunity Where id=:oppId];
    if(UserInfo.getUserId() == objOpp.OwnerId){
            msg = 'Send Message to Sales Support';
        }else{
            msg = 'Send Message to Sales Rep';
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
  public static List<Task> taskList(Id oppId){
    List<Task> taskList = [SELECT id,Description,Status,whatid,Subject,ActivityDate,Owner.Name,CreatedDate FROM Task WHERE whatid=:oppId AND (subject='Task Assign to Sales Rep' OR subject='Task Assign to Sales Support') Order by CreatedDate Desc];
    if(taskList.size()>0){
      return taskList;
    }else{
      return null;
    }
  }
  
  @AuraEnabled
    public static string SendMessageC(Id oppId, String inputmsg){
        system.debug('oppId==>>'+oppId+'inputmsg==>>'+inputmsg);
        string msg='';
        if(inputmsg !=null && !String.isBlank(inputmsg)){
            boolean sendmMailToSalesRep = false;
            boolean sendmMailToSalesSupport = false;
            opportunity objOpp = [SELECT id,OwnerId,Owner.CompanyName,Owner.Sales_Support_Email__c,Owner.Email, Owner.ManagerId, Owner.Manager.Email FROM Opportunity Where id=:oppId];
            //List<User> userList = [select Id, Name,CompanyName,UserRole.Name,UserRole.id,Profile.name from User WHERE id=:UserInfo.getUserId() LIMIT 1];
            //system.debug('userList=>'+userList);
            Task objTask = new Task();
            objTask.whatid = oppId;
            objTask.Description = inputmsg;
            system.debug('UserInfo.getUserId()=>'+UserInfo.getUserId());
            if(UserInfo.getUserId() == objOpp.OwnerId){
                 objTask.Subject = 'Task Assign to Sales Support';
                 sendmMailToSalesSupport = true;
            }else{
                 objTask.Subject = 'Task Assign to Sales Rep';
                 sendmMailToSalesRep = true;
            }
            //objTask.Status = 'Active';
            objTask.ActivityDate = system.today();
            insert objTask;
            EmailTemplate emailTemp = new EmailTemplate();       
            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            List<String> ToEmailIds=new List<String>();
            if(objOpp.Owner.Sales_Support_Email__c!=null && sendmMailToSalesSupport){
                ToEmailIds.add(objOpp.Owner.Sales_Support_Email__c);
                emailTemp = [select id from EmailTemplate where DeveloperName = 'Message_to_Support_From_Sales_Rep'];
                system.debug('emailTemp==>>'+emailTemp);
            }else if(objOpp.Owner.Email !=null && sendmMailToSalesRep){
                ToEmailIds.add(objOpp.Owner.Email);
                emailTemp = [select id from EmailTemplate where DeveloperName = 'Message_to_Sales_Rep_From_Support'];
                system.debug('emailTemp==>>'+emailTemp);
            }
            //Copy Owner's Manager in all communications
            if(objOpp.Owner.ManagerId!=null && objOpp.Owner.Manager.Email!=null){
                ToEmailIds.add(objOpp.Owner.Manager.Email);
            }
            emailMsg.setToAddresses(ToEmailIds);
            emailMsg.setTargetObjectId(UserInfo.getUserId());
            emailMsg.setWhatId(objOpp.id);
            emailMsg.setTemplateId(emailTemp.id);
            emailMsg.SaveAsActivity = False;
            emailMsg.setTreatTargetObjectAsRecipient(false);
            if(ToEmailIds.size()>0){
                system.debug('emailMsg==>>'+emailMsg);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMsg});
                msg +='Message has been sent successfully';                
            }else{
                msg +='Email is not available';
            }
        }else{
            msg +='Please Type message';
        }
        return msg;
    }
}