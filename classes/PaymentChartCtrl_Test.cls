@isTest
public class PaymentChartCtrl_Test 
{
    @isTest
    public static void testPaymentChartCtrl()
    {
        //Insert opportunity
        Opportunity objOpp = new Opportunity(); 
        objOpp.Name = 'Test Opp';
        objOpp.ForecastCategoryName = 'Pipeline';
        objOpp.CloseDate = System.today();
        objOpp.StageName = 'Qualified';
        insert objOpp;
        
        // Insert Account
        Account objAccount = new Account(Name = 'Test');
        insert objAccount;
        
        // Insert payments
        Cloufi__Payments__c objPayment = new Cloufi__Payments__c(Cloufi__Opportunity__c = objOpp.Id, Cloufi__Account__c = objAccount.Id, Cloufi__Payment_Amount__c = 2000);
        insert objPayment;
        
        PaymentChartCtrl.getAccountList(objOpp.Id);
    }
}