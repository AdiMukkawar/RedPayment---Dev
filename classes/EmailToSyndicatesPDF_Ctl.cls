/*****************************************************************
* Author: Aditya Mukkawar
* Class Name: emailToSyndicatesPDF_Ctl
* Test Class Name: emailToSyndicates_Test
* Created Date: 12/17/2018
* Description: controller class for emailToSyndicatesPDF Page
*******************************************************************/
public class EmailToSyndicatesPDF_Ctl{
    
    public string syndId{get;set;}
    public string numberOfDays{get;set;}
    public Decimal totalACHAmnt{get;set;}
    public Decimal totalACHTodayAmnt{get;set;}
    public Decimal totalMngFee{get;set;}
    public Integer totalMerchants{get;set;}
    public List<Cloufi__Payments__c> payList{get;set;}
    public CloufiServicing__Syndication__c objSynd{get;set;}
    
    public EmailToSyndicatesPDF_Ctl(ApexPages.StandardController controller) {
        syndId = ApexPages.currentPage().getParameters().get('id');
        numberOfDays = ApexPages.currentPage().getParameters().containsKey('days') ? ApexPages.currentPage().getParameters().get('days') : null;
        system.debug('syndId=>'+syndId+' numberOfDays=>'+numberOfDays);
        objSynd = new CloufiServicing__Syndication__c();
        objSynd = [SELECT id,Name,CloufiServicing__Syndicating_Account__r.Name,CloufiServicing__Running_Balance__c FROM CloufiServicing__Syndication__c WHERE id=:syndId];
        getPayList();
    }
    
    public void getPayList(){
        /*if(numberOfDays=='0'){
            numberOfDays = '1';
        }*/
        Date d = System.today() - Integer.ValueOf(numberOfDays);
        payList = [SELECT id,Cloufi__Payment_Amount__c,CloufiServicing__Management_Fee_Paid__c,Cloufi__Opportunity__c,Cloufi__Opportunity__r.Name,Cloufi__Opportunity__r.Type,Cloufi__Payment_Type__c,RecordType.Name,Cloufi__Status__c,Cloufi__Account__c,CloufiServicing__Syndication__c,CloufiServicing__Expected_Settlement_Date__c FROM Cloufi__Payments__c WHERE CloufiServicing__Syndication__c=:syndId AND RecordType.Name='Payment Out' AND Cloufi__Status__c='Settled' AND CloufiServicing__Expected_Settlement_Date__c = yesterday AND Cloufi__Payment_Type__c='Syndication Payment'];
        totalACHAmnt = 0;
        totalACHTodayAmnt = 0;
        totalMngFee = 0;
        set<Id> oppIds = new set<Id>();
        for(Cloufi__Payments__c objPay:payList){
            oppIds.add(objPay.Cloufi__Opportunity__c);
            if(objPay.Cloufi__Payment_Amount__c != null){
                totalACHAmnt = totalACHAmnt + objPay.Cloufi__Payment_Amount__c;
            }
            if(objPay.CloufiServicing__Management_Fee_Paid__c != null){
                totalMngFee = totalMngFee + objPay.CloufiServicing__Management_Fee_Paid__c;
            }
            totalACHTodayAmnt = totalACHAmnt - totalMngFee;
            system.debug('totalACHTodayAmnt >>'+totalACHTodayAmnt);
        }
        if(oppIds.size() >0){
            totalMerchants = oppIds.size();
        }
    }
}