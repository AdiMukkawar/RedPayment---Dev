/**
Author | Date       | Description
Neha   | 08/14/2018 | Test class for PricingOptionCalculatorExtension
**/

@isTest
private class PricingOptionCalculatorExtension_Test
{
    
    static testMethod void PricingOptionCalculatorExtensionTest()
    {
        PricingOptionCalculatorExtension.OfferWrapperClass testwrap; 
        
        Account acc=new Account();
        acc.Name='Test';
        acc.Cloufi__Upfront_Fees__c=5.2;
        acc.Cloufi__Backend_Fees__c=9.6;
        insert acc;
        system.assertNotequals(acc.id,null);
        
        List<Cloufi__Offers__c> lstoffertest = new List<Cloufi__Offers__c>();
        List<PricingOptionCalculatorExtension.OfferWrapperClass> lstOfferWrapper=new List<PricingOptionCalculatorExtension.OfferWrapperClass>();
        integer i=0;   
        Opportunity loan=new Opportunity(Name='Test',AccountID = acc.ID,StageName = 'Qualified',CloseDate = System.today(),Cloufi__Payback_Amount__c=2000,Cloufi__Monthly_Gross_Sale__c=3000,Cloufi__Funder__c=acc.id,Amount =151250,Cloufi__Loan_Term__c=7,Cloufi__Account__c=acc.Id, Sales_Support_Email__c = 'test@gamil.com', Cloufi__Dropbox_Folder_Path__c = 'Test');
        insert loan;
        
        //Cloufi__Submission__c objSubmission = new Cloufi__Submission__c(Decline_Reason__c = 'test',Cloufi__Opportunity__c = loan.Id,Cloufi__Lender__c = acc.Id);
        Cloufi__Submission__c objSubmission = new Cloufi__Submission__c(Cloufi__Opportunity__c = loan.Id,Cloufi__Lender__c = acc.Id);
        insert objSubmission;
        
        Cloufi__Application__c objApplication =  new Cloufi__Application__c (Cloufi__Opportunity__c = loan.id);
        insert objApplication;    
        
        
        Cloufi__Offers__c off=new Cloufi__Offers__c(Cloufi__Notes__c='Test',Cloufi__Daily_PB_Amount__c=103,Cloufi__Factor_Rate__c=1.42,Cloufi__Percentage_Of_Gross__c=16,Cloufi__Payback_Amount__c=14500,Cloufi__Terms_In_Months__c=8,Cloufi__Opportunity__c=loan.id,Cloufi__Funder__c = acc.id,Cloufi__Offer_Status__c = 'Pending',Cloufi__Funding_Amount__c = 100, Program_Type__c = 'Loan');
        Cloufi__Offers__c off2=new Cloufi__Offers__c(Cloufi__Daily_PB_Amount__c=103,Cloufi__Factor_Rate__c=1.42,Cloufi__Percentage_Of_Gross__c=16,Cloufi__Payback_Amount__c=14500,Cloufi__Terms_In_Months__c=8,Cloufi__Opportunity__c=loan.id,Cloufi__Funder__c = acc.id,Cloufi__Offer_Status__c = 'Pending',Cloufi__Funding_Amount__c = 100,Cloufi__Notes__c='Notes here', Program_Type__c = 'MCA');
        
        List<Cloufi__Offers__c> lstTemptest=new List<Cloufi__Offers__c>();
        lstTemptest.add(off);
        insert off;
        insert off2;
        lstOfferWrapper.add(new PricingOptionCalculatorExtension.OfferWrapperClass(off,1));
        
        if(lstoffertest.size()>0)
        {
            lstoffertest.add(off2);
            //insert lstoffertest ();
        }
        
        Cloufi__UW_Document__c ObjStips = new Cloufi__UW_Document__c();
        ObjStips.name = 'test';
        ObjStips.Cloufi__Type__c = 'Test';
        ObjStips.Cloufi__Opportunity__c = loan.id;
        ObjStips.Cloufi__URL__c ='www.test.com';
        ObjStips.Stip_Name__c='Signed Application';
        insert ObjStips; 
        
        UW_Document_Share__c objShare = new UW_Document_Share__c(Account__c=acc.id,Opportunity__c=loan.id,UW_Documents__c=ObjStips.id);
        insert objShare;
        
        Cloufi__Dropbox_Settings__c ObjDropboxSetting = new Cloufi__Dropbox_Settings__c();
        ObjDropboxSetting.Cloufi__Access_Token__c = 'test';
        ObjDropboxSetting.Cloufi__Name__c = 'Access Token';
        insert ObjDropboxSetting ;
        
        ApexPages.currentPage().getParameters().put('Id',loan.id);
      ApexPages.currentPage().getParameters().put('accId',acc.id);
        List<PricingOptionCalculatorExtension.StipTypeWrapper> lstStip = new List<PricingOptionCalculatorExtension.StipTypeWrapper>();
        PricingOptionCalculatorExtension poctrl=new PricingOptionCalculatorExtension(new ApexPages.StandardController(loan));
        PricingOptionCalculatorExtension.StipTypeWrapper stipTypeWrap = new PricingOptionCalculatorExtension.StipTypeWrapper('test',true,'testing',true);
        lstStip.add(stipTypeWrap);
        
        boolean Flag = true;
        poctrl.getIndex=0;
        poctrl.SaveOffer();
        poctrl.CancelOffer();
        poctrl.EditOffer();
        poctrl.DeleteOffer();    
        
        poctrl.AddOffer();
        poctrl.getIndex=1;
        poctrl.SaveOffer();
        poctrl.CancelOffer();
        //poctrl.EditOffer();
        poctrl.SendEmail();
        
        poctrl.getIndex=2;
        poctrl.SaveNAddNewOffer();
        
        poctrl.requestStipShow();
        poctrl.AddCustomStip();
        poctrl.AddCustomStipCancel();
        
        poctrl.cancelCustomOffer();
        poctrl.requestStipShowCancel();
        poctrl.showOffers();
        poctrl.lstStipTypeWrapper = lstStip;
        poctrl.lstStipTypeWrapper[0].IsSelected = true;
        poctrl.requestStipsSave();
        //poctrl.fundingDeclined();
        poctrl.getFields();
        poctrl.AddcustomStipsSave();
        poctrl.SaveCustomOffer();
        poctrl.addCustomOffer();
        poctrl.notifySalesSupport(objSubmission);
        poctrl.notifySalesRep('Test reason');
        poctrl.declineReason = 'Test Reason';
        poctrl.submissionId = objSubmission.Id;
        poctrl.fundingDeclined();
        poctrl.updateSubmission();
    }
    
