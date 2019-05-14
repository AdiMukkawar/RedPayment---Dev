@istest
public class SendApplicationComp_Ctl_Test {
    public static testMethod void executeApplicationlink(){
        
        Cloufi__LendingXL_Settings__c objSettings = new Cloufi__LendingXL_Settings__c(Name='Site_URL',Cloufi__Value__c ='test1');
        insert objSettings;
        
        SendApplicationComp_Ctl objCont = new SendApplicationComp_Ctl();
        objCont.getLead();
        
        cloufi__Application__c objApp = new cloufi__Application__c(Missing_Documents_Types__c='Test,Test1');
        insert objApp;
        
        MissingDocument_Ctl objM = new MissingDocument_Ctl();
        objM.getLead();
        objM.appid = objApp.id;
        objM.getMissingDocs();
    }
    
}