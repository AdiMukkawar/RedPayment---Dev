/**********************************************************************************
Send Contract page Controller
Test Class Name : SendContract_Test
----------------------------------------------------------------------------------
Author           | Project       |Date           | Description
----------------------------------------------------------------------------------
Aditya           | Red Payment   | 08/21/2018    | Test class for SendContract
----------------------------------------------------------------------------------
**********************************************************************************/
@isTest
public class SendContract_Test {
    
    public static testMethod void testSendContract(){
        Opportunity objOpp = new Opportunity(stageName = 'Contract Received',Name='Test Opp',Cloufi__Email_Address__c='test@gmail.com', CloseDate=system.today());
        insert objOpp;
        
        Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c(Name='Test',Stip_Name__c='Contract',Cloufi__Opportunity__c=objOpp.Id);
        insert objUW;
        
        Test.startTest();           
            ApexPages.StandardController sc = new ApexPages.StandardController(objOpp);
            apexpages.currentpage().getparameters().put('id',objOpp.id);
            SendContract_Ctl objController = new SendContract_Ctl(sc);
            objController.SendContract();
        Test.stopTest();
    }
}