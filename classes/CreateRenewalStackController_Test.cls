@isTest
public class CreateRenewalStackController_Test 
{
    @isTest
    public static void testMethod0()
    {
        // Insert Account
        Account objAccount = new Account(Name = 'Test');
        insert objAccount;
        
        // Insert Oppotunity
        Opportunity objOpp = new Opportunity();
        objOpp.AccountId = objAccount.Id;
        objOpp.Name = 'test';
        objOpp.StageName = 'Funded';
        objOpp.CloseDate = System.Today();
        objOpp.Type = 'Renewal';
        insert objOpp;
        
        objOpp = new Opportunity();
        objOpp.AccountId = objAccount.Id;
        objOpp.Name = 'test 1';
        objOpp.StageName = 'Funded';
        objOpp.CloseDate = System.Today();
        objOpp.Type = 'Renewal';
        insert objOpp;

        // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application_Status__c='In Progress',tabnumber__c=2,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',CreditScore__c='700+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;
        
        // Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Cloufi__Opportunity__c = objOpp.id,stip_Name__c='Test',Name = 'Test UW Docu',Cloufi__Type__c = 'Application - Document');
        insert objUWDocument ;
        
        CloufiServicing__Deal_Renewal_Criteria__c objRenewal = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test');
        insert objRenewal;
        
        Test.StartTest();
            ApexPages.currentPage().getParameters().put('id',objOpp.id);
            CreateRenewalStackController objController = new CreateRenewalStackController(new ApexPages.StandardController(objOpp));
            objController.objProspectingOpportunity = objOpp;
            objController.saveRenewal();
        Test.stopTest();
    }

