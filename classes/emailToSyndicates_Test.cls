/*********************************************************************************
Test Class Name : emailToSyndicates_Test 
----------------------------------------------------------------------------------
Author          | Project     |  Date       | Description
----------------------------------------------------------------------------------
Aditya Mukkawar | Red Payment | 12/17/2018  | Test class for emailToSyndicates and emailToSyndicatesPDF_Ctl
**********************************************************************************/
@isTest
public class emailToSyndicates_Test {
    static testMethod void executeEmailToSyndicates(){
        Id RecordTypeIdPayment = Schema.SObjectType.Cloufi__Payments__c.getRecordTypeInfosByName().get('Payment Out').getRecordTypeId();
        //Insert Account
        Account objAcc = new Account(Name='Test',Cloufi__Syndicator__c=true);
        insert objAcc;
        
        //Insert Contact
        Contact objCon = new Contact(FirstName='Test',LastName='Test',Accountid= objAcc.id,email='test@gmail.com');
        insert objCon;
        
        //Insert Opportunity
        Opportunity objOpp = new Opportunity(AccountId=objAcc.Id,Name='Test Opp',StageName='App Sent', CloseDate=system.today());
        insert objOpp;
        
        //Insert Syndicator
        CloufiServicing__Syndication__c objSyn = new CloufiServicing__Syndication__c(CloufiServicing__Opportunity__c=objOpp.id,CloufiServicing__Syndicating_Account__c=objAcc.Id);
        insert objSyn;
        
        Cloufi__Payments__c objPay = new Cloufi__Payments__c(CloufiServicing__Expected_Settlement_Date__c=system.today()-1,CloufiServicing__Management_Fee_Paid__c=100,Cloufi__Opportunity__c=objOpp.id,Cloufi__Payment_Amount__c=1000,recordtypeid=RecordTypeIdPayment,Cloufi__Account__c=objAcc.Id,Cloufi__Status__c='Settled',CloufiServicing__Syndication__c=objSyn.id, Cloufi__Payment_Type__c='Syndication Payment');
        insert objPay;
        
        Test.startTest();
            emailToSyndicates c = new emailToSyndicates(1);
            Database.executeBatch(c);
        
            PageReference pageRef = Page.emailToSyndicatesPDF;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objSyn);
            ApexPages.currentPage().getParameters().put('Id',objSyn.id);
            ApexPages.currentPage().getParameters().put('days','1');
            
            emailToSyndicatesPDF_Ctl objCtl = new emailToSyndicatesPDF_Ctl(new ApexPages.StandardController(objSyn));
            emailToSyndicatesSchedule sh1 = new emailToSyndicatesSchedule();
            String sch = '0 0 23 * * ?'; 
            system.schedule('Test Territory Check', sch, sh1);
        Test.stopTest();
    }
}