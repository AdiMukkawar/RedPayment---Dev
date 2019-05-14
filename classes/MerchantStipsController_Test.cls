/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: MerchantStipsController_Test
* Created Date: 27-September-2018
* Description:  Test class for MerchantStipsController
*******************************************************************/

@isTest
public class MerchantStipsController_Test {

    public static testMethod void testMerchantStipsController(){
        //Insert Opportunity
        Opportunity objOpp = new Opportunity(Name = 'Test Opportunity',CloseDate = system.today(),StageName = 'Closed Won', Cloufi__Dropbox_Folder_Path__c = 'Test');
        insert objOpp;
        
        //Insert UW document
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Cloufi__URL__c='www.salesforce.com',Cloufi__Type__c='Stip',Cloufi__Opportunity__c=objOpp.id,stip_Name__c='Test',Name = 'Test UW Docu');
        insert objUWDocument ;
        
        //Insert UW share Document
        UW_Document_Share__c objUWShare = new UW_Document_Share__c(Opportunity__c = objOpp.Id, UW_Documents__c = objUWDocument.Id);
        insert objUWShare;
        
        Test.startTest();
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objOpp);
            ApexPages.currentPage().getParameters().put('Id',objOpp.id);
            MerchantStipsController objCtl = new MerchantStipsController(new ApexPages.StandardController(objOpp));
        Test.stopTest();
        
    }
}