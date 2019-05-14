/*
****************************************************************
* Author: Techila Global Services Pvt Ltd. (Sheema Dhanraj)
* Component Name: GeneratePasswordController
* Created Date: 05/04/2019   
* Description:  To generate new password foe syndiction portal.
******************************************************************
*/
public class GeneratePasswordController {
    
    Public string password {get;set;} 
    Public Account objAccount {get;set;}   
    Public string userid {get;set;}    
    Public list <Account> accountList {get;set;} 
    Public string confirmPassword {get;set;} 
    
    // constructor 
    public GeneratePasswordController(ApexPages.StandardController controller) {
        password = '';
        objAccount = New Account();
        userid = Apexpages.currentPage().getParameters().get('id');
        accountList = [Select a.Id, a.Name, a.Email__c, a.Password__c
                       From Account a Where Id = : userid limit 1];
        if (!accountList.isEmpty()) 
        {
            objAccount = accountList[0];
        }
    }
    
    // method called on submit of new password
    Public pagereference updatePassword() {
        if ((password.length() > 0) && password == confirmPassword) {
            objAccount.password__c = password;
        }
        
        if(password.contains(' ')){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Password can not contain space');
           apexpages.addmessage(myMsg);
           RETURN Null; 
        }
        
        if ((password.length() > 0) && password != confirmPassword) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Confirm password should match...');
            apexpages.addmessage(myMsg);
            return null;
        }
        
        if (password.length() < 8) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Password must contain minimum 8 characters.');
            apexpages.addmessage(myMsg);
            return null;
        }
        
        if (password.length() > 12) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Password must contain maximum 12 characters.');
            apexpages.addmessage(myMsg);
            return null;
        }
        
        if (password.length() == 0) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please Enter Your Password.');
            apexpages.addmessage(myMsg);
            return null;
        }
        upsert objAccount;
        EmailTemplate emailTemplate = [Select id from EmailTemplate where DeveloperName ='Syndication_Portal_Send_Login_Details' LIMIT 1];
        if(emailTemplate.Id !=null && objAccount.id !=null){
            String[] toAddress = new String[] {objAccount.Email__c};
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddress);
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setWhatId(objAccount.id);
            mail.setTemplateId(emailTemplate.id); 
            mail.setSaveAsActivity(false);
            mail.setTreatTargetObjectAsRecipient(false);
            Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        pageReference pg = new pageReference('/apex/SyndicatorLoginPage');
        pg.setRedirect(true);
        return pg;
    }
}