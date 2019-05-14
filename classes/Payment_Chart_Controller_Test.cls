/*****************************************************************
* Author: Techila Global Services Pvt Ltd. 
* Class Name: Payment_Chart_Controller_Test
* Created Date: 26 - 02 - 2019
* Description: Test Class of Payment_Chart_Controller class
*******************************************************************/
/*Author            | Date       | Description
Sheema Dhanraj      | 27-Feb-2019| Test Class of Payment_Chart_Controller class
**/
@isTest
public class Payment_Chart_Controller_Test 
{
    @isTest
    public static void testPayments()
    {
        // Insert opportunity
        Opportunity objOpp = new Opportunity(); 
        objOpp.Name = 'Test Opp';
        objOpp.ForecastCategoryName = 'Pipeline';
        objOpp.CloseDate = System.today();
        objOpp.StageName = 'Qualified';
        insert objOpp;
        
        // Insert Account
        Account objAccount = new Account(Name = 'Test');
        insert objAccount;
        
        // Insert Syndication
        CloufiServicing__Syndication__c objSyndAccount = new CloufiServicing__Syndication__c(CloufiServicing__Status__c = 'Approved',
                                                                                             CloufiServicing__Opportunity__c = objOpp.Id
                                                                                             );
        insert objSyndAccount;
        
        // Insert payments
        Cloufi__Payments__c objPayment = new Cloufi__Payments__c(Cloufi__Opportunity__c = objOpp.Id, Cloufi__Account__c = objAccount.Id,
                                                                 Cloufi__Payment_Type__c = 'Fees',
                                                                 Cloufi__Effective_Date__c = Date.today(), 
                                                                 CloufiServicing__Expected_Settlement_Date__c = Date.today(),
                                                                 Cloufi__Status__c = 'Settled', Cloufi__Payment_Amount__c = 2000);
        insert objPayment;
        
        //Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Status__c='Completed',Sent_for_Contract__c=true,Cloufi__URL__c='www.salesforce.com',Cloufi__Type__c='Stip',Cloufi__Opportunity__c=objOpp.id,stip_Name__c='Test',Name = 'Test UW Docu');
        insert objUWDocument ;
        
        Payment_Chart_Controller.getPaymentRecords(objOpp.Id);
        Payment_Chart_Controller.getSyndication(objOpp.Id);
        Payment_Chart_Controller.getPicklistValues('Cloufi__Status__c');
        Date d = Date.today();
        String effFrom = String.Valueof(d);
        String effTo = String.Valueof(d);
        String settTo = String.Valueof(d);
        String settFrom = String.Valueof(d);
        Payment_Chart_Controller.getFilteredRecords(objOpp.Id, objSyndAccount.Name, 'Fees', true, true,
                                                    effFrom, effTo, settFrom, settTo, 'Settled');
        DevUtil.fetchDocument(objOpp.Id);
        DevUtil.getFieldsOfsObject('opportunity');
    }
}