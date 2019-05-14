@isTest
public class SendLoginDetailsController_Test 
{
    @isTest
    public static void testSendLoginDetails1(){
        //Insert Account
        Account objAccount = new Account();
        objAccount.Name = 'Test1';
        objAccount.Access_Code__c = 'daf00c';
        objAccount.Last_Login_Date__c = Date.today();
        insert objAccount;
        
        Test.startTest();
        	SendLoginDetailsController.sendLoginDetails(objAccount.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void testSendLoginDetails2(){
        //Insert Account
        Account objAccount = new Account();
        objAccount.Name = 'Test1';
        objAccount.Access_Code__c = 'daf00c';
        objAccount.Last_Login_Date__c = Date.today();
        objAccount.Email__c = 'test@gmail.com';
        objAccount.Cloufi__Syndicator__c = false;
        insert objAccount;
        
        Test.startTest();
        	SendLoginDetailsController.sendLoginDetails(objAccount.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void testSendLoginDetails3(){
        //Insert Account
        Account objAccount = new Account();
        objAccount.Name = 'Test1';
        objAccount.Access_Code__c = 'daf00c';
        objAccount.Last_Login_Date__c = Date.today();
        objAccount.Email__c = 'test@gmail.com';
        objAccount.Cloufi__Syndicator__c = true;
        objAccount.Syndication_Portal_Access__c = false;
        insert objAccount;
        
        Test.startTest();
        	SendLoginDetailsController.sendLoginDetails(objAccount.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void testSendLoginDetails4(){
        //Insert Account
        Account objAccount = new Account();
        objAccount.Name = 'Test2';
        objAccount.Access_Code__c = 'daf00c';
        objAccount.Last_Login_Date__c = Date.today();
        objAccount.Email__c = 'test@gmail.com';
        objAccount.Cloufi__Syndicator__c = true;
        objAccount.Syndication_Portal_Access__c = true;
        insert objAccount;
        
        Test.startTest();
        	SendLoginDetailsController.sendLoginDetails(objAccount.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void testSendLoginDetails5(){
        //Insert Account
        Account objAccount = new Account();
        objAccount.Name = 'Test2';
        objAccount.Access_Code__c = 'daf00c';
        objAccount.Last_Login_Date__c = Date.today();
        objAccount.Password__c = '12345678';
        objAccount.Email__c = 'test@gmail.com';
        objAccount.Cloufi__Syndicator__c = true;
        objAccount.Syndication_Portal_Access__c = true;
        insert objAccount;
        
        Test.startTest();
        	SendLoginDetailsController.sendLoginDetails(objAccount.Id);
        Test.stopTest();
    }
}