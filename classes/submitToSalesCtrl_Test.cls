/*Author | Date       | Description
Neha     | 08/22/2018 | Test class for submitToSalesCtrl
*/
@isTest
public class submitToSalesCtrl_Test {
    
    public static testMethod void testSubmitToSalesCtrl(){
        Id roleId = [select id,name from UserRole where Name =: 'Sales Support' limit 1].Id;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            LastName = 'last',
            Email = 'test@test.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = roleId);
        
        //insert u;
        
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'test';
        oppObj.StageName = 'Application';
        oppobj.CloseDate = system.today();
        oppobj.isPrivate=true;
        oppobj.Cloufi__Monthly_Revenue__c = 10000;
        oppobj.Cloufi__Type_of_Business__c = 'test';
        oppobj.CloufiServicing__Submission_Country__c = 'United States';
        insert oppObj;
        
        Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c();
        objUW.Name = 'Signed Application';
        objUW.Stip_Name__c = 'Signed Application';
        objUW.Cloufi__URL__c = 'www.dropbox.com';
        objUW.Cloufi__Opportunity__c = oppObj.Id;
        insert objUW;
        
        List<Cloufi__UW_Document__c> UWList = new List<Cloufi__UW_Document__c>();
        for(integer i =0;i<4;i++){
            Cloufi__UW_Document__c objUW1 = new Cloufi__UW_Document__c();
            objUW1.Name = 'May Bank Statement';
            objUW1.Stip_Name__c = 'May Bank Statement '+i;
            objUW1.Cloufi__URL__c = 'www.dropbox.com';
            objUW1.Cloufi__Opportunity__c = oppObj.Id;
            UWList.add(objUW1);            
        }  
        for(integer i =0;i<4;i++){
            Cloufi__UW_Document__c objUW2 = new Cloufi__UW_Document__c();
            objUW2.Name = 'May Processing Statement';
            objUW2.Stip_Name__c = 'May Processing Statement '+i;
            objUW2.Cloufi__URL__c = 'www.dropbox.com';
            objUW2.Cloufi__Opportunity__c = oppObj.Id;
            UWList.add(objUW2);            
        }  
        insert UWList;
        
        PageReference myVfPage = Page.submitToSalesSupport;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id',oppObj.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(oppObj);
        submitToSalesCtrl objContrlSheetCtrl  = new submitToSalesCtrl(sc);
        objContrlSheetCtrl.submitToSalesSupport();
    }    
}