/*****************************************************************
Test Class Name : CompleteApplicationForm_Ctl_Test 
-------------------------------------------------------------------------------------------
Author           | Project       |    Date       | Description
-------------------------------------------------------------------------------------------
Aditya           | Red Payment   |   07/03/2018  | Test class for CompleteApplicationForm_Ctl
********************************************************************/
@isTest
public class CompleteApplicationForm_Ctl_Test {
    
    public static testmethod void executeCompleteApplicationForm_Ctl(){
        // Insert Application Lead Custom setting
        Cloufi__Lead_Application_Field_Mapping__c objleadapplication = new Cloufi__Lead_Application_Field_Mapping__c(name = 'Last Name', Cloufi__Application_Field_API__c = 'Cloufi__Last_Name__c', Cloufi__Lead_Field_API__c = 'LastName');
        insert objleadapplication;
        
        Cloufi__Lead_Application_Field_Mapping__c objleadapplication1 = new Cloufi__Lead_Application_Field_Mapping__c(name = 'Company', Cloufi__Application_Field_API__c = 'Cloufi__Business_DBA_Name__c', Cloufi__Lead_Field_API__c = 'Company');
        insert objleadapplication1;
        
        Cloufi__Lead_Application_Field_Mapping__c objleadapplication2 = new Cloufi__Lead_Application_Field_Mapping__c(name = 'Lead', Cloufi__Application_Field_API__c = 'Cloufi__Lead__c', Cloufi__Lead_Field_API__c = 'Id');
        insert objleadapplication2;
        
        // Insert Lead
        Lead objLead = New Lead(LastName='Test1',Status='New',Company='TestCompany',Average_Monthly_Revenue__c='$10,000 - $24,999',Time_in_Business__c='1-3 Years',Phone='9632587410',country='Canada');
        insert objLead;
        
        // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(tabnumber__c=2,Cloufi__Lead__c=objLead.id,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com',Type_of_Entity__c='Partnership',Cloufi__Type_Of_Business__c='Services',Do_you_Own_Lease_your_terminals__c='Rent',Owner1Ownership__c=75);
        insert objApp;
        
        // Insert Custom setting
        Cloufi__LendingXL_Settings__c objSett = new Cloufi__LendingXL_Settings__c();
        objSett.Name = 'UW_Documents_List';
        objSett.Cloufi__Value__c = 'Converted';
        insert objSett;
        
        // Insert UW Documents
        List<Cloufi__UW_Document__c> lstUWDocs = new List<Cloufi__UW_Document__c>();
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Cloufi__Application__c = objApp.id,Name = 'Test UW Docu',Cloufi__Type__c = 'Signed Application');
        lstUWDocs.add(objUWDocument);
        
        Cloufi__UW_Document__c objUWDocument1 = new Cloufi__UW_Document__c(Cloufi__Application__c = objApp.id,Name = 'Bank statement',stip_Name__c='Bank statement',Cloufi__Type__c = 'Bank Statement');
        lstUWDocs.add(objUWDocument1);
        
        Cloufi__UW_Document__c objUWDocument2 = new Cloufi__UW_Document__c(Cloufi__Application__c = objApp.id,Name = 'processing statement',stip_Name__c='processing statement',Cloufi__Type__c = 'Bank Statement');
        lstUWDocs.add(objUWDocument2);
        insert lstUWDocs;
        
