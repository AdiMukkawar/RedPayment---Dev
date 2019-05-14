@isTest
private class SendFundingEmailToMerchantCtrlTest {
	
	@isTest static void test_method_one() {
		Opportunity objOpportunity = new Opportunity();
		objOpportunity.Name = 'Test Opportunity';
		objOpportunity.CloseDate = System.today();
		objOpportunity.StageName = 'App Sent';
		objOpportunity.Cloufi__Email_Address__c = 'test@test.com';
		insert objOpportunity;

        PageReference myVfPage = Page.SendFundingEmailToMerchant;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpportunity);
        SendFundingEmailToMerchantControllerX objController  = new SendFundingEmailToMerchantControllerX(sc);
        objController.sendFundingEmailToMerchant();		
	}
}