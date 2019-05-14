/*******************************************************************************************
-------------------------------------------------------------------------------------------
Author           | Project       |Date              | Description
-------------------------------------------------------------------------------------------
Aditya Mukkawar  | Red Payment   |18-September-2018 | Test class for SendStipstoSalesRepComp_Ctl
*******************************************************************************************/
@isTest
public class SendStipstoSalesRepComp_Ctl_Test {
    public static testmethod void SendStipstoSalesRepCompTest(){
        
        //Inser Opportunity 
        Opportunity objOpp = new Opportunity(Name = 'test',StageName = 'Application',CloseDate = system.today());
        insert objOpp;
        
        //Insert UW Document
        Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c(status__c='Requested',Name='Signed Application',Stip_Name__c='Signed Application',Cloufi__Opportunity__c=objOpp.Id);
        insert objUW;
        
        SendStipstoSalesRepComp_Ctl objctrl = new SendStipstoSalesRepComp_Ctl();
        objctrl.getOpp();
        objctrl.getMissingDocs();
        objctrl.oppid = objOpp.id;
        objctrl.getMissingDocs();
    }
}