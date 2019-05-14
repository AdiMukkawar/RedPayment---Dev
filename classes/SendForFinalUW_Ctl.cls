public class SendForFinalUW_Ctl{

    public Id oppid {get;set;}
    
    public string getMerchantStipPageLink(){
        List<Cloufi__LendingXL_Settings__c> sett= [select Cloufi__Value__c from Cloufi__LendingXL_Settings__c where Name = 'Site_URL' AND Cloufi__Value__c !=null LIMIT 1];
        String Site_URL = sett[0].Cloufi__Value__c;
        if(oppid != null){
            return Site_URL+'MerchantStips?Id='+oppid;
        }
        return null;
    }
    
    
    public List<String> getCompletedDocs(){
        if(oppid != null){
            List<String> lstUW = new List<String>();
            Opportunity objOpp = [SELECT id,Owner.Email,Lead__c,Owner_1_Email__c,(SELECT id,Cloufi__URL__c,Stip_Name__c FROM Cloufi__Dropbox_Attachments__r WHERE Cloufi__URL__c!=null AND Stip_Name__c !='Signed Application' AND Stip_Name__c!='Contract' AND Status__c = 'Completed' AND Sent_to_Lender__c=true ORDER BY Stip_Name__c ASC) FROM Opportunity WHERE id=:oppid];
            //lstUW = objApp.Missing_Documents_Types__c.split(',');
            for(Cloufi__UW_Document__c objUW:objOpp.Cloufi__Dropbox_Attachments__r){
                lstUW.add(objUW.Stip_Name__c);
            }
            return lstUW;
        }
        return null;
    }    
}