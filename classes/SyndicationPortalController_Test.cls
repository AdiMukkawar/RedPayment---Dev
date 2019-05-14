@isTest
public class SyndicationPortalController_Test 
{
    @isTest
    public static void testSyndicationPortalController()
    {
        // Insert Account
        Account objAccount = new Account();
        objAccount.Name = 'test';
        objAccount.Cloufi__Syndicator__c = true;
        Insert objAccount;
        
        // Insert opportunity
        Opportunity objOpp = new Opportunity(); 
        objOpp.Name = 'Test Opp';
        objOpp.ForecastCategoryName = 'Pipeline';
        objOpp.CloseDate = System.today();
        objOpp.StageName = 'Qualified';
        insert objOpp;
        
        // Insert Syndication
        CloufiServicing__Syndication__c objSyndAccount = new CloufiServicing__Syndication__c(CloufiServicing__Status__c = 'Approved',CloufiServicing__Opportunity__c = objOpp.Id, CloufiServicing__Syndicating_Account__c = objAccount.Id);
        insert objSyndAccount;
        
        PageReference pageRef = Page.SyndicationPortal;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(objAccount.Id));
        SyndicationPortalController sc = new SyndicationPortalController();
        sc.init();
        sc.fetchPaymentsForSelectedOpp();
        sc.populateValues(objAccount.Id);
    }
}