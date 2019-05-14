/******************************************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: ControlSheetUtil
* Test class: ControlSheetDeptLoginController_Test
* Created Date: 11-April-2019
* Description: Utility class for Control Sheet portal
*******************************************************************
*Author             | Date       | Description
*
******************************************************************************************/
public class ControlSheetUtil{
     //Login Logout methods   
    Public static ID LoginUserMethod(String username, String password){
        boolean checkPassword = false;
        Contact objContact = new Contact();
        List<Contact> contactList = [select Name,Id,Access_Code__c,Access_Code_Expiration__c,Password__c,Email 
                                     from Contact where Email!=null and Password__c !=null and Email =: username and Password__c =: password];

        for(Contact objCon:contactList){
            if(password.equals(objCon.Password__c)){
                checkPassword = true;
                objContact = objCon;
                break;
            }
        }
        if(objContact != null && checkPassword){             
            objContact.Access_Code__c = generateRandomNumber();
            objContact.Access_Code_Expiration__c = System.Now(); 
            update objContact;         
            return objContact.Id;
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Username or Password is incorrect.');
            apexpages.addmessage(myMsg);
            return null;
        }
    }
    
    // method to generate rand access codes
    public static String generateRandomNumber(){
        String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        return (String.valueOf(EncodingUtil.convertToHex(hash)).subString(0,6));        
    } 

    // method call on click of forgot password
    public static PageReference ControlSheetUserForgotPassword(Contact objContact, List<Contact> tempUserId){
        if(objContact.Email == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Username/Email Id.');
            apexpages.addmessage(myMsg);
        } 
        string strMail = objContact.Email;
        tempUserId = [select id,Email,Name,Password__c from Contact where Email= :strMail AND Password__c!=null limit 1];

        if (tempUserId.size() > 0) {
            EmailTemplate emailTemplate = [Select id from EmailTemplate where DeveloperName ='Control_sheet_Generate_Password'];
            if(emailTemplate.Id !=null){
                String[] toAddress = new String[] {objContact.Email};
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(toAddress);
                mail.setTargetObjectId(UserInfo.getUserId());
                mail.setWhatId(tempUserId[0].id);
                mail.setTemplateId(emailTemplate.id); 
                mail.setSaveAsActivity(false);
                mail.setTreatTargetObjectAsRecipient(false);
                Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'Reset password link has been sent to your email');
                apexpages.addmessage(myMsg);
            }
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please Contact support to update Email Address');
            apexpages.addmessage(myMsg);
        }
        pageReference pg = new pageReference('/apex/ControlSheetDeptLogin');
        pg.setRedirect(false);
        return pg;
    }
}