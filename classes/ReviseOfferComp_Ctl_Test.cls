@istest
public class ReviseOfferComp_Ctl_Test {
    public static testMethod void executeReviseOfferComp(){
        
        Cloufi__LendingXL_Settings__c objSettings = new Cloufi__LendingXL_Settings__c(Name='Site_URL',Cloufi__Value__c ='test1');
        insert objSettings;
        
        ReviseOfferComp_Ctl ctrl = new ReviseOfferComp_Ctl();
        ctrl.getOfferR();
    }
}