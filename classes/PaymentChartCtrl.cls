/*****************************************************************
* Author: Techila Global Services Pvt Ltd (Aditya Mukkawar)
* Class Name: PaymentChartCtrl
* Created Date: 02/06/2019
* Description: Controller class for PaymentChart component
*******************************************************************/
public class PaymentChartCtrl {
	@auraEnabled
    public static List<accountList> getAccountList(Id oppId){
        
        List<accountList> listAcc = new List<accountList>();
        set<Id> accIds = new set<Id>();    
        for(Cloufi__Payments__c sRecordType : [SELECT Id,Cloufi__Account__c,Cloufi__Account__r.name, Name FROM Cloufi__Payments__c WHERE Cloufi__Opportunity__c=:oppId]){
            //listAcc.add(new accountList(sRecordType.Cloufi__Account__c, sRecordType.Cloufi__Account__r.name));
            accIds.add(sRecordType.Cloufi__Account__c);
        }
        if(accIds.size()>0){
	        for(Account objAcc:[SELECT id,Name FROM Account WHERE id IN:accIds]){
	        	listAcc.add(new accountList(objAcc.id, objAcc.name));
	        }
        }
        
        System.debug('listAcc==>'+listAcc);
        return listAcc;
    }
    
    
    public class accountList{
        @auraEnabled
        public String accId{get;set;}
        
        @auraEnabled
        public String accName{get;set;}
        
        public accountList(String accId, String accName){
            this.accId = accId;
            this.accName = accName;
        }
    }
}