@isTest
public class GeneratePasswordController_Test {
    @isTest
    public static void testGeneratePassword1(){
        Account objAccount = new Account();
        objAccount.Name ='Test';
        objAccount.Password__c = '12345678';
        objAccount.Email__c = 'test@gmail.com';
        insert objAccount;
        
        PageReference pageRef = Page.GeneratePassword;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(objAccount.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        GeneratePasswordController objGeneratePasswordController = new GeneratePasswordController(sc);
        
        Test.startTest();
            objGeneratePasswordController.password = '12345678';
            objGeneratePasswordController.confirmPassword = '12345678';
            objGeneratePasswordController.updatePassword();
        Test.stopTest();
    }
    
    @isTest
    public static void testGeneratePassword2(){
        Account objAccount = new Account();
        objAccount.Name ='Test';
        objAccount.Password__c = '12345678';
        objAccount.Email__c = 'test@gmail.com';
        insert objAccount;
        
        PageReference pageRef = Page.GeneratePassword;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(objAccount.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        GeneratePasswordController objGeneratePasswordController = new GeneratePasswordController(sc);
        Test.startTest();
            objGeneratePasswordController.password = '12345678';
            objGeneratePasswordController.confirmPassword = '123456789';
            objGeneratePasswordController.updatePassword();
        Test.stopTest();
    }
    
    @isTest
    public static void testGeneratePassword3(){
        Account objAccount = new Account();
        objAccount.Name ='Test';
        objAccount.Email__c = 'test@gmail.com';
        insert objAccount;
        
        PageReference pageRef = Page.GeneratePassword;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(objAccount.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        GeneratePasswordController objGeneratePasswordController = new GeneratePasswordController(sc);
        Test.startTest();
            objGeneratePasswordController.password = '';
            objGeneratePasswordController.updatePassword();
        Test.stopTest();
    }
    
    @isTest
    public static void testGeneratePassword4(){
        Account objAccount = new Account();
        objAccount.Name ='Test';
        objAccount.Email__c = 'test@gmail.com';
        insert objAccount;
        
        PageReference pageRef = Page.GeneratePassword;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(objAccount.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        GeneratePasswordController objGeneratePasswordController = new GeneratePasswordController(sc);
        Test.startTest();
            objGeneratePasswordController.password = '12345 7896';
            objGeneratePasswordController.updatePassword();
        Test.stopTest();
    }
    
    @isTest
    public static void testGeneratePassword5(){
        Account objAccount = new Account();
        objAccount.Name ='Test';
        objAccount.Email__c = 'test@gmail.com';
        insert objAccount;
        
        PageReference pageRef = Page.GeneratePassword;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(objAccount.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        GeneratePasswordController objGeneratePasswordController = new GeneratePasswordController(sc);
        Test.startTest();
            objGeneratePasswordController.password = '123456789123123';
            objGeneratePasswordController.updatePassword();
        Test.stopTest();
    }
}