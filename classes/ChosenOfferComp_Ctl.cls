public class ChosenOfferComp_Ctl{
    
    public Id oppId {get;set;}
    
    public List<Cloufi__UW_Document__c> getOfferDocs(){
        if(oppId != null){
            Opportunity objopp = [SELECT id,AccountId,(SELECT id,Cloufi__Offer_Status__c,Cloufi__Funder__c FROM Cloufi__Offers__r WHERE Cloufi__Offer_Status__c='Approved' LIMIT 1) FROM Opportunity WHERE id=:oppId];
            
            List<UW_Document_Share__c> lstShareDocs = [SELECT id,UW_Documents__c,Account__c,UW_Documents__r.stip_name__c,UW_Documents__r.Cloufi__URL__c FROM UW_Document_Share__c WHERE Account__c=:objopp.Cloufi__Offers__r[0].Cloufi__Funder__c AND Opportunity__c=:oppId AND UW_Documents__r.Cloufi__URL__c!=null];
            set<Id> uwIds = new set<Id>();
            for(UW_Document_Share__c objShare:lstShareDocs){
                uwIds.add(objShare.UW_Documents__c);
            }
            List<Cloufi__UW_Document__c> lstUW = new List<Cloufi__UW_Document__c>();
            if(uwIds.size()>0){
                lstUW = [SELECT id,Stip_Name__c,Cloufi__URL__c FROM Cloufi__UW_Document__c WHERE id in:uwIds];
            }
            if(lstUW.size()>0){
                return lstUW;
            }else{
                return null;
            }
        }
        return null;
    }
}