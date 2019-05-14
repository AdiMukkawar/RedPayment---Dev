/******************************************************************************
Author             | Date           | Description
Aditya Mukkawar    | 15-April-2019  | Test class for SendControlSheetLinkController
**********************************************************************************/

@isTest
public class SendControlSheetLinkController_Test{

    public static testMethod void executeControlSheetPortal(){

        // Inserting Account
        Account objAccount = new Account(Name='Test Account');
        insert objAccount;

        // Inserting Contact
        Contact objContact=new Contact(AccountId=objAccount.Id,FirstName='fname',LastName = 'lname'); 
        insert objContact;
       
        Test.startTest();
            SendControlSheetLinkController.sendLoginDetails(objContact.id);

            objContact.Email = 'email@gmail.com';
            update objContact;
            SendControlSheetLinkController.sendLoginDetails(objContact.id);

            objContact.Control_sheet_Portal_Access__c=true;
            update objContact;
            SendControlSheetLinkController.sendLoginDetails(objContact.id);
            
            objContact.password__c='12345678';
            update objContact;
            SendControlSheetLinkController.sendLoginDetails(objContact.id);
            
        Test.stopTest();

    }

}