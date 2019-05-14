/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Test Class Name: OpportunityTrigger_Test
* Created Date: 
* Description:  Test class for OpportunityTrigger
*******************************************************************/
@isTest
public class OpportunityTrigger_Test {
    public static testMethod void testOpportunityTrigger(){
        //Insert Custom Setting
        UW_Documents_Settings__c objUWSettings = new UW_Documents_Settings__c(Name = 'Test doc',Type__c = 'Document',Stage__c = 'Application');
        insert objUWSettings;

        Cloufi__LendingXL_Trigger_Settings__c objOppTriggerSettings = new Cloufi__LendingXL_Trigger_Settings__c(Custom_Opportunity_Create_UW_Doc_Trigger__c=true,Custom_Opportunity_Trigger__c=true);
        insert objOppTriggerSettings;
        
        //Insert Lead
        Lead objLead = New Lead(LastName='Test1',Status='New',Company='TestCompany',Average_Monthly_Revenue__c='$10,000 - $24,999',Time_in_Business__c='1-3 Years',Phone='9632587410',country='Canada');
        insert objLead;
        
        //Insert Opportunity
        Opportunity objOpp = new Opportunity(Name='Test Opp',StageName='App Sent', CloseDate=system.today());
        insert objOpp;
        
        //Insert Application
        Cloufi__Application__c objApp = new Cloufi__Application__c(Cloufi__Application_Status__c='In Progress',cloufi__Opportunity__c =objOpp.id,Cloufi__Lead__c=objLead.id,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
        insert objApp;

        //Update Opportunity 
        objOpp.StageName = 'App In Missing Info';
        update objOpp;
        
        Test.startTest();

        //Insert UW Document
        Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c(Status__c='Requested',Cloufi__Type__c = 'Stip',Name='Contract',Stip_Name__c='Contract',Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application__c=objApp.Id);
        insert objUW;

        //Insert UW Document
        objUW = new Cloufi__UW_Document__c(Status__c='Requested',Cloufi__Type__c = 'Stip',Name='Signed Contract',Stip_Name__c='Signed Contract',Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application__c=objApp.Id);
        insert objUW;

        //Update Opportunity 
        objOpp.StageName = 'Contract Requested';
        update objOpp;

        //Update Opportunity 
        objOpp.StageName = 'Contract Sent';
        update objOpp;
        
        //Insert UW Document
        objUW = new Cloufi__UW_Document__c(Status__c='Completed',Cloufi__Type__c = 'Application - Document',Name='Test doc',Stip_Name__c='Test doc',Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application__c=objApp.id);
        insert objUW;
        
        //Insert UW Document
        objUW = new Cloufi__UW_Document__c(Status__c='Completed',Cloufi__Type__c = 'Application - Document',Name='Bank Statement',Stip_Name__c='Bank Statement',Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application__c=objApp.id);
        insert objUW; 

        Test.stopTest();        
    }

    public static testMethod void testOpportunityTriggerOne(){
         Cloufi__LendingXL_Trigger_Settings__c objOppTriggerSettings = new Cloufi__LendingXL_Trigger_Settings__c(Custom_Opportunity_Create_UW_Doc_Trigger__c=true,Custom_Opportunity_Trigger__c=true);
        insert objOppTriggerSettings;
        Test.startTest();
        
        Opportunity objOpportunity = new Opportunity(Name='Test Opp',StageName='Contract Requested', CloseDate=system.today());
        insert objOpportunity;

        //Update Opportunity 
        Opportunity objOpp = [SELECT Id, StageName FROM Opportunity WHERE Id =: objOpportunity.Id];
        objOpp.StageName = 'Contract Sent';
        update objOpp;      

        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        oppMap.put(objOpp.Id, objOpp);

        OpportunityTriggerHandler.createSignedContractUWDocument(oppMap);

        Test.stopTest();         
    }  

    public static testMethod void testOpportunityTriggerTwo(){
         Cloufi__LendingXL_Trigger_Settings__c objOppTriggerSettings = new Cloufi__LendingXL_Trigger_Settings__c(Custom_Opportunity_Create_UW_Doc_Trigger__c=true,Custom_Opportunity_Trigger__c=true);
        insert objOppTriggerSettings;
        Test.startTest();
        
        Opportunity objOpportunity = new Opportunity(Name='Test Opp',StageName='Contract Sent', CloseDate=system.today());
        insert objOpportunity;

        //Update Opportunity 
        Opportunity objOpp = [SELECT Id, StageName FROM Opportunity WHERE Id =: objOpportunity.Id];
        objOpp.StageName = 'Contract Requested';
        update objOpp;      
        
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        oppMap.put(objOpp.Id, objOpp);

        OpportunityTriggerHandler.createContractUWDocument(oppMap);
        Test.stopTest();         
    }
    
    public static testMethod void testOpportunityTrigger_3(){
        Cloufi__LendingXL_Trigger_Settings__c objOppTriggerSettings = new Cloufi__LendingXL_Trigger_Settings__c(Custom_Opportunity_Create_UW_Doc_Trigger__c=true,Custom_Opportunity_Trigger__c=true);
        insert objOppTriggerSettings;
        Test.startTest();
        
        Opportunity objOpportunity = new Opportunity(Name='Test Opp',StageName='Contract Sent', CloseDate=system.today());
        insert objOpportunity;
        
        //Update Opportunity 
        Opportunity objOpp = [SELECT Id, StageName FROM Opportunity WHERE Id =: objOpportunity.Id];
        objOpp.StageName = 'App In Missing Info';
        objOpp.Owner_2_Email__c = 'test2@test.com';
        objOpp.Owner_1_Email__c = 'test1@test.com';
        update objOpp;      
        
        Test.stopTest();         
    }
    
    
}