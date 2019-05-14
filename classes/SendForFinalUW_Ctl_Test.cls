/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: SendForFinalUW_Ctl_Test
* Created Date: 27-September-2018
* Description:  Test class for SendForFinalUW_Ctl
*******************************************************************/

@isTest
public class SendForFinalUW_Ctl_Test {

	public static testMethod void testSendForFinalUW(){
		// Insert Opportunity
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Test Opportunity';
        objOpp.CloseDate = system.today();
        objOpp.StageName = 'Closed Won';
        insert objOpp;
		
		// Insert Custom setting
		Cloufi__LendingXL_Settings__c objSettings = new Cloufi__LendingXL_Settings__c(Name='Site_URL',Cloufi__Value__c ='test1');
        insert objSettings;
        
        //Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Cloufi__URL__c='www.salesforce.com',Cloufi__Type__c='Stip',Cloufi__Opportunity__c=objOpp.id,stip_Name__c='Test',Name = 'Test UW Docu');
        insert objUWDocument ;
		
		SendForFinalUW_Ctl objCtl = new SendForFinalUW_Ctl();
        objCtl.getMerchantStipPageLink();
		objCtl.oppid = objOpp.id;
		objCtl.getMerchantStipPageLink();
        objCtl.getCompletedDocs();
	}
}