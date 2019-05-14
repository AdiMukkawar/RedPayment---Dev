@isTest
private class RequestContractFromLenderControllerXTest {
	
	@isTest static void test_method_one() {
        Account objAccount = new Account(Name='Test Account');
        insert objAccount;
        
        //Insert contacts under account
        Contact objContact = new Contact(FirstName='Test',Lastname='TestLast',Email='gaurav@techilaservices.com',AccountId=objAccount.Id, Contract__c = true);
        insert objContact;

        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'test';
        oppObj.StageName = 'Application';
        oppobj.CloseDate = system.today();        
        oppobj.Cloufi__Monthly_Revenue__c = 10000;
        oppobj.Cloufi__Type_of_Business__c = 'test';
        oppobj.CloufiServicing__Submission_Country__c = 'United States';        
        insert oppObj;

        PageReference myVfPage = Page.RequestContractFromLender;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id',oppObj.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(oppObj);
        RequestContractFromLenderControllerX objController  = new RequestContractFromLenderControllerX(sc);
        objController.requestContract();                
	}	

	@isTest static void test_method_two() {
        Account objAccount = new Account(Name='Test Account');
        insert objAccount;
        
        //Insert contacts under account
        Contact objContact = new Contact(FirstName='Test',Lastname='TestLast',Email='gaurav@techilaservices.com',AccountId=objAccount.Id, Contract__c = true);
        insert objContact;

        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'test';
        oppObj.StageName = 'Application';
        oppobj.CloseDate = system.today();        
        oppobj.Cloufi__Monthly_Revenue__c = 10000;
        oppobj.Cloufi__Type_of_Business__c = 'test';
        oppobj.CloufiServicing__Submission_Country__c = 'United States';
        oppObj.Cloufi__Funder__c = objAccount.Id;
        oppObj.StageName = 'Approved';
        insert oppObj;

        PageReference myVfPage = Page.RequestContractFromLender;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id',oppObj.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(oppObj);
        RequestContractFromLenderControllerX objController  = new RequestContractFromLenderControllerX(sc);
        objController.requestContract();                
	}	
}