    @isTest
    public static void testMethod1()
    {
        // Insert Account
        Account objAccount = new Account(Name = 'Test');
        insert objAccount;
        
        Opportunity objParentOpp = new Opportunity();
        objParentOpp.AccountId = objAccount.Id;
        objParentOpp.Name = 'test Parent';
        objParentOpp.StageName = 'Funded';
        objParentOpp.CloseDate = System.Today();
        objParentOpp.Type = 'New Customer';
        insert objParentOpp;

        // Insert Oppotunity
        Opportunity objOpp = new Opportunity();
        objOpp.AccountId = objAccount.Id;
        objOpp.Name = 'test';
        objOpp.StageName = 'Funded';
        objOpp.CloseDate = System.Today();
        objOpp.Type = 'Renewal';
        objOpp.CloufiServicing__Parent_Opportunity__c = objParentOpp.Id;
        insert objOpp;
        
        objOpp = new Opportunity();
        objOpp.AccountId = objAccount.Id;
        objOpp.Name = 'test 1';
        objOpp.StageName = 'Funded';
        objOpp.CloseDate = System.Today();
        objOpp.Type = 'Renewal';
        objOpp.CloufiServicing__Parent_Opportunity__c = objParentOpp.Id;
        insert objOpp;

        // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application_Status__c='In Progress',tabnumber__c=2,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',CreditScore__c='700+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;
        
        // Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Cloufi__Opportunity__c = objOpp.id,stip_Name__c='Test',Name = 'Test UW Docu',Cloufi__Type__c = 'Application - Document');
        insert objUWDocument ;
        
        CloufiServicing__Deal_Renewal_Criteria__c objRenewal = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test');
        insert objRenewal;
        
        Test.StartTest();
        	ApexPages.currentPage().getParameters().put('id',objOpp.id);
        	CreateRenewalStackController objController = new CreateRenewalStackController(new ApexPages.StandardController(objOpp));
            objController.objProspectingOpportunity = objOpp;
        	objController.saveRenewal();
        Test.stopTest();
    }
    @isTest
    public static void testMethod2()
    {
        // Insert Account
        Account objAccount = new Account(Name = 'Test');
        insert objAccount;
        
        // Insert Oppotunity
        Opportunity objOpp = new Opportunity();
        objOpp.AccountId = objAccount.Id;
        objOpp.Name = 'test';
        objOpp.Amount = 10000;
        objOpp.StageName = 'Funded';
        objOpp.CloseDate = System.Today();
        objOpp.Cloufi__Payment_Processor__c = 'MAC TD';
        insert objOpp;
        
        // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application_Status__c='In Progress',tabnumber__c=2,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',CreditScore__c='700+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;
        
        // Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Cloufi__Opportunity__c = objOpp.id,stip_Name__c='Test',/*Cloufi__Application__c = objApp.id,*/Name = 'Test UW Docu',Cloufi__Type__c = 'Application - Document');
        insert objUWDocument ;
        
        // Insert Custom setting
        CloufiServicing__Deal_Renewal_Criteria__c objRenewal = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test', CloufiServicing__Payment_Processor__c = 'MAC TD', CloufiServicing__Field__c = 'Amount', CloufiServicing__Field_Type__c = 'Number',CloufiServicing__Criteria__c='equals to',CloufiServicing__Value__c='10');
        insert objRenewal;
        
        // Insert Custom setting
        //CloufiServicing__Deal_Renewal_Criteria__c objRenewal1 = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test1', CloufiServicing__Payment_Processor__c = 'MAC TD', CloufiServicing__Field__c = 'Amount', CloufiServicing__Field_Type__c = 'Equals To');
        //insert objRenewal1;
        
        Test.StartTest();
        	ApexPages.currentPage().getParameters().put('id',objOpp.id);
        	CreateRenewalStackController objController = new CreateRenewalStackController(new ApexPages.StandardController(objOpp));
        	objController.saveRenewal();
        Test.stopTest();
    }
    @isTest
    public static void testMethod3()
    {
        // Insert Account
        Account objAccount = new Account(Name = 'Test');
        insert objAccount;
        
        // Insert Oppotunity
        Opportunity objOpp = new Opportunity();
        objOpp.AccountId = objAccount.Id;
        objOpp.Name = 'test';
        objOpp.Amount = 5;
        objOpp.StageName = 'Funded';
        objOpp.CloseDate = System.Today();
        objOpp.Cloufi__Payment_Processor__c = 'MAC TD';
        insert objOpp;
        
        // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application_Status__c='In Progress',tabnumber__c=2,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',CreditScore__c='700+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;
        
        // Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Cloufi__Opportunity__c = objOpp.id,stip_Name__c='Test',/*Cloufi__Application__c = objApp.id,*/Name = 'Test UW Docu',Cloufi__Type__c = 'Application - Document');
        insert objUWDocument ;
        
        // Insert Custom setting
        CloufiServicing__Deal_Renewal_Criteria__c objRenewal = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test', CloufiServicing__Payment_Processor__c = 'MAC TD', CloufiServicing__Field__c = 'Amount', CloufiServicing__Field_Type__c = 'Number',CloufiServicing__Criteria__c='greater than',CloufiServicing__Value__c='10');
        insert objRenewal;
        
        // Insert Custom setting
        //CloufiServicing__Deal_Renewal_Criteria__c objRenewal1 = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test1', CloufiServicing__Payment_Processor__c = 'MAC TD', CloufiServicing__Field__c = 'Amount', CloufiServicing__Field_Type__c = 'Equals To');
        //insert objRenewal1;
        
        Test.StartTest();
        	ApexPages.currentPage().getParameters().put('id',objOpp.id);
        	CreateRenewalStackController objController = new CreateRenewalStackController(new ApexPages.StandardController(objOpp));
        	objController.saveRenewal();
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod4()
    {
        // Insert Account
        Account objAccount = new Account(Name = 'Test');
        insert objAccount;
        
        // Insert Oppotunity
        Opportunity objOpp = new Opportunity();
        objOpp.AccountId = objAccount.Id;
        objOpp.Name = 'test';
        objOpp.Amount = 1000;
        objOpp.StageName = 'Funded';
        objOpp.CloseDate = System.Today();
        objOpp.Cloufi__Payment_Processor__c = 'MAC TD';
        insert objOpp;
        
        // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application_Status__c='In Progress',tabnumber__c=2,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',CreditScore__c='700+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;
        
        // Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Cloufi__Opportunity__c = objOpp.id,stip_Name__c='Test',/*Cloufi__Application__c = objApp.id,*/Name = 'Test UW Docu',Cloufi__Type__c = 'Application - Document');
        insert objUWDocument ;
        
        // Insert Custom setting
        CloufiServicing__Deal_Renewal_Criteria__c objRenewal = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test', CloufiServicing__Payment_Processor__c = 'MAC TD', CloufiServicing__Field__c = 'Amount', CloufiServicing__Field_Type__c = 'Number',CloufiServicing__Criteria__c='less than',CloufiServicing__Value__c='10');
        insert objRenewal;
        
        // Insert Custom setting
        //CloufiServicing__Deal_Renewal_Criteria__c objRenewal1 = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test1', CloufiServicing__Payment_Processor__c = 'MAC TD', CloufiServicing__Field__c = 'Amount', CloufiServicing__Field_Type__c = 'Equals To');
        //insert objRenewal1;
        
        Test.StartTest();
        	ApexPages.currentPage().getParameters().put('id',objOpp.id);
        	CreateRenewalStackController objController = new CreateRenewalStackController(new ApexPages.StandardController(objOpp));
        	objController.saveRenewal();
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod5()
    {
        // Insert Account
        Account objAccount = new Account(Name = 'Test');
        insert objAccount;
        
        // Insert Oppotunity
        Opportunity objOpp = new Opportunity();
        objOpp.AccountId = objAccount.Id;
        objOpp.Name = 'test';
        objOpp.Amount = 1;
        objOpp.StageName = 'Funded';
        objOpp.CloseDate = System.Today();
        objOpp.Cloufi__Payment_Processor__c = 'MAC TD';
        insert objOpp;
        
        // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application_Status__c='In Progress',tabnumber__c=2,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',CreditScore__c='700+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;
        
        // Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Cloufi__Opportunity__c = objOpp.id,stip_Name__c='Test',/*Cloufi__Application__c = objApp.id,*/Name = 'Test UW Docu',Cloufi__Type__c = 'Application - Document');
        insert objUWDocument ;
        
        // Insert Custom setting
        CloufiServicing__Deal_Renewal_Criteria__c objRenewal = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test', CloufiServicing__Payment_Processor__c = 'MAC TD', CloufiServicing__Field__c = 'Amount', CloufiServicing__Field_Type__c = 'text',CloufiServicing__Criteria__c='equals to',CloufiServicing__Value__c='10');
        insert objRenewal;
        
        // Insert Custom setting
        //CloufiServicing__Deal_Renewal_Criteria__c objRenewal1 = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test1', CloufiServicing__Payment_Processor__c = 'MAC TD', CloufiServicing__Field__c = 'Amount', CloufiServicing__Field_Type__c = 'Equals To');
        //insert objRenewal1;
        
        Test.StartTest();
        	ApexPages.currentPage().getParameters().put('id',objOpp.id);
        	CreateRenewalStackController objController = new CreateRenewalStackController(new ApexPages.StandardController(objOpp));
        	objController.saveRenewal();
        Test.stopTest();
    }
    
     @isTest
    public static void testMethod6()
    {
        // Insert Account
        Account objAccount = new Account(Name = 'Test');
        insert objAccount;
        
        // Insert Oppotunity
        Opportunity objOpp = new Opportunity();
        objOpp.AccountId = objAccount.Id;
        objOpp.Name = 'test';
        objOpp.Amount = 1;
        objOpp.StageName = 'Funded';
        objOpp.CloseDate = System.Today();
        objOpp.Cloufi__Payment_Processor__c = 'MAC TD';
        insert objOpp;
        
        // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application_Status__c='In Progress',tabnumber__c=2,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',CreditScore__c='700+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;
        
        // Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Cloufi__Opportunity__c = objOpp.id,stip_Name__c='Test',/*Cloufi__Application__c = objApp.id,*/Name = 'Test UW Docu',Cloufi__Type__c = 'Application - Document');
        insert objUWDocument ;
        
        // Insert Custom setting
        CloufiServicing__Deal_Renewal_Criteria__c objRenewal = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test', CloufiServicing__Payment_Processor__c = 'MAC TD', CloufiServicing__Field__c = 'Amount', CloufiServicing__Field_Type__c = 'text',CloufiServicing__Criteria__c='not equals to',CloufiServicing__Value__c='10');
        insert objRenewal;
        
        // Insert Custom setting
        //CloufiServicing__Deal_Renewal_Criteria__c objRenewal1 = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test1', CloufiServicing__Payment_Processor__c = 'MAC TD', CloufiServicing__Field__c = 'Amount', CloufiServicing__Field_Type__c = 'Equals To');
        //insert objRenewal1;
        
        Test.StartTest();
        	ApexPages.currentPage().getParameters().put('id',objOpp.id);
        	CreateRenewalStackController objController = new CreateRenewalStackController(new ApexPages.StandardController(objOpp));
        	objController.saveRenewal();
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod7()
    {
        // Insert Account
        Account objAccount = new Account(Name = 'Test');
        insert objAccount;
        
        // Insert Oppotunity
        Opportunity objOpp = new Opportunity();
        objOpp.AccountId = objAccount.Id;
        objOpp.Name = 'test';
        objOpp.Amount = 1;
        objOpp.StageName = 'Funded';
        objOpp.CloseDate = System.Today();
        objOpp.Cloufi__Payment_Processor__c = 'MAC TD';
        insert objOpp;
        
        // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application_Status__c='In Progress',tabnumber__c=2,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',CreditScore__c='700+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;
        
        // Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Cloufi__Opportunity__c = objOpp.id,stip_Name__c='Test',/*Cloufi__Application__c = objApp.id,*/Name = 'Test UW Docu',Cloufi__Type__c = 'Application - Document');
        insert objUWDocument ;
        
        // Insert Custom setting
        CloufiServicing__Deal_Renewal_Criteria__c objRenewal = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test', CloufiServicing__Payment_Processor__c = 'MAC TD', CloufiServicing__Field__c = 'CloseDate', CloufiServicing__Field_Type__c = 'date',CloufiServicing__Criteria__c='equals to',CloufiServicing__Value__c='10', CloufiServicing__Date_Value__c = Date.newInstance(2019, 03, 10));
        insert objRenewal;
        
        // Insert Custom setting
        //CloufiServicing__Deal_Renewal_Criteria__c objRenewal1 = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test1', CloufiServicing__Payment_Processor__c = 'MAC TD', CloufiServicing__Field__c = 'Amount', CloufiServicing__Field_Type__c = 'Equals To');
        //insert objRenewal1;
        
        Test.StartTest();
        	ApexPages.currentPage().getParameters().put('id',objOpp.id);
        	CreateRenewalStackController objController = new CreateRenewalStackController(new ApexPages.StandardController(objOpp));
        	objController.saveRenewal();
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod8()
    {
        // Insert Account
        Account objAccount = new Account(Name = 'Test');
        insert objAccount;
        
        // Insert Oppotunity
        Opportunity objOpp = new Opportunity();
        objOpp.AccountId = objAccount.Id;
        objOpp.Name = 'test';
        objOpp.Amount = 1;
        objOpp.StageName = 'Funded';
        objOpp.CloseDate = System.Today();
        objOpp.Cloufi__Payment_Processor__c = 'MAC TD';
        insert objOpp;
        
        // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application_Status__c='In Progress',tabnumber__c=2,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',CreditScore__c='700+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;
        
        // Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Cloufi__Opportunity__c = objOpp.id,stip_Name__c='Test',/*Cloufi__Application__c = objApp.id,*/Name = 'Test UW Docu',Cloufi__Type__c = 'Application - Document');
        insert objUWDocument ;
        
        // Insert Custom setting
        CloufiServicing__Deal_Renewal_Criteria__c objRenewal = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test', CloufiServicing__Payment_Processor__c = 'MAC TD', CloufiServicing__Field__c = 'CloseDate', CloufiServicing__Field_Type__c = 'date',CloufiServicing__Criteria__c='greater than',CloufiServicing__Value__c='10', CloufiServicing__Date_Value__c = Date.newInstance(2019, 03, 20));
        insert objRenewal;
        
        // Insert Custom setting
        //CloufiServicing__Deal_Renewal_Criteria__c objRenewal1 = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test1', CloufiServicing__Payment_Processor__c = 'MAC TD', CloufiServicing__Field__c = 'Amount', CloufiServicing__Field_Type__c = 'Equals To');
        //insert objRenewal1;
        
        Test.StartTest();
        	ApexPages.currentPage().getParameters().put('id',objOpp.id);
        	CreateRenewalStackController objController = new CreateRenewalStackController(new ApexPages.StandardController(objOpp));
        	objController.saveRenewal();
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod9()
    {
        // Insert Account
        Account objAccount = new Account(Name = 'Test');
        insert objAccount;
        
        // Insert Oppotunity
        Opportunity objOpp = new Opportunity();
        objOpp.AccountId = objAccount.Id;
        objOpp.Name = 'test';
        objOpp.Amount = 1;
        objOpp.StageName = 'Funded';
        objOpp.CloseDate = System.Today();
        objOpp.Cloufi__Payment_Processor__c = 'MAC TD';
        insert objOpp;
        
        // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application_Status__c='In Progress',tabnumber__c=2,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',CreditScore__c='700+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;
        
        // Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Cloufi__Opportunity__c = objOpp.id,stip_Name__c='Test',/*Cloufi__Application__c = objApp.id,*/Name = 'Test UW Docu',Cloufi__Type__c = 'Application - Document');
        insert objUWDocument ;
        
        // Insert Custom setting
        CloufiServicing__Deal_Renewal_Criteria__c objRenewal = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test', CloufiServicing__Payment_Processor__c = 'MAC TD', CloufiServicing__Field__c = 'CloseDate', CloufiServicing__Field_Type__c = 'date',CloufiServicing__Criteria__c='less than',CloufiServicing__Value__c='10', CloufiServicing__Date_Value__c = Date.newInstance(2019, 03, 10));
        insert objRenewal;
        
        // Insert Custom setting
        //CloufiServicing__Deal_Renewal_Criteria__c objRenewal1 = new CloufiServicing__Deal_Renewal_Criteria__c(Name = 'Test1', CloufiServicing__Payment_Processor__c = 'MAC TD', CloufiServicing__Field__c = 'Amount', CloufiServicing__Field_Type__c = 'Equals To');
        //insert objRenewal1;
        
        Test.StartTest();
        	ApexPages.currentPage().getParameters().put('id',objOpp.id);
        	CreateRenewalStackController objController = new CreateRenewalStackController(new ApexPages.StandardController(objOpp));
        	objController.saveRenewal();
        Test.stopTest();
    }
}