        Test.startTest();
            PageReference pageRef = Page.CompleteApplicationForm;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objApp);
            ApexPages.currentPage().getParameters().put('Id',objApp.id);
            
            CompleteApplicationForm_Ctl objCtl = new CompleteApplicationForm_Ctl(new ApexPages.StandardController(objApp));
            objCtl.saveApplication();
            objCtl.uploadDocuments();
            objCtl.createDocusignDataPostURL();
        Test.stopTest();
    }
    
    public static testmethod void executeCompleteApplicationForm_CtlTwo(){
        
        // Insert Application Lead Custom setting
        Cloufi__Lead_Application_Field_Mapping__c objleadapplication = new Cloufi__Lead_Application_Field_Mapping__c(name = 'Last Name', Cloufi__Application_Field_API__c = 'Cloufi__Last_Name__c', Cloufi__Lead_Field_API__c = 'LastName');
        insert objleadapplication;
        
        Cloufi__Lead_Application_Field_Mapping__c objleadapplication1 = new Cloufi__Lead_Application_Field_Mapping__c(name = 'Company', Cloufi__Application_Field_API__c = 'Cloufi__Business_DBA_Name__c', Cloufi__Lead_Field_API__c = 'Company');
        insert objleadapplication1;
        
        Cloufi__Lead_Application_Field_Mapping__c objleadapplication2 = new Cloufi__Lead_Application_Field_Mapping__c(name = 'Lead', Cloufi__Application_Field_API__c = 'Cloufi__Lead__c', Cloufi__Lead_Field_API__c = 'Id');
        insert objleadapplication2;
        
        // Insert Lead
        Lead objLead = New Lead(LastName='Test1',Status='New',Company='TestCompany',Average_Monthly_Revenue__c='$10,000 - $24,999',Time_in_Business__c='1-3 Years',Phone='9632587410',country='Canada');
        insert objLead;
        
        // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(tabnumber__c=2,Cloufi__Lead__c=objLead.id,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com',Type_of_Entity__c='Partnership',Cloufi__Type_Of_Business__c='Wholesale',Do_you_Own_Lease_your_terminals__c='Lease',Do_you_usually_close_the_business_during__c='No',Do_You_Owe_Money_To_The_CRA__c='No',Any_open_State_Federal_Tax_Liens_Against__c='No',Any_Lawsuits_or_Judgments_Pending_agains__c='No',Owner1Ownership__c=25);
        insert objApp;
       
        
        Test.startTest();
            PageReference pageRef = Page.CompleteApplicationForm;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objApp);
            ApexPages.currentPage().getParameters().put('Id',objApp.id);            
            CompleteApplicationForm_Ctl objCtl = new CompleteApplicationForm_Ctl(new ApexPages.StandardController(objApp));
            objCtl.saveApplication();
            objCtl.createDocusignDataPostURL();
        Test.stopTest();
    }
    
    public static testmethod void executeDocuSign(){
        // Insert Application Lead Custom setting
        Cloufi__Lead_Application_Field_Mapping__c objleadapplication = new Cloufi__Lead_Application_Field_Mapping__c(name = 'Last Name', Cloufi__Application_Field_API__c = 'Cloufi__Last_Name__c', Cloufi__Lead_Field_API__c = 'LastName');
        insert objleadapplication;
        
        Cloufi__Lead_Application_Field_Mapping__c objleadapplication1 = new Cloufi__Lead_Application_Field_Mapping__c(name = 'Company', Cloufi__Application_Field_API__c = 'Cloufi__Business_DBA_Name__c', Cloufi__Lead_Field_API__c = 'Company');
        insert objleadapplication1;
        
        Cloufi__Lead_Application_Field_Mapping__c objleadapplication2 = new Cloufi__Lead_Application_Field_Mapping__c(name = 'Lead', Cloufi__Application_Field_API__c = 'Cloufi__Lead__c', Cloufi__Lead_Field_API__c = 'Id');
        insert objleadapplication2;
        
        // Insert Lead
        Lead objLead = New Lead(LastName='Test1',Status='New',Company='TestCompany',Average_Monthly_Revenue__c='$10,000 - $24,999',Time_in_Business__c='1-3 Years',Phone='9632587410',country='Canada');
        insert objLead;
        
        //Insert Opportunity
        Opportunity objOpp = new opportunity(Name = 'Test Opportunity',CloseDate = system.today(),StageName = 'Closed Won',Application_Sent_by_Rep__c=true);
        insert objOpp;
        
        // Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Opportunity__c=objOpp.Id,Corporate_Email__c='test@gmail.com',Corporate_Officer_Name__c='Test Officer',Corporate_Officer_Last_Name__c='Test Last officer',tabnumber__c=2,Cloufi__Lead__c=objLead.id,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com',Cloufi__Website__c='www.salesforce.com',Physical_Address__c='Street 1',Physical_City__c='City',Physical_Province__c='Alberta',Physical_Postal_Code__c='21345',Cloufi__Mailing_City__c='M street',MailingState__c='Alberta',Cloufi__Mailing_Zip_Code__c='12345',Business_Cell_Phone_Number__c='9999999999',Fax_Number__c='12345',Province_of_Registration__c='Alberta',Cloufi__Business_Start_Date__c=system.today(),Type_of_Entity__c='Corporation',GST_HST__c='GST',Cloufi__Type_Of_Business__c='Retail',How_will_you_use_the_loan__c='Personal',Product_Service_Sold__c='Test',Owner_1_Address_Street__c='Street 2',Owner_1_City__c='City 1',Owner_1_Province__c='Alberta',Owner_1_Postal_Code__c='123',Owner_Date_Of_Birth__c=system.today(),Social_Security_Number__c='98745',Owner_Home_Phone_Number__c='9999999999',Telephone_Number__c='9999999999',Corporate_Address__c='C Street',Corporate_City__c='C city',Corporate_Province__c='Alberta',Corporate_Postal_Code__c='4125',Corporate_Date_of_Birth__c=system.today(),Corporate_Social_security_Number__c='98745',Corporate_Home_Phone_Number__c='9999999999',Corporate_Cell_Phone_Number__c='9999999999',Own_Lease__c='Own',Years_at_This_Location__c='10',Monthly_Rent_or_Mortgage__c=784512,Date_Lease_Ends__c=system.today(),Business_Landlord_or_Mortgage_Bank__c='Test',Contact_Name_and_or_Account_No__c='Test 1',Office_Mobile_Number__c='9999999999',Current_Processing_Company__c='CPS',Prior_Current_Cash_Advance_Company__c='45123',Current_Balance__c=98745,Do_you_Own_Lease_your_terminals__c='Own',Cloufi__Amount_Requested__c=874512,Do_you_usually_close_the_business_during__c='Yes',Do_You_Owe_Money_To_The_CRA__c='Yes',Any_open_State_Federal_Tax_Liens_Against__c='Yes',Any_Lawsuits_or_Judgments_Pending_agains__c='Yes',Cloufi__Mailing_Street__c='M street',Average_Monthly_Credit_Card_Sales__c='$50,000 - $99,999',Owner1Ownership__c=55,Corporate_Ownership__c=55,No_of_terminals__c='2',Line_of_Credit__c=12345,Corporate_Length_of_Ownership__c='10',Length_of_Ownership__c='10',Details_for_close_the_business__c='Yes',Details_Do_You_Owe_Money_To_The_CRA__c='Details Really',Details_State_Federal_Tax_Liens__c='Dont have',Details_Lawsuits_or_Judgments__c='Nope');
        insert objApp;
       
        Test.startTest();
            PageReference pageRef = Page.CompleteApplicationForm;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objApp);
            ApexPages.currentPage().getParameters().put('Id',objApp.id);            
            CompleteApplicationForm_Ctl objCtl = new CompleteApplicationForm_Ctl(new ApexPages.StandardController(objApp));
            objCtl.createDocusignDataPostURL();
        Test.stopTest();
    }
}