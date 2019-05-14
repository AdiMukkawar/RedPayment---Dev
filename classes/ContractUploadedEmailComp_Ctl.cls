public class ContractUploadedEmailComp_Ctl {
    public Id oppId{get;set;}
               
    public string getOppLink(){
        string base_URL = System.URL.getSalesforceBaseURL().toExternalForm();
        return base_URL+'/'+oppId;
    }
    
    public List<Cloufi__UW_Document__c> getRequestedDocs(){
        if(oppId != null){       
            List<Cloufi__UW_Document__c> lstUW = new List<Cloufi__UW_Document__c>();
            Opportunity objopp = [SELECT id,(SELECT id, Name, Stip_Name__c FROM Cloufi__Dropbox_Attachments__r WHERE Status__c = 'Requested' AND Stip_Name__c != 'Contract' AND Cloufi__Type__c!='Processing Statement') FROM Opportunity WHERE id=:oppId];
                for(Cloufi__UW_Document__c objUWDoc : objopp.Cloufi__Dropbox_Attachments__r){
                    lstUW.add(objUWDoc);
                }
                return lstUW;
        }
        return null;
    }    
}