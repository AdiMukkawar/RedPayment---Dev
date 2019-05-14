public class SendContractComp_Ctl {
    
    public Id oppid {get;set;}
   
    public String getContractLink(){
        String conLink = '';
        if(oppid != null){  
            List<Cloufi__UW_Document__c> uwDocList = new List<Cloufi__UW_Document__c>();
            uwDocList = [SELECT id,Stip_Name__c,Cloufi__URL__c,createdDate,Status__c FROM Cloufi__UW_Document__c WHERE Status__c='Completed' AND Stip_Name__c='Contract' AND Cloufi__URL__c !=null AND cloufi__Opportunity__c=:oppid order by createdDate DESC LIMIT 1];
            if(uwDocList.size()>0){
                conLink = uwDocList[0].Cloufi__URL__c;
            }
        }
        return conLink;                  
    }
    public List<Cloufi__UW_Document__c> getUWDocumentList(){
        List<Cloufi__UW_Document__c> uwDocList = new List<Cloufi__UW_Document__c>();
        if(oppid != null){            
            uwDocList = [SELECT Id, Stip_Name__c,Cloufi__URL__c FROM Cloufi__UW_Document__c WHERE cloufi__Opportunity__c=:oppid AND (Status__c = 'Requested' OR Status__c = 'Rejected') AND Cloufi__Type__c != 'Processing Statement'];            
        }
        return uwDocList;            
    }
}