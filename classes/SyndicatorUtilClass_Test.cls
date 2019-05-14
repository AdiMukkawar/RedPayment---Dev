@isTest
public class SyndicatorUtilClass_Test {
    @isTest
    public static void testUtilClass1(){
        //Insert Account
        Account objAccount = new Account();
        objAccount.Name = 'Test2';
        objAccount.Access_Code__c = 'daf00c';
        objAccount.Last_Login_Date__c = Date.today();
        objAccount.Password__c = '12345678';
        objAccount.Email__c = 'test@gmail.com';
        objAccount.Cloufi__Syndicator__c = false;
        objAccount.Syndication_Portal_Access__c = false;
        insert objAccount;
        
        List<Account> accountList = new List<Account>();
        accountList.add(objAccount);
        
        Test.startTest();
            SyndicatorUtilClass.generateRandomNumber();
            SyndicatorUtilClass.LoginUserMethod(objAccount.Email__c, objAccount.Password__c);
            SyndicatorUtilClass.SyndicatorForgotPassword(objAccount, accountList);
        Test.stopTest();
        
    }
    
    @isTest
    public static void testUtilClass2(){
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
        
        List<Account> accountList = new List<Account>();
        accountList.add(objAccount);
        
        Test.startTest();
            SyndicatorUtilClass.generateRandomNumber();
            SyndicatorUtilClass.LoginUserMethod(objAccount.Email__c, objAccount.Password__c);
            SyndicatorUtilClass.SyndicatorForgotPassword(objAccount, accountList);
        Test.stopTest();
        
    }
    
    @isTest
    public static void testUtilClass3(){
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
        
        List<Account> accountList = new List<Account>();
        accountList.add(objAccount);
        
        Test.startTest();
            SyndicatorUtilClass.generateRandomNumber();
            SyndicatorUtilClass.LoginUserMethod(objAccount.Email__c, objAccount.Password__c);
            SyndicatorUtilClass.SyndicatorForgotPassword(objAccount, accountList);
        Test.stopTest();
        
    }
}