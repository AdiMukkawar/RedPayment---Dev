@istest
public class ChosenOfferComp_Ctl_Test {
    
    public static testMethod void executeChosenOfferComp(){
        
        Account objAcc = new Account(Name='Test Account');
        insert objAcc;
        
        contact objCon = new Contact(lastname='Test',Email='test@test.com',AccountId=objAcc.Id,Submission__c=true);
        insert objCon;
	
        Lead objLead = New Lead(LastName='Test1',Status='New',Company='TestCompany',Average_Monthly_Revenue__c='$10,000 - $24,999',Time_in_Business__c='1-3 Years',Phone='9632587410',country='Canada');
        insert objLead;
        
        Opportunity objOpp = new Opportunity(AccountId=objAcc.id,Opportunity_Owner_Manager__c=UserInfo.getUserId(),Name='Test Opp',StageName='Contract Signed Partial', CloseDate=system.today(),Lead__c=objLead.id);
        insert objOpp;
        
        Cloufi__Submission__c objSub = new Cloufi__Submission__c(Cloufi__Lender__c=objAcc.id,Cloufi__Opportunity__c=objOpp.id,Cloufi__Status__c='Requested');
        insert objSub;
        
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c(Cloufi__Funder__c=objAcc.id,Cloufi__Opportunity__c=objOpp.id,Cloufi__Submission__c=objSub.id,Cloufi__Offer_Status__c='Approved');
        insert objOffer;
        
        Cloufi__UW_Document__c objUw = new Cloufi__UW_Document__c(Cloufi__Opportunity__c=objOpp.Id,Stip_Name__c='Test Name',Cloufi__URL__c='www.salesforce.com');
        insert objUw;
        
        UW_Document_Share__c objShare = new UW_Document_Share__c(Account__c=objAcc.id,Opportunity__c=objOpp.id,UW_Documents__c=objUw.id);
        insert objShare;
        
        ChosenOfferComp_Ctl objCont = new ChosenOfferComp_Ctl();
        objCont.getOfferDocs();
        objCont.oppId = objOpp.id;
        objCont.getOfferDocs();
    }
    
}