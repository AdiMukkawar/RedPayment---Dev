/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Component Name: SendControlSheetLinkController
* Created Date: 12-April-2019
* Description:  Controller for SendControlSheetLink lightning component
*******************************************************************/
public class SendControlSheetLinkController{
    // Send login details method
    @AuraEnabled
    public static Map<String,String> sendLoginDetails(Id userid){
        Map<String,String> msg = new Map<String,String>();
        Contact objContact = [Select Id, Name, Access_Code__c, Access_Code_Expiration__c,Email,Password__c,Control_sheet_Portal_Access__c FROM Contact Where Id =: userid];
        EmailTemplate emailTemplate;
        if(objContact.Email == null){
            msg.put('Error','Please enter Email Id.');
        }else if(objContact.Control_sheet_Portal_Access__c != true){
            msg.put('Warning','Login Details can only be shared for user who is having control sheet portal Access.');
        }
        else{
            if(objContact.Password__c == null){
                emailTemplate = [Select id from EmailTemplate where DeveloperName ='Control_sheet_Generate_Password']; 
            }else{
                emailTemplate = [Select id from EmailTemplate where DeveloperName =:'Control_Sheet_Send_Login_Details'];
            }
            String[] toAddress = new String[] {objContact.Email};
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddress);
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setWhatId(objContact.id);
            mail.setTemplateId(emailTemplate.id); 
            mail.setSaveAsActivity(false);
            Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            msg.put('Success','Email Sent Successfully');
        }
        return msg;
    }
}