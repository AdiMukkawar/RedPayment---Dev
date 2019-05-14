@isTest
public class SendContractComp_Ctl_Test {
    public static testMethod void executeSendContractComp(){
        
        Opportunity objOpp = new Opportunity(Name='Test Opp',StageName='App Sent', CloseDate=system.today());
        insert objOpp;
        
        Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c(Status__c='Completed',Name='Test',Stip_Name__c='Contract',Cloufi__Opportunity__c=objOpp.Id);
        insert objUW;

        SendContractComp_Ctl objCont = new SendContractComp_Ctl();
        objCont.oppid = objOpp.id;
        objCont.getContractLink();
        objCont.getUWDocumentList();
    }
}