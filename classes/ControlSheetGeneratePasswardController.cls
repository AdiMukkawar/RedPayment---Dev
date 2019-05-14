/******************************************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: ControlSheetGeneratePasswardController
* Test class: ControlSheetDeptLoginController_Test
* Created Date: 11-April-2019
* Description: Apex class for the genearting new password.
*******************************************************************
*Author             | Date       | Description
*
******************************************************************************************/
public class ControlSheetGeneratePasswardController {

    Public string password {get;set;} 
    Public Contact objContact {get;set;}   
    Public string userid {get;set;}    
    Public list <Contact> contactList {get;set;} 
    Public string confirmPassword {get;set;} 
    
    public ControlSheetGeneratePasswardController(ApexPages.StandardController controller) {
        password = '';
        objContact = new Contact();
        userid = Apexpages.currentPage().getParameters().get('id');
        contactList = [Select Id, Name, Email, Password__c From Contact a Where Id = : userid limit 1];                         
        if(!contactList.isEmpty()){
            objContact = contactList[0];
            system.debug('--objContact--' + objContact);
        }
    }
    
    public pagereference saveMethod() {
        system.debug('objContact.Name'+objContact.Name);
        system.debug('password=>'+password);
        system.debug('password.length()=>'+password.length());

        if(password.contains(' ')){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Password can not contain space.');
           apexpages.addmessage(myMsg);
           RETURN Null; 
        }

        if(password.length() < 8 || password.length() > 12) {
            system.debug('Valide password');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Password must be 8 to 12 character long');
            apexpages.addmessage(myMsg);
            RETURN Null;
        }

        if((password.length() > 0) && password == confirmPassword) {
            objContact.password__c = password;
        }
        
        if((password.length() > 0) && password != confirmPassword) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Confirm password should match...');
            apexpages.addmessage(myMsg);
            RETURN Null;
        }

        if (password.length() == 0) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please Enter Your Password');
            apexpages.addmessage(myMsg);
            RETURN Null;
        }
        upsert objContact;
        EmailTemplate emailTemplate = [Select id from EmailTemplate where DeveloperName ='Control_Sheet_Send_Login_Details' LIMIT 1];
        if(emailTemplate.Id !=null && objContact.id !=null){
            String[] toAddress = new String[] {objContact.Email};
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddress);
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setWhatId(objContact.id);
            mail.setTemplateId(emailTemplate.id); 
            mail.setSaveAsActivity(false);
            mail.setTreatTargetObjectAsRecipient(false);
            Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }

        pageReference pg = new pageReference('/apex/ControlSheetDeptLogin');
        pg.setRedirect(true);
        return pg;
    }
}