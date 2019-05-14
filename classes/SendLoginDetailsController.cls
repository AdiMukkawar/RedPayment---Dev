/*
****************************************************************
* Author: Techila Global Services Pvt Ltd. (Sheema Dhanraj)
* Component Name: SendLoginDetailsController
* Created Date: 05-04-2019
* Description:  Controller of SendLoginDetailsComponent
******************************************************************
*/
public class SendLoginDetailsController 
{
    // Send login details method
    @AuraEnabled
    public static Map<String,String> sendLoginDetails(Id userid){
        Map<String,String> toastMessage = new Map<String,String>();
        String Htmlbody;
        String subject;
        Account objAccount = [Select Id, Name, Access_Code__c, Access_Code_Expiration__c,  
                          		Cloufi__Syndicator__c, Email__c, Password__c, Syndication_Portal_Access__c
                          		FROM Account
                          		Where Id =: userid];
        EmailTemplate emailTemplate;
        if(objAccount.Email__c == null){
            toastMessage.put('Error','Please enter Email Id.');
        }else if(objAccount.Cloufi__Syndicator__c != true){
            toastMessage.put('Warning','Login Details can only be shared for Syndicating Account.');
        }else if(objAccount.Syndication_Portal_Access__c != true){
            toastMessage.put('Warning','Login Details can only be shared for Syndicates who is having Portal Access.');
        }
        else{
            if(objAccount.Password__c == null){
                emailTemplate = [Select id from EmailTemplate where DeveloperName =: 'Syndication_Portal_Generate_Password']; 
            }else{
                emailTemplate = [Select id from EmailTemplate where DeveloperName =: 'Syndication_Portal_Send_Login_Details'];
            }
            String[] toAddress = new String[] {objAccount.Email__c};
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddress);
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setWhatId(objAccount.id);
            mail.setTemplateId(emailTemplate.id); 
            mail.setSaveAsActivity(false);
            mail.setTreatTargetObjectAsRecipient(false);
            Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            toastMessage.put('Success','Email Sent Successfully');
        }
        return toastMessage;
    }
}