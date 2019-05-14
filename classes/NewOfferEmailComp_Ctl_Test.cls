/*******************************************************************************************
-------------------------------------------------------------------------------------------
Author           | Project       |Date              | Description
-------------------------------------------------------------------------------------------
Aditya Mukkawar  | Red Payment   |18-September-2018 | Test class for NewOfferEmailComp_Ctl
*******************************************************************************************/
@isTest
public class NewOfferEmailComp_Ctl_Test {
    public static testmethod void NewOfferEmailCompTest(){
        //Inser Opportunity 
        Opportunity objOpp = new Opportunity(Name = 'test',StageName = 'Application',CloseDate = system.today());
        insert objOpp;
        
        //Insert offer
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c(Cloufi__Opportunity__c=ObjOpp.id,
                                                           Cloufi__Offer_Status__c = 'Pending',
                                                           Revision_Notes__c = 'Test',
                                                           Cloufi__Funding_Amount__c=10000,
                                                           Cloufi__Payback_Amount__c=54211);
        insert objOffer;
        
        NewOfferEmailComp_Ctl objctrl = new NewOfferEmailComp_Ctl();
        objctrl.offid = objOffer.Id;
        objctrl.getFields();
        objctrl.getOffer();
        objctrl.getOfferLink();
        
        NewCustomOfferEmailComp_Ctl objctrl1 = new NewCustomOfferEmailComp_Ctl();
        objctrl1.getOfferLink();
    }
}