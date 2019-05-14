@isTest
public class SyndicatorController_Test 
{
    @isTest
    public static void executeTest1(){
        //Insert Account
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        objAccount.Access_Code__c = 'daf00c';
        objAccount.Password__c = '12345678';
        objAccount.Cloufi__Syndicator__c = true;
        objAccount.Syndication_Portal_Access__c = true;
        objAccount.Email__c = 'email@gmail.com';
        insert objAccount;
        
        // Insert Oppotunity
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.AccountId = objAccount.Id;
        objOpportunity.CloseDate = Date.today();
        objOpportunity.StageName = 'Funded';
        insert objOpportunity;
        
        PageReference pageRef = Page.SyndicatorLoginPage;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(objAccount.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        SyndicatorController objSyndicatorController = new SyndicatorController(sc);
        Test.startTest();
        
        objSyndicatorController.username = 'email1@gmail.com';
        objSyndicatorController.password = '12345678';
        objSyndicatorController.LoginUser();
        
        objSyndicatorController.username = 'email@gmail.com';
        objSyndicatorController.password = '12345678';
        objSyndicatorController.LoginUser();
        Account objAcc = [SELECT id,Access_code__c FROM Account WHERE Id =: objAccount.id];
        objSyndicatorController.accessCode = objAcc.Access_Code__c; 
        objSyndicatorController.NewPassword = '12345678';
        objSyndicatorController.ConfirmNewPassword = '12345678';
        objSyndicatorController.confirmLogin();
        objSyndicatorController.forgetPassword();
        objSyndicatorController.Logout();
        
        Test.stopTest();
    }
    
    @isTest
    public static void executeTest2(){
        //Insert Account
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        objAccount.Last_Login_Date__c = Date.today();
        objAccount.Password__c = '12345678';
        objAccount.Cloufi__Syndicator__c = true;
        objAccount.Syndication_Portal_Access__c = true;
        insert objAccount;
        
        // Insert Oppotunity
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.AccountId = objAccount.Id;
        objOpportunity.CloseDate = Date.today();
        objOpportunity.StageName = 'Funded';
        insert objOpportunity;
        
        PageReference pageRef = Page.SyndicatorLoginPage;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(objAccount.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        SyndicatorController objSyndicatorController = new SyndicatorController(sc);
        Test.startTest();
            objSyndicatorController.username = 'email@gmail.com';
            objSyndicatorController.password = '12345678';
            objSyndicatorController.LoginUser();
            objSyndicatorController.forgetPassword();
        Test.stopTest();
    }
    
    @isTest
    public static void executeTest3(){
        String accessCode = 'daf00c';
        //Insert Account
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        objAccount.Last_Login_Date__c = Date.today();
        objAccount.Password__c = '12345678';
        objAccount.Cloufi__Syndicator__c = true;
        objAccount.Syndication_Portal_Access__c = true;
        insert objAccount;
        
        // Insert Oppotunity
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.AccountId = objAccount.Id;
        objOpportunity.CloseDate = Date.today();
        objOpportunity.StageName = 'Funded';
        insert objOpportunity;
        
        PageReference pageRef = Page.SyndicatorLoginPage;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(objAccount.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        SyndicatorController objSyndicatorController = new SyndicatorController(sc);
        Test.startTest();
            objSyndicatorController.forgetPassword();
        Test.stopTest();
    }
    
    @isTest
    public static void executeTest4(){
        String accessCode = 'daf00c';
        //Insert Account
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        objAccount.Access_Code__c = '123456';
        objAccount.Last_Login_Date__c = Date.today();
        objAccount.Password__c = '12345678';
        objAccount.Cloufi__Syndicator__c = true;
        objAccount.Syndication_Portal_Access__c = true;
        insert objAccount;
        
        // Insert Oppotunity
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.AccountId = objAccount.Id;
        objOpportunity.CloseDate = Date.today();
        objOpportunity.StageName = 'Funded';
        insert objOpportunity;
        
         // Insert payments
        Cloufi__Payments__c objPayment = new Cloufi__Payments__c(Cloufi__Opportunity__c = objOpportunity.Id, Cloufi__Account__c = objAccount.Id,
                                                                 Cloufi__Payment_Type__c = 'Fees',
                                                                 Cloufi__Effective_Date__c = Date.today(), 
                                                                 CloufiServicing__Expected_Settlement_Date__c = Date.today(),
                                                                 Cloufi__Status__c = 'Settled', Cloufi__Payment_Amount__c = 2000);
        insert objPayment;
        
        // Insert Syndication
        CloufiServicing__Syndication__c objSynd = new CloufiServicing__Syndication__c();
        objSynd.CloufiServicing__Opportunity__c = objOpportunity.Id;
        objSynd.CloufiServicing__Syndicating_Account__c = objAccount.Id;
        insert objSynd;
        
        PageReference pageRef = Page.SyndicatorLoginPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(objAccount.Id));
        pageRef.getParameters().put('opportunityId', String.valueOf(objOpportunity.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        SyndicatorController objSyndicatorController = new SyndicatorController(sc);
        Test.startTest();
        	objSyndicatorController.populateValues(objAccount.Id);
            objSyndicatorController.fetchPaymentsForSelectedOpp();
        	
        Test.stopTest();
    }
    
    @isTest
    public static void executeTest5(){
        //Insert Account
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        objAccount.Access_Code__c = 'daf00c';
        //objAccount.Last_Login_Date__c = Date.today();
        objAccount.Password__c = '12345678';
        objAccount.Cloufi__Syndicator__c = true;
        objAccount.Syndication_Portal_Access__c = true;
        objAccount.Email__c = 'email@gmail.com';
        insert objAccount;
        
        // Insert Oppotunity
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.AccountId = objAccount.Id;
        objOpportunity.CloseDate = Date.today();
        objOpportunity.StageName = 'Funded';
        insert objOpportunity;
        
        PageReference pageRef = Page.SyndicatorLoginPage;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(objAccount.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        SyndicatorController objSyndicatorController = new SyndicatorController(sc);
        Test.startTest();
            objSyndicatorController.username = 'email1@gmail.com';
            objSyndicatorController.password = '12345678';
            objSyndicatorController.LoginUser();
            
            objSyndicatorController.username = 'email@gmail.com';
            objSyndicatorController.password = '12345678';
            objSyndicatorController.LoginUser();
            objSyndicatorController.accessCode = '123456';
            objSyndicatorController.NewPassword = '12345678';
            objSyndicatorController.ConfirmNewPassword = '12345678';
            objSyndicatorController.confirmLogin();
        Test.stopTest();
    }
    
    @isTest
    public static void executeTest6(){
        //Insert Account
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        objAccount.Access_Code__c = 'daf00c';
        objAccount.Password__c = '12345678';
        objAccount.Cloufi__Syndicator__c = true;
        objAccount.Syndication_Portal_Access__c = true;
        objAccount.Email__c = 'email@gmail.com';
        insert objAccount;
        
        // Insert Oppotunity
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.AccountId = objAccount.Id;
        objOpportunity.CloseDate = Date.today();
        objOpportunity.StageName = 'Funded';
        insert objOpportunity;
        
        // Insert payments
        Cloufi__Payments__c objPayment = new Cloufi__Payments__c(Cloufi__Opportunity__c = objOpportunity.Id, Cloufi__Account__c = objAccount.Id,
                                                                 Cloufi__Payment_Type__c = 'Fees',
                                                                 Cloufi__Effective_Date__c = Date.today(), 
                                                                 CloufiServicing__Expected_Settlement_Date__c = Date.today(),
                                                                 Cloufi__Status__c = 'Settled', Cloufi__Payment_Amount__c = 2000);
        insert objPayment;
        
        // Insert Syndication
        CloufiServicing__Syndication__c objSynd = new CloufiServicing__Syndication__c();
        objSynd.CloufiServicing__Opportunity__c = objOpportunity.Id;
        objSynd.CloufiServicing__Syndicating_Account__c = objAccount.Id;
        insert objSynd;
        
        PageReference pageRef = Page.SyndicatorLoginPage;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('Id', String.valueOf(objAccount.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        SyndicatorController objSyndicatorController = new SyndicatorController(sc);
        Test.startTest();
        
            objSyndicatorController.username = 'email1@gmail.com';
            objSyndicatorController.password = '12345678';
            objSyndicatorController.LoginUser();
            
            objSyndicatorController.username = 'email@gmail.com';
            objSyndicatorController.password = '12345678';
            objSyndicatorController.LoginUser();
            Account objAcc = [SELECT id,Access_code__c FROM Account WHERE Id =: objAccount.id];
            objSyndicatorController.accessCode = objAcc.Access_Code__c; 
            objSyndicatorController.NewPassword = '12345678';
            objSyndicatorController.ConfirmNewPassword = '12345678';
            objSyndicatorController.confirmLogin();
            objSyndicatorController.forgetPassword();
            objSyndicatorController.Logout();
        
        Test.stopTest();
    }
}