/*
-------------------------------------------------------------------------------------------
Author           | Project       |Date           | Description
-------------------------------------------------------------------------------------------
Aditya           | Red Payment   |08/13/2018     | Test class for MissingDocumentsController
-------------------------------------------------------------------------------------------
*/
@isTest
public class MissingDocumentsController_Test {
	
   public static testmethod void MissingDocumentsTest(){
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Application_Status__c='In Progress',tabnumber__c=2,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',CreditScore__c='700+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;
        
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(stip_Name__c='Test',Cloufi__Application__c = objApp.id,Name = 'Test UW Docu',Cloufi__Type__c = '6 month bank');
        insert objUWDocument ;
        
        Test.startTest();
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objApp);
            ApexPages.currentPage().getParameters().put('Id',objApp.id);
            MissingDocumentsController objCtl = new MissingDocumentsController(new ApexPages.StandardController(objApp));
            
            //objCtl.init();
            objCtl.uploadDocuments();
        Test.stopTest();
    }
}