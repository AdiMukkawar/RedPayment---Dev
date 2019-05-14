@isTest
public class ApplicationTrigger_Test {
    public static testmethod void executeApplicationForm_Ctl(){
        Lead objLead = New Lead(LastName='Test1',Status='New',Company='TestCompany',Average_Monthly_Revenue__c='$10,000 - $24,999',Time_in_Business__c='1-3 Years',Phone='9632587410',country='Canada');
        insert objLead;
        
        Opportunity objOpp = new Opportunity(Name='Test Opp',StageName='App Sent', CloseDate=system.today());
        insert objOpp;
        
        Cloufi__Application__c objApp = new Cloufi__Application__c(cloufi__Opportunity__c =objOpp.id,Cloufi__Lead__c=objLead.id,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;
        
        Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c(Name='Test',Stip_Name__c='Contract',Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application__c=objApp.id);
        insert objUW;
        
        objApp.Cloufi__Business_DBA_Name__c = 'Update';
        update objApp;
        
        objOpp.StageName = 'UW';
        update objOpp;
    }
}