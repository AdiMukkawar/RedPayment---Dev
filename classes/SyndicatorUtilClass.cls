/*
****************************************************************
* Author: Techila Global Services Pvt Ltd. (Sheema Dhanraj)
* Component Name: SyndicatorUtilClass
* Created Date: 05-04-2019
* Description:  Utility class
******************************************************************
*/
public class SyndicatorUtilClass{
    
    //Login method 
    Public static ID LoginUserMethod(String username, String password){ 
        boolean checkPassword = false;
        Account objAccount = new Account();
        List<Account> accountList = [select Name, Id, Access_Code__c, 
                                     Access_Code_Expiration__c, Password__c, Email__c, Cloufi__Syndicator__c, Syndication_Portal_Access__c
                                     from Account where Email__c =: username and passWord__c =: password];
        for(Account objAcc : accountList){
            if(password.equals(objAcc.Password__c)){
                checkPassword = true;
                objAccount = objAcc;
                break;
            }
        }
        
        if(objAccount != null && checkPassword){
            if(objAccount.Cloufi__Syndicator__c != true || objAccount.Syndication_Portal_Access__c != true){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'You dont have access for this portal.');
                apexpages.addmessage(myMsg);
                return null;
            }else{
                objAccount.Access_Code__c = generateRandomNumber();
                objAccount.Access_Code_Expiration__c = System.Now(); 
                update objAccount;         
                return objAccount.Id;
            }
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
    public static PageReference SyndicatorForgotPassword(Account objAccount, List<Account> tempUserId){
        if(objAccount.Email__c == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Username/Email Id.');
            apexpages.addmessage(myMsg);
            
        }
        string accountEmail = objAccount.Email__c;
        tempUserId = [select id, Email__c, Name from Account where Email__c = : accountEmail limit 1];
        
        if (tempUserId.size() > 0) {
            EmailTemplate emailTemplate = [Select id from EmailTemplate where DeveloperName ='Reset_password_for_Syndication_Portal'];
            if(emailTemplate.Id != null){
                String[] toAddress = new String[] {accountEmail};
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
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Email ID does not exist.');
            apexpages.addmessage(myMsg);
        }
        pageReference pg = new pageReference('/apex/SyndicatorLoginPage');
        pg.setRedirect(false);
        return pg;
    }
}