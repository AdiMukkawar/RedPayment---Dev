/*
****************************************************************
* Author: Techila Global Services Pvt Ltd. (Sheema Dhanraj)
* Component Name: SyndicatorController
* Created Date: 12-04-2019
* Description:  To fetch opportunity and related payment records
******************************************************************
*/
public with sharing class SyndicationPortalController {
    public Account syndicatingAccount{get;set;}
    public Map<Id, Opportunity> opportunityMap{get;set;}
    public Map<Id, List<Cloufi__Payments__c>> paymentMap{get;set;}
    private Set<Id> opportunityIdSet;
    public List<SyndicatorPaymentWrapper> syndicationPaymentWrapperList{get;set;}
    private Map<Id, CloufiServicing__Syndication__c> opportunitySyndicationMap;
    public List<Cloufi__Payments__c> paymentList{get;set;}
    public String message{get; set;}
    public boolean displayPaymentPanel {get;set;}
    public string userId {get;set;}
    public String accountName{get; set;}
    
    public SyndicationPortalController(ApexPages.StandardController controller){
        userId = ApexPages.currentPage().getParameters().get('id');
        Account objAccount = [Select Id, Name from Account
                                Where Id =: userId];
        accountName = objAccount.Name;
        if(userId != null){
            message = 'Please select Opportunity to see Payment Records.';
            init();
            populateValues(ApexPages.currentPage().getParameters().get('id'));
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Page must have Syndicator defined'));
        }
    }
    
    public void init(){
        syndicatingAccount = new Account();
        opportunityMap = new Map<Id, Opportunity>();
        paymentMap = new Map<Id, List<Cloufi__Payments__c>>();
        opportunityIdSet = new Set<Id>();
        syndicationPaymentWrapperList = new List<SyndicatorPaymentWrapper>();
        opportunitySyndicationMap = new Map<Id, CloufiServicing__Syndication__c>(); 
        paymentList = new List<Cloufi__Payments__c>();
    }
    
    public void populateValues(Id syndicatingAccountId){
        Set<String> opportunityStages = new Set<String>();
        List<String> stageNameList = new List<String>{'Completed', 'Funded'};
        Map<String, List<Opportunity>> stageWiseOpportunityMap = new Map<String, List<Opportunity>>();
        String q = 'SELECT ' + String.join(DevUtil.getFieldsOfsObject('Account'),',');
        q += ' FROM Account WHERE Id = \''+ syndicatingAccountId +'\'';
        syndicatingAccount = Database.Query(q);
        
        q = '';
        q = 'SELECT ' + String.join(DevUtil.getFieldsOfsObject('CloufiServicing__Syndication__c'),',');
        q += ' FROM CloufiServicing__Syndication__c WHERE CloufiServicing__Syndicating_Account__c = \''+syndicatingAccountId+'\'';      
        for(CloufiServicing__Syndication__c objSyndication : Database.Query(q)){
            opportunitySyndicationMap.put(objSyndication.CloufiServicing__Opportunity__c, objSyndication);
            opportunityIdSet.add(objSyndication.CloufiServicing__Opportunity__c);
        }
        
        q = '';
        q = 'SELECT ' + String.join(DevUtil.getFieldsOfsObject('Opportunity'),',');
        q += ',(SELECT '+String.join(DevUtil.getFieldsOfsObject('Cloufi__Payments__c'),',');
        q += ' FROM Cloufi__Payments1__r)';     
        q += ' FROM Opportunity WHERE Id IN : opportunityIdSet AND StageName IN: stageNameList';
        
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple){
                opportunityStages.add(f.getLabel());
        }           
        
        for(Opportunity objOpportunity : Database.Query(q)){
            opportunityMap.put(objOpportunity.Id, objOpportunity);
            if(objOpportunity.Cloufi__Payments1__r.size()>0){
                paymentMap.put(objOpportunity.Id, objOpportunity.Cloufi__Payments1__r);
            }
            
            if(stageWiseOpportunityMap.containsKey(objOpportunity.StageName)){
                stageWiseOpportunityMap.get(objOpportunity.StageName).add(objOpportunity);
            }else{
                stageWiseOpportunityMap.put(objOpportunity.StageName, new List<Opportunity>{objOpportunity});
            }
        }
        
        for(String stageName : stageWiseOpportunityMap.keySet()){
            List<OpportunityPaymentWrapper> opportunityPaymentWrapperTempList = new List<OpportunityPaymentWrapper>();
            if(stageWiseOpportunityMap.get(stageName) != null){
                for(Opportunity objOpportunity : stageWiseOpportunityMap.get(stageName)){
                    if(objOpportunity.Cloufi__Payments1__r.size()>0 && opportunitySyndicationMap.get(objOpportunity.Id) != null){
                        opportunityPaymentWrapperTempList.add(new OpportunityPaymentWrapper(objOpportunity.Name, objOpportunity.Id));
                    }
                }
                syndicationPaymentWrapperList.add(new SyndicatorPaymentWrapper(stageName, opportunityPaymentWrapperTempList));
            }
        }
    }
    
    public void fetchPaymentsForSelectedOpp(){
        message = '';
        String oppId = Apexpages.currentPage().getParameters().get('opportunityId');
        Opportunity objOpportunity = [select Id, Name from Opportunity Where Id =: oppId];
        System.debug('oppId ->'+oppId);
        if(paymentMap.get(oppId) != null){
            paymentList = paymentMap.get(oppId);
        }
        if(paymentList.size() > 0){
            displayPaymentPanel = true;
            message = 'Showing Payments for '+objOpportunity.Name;
        }else{
            displayPaymentPanel = false;
            message = 'No Payments found!!!';
        }
    }
    
     public PageReference Logout(){ 
            PageReference pg = new PageReference('/apex/SyndicatorLoginPage');
            pg.setRedirect(false);
            return pg;
    }
    
    public class SyndicatorPaymentWrapper{
        public String opportunityStageName{get;set;}
        public List<OpportunityPaymentWrapper> opportunityPaymentWrapperList{get;set;}
        public SyndicatorPaymentWrapper(String stageName, List<OpportunityPaymentWrapper> paymentWrapList){
            this.opportunityStageName = stageName;
            this.opportunityPaymentWrapperList = paymentWrapList;
        }
    }
    
    public class OpportunityPaymentWrapper{
        public String opportunityName{get;set;}
        public Id opportunityId{get;set;}
        public OpportunityPaymentWrapper(String oppName, Id oppId){
            this.opportunityName = oppName;
            this.opportunityId = oppId;
        }
    }
}