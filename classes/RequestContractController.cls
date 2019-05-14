public class RequestContractController {
	// Aditya -  Get UW documents those are completed
     @AuraEnabled
    public static List<Cloufi__UW_Document__c> getUWDocumentList(Id oppId){
        return [select id,Stip_Name__c,Cloufi__URL__c,Cloufi__Opportunity__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c= : oppId and Cloufi__URL__c!=null AND Status__c='Completed'];
    }
}