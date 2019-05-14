/**
Author            | Date       | Description
Aditya Mukkawar   | 03/15/2019 | Test class for LeadNoteboxController
**/
@isTest
public class LeadNoteboxController_Test {
    public static testMethod void LeadNoteboxControllerTest(){
        // Insert Lead
        Lead objLead = new Lead(Company = 'Test Lead',LastName = 'Lead Last Name',Status = 'Open');
        insert objLead;
        
        Test.startTest();
            LeadNoteboxController.fetchUser();
            LeadNoteboxController.createSalesRepNoteCtrl(objLead.id,'<p>Test</p>');
            LeadNoteboxController.salesRepNoteListCtrl(objLead.id);
        Test.stopTest();
    }
}