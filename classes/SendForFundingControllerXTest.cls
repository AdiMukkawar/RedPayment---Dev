@isTest
private class SendForFundingControllerXTest {
	
	@isTest static void test_method_one() {
        //Insert Control sheet department account
        Account objAccount = new Account(Name='Funding Department');
        insert objAccount;
        
        //Insert contacts under account
        Contact objContact = new Contact(FirstName='Test',Lastname='TestLast',Email='test@test.com',AccountId=objAccount.Id);
        insert objContact;
        
        //Insert Opportunity
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'test';
        oppObj.StageName = 'Application';
        oppobj.CloseDate = system.today();
        oppobj.isPrivate=true;
        oppobj.Cloufi__Monthly_Revenue__c = 10000;
        oppobj.Cloufi__Type_of_Business__c = 'test';
        oppobj.CloufiServicing__Submission_Country__c = 'United States';
        insert oppObj;
        
        PageReference myVfPage = Page.SendForFunding;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id',oppObj.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(oppObj);
        SendForFundingControllerX objSendForFunding  = new SendForFundingControllerX(sc);
        objSendForFunding.send();
	}
}