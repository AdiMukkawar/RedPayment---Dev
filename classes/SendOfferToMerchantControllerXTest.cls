@isTest
private class SendOfferToMerchantControllerXTest {
	
	@isTest static void test_method_one() {
 		//Insert Opportunity 
        Opportunity objOpp = new Opportunity(Name = 'test',StageName = 'Application',CloseDate = system.today());
        insert objOpp;
        
        //Insert offer
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c(Cloufi__Opportunity__c=ObjOpp.id,Cloufi__Offer_Status__c = 'New',Revision_Notes__c = 'Test',Cloufi__Funding_Amount__c=10000,Cloufi__Payback_Amount__c=54211);
        insert objOffer;

		PageReference pageRef = Page.SendOfferToMerchant;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id',objOffer.id);
        SendOfferToMerchantControllerX objController = new SendOfferToMerchantControllerX(new ApexPages.StandardController(objOffer));
		objController.presentOffer();                
	}

	@isTest static void test_method_two() {
 		//Insert Opportunity 
        Opportunity objOpp = new Opportunity(Name = 'test',StageName = 'Application',CloseDate = system.today());
        insert objOpp;
        
        //Insert offer
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c(Cloufi__Opportunity__c=ObjOpp.id,Cloufi__Offer_Status__c = 'Presented',Revision_Notes__c = 'Test',Cloufi__Funding_Amount__c=10000,Cloufi__Payback_Amount__c=54211);
        insert objOffer;

		PageReference pageRef = Page.SendOfferToMerchant;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id',objOffer.id);
        SendOfferToMerchantControllerX objController = new SendOfferToMerchantControllerX(new ApexPages.StandardController(objOffer));
		objController.presentOffer();                
	}

	@isTest static void test_method_three() {
 		//Insert Opportunity 
        Opportunity objOpp = new Opportunity(Name = 'test',StageName = 'Application',CloseDate = system.today());
        insert objOpp;
        
        //Insert offer
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c(Cloufi__Opportunity__c=ObjOpp.id,Cloufi__Offer_Status__c = 'Presented',Revision_Notes__c = 'Test',Cloufi__Funding_Amount__c=10000,Cloufi__Payback_Amount__c=54211);
        insert objOffer;

		PageReference pageRef = Page.SendOfferToMerchant;
		Test.setCurrentPage(pageRef);		
        SendOfferToMerchantControllerX objController = new SendOfferToMerchantControllerX(new ApexPages.StandardController(objOffer));
		objController.presentOffer();                
	}		
}