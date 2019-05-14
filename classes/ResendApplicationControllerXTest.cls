@isTest
private class ResendApplicationControllerXTest {
    
    @isTest static void test_method_one() {
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test Opportunity';
        objOpportunity.CloseDate = System.today();
        objOpportunity.StageName = 'App Sent';
        objOpportunity.Cloufi__Email_Address__c = 'test@test.com';
        insert objOpportunity;
        
        Cloufi__Application__c objApp = new Cloufi__Application__c();
        objApp.Cloufi__Opportunity__c = objOpportunity.Id;
        insert objApp;
        
        PageReference myVfPage = Page.ResendApplication;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpportunity);
        ResendApplicationControllerX objContrlSheetCtrl  = new ResendApplicationControllerX(sc);
        
        objContrlSheetCtrl.sendAppLink = true;
        objContrlSheetCtrl.sendPDF = false;
        objContrlSheetCtrl.sendMobile  = false;
        objContrlSheetCtrl.sendEmailToMerchant();
        
    }
    
    @isTest static void test_method_two() {
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test Opportunity';
        objOpportunity.CloseDate = System.today();
        objOpportunity.StageName = 'Prospecting';
        objOpportunity.Cloufi__Email_Address__c = 'test@test.com';
        insert objOpportunity;
        
        Cloufi__Application__c objApp = new Cloufi__Application__c();
        objApp.Cloufi__Opportunity__c = objOpportunity.Id;
        insert objApp;
        
        PageReference myVfPage = Page.ResendApplication;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpportunity);
        ResendApplicationControllerX obj  = new ResendApplicationControllerX(sc);
        obj.sendAppLink = true;
        obj.sendPDF = true;
        obj.sendMobile  = false;
        
        obj.sendEmailToMerchant();
        
    }
    
    @isTest static void test_method_three() {
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test Opportunity';
        objOpportunity.CloseDate = System.today();
        objOpportunity.StageName = 'Revived';
        objOpportunity.Cloufi__Email_Address__c = 'test@test.com';
        insert objOpportunity;
        
        Cloufi__Application__c objApp = new Cloufi__Application__c();
        objApp.Cloufi__Opportunity__c = objOpportunity.Id;
        insert objApp;
        
        PageReference myVfPage = Page.ResendApplication;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpportunity);
        ResendApplicationControllerX obj  = new ResendApplicationControllerX(sc);
        obj.sendAppLink = false;
        obj.sendPDF = true;
        obj.sendMobile  = false;
        
        obj.sendEmailToMerchant();
        
    }
    
    @isTest static void test_method_four() {
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test Opportunity';
        objOpportunity.CloseDate = System.today();
        objOpportunity.StageName = 'App In Missing Info';
        objOpportunity.Cloufi__Email_Address__c = 'test@test.com';
        insert objOpportunity;
        
        Cloufi__UW_Document__c uwRecord = new Cloufi__UW_Document__c();
        uwRecord.Stip_Name__c = 'Signed Application';
        uwRecord.Cloufi__Opportunity__c = objOpportunity.Id;
        insert uwRecord;
        
        Cloufi__Application__c objApp = new Cloufi__Application__c();
        objApp.Cloufi__Opportunity__c = objOpportunity.Id;
        insert objApp;
        
        PageReference myVfPage = Page.ResendApplication;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpportunity);
        ResendApplicationControllerX obj  = new ResendApplicationControllerX(sc);
        obj.objApp = new Cloufi__Application__c();
        obj.formatedNumber = '7066215925';
        obj.sendAppLink = false;
        obj.sendPDF = false;
        obj.sendMobile  = true;
        
        obj.sendEmailToMerchant();
        
    }
    
    
}