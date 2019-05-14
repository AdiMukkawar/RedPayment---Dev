/**
Author | Date       | Description
Neha   | 08/27/2018 | Test class for SendToControlSheetDeptControllerX
*/

@isTest
public class SendToControlSheetDeptControllerX_Test {
    
    public static testMethod void ontrolSheetDeptControllerX(){
        //Insert Control sheet department account
        Account objAccount = new Account(Name='Control Sheet Department');
        insert objAccount;
        
        //Insert contacts under account
        Contact objContact = new Contact(FirstName='Test',Lastname='TestLast',Email='test@test.com',AccountId=objAccount.Id);
        insert objContact;
        
        //Insert Opportunity
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'test';
        oppObj.StageName = 'Application';
        oppobj.CloseDate = system.today();
        oppobj.isPrivate=true;
        oppobj.Cloufi__Monthly_Revenue__c = 10000;
        oppobj.Cloufi__Type_of_Business__c = 'test';
        oppobj.CloufiServicing__Submission_Country__c = 'United States';
        oppObj.AccountId = objAccount.id;
        insert oppObj;

        List<Cloufi__UW_Document__c> uwDocList = new List<Cloufi__UW_Document__c>();

        Cloufi__UW_Document__c objStip2 = new Cloufi__UW_Document__c(Cloufi__Opportunity__c = oppObj.id,name = 'March-2019 Bank Statement',Stip_Name__c = 'March-2019 Bank Statement',Cloufi__Type__c = 'Bank Statement',Cloufi__URL__c ='https://www.dropbox.com/s/6pvxabx1plkjvx6/Control%20Sheet%205%20O9s23Zxlpg.jpg?dl=1',Status__c = 'Completed');
        uwDocList.add(objStip2);

        Cloufi__UW_Document__c objStip3 = new Cloufi__UW_Document__c(Cloufi__Opportunity__c = oppObj.id,name = 'February-2019 Bank Statement',Stip_Name__c = 'February-2019 Bank Statement',Cloufi__Type__c = 'Bank Statement',Cloufi__URL__c ='https://www.dropbox.com/s/6pvxabx1plkjvx6/Control%20Sheet%205%20O9s23Zxlpg.jpg?dl=1',Status__c = 'Completed');
        uwDocList.add(ObjStip3);

        Cloufi__UW_Document__c objStip4 = new Cloufi__UW_Document__c(Cloufi__Opportunity__c = oppObj.id,name = 'January-2019 Bank Statement',Stip_Name__c = 'January-2019 Bank Statement',Cloufi__Type__c = 'Bank Statement',Cloufi__URL__c ='https://www.dropbox.com/s/6pvxabx1plkjvx6/Control%20Sheet%205%20O9s23Zxlpg.jpg?dl=1',Status__c = 'Completed');
        uwDocList.add(objStip4);

        Cloufi__UW_Document__c objStip5 = new Cloufi__UW_Document__c(Cloufi__Opportunity__c = oppObj.id,name = 'December-2018 Bank Statement',Stip_Name__c = 'December-2018 Bank Statement',Cloufi__Type__c = 'Bank Statement',Cloufi__URL__c ='https://www.dropbox.com/s/6pvxabx1plkjvx6/Control%20Sheet%205%20O9s23Zxlpg.jpg?dl=1',Status__c = 'Completed');
        uwDocList.add(objStip5);
        insert uwDocList;
        
        PageReference myVfPage = Page.SendToControlSheetDept;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id',oppObj.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(oppObj);
        SendToControlSheetDeptControllerX objContrlSheetCtrl  = new SendToControlSheetDeptControllerX(sc);
        objContrlSheetCtrl.Send();
    }
}