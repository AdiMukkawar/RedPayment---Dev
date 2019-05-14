/**
Author | Date       | Description
Aditya | 09/14/2018 | Test class for RequestedDocumentComp
*/
@isTest
public class RequestedDocumentComp_Ctl_Test {
    public static testMethod void executeRequestedDocumentComp(){
         Cloufi__LendingXL_Settings__c objSettings = new Cloufi__LendingXL_Settings__c(Name='Site_URL',Cloufi__Value__c ='test1');
        insert objSettings;
        
        //Insert Opportunity
        Opportunity objOpp = new Opportunity(Name = 'test',StageName = 'Application',CloseDate = system.today());
        insert objOpp;
        
        cloufi__Application__c objApp = new cloufi__Application__c(Missing_Documents_Types__c='Test,Test1',Cloufi__Opportunity__c=objOpp.Id);
        insert objApp;
        
        //Insert UW Document
        Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c(Name='Test',Stip_Name__c='Signed Application',Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application__c=objApp.id);
        insert objUW;
        
        RequestedDocumentComp_Ctl objctrl = new RequestedDocumentComp_Ctl();
        objctrl.getLead();
        objctrl.oppid = objOpp.id;
        objctrl.getMissingDocs();
    }
}