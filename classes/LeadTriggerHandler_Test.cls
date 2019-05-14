@isTest
public class LeadTriggerHandler_Test {
    public static testmethod void executeLeadTriggerHandler(){
        Cloufi__Lead_Application_Field_Mapping__c objleadapplication = new Cloufi__Lead_Application_Field_Mapping__c(name = 'Last Name', Cloufi__Application_Field_API__c = 'Cloufi__Last_Name__c', Cloufi__Lead_Field_API__c = 'LastName');
        insert objleadapplication;
        
        Cloufi__Lead_Application_Field_Mapping__c objleadapplication1 = new Cloufi__Lead_Application_Field_Mapping__c(name = 'Company', Cloufi__Application_Field_API__c = 'Cloufi__Business_DBA_Name__c', Cloufi__Lead_Field_API__c = 'Company');
        insert objleadapplication1;
        
        Cloufi__Lead_Application_Field_Mapping__c objleadapplication2 = new Cloufi__Lead_Application_Field_Mapping__c(name = 'Lead', Cloufi__Application_Field_API__c = 'Cloufi__Lead__c', Cloufi__Lead_Field_API__c = 'Id');
        insert objleadapplication2;
        
        Lead objLead = New Lead(LastName='Test1',Status='New',Company='TestCompany',Average_Monthly_Revenue__c='$10,000 - $24,999',Time_in_Business__c='1-3 Years',Phone='9632587410',country='Canada');
        insert objLead;
    }
    
    public static testmethod void verifyAppChecklist(){
        
        
        Profile objProfile =[SELECT Id FROM Profile WHERE Name='Cash Advance Sales Agent OffShore'];
        User userRecord = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = objProfile.Id, 
                        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser98745@testorg.com');
        insert userRecord;
        
        system.runAs(userRecord){
            Lead objLead = New Lead(LastName='Test1',Status='New',Company='TestCompany',Average_Monthly_Revenue__c='$10,000 - $24,999',Time_in_Business__c='1-3 Years',Phone='9632587410',country='Canada', Email='test@test.com');
            insert objLead;
            
            objLead.Type_Of_Business__c = 'Corporation';
            objLead.Are_you_in_Bankruptcy_Consumer_Proposal__c = true;
            objLead.Current_Payment_Plan__c = 'Yes';
            objLead.Interested_within_2_4_weeks__c = true;
            objLead.Cloufi__Business_DBA_Name__c = 'Test DBA';
            objLead.Time_in_Business__c = '4 months – 1 year';
            objLead.Average_Monthly_Revenue__c = '$10,000 - $24,999';
            objLead.Cloufi__Amount_Requested__c = 200;
            objLead.Purpose_of_Funding__c = 'Setup';
            
            objLead.Is_Application_Checklist_Completed__c = true;
            update objLead;
        }
    }
}