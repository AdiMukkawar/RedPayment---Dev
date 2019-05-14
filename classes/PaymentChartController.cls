/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya)
* Class Name: PaymentChartController
* Created Date: 23-Aug-2018
* Description: 
*******************************************************************/

public class PaymentChartController{
    public id oppId{get;set;}
    public List<Cloufi__Payments__c> paymentList{get;set;}
    public Cloufi__Payments__c objPayment{get;set;}
    public Date effectiveDateFrom{get;set;}
    public Date effectiveDateTo{get;set;}
    public Date settlementDateFrom{get;set;}
    public Date settlementDateTo{get;set;}
    public List<RecordType> listRecordType{get;set;}
    //CSV file 
    public List<wrapper> lstwrapper {get; set;}
    //public list<SelectOption> rtOptions{get;set;}
    public string recordTypeId {get; set;}
    public string accId {get; set;}
    public string effDate {get; set;}
    public string settDate {get; set;}
    
    public PaymentChartController(ApexPages.StandardController controller) {
        oppId = ApexPages.currentPage().getParameters().get('id');
        paymentList = new List<Cloufi__Payments__c>();
        objPayment = new Cloufi__Payments__c();
        //CSV file
        lstwrapper = new List<wrapper>();
        listRecordType = [SELECT id, Name FROM RecordType WHERE SobjectType = 'Cloufi__Payments__c'];
    }
    
    //list of record types
    public list<SelectOption> getRecordTypes(){
        List<SelectOption> rtOptions = new List<SelectOption>{
            new SelectOption('','-Select-')
        };
        for(RecordType sRecordType : [SELECT Id, Name FROM RecordType WHERE sObjectType = 'Cloufi__Payments__c']){
            rtOptions.add(new SelectOption(sRecordType.Id, sRecordType.Name));
        }
        return rtOptions;
    }
    
    //list of Accounts
    public list<SelectOption> getAccounts(){
        List<SelectOption> accOptions = new List<SelectOption>{
            new SelectOption('','-Select-')
        };
        Set<SelectOption> accOptions1 = new Set<SelectOption>();
        for(Cloufi__Payments__c sRecordType : [SELECT Id,Cloufi__Account__c,Cloufi__Account__r.name, Name FROM Cloufi__Payments__c WHERE Cloufi__Opportunity__c=:oppId]){
            accOptions1.add(new SelectOption(sRecordType.Cloufi__Account__c, sRecordType.Cloufi__Account__r.name));
        }
        accOptions.addAll(accOptions1);
        return accOptions;
    }
    
    //Effective date
    public list<SelectOption> getEffectiveDate(){
        List<SelectOption> effOptions = new List<SelectOption>{
            new SelectOption('','-Select-')
        };
        effOptions.add(new SelectOption('30', 'Last One Month'));
        effOptions.add(new SelectOption('60', 'Last Two Month'));
        effOptions.add(new SelectOption('120', 'Last Four Month'));
        effOptions.add(new SelectOption('180', 'Last Six Month'));
        return effOptions;
    }
    //Settlement date
    public list<SelectOption> getSettlementDate(){
        List<SelectOption> settOptions = new List<SelectOption>{
            new SelectOption('','-Select-')
        };
        settOptions.add(new SelectOption('30', 'Last One Month'));
        settOptions.add(new SelectOption('60', 'Last Two Month'));
        settOptions.add(new SelectOption('120', 'Last Four Month'));
        settOptions.add(new SelectOption('180', 'Last Six Month'));
        return settOptions;
    }
    
    public pageReference showPaymentList(){
        paymentList.clear();
        system.debug('accId=>'+accId);
        if(objPayment.Cloufi__Payment_Type__c != null || objPayment.Cloufi__Status__c != null || effectiveDateFrom != null || effectiveDateTo != null || settlementDateFrom != null || settlementDateTo != null || recordTypeId != null || accId != null || effDate!=null || settDate!=null){
            string query = 'SELECT id,Name,Cloufi__Account__c,RecordTypeId,RecordType.Name,Cloufi__Account__r.name,Cloufi__Payment_Amount__c,Cloufi__Status__c,Cloufi__Payment_Type__c,Cloufi__Effective_Date__c, CloufiServicing__Expected_Settlement_Date__c,CloufiServicing__Is_Internal__c FROM Cloufi__Payments__c WHERE Cloufi__Opportunity__c=:oppId';
            if(recordTypeId!=null){
                query+='  AND RecordTypeId=:recordTypeId';
            }
            if(accId != null){
                system.debug('accId=>'+accId);
                query+='  AND Cloufi__Account__c=:accId';
            }
            if(objPayment.CloufiServicing__Is_Internal__c){
                query+='  AND CloufiServicing__Is_Internal__c=true';
            }
            if(objPayment.Cloufi__Payment_Type__c!=null){
                string payType = objPayment.Cloufi__Payment_Type__c;
                query+='  AND Cloufi__Payment_Type__c=:payType';
            }
            if(objPayment.Cloufi__Status__c!=null){
                string payStatus = objPayment.Cloufi__Status__c;
                query+='  AND Cloufi__Status__c=:payStatus';
            }
            if(effDate != null){
                query+='  AND Cloufi__Effective_Date__c = LAST_N_DAYS:'+effDate;
            }
            if(settDate != null){
                query+='  AND Cloufi__Effective_Date__c = LAST_N_DAYS:'+settDate;
            }
            
            if(effectiveDateFrom != null && effectiveDateTo != null){
                query+='  AND Cloufi__Effective_Date__c >:effectiveDateFrom and Cloufi__Effective_Date__c <:effectiveDateTo';
            }
            if(settlementDateFrom != null && settlementDateTo != null){
                query+='  AND CloufiServicing__Expected_Settlement_Date__c >:settlementDateFrom and CloufiServicing__Expected_Settlement_Date__c <:settlementDateTo';
            }
            system.debug('query=>'+query);
            paymentList = Database.query(query);
            system.debug('paymentList=>'+paymentList);
        }
        return null;
    }
    public PageReference generateCSV(){
        PageReference objPR = new PageReference('/apex/PaymentChartExport');
        objPR.setRedirect(false);
        return objPR;
    }
    
    public void exportToCSV(){
        system.debug('paymentList :'+paymentList.size());
        if(paymentList.size()>0){
            for(Cloufi__Payments__c pay :paymentList){
                wrapper w = new wrapper();
                w.name = pay.Name ;
                w.account = pay.Cloufi__Account__r.name ;
                w.RecordType = pay.RecordType.Name;
                w.paymentAmount = string.valueof(pay.Cloufi__Payment_Amount__c);
                w.Status = pay.Cloufi__Status__c ;
                w.PaymentType = pay.Cloufi__Payment_Type__c;
                w.effectiveDate = string.valueof(pay.Cloufi__Effective_Date__c);
                w.settlementDate = string.valueOf(pay.CloufiServicing__Expected_Settlement_Date__c);
                lstwrapper.add(w);               
            }             
        }
        system.debug('lstwrapper :'+lstwrapper.size());
    }
    
    public class wrapper{
        public string name {get; set;}
        public string account {get; set;}
        public string RecordType{get; set;}
        public string paymentAmount{get; set;}
        public string Status{get; set;}
        public string PaymentType{get; set;}
        public string effectiveDate{get; set;}
        public string settlementDate{get; set;}
        
    }
}