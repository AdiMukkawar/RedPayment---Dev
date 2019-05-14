@isTest
public class ReviseOfferController_Test {
    public static testMethod void executeReviseOfferController(){
        ReviseOfferController.OfferWrapperClass testwrap;       
        
        Account acc=new Account();
        acc.Name='Test';
        acc.Cloufi__Upfront_Fees__c=5.2;
        acc.Cloufi__Backend_Fees__c=9.6;
        insert acc;
        
        system.assertNotequals(acc.id,null);
        
        List<Cloufi__Offers__c> lstoffertest = new List<Cloufi__Offers__c>();
        List<ReviseOfferController.OfferWrapperClass> lstOfferWrapper=new List<ReviseOfferController.OfferWrapperClass>();
        integer i=0;
        
        Opportunity loan=new Opportunity(Name='Test',
                                         AccountID = acc.ID,
                                         StageName = 'Qualified',
                                         CloseDate = System.today(),
                                         Cloufi__Payback_Amount__c=2000,
                                         Cloufi__Monthly_Gross_Sale__c=3000,
                                         Cloufi__Funder__c=acc.id,Amount =151250,
                                         Cloufi__Loan_Term__c=7,Cloufi__Account__c=acc.Id, Cloufi__Gross_Profit__c = 200, 
                                        Cloufi__Business_DBA_Years_in_Business__c = 2,
                                        Cloufi__Dropbox_Folder_Path__c = 'Test');
        insert loan;
        
        Cloufi__Submission__c ObjSub = new Cloufi__Submission__c(Cloufi__Opportunity__c=loan.id,Cloufi__Lender__c=acc.id,Cloufi__Status__c='Requested');
        insert objSub;
        
        Cloufi__Offers__c off=new Cloufi__Offers__c(Revision_Notes__c = 'Test',Program_Type__c='MCA',Cloufi__Submission__c=objSub.id,Cloufi__Daily_PB_Amount__c=103,Factor_Rate__c=1.42,Cloufi__Percentage_Of_Gross__c=16,Cloufi__Payback_Amount__c=14500,Cloufi__Terms_In_Months__c=8,Cloufi__Opportunity__c=loan.id,Cloufi__Funder__c = acc.id,Cloufi__Offer_Status__c = 'Pending',Cloufi__Funding_Amount__c = 100);
        Cloufi__Offers__c off2=new Cloufi__Offers__c(Revision_Notes__c = 'Test',Program_Type__c='MCA',Cloufi__Submission__c=objSub.id,Cloufi__Daily_PB_Amount__c=103,Factor_Rate__c=1.42,Cloufi__Percentage_Of_Gross__c=16,Cloufi__Payback_Amount__c=14500,Cloufi__Terms_In_Months__c=8,Cloufi__Opportunity__c=loan.id,Cloufi__Funder__c = acc.id,Cloufi__Offer_Status__c = 'Revision',Cloufi__Funding_Amount__c = 100);
        
        Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c(Cloufi__URL__c='www.sfdc.com',Name='Test',Stip_Name__c='Signed Application',Cloufi__Opportunity__c=loan.Id, Cloufi__Type__c='Bank Statement', Status__c='Pending');
            insert objUW;
            objUW.Cloufi__URL__c = 'www.salesforce.com';
        	update objUW;
        
            UW_Document_Share__c objShare = new UW_Document_Share__c(Account__c=acc.id,Opportunity__c=loan.id,UW_Documents__c=objUW.id);
            insert objShare;
        
        List<Cloufi__Offers__c> lstTemptest=new List<Cloufi__Offers__c>();
        lstTemptest.add(off);
        insert off;
        insert off2;
        lstOfferWrapper.add(new ReviseOfferController.OfferWrapperClass(off2,1));
        
		PageReference myVfPage = Page.ReviseOffer;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', off2.Id);
		ReviseOfferController ctrl=new ReviseOfferController();
        ctrl.getFields();
        ctrl.submissionId = objSub.id;
        ctrl.getIndex = 1;
        ctrl.SaveOffer();
        ctrl.updateSubmission();
        ctrl.queryRelatedOffer();
    }
}