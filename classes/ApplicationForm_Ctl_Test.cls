@isTest
public class ApplicationForm_Ctl_Test {
    public static testmethod void executeApplicationForm_Ctl(){
        Cloufi__Lead_Application_Field_Mapping__c objleadapplication = new Cloufi__Lead_Application_Field_Mapping__c(name = 'Last Name', Cloufi__Application_Field_API__c = 'Cloufi__Last_Name__c', Cloufi__Lead_Field_API__c = 'LastName');
        insert objleadapplication;
        
        Cloufi__Lead_Application_Field_Mapping__c objleadapplication1 = new Cloufi__Lead_Application_Field_Mapping__c(name = 'Company', Cloufi__Application_Field_API__c = 'Cloufi__Business_DBA_Name__c', Cloufi__Lead_Field_API__c = 'Company');
        insert objleadapplication1;
        
        Cloufi__Lead_Application_Field_Mapping__c objleadapplication2 = new Cloufi__Lead_Application_Field_Mapping__c(name = 'Lead', Cloufi__Application_Field_API__c = 'Cloufi__Lead__c', Cloufi__Lead_Field_API__c = 'Id');
        insert objleadapplication2;
        
        Lead objLead = New Lead(LastName='Test1',Status='New',Company='TestCompany',Average_Monthly_Revenue__c='$10,000 - $24,999',Time_in_Business__c='1-3 Years',Phone='9632587410',country='Canada');
        insert objLead;
        
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Amount_Requested__c=1234,Cloufi__Lead__c=objLead.id,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Type_Of_Business__c='Retail',How_will_you_use_the_loan__c='Test',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        
       Test.startTest();
            PageReference pageRef = Page.ApplicationForm;
            ApplicationForm_Ctl objCtl = new ApplicationForm_Ctl(new ApexPages.StandardController(objApp));
            objCtl.objApplication = objApp;
            objCtl.Proceed();
            objCtl.createApplication();
            objCtl.goBack();
            objCtl.submitApplication();
            objCtl.getContactWay();
        
        Test.stopTest();
    }
}