/**
Author | Date       | Description
Anuradha   | 04/29/2019 | Test class for RenewalPayoffPercentageCalculationBatch 
**/

@isTest(seeAllData = false)
public class RenewalPayoffPercCalculationBatch_Test {
    public static testmethod void renewalPayOffTest_1(){
        
        Account acc=new Account();
        acc.Name='Test';
        insert acc;
        system.assertNotequals(acc.id,null);
        
        Contact objContact = new Contact();
        objContact.LastName = 'Testing';
        objContact.Email = 'test@gmail.com';
        insert objContact;        
        
        Opportunity ObjLoan = new Opportunity();
        ObjLoan.Name = 'test';
        ObjLoan.CloufiServicing__Funding_Date__c = System.Today();
        ObjLoan.StageName = 'Funded';
        ObjLoan.amount = 100;
        ObjLoan.Cloufi__Payback_Amount__c= 100;   
        ObjLoan.Cloufi__Daily_Payback_Amt__c= 50;
        ObjLoan.Cloufi__Factor_Rate__c= 1.2;
        ObjLoan.Cloufi__Loan_Term__c= 12;        
        ObjLoan.Cloufi__Percentage_Of_Gross__c= 100;
        ObjLoan.Cloufi__Borrower_Email__c = 'test@gmail.com';
        ObjLoan.CloseDate =System.Today();
        ObjLoan.CloufiServicing__Payment_Installment__c = 75;
        ObjLoan.Payoff_Percentage_Time__c  = 1.0;
        insert ObjLoan;
        System.assertNotEquals(ObjLoan.id,null);
        
        Test.startTest();
        RenewalPayoffPercCalcSchedular sh1 = new RenewalPayoffPercCalcSchedular();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test Renewal PayOff Calc', sch, sh1); 
        Test.stopTest();
        
        
    }
}