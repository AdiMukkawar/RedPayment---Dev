/*
****************************************************************
* Author: Techila Global Services Pvt Ltd. (Sheema Dhanraj)
* Component Name: SyndicatorController
* Created Date: 05-04-2019
* Description:  Apex class to login and initialize opportunity records
******************************************************************
*/

public class SyndicatorController{
    
    public Account acc {get; set;}
    public String username {get; set;}
    public string password {get;set;} 
    public String accessCode{get;set;}
    public String NewPassword {get;set;}
    public String ConfirmNewPassword {get;set;}
    public List<Account> tempUserId;
    public List<opportunity> oppList{get; set;}
    
    public Account syndicatingAccount{get;set;}
    public Map<Id, Opportunity> opportunityMap{get;set;}
    public Map<Id, List<Cloufi__Payments__c>> paymentMap{get;set;}
    private Set<Id> opportunityIdSet;
     private Set<Id> syndicationIdSet;
    public List<SyndicatorPaymentWrapper> syndicationPaymentWrapperList{get;set;}
    private Map<Id, CloufiServicing__Syndication__c> opportunitySyndicationMap;
    public List<Cloufi__Payments__c> paymentList{get;set;}
    public String message{get; set;}
    public String oppMessage{get; set;}
    public boolean displayPaymentPanel {get;set;}
    public boolean displayPaymentSection {get;set;}
    public string userId {get;set;}
    public String accountName{get; set;}
    
    
    // Constructor
    public SyndicatorController(ApexPages.StandardController controller) {
        accessCode = '';
        userid = Apexpages.currentPage().getParameters().get('id');
        system.debug('userid=> '+userid);
        tempUserId = new List<Account> ();
    }
    
    // Login Method
    Public PageReference LoginUser(){
        List<Account> accountList;
        userid = SyndicatorUtilClass.LoginUserMethod(username, password);
        system.debug('userid=> '+userid);
        if(userid != null && userid.length() > 0){
            system.debug('userid in userid != null=> '+userid);
            accountList = [Select id, Last_Login_Date__c, Name, Access_Code__c, Email__c, Syndication_Portal_Access__c, Cloufi__Syndicator__c
                           from Account where id = : userid];
            for(Account accounts: accountList){
                acc = accounts;
            }
            PageReference pg = new PageReference('/apex/SyndicatorConfirmAccess');
            pg.setRedirect(false);
            return pg;
        }else{
            return null;
        }
    }  
    
    // Method called on click of forgot password button
    public PageReference forgetPassword() { 
        if(username == null || username == '') {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please Enter Email');
            apexpages.addmessage(myMsg);
            return null;
        }
        
        List <Account> accountEmail = [select id, Name, PassWord__c, Email__c From Account a Where Email__c = : username limit 1]; 
        if(!accountEmail.isEmpty()){
            acc = accountEmail[0]; 
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Email is not present');
            apexpages.addmessage(myMsg);
            return null;
        }
        PageReference pg = SyndicatorUtilClass.SyndicatorForgotPassword(acc, tempUserId);
        return pg;
    }
    
    
    // method called on click of confirm access
    public PageReference confirmLogin(){
        if(acc.Access_Code__c == accessCode){
           //if(acc.Last_Login_Date__c == null && NewPassword == password){
                acc.Password__c = password;
                acc.Last_Login_Date__c = System.Today();                
           //}
            update acc;
            PageReference pg = new PageReference('/apex/SyndicationPortal');
            populateValues(acc.id);
            pg.setRedirect(false);
            return pg;            
        }else if(accessCode == null || accessCode == ''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Access Code.');
            apexpages.addmessage(myMsg);
            return null;            
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Access Code is incorrect.');
            apexpages.addmessage(myMsg);
            return null;  
        }
    }
    
    
    public PageReference checkSession(){  
        if(userid == null || userid == ''){  
            PageReference pg = new PageReference('/apex/SyndicatorLoginPage');
            pg.setRedirect(false);
            return pg;
        }
        return null;
    }
    
    
    // Logout method
    Public PageReference Logout() {
        Account acc = [Select ID, Name, Email__c, Password__c from Account where Id =: userid];
        system.debug('acc=>'+acc);
        PageReference Pref = new PageReference('/apex/SyndicatorLoginPage');
        Pref.setRedirect(true);
        return Pref;
    }

    public void refreshPage(){
        populateValues(acc.id);
    }
    
    // method to populate opportunity records
    public void populateValues(Id syndicatingAccountId){
        Account objAccount = [Select Id, Name, Password__c from Account
                                Where Id =: userId];
        system.debug('objAccount.Password__c=> '+objAccount.Password__c);
        accountName = objAccount.Name;
        syndicatingAccount = new Account();
        opportunityMap = new Map<Id, Opportunity>();
        paymentMap = new Map<Id, List<Cloufi__Payments__c>>();
        opportunityIdSet = new Set<Id>();
        syndicationIdSet = new Set<Id>();
        syndicationPaymentWrapperList = new List<SyndicatorPaymentWrapper>();
        opportunitySyndicationMap = new Map<Id, CloufiServicing__Syndication__c>(); 
        paymentList = new List<Cloufi__Payments__c>();
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
            syndicationIdSet.add(objSyndication.Id);
        }
        
        if(opportunityIdSet.size() > 0){
            displayPaymentSection = true;
            displayPaymentPanel = false;
            oppMessage = '';
            message = 'Please select Opportunity to see Payment Records.';
        }else{
            displayPaymentSection = false;
            displayPaymentPanel = false;
            oppMessage = 'No opportunities found!!!';
            message = '';
        }
        
        q = '';
        q = 'SELECT ' + String.join(DevUtil.getFieldsOfsObject('Opportunity'),',');
        q += ',(SELECT '+String.join(DevUtil.getFieldsOfsObject('Cloufi__Payments__c'),',');
        q += ' FROM Cloufi__Payments1__r WHERE CloufiServicing__Syndication__c =: syndicationIdSet)';     
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
    
    // method to fetch Payment records
    public void fetchPaymentsForSelectedOpp(){
        message = '';
        String selectedOppId = Apexpages.currentPage().getParameters().get('opportunityId');
        Opportunity objOpportunity = [select Id, Name from Opportunity Where Id =: selectedOppId];
        if(paymentMap.get(selectedOppId) != null){
            paymentList = paymentMap.get(selectedOppId);
        }
        if(paymentList.size() > 0){
            displayPaymentPanel = true;
            message = 'Showing Payments for '+objOpportunity.Name;
        }else{
            displayPaymentPanel = false;
            message = 'No Payments found!!!';
        }
    }
    
    // Wrapper class
    public class SyndicatorPaymentWrapper{
        public String opportunityStageName{get;set;}
        public List<OpportunityPaymentWrapper> opportunityPaymentWrapperList{get;set;}
        public SyndicatorPaymentWrapper(String stageName, List<OpportunityPaymentWrapper> paymentWrapList){
            this.opportunityStageName = stageName;
            this.opportunityPaymentWrapperList = paymentWrapList;
        }
    }
    
    // Wrapper class
    public class OpportunityPaymentWrapper{
        public String opportunityName{get;set;}
        public Id opportunityId{get;set;}
        public OpportunityPaymentWrapper(String oppName, Id oppId){
            this.opportunityName = oppName;
            this.opportunityId = oppId;
        }
    }
}