    static testMethod void PricingOptionCalculatorExtensionTestTwo()
    {
        PricingOptionCalculatorExtension.OfferWrapperClass testwrap; 
        
        
        Account acc=new Account();
        acc.Name='Test';
        acc.Cloufi__Upfront_Fees__c=5.2;
        acc.Cloufi__Backend_Fees__c=9.6;
        //insert acc;
        
        //system.assertNotequals(acc.id,null);
        
        List<Cloufi__Offers__c> lstoffertest = new List<Cloufi__Offers__c>();
        List<PricingOptionCalculatorExtension.OfferWrapperClass> lstOfferWrapper=new List<PricingOptionCalculatorExtension.OfferWrapperClass>();
        integer i=0;   
        Opportunity loan=new Opportunity(Name='Test',StageName = 'Qualified',CloseDate = System.today(),Cloufi__Payback_Amount__c=2000,Cloufi__Monthly_Gross_Sale__c=3000,Amount =151250,Cloufi__Loan_Term__c=7,Cloufi__Account__c=acc.Id, Cloufi__Dropbox_Folder_Path__c = 'Test');
        insert loan;
        
        Cloufi__Application__c objApplication =  new Cloufi__Application__c (Cloufi__Opportunity__c = loan.id);
        insert objApplication;    
        
        Cloufi__Offers__c off=new Cloufi__Offers__c(Cloufi__Daily_PB_Amount__c=103,Cloufi__Factor_Rate__c=1.42,Cloufi__Percentage_Of_Gross__c=16,Cloufi__Payback_Amount__c=14500,Cloufi__Terms_In_Months__c=8,Cloufi__Opportunity__c=loan.id,Cloufi__Offer_Status__c = 'Pending',Cloufi__Funding_Amount__c = 100);
        Cloufi__Offers__c off2=new Cloufi__Offers__c(Cloufi__Daily_PB_Amount__c=103,Cloufi__Factor_Rate__c=1.42,Cloufi__Percentage_Of_Gross__c=16,Cloufi__Payback_Amount__c=14500,Cloufi__Terms_In_Months__c=8,Cloufi__Opportunity__c=loan.id,Cloufi__Offer_Status__c = 'Funder Declined',Cloufi__Funding_Amount__c = 100,Cloufi__Notes__c='Notes here',Program_Type__c='MCA');
        
        List<Cloufi__Offers__c> lstTemptest=new List<Cloufi__Offers__c>();
        lstTemptest.add(off);
        insert off;
        insert off2;
        
        lstOfferWrapper.add(new PricingOptionCalculatorExtension.OfferWrapperClass(off,1));
        System.assertNotEquals(lstOfferWrapper, null);
        
        if(lstoffertest.size()>0)
        {
            lstoffertest.add(off2);
            System.assertEquals(lstoffertest, null);
        }
        ApexPages.currentPage().getParameters().put('Id',loan.id);
        List<PricingOptionCalculatorExtension.StipTypeWrapper> lstStip = new List<PricingOptionCalculatorExtension.StipTypeWrapper>();
        PricingOptionCalculatorExtension poctrl=new PricingOptionCalculatorExtension(new ApexPages.StandardController(loan));
        PricingOptionCalculatorExtension.StipTypeWrapper stipTypeWrap = new PricingOptionCalculatorExtension.StipTypeWrapper('test',true,'testing',false);
        lstStip.add(stipTypeWrap);
        
        boolean Flag = false;
        boolean showSubmitBtn = true;
        Integer getNoteIndex = 1;
        poctrl.getIndex=0;
        poctrl.SaveOffer();
        poctrl.CancelOffer();
        poctrl.EditOffer();
        poctrl.DeleteOffer();    
        
        poctrl.AddOffer();
        poctrl.getIndex=1;
        //poctrl.SaveOffer();
        //poctrl.CancelOffer();
        poctrl.EditOffer();
        poctrl.SendEmail();
        
        poctrl.getIndex=2;
        poctrl.SaveNAddNewOffer();
        
        poctrl.requestStipShow();
        poctrl.AddCustomStip();
        poctrl.AddCustomStipCancel();
        
        poctrl.cancelCustomOffer();
        poctrl.requestStipShowCancel();
        poctrl.showOffers();
        poctrl.lstStipTypeWrapper = lstStip;
        poctrl.lstStipTypeWrapper[0].IsSelected = true;
        poctrl.requestStipsSave();
        //poctrl.fundingDeclined();
        poctrl.getFields();
        poctrl.AddcustomStipsSave();
        poctrl.SaveCustomOffer();
        poctrl.addCustomOffer();
    }  
}