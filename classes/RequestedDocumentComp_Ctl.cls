public class RequestedDocumentComp_Ctl{
    
    public String Site_URL { get; set; }
    public Id oppid {get;set;}
    
    public string getLead(){
        List<Cloufi__LendingXL_Settings__c> sett= [select Cloufi__Value__c from Cloufi__LendingXL_Settings__c where Name = 'Site_URL' AND Cloufi__Value__c !=null LIMIT 1];
        Site_URL = sett[0].Cloufi__Value__c;
        if(oppid != null){
            //Opportunity objOpp = [SELECT id,Owner.Email,Lead__c,Owner_1_Email__c,(SELECT id,Cloufi__URL__c FROM Cloufi__Dropbox_Attachments__r),(SELECT id FROM Cloufi__Applications__r LIMIT 1) FROM Opportunity WHERE id=:oppid];
            //return Site_URL+'MissingDocuments?Id='+objOpp.Cloufi__Applications__r[0].id;
            return Site_URL+'OpportunityDocuments?Id='+oppid;
        }
        return null;
    }
    
    public List<String> getMissingDocs(){
        if(oppid != null){
            List<String> uwDocumentList = new List<String>();
            Set<String> bankStatements = new Set<String>();
            Set<String> otherDocuments = new Set<String>();
            
            Opportunity objOpp = [SELECT id,Owner.Email,Lead__c,Owner_1_Email__c,(SELECT id,Cloufi__URL__c,Stip_Name__c,Cloufi__Type__c  FROM Cloufi__Dropbox_Attachments__r WHERE (Status__c='Requested' OR Status__c='Rejected' OR (Status__c='Pending' AND Cloufi__URL__c=null)) AND Cloufi__Type__c!='Processing Statement' AND Cloufi__Type__c!='Control Sheet' AND Cloufi__Type__c!='Control Sheet Completed' AND Stip_Name__c!='ESC Reports' ORDER BY Stip_Name__c ASC) FROM Opportunity WHERE id=:oppid];
            //lstUW = objApp.Missing_Documents_Types__c.split(',');
            for(Cloufi__UW_Document__c objUW:objOpp.Cloufi__Dropbox_Attachments__r){
                if(objUW.Cloufi__Type__c == 'Bank Statement'){
                    bankStatements.add(objUW.Stip_Name__c);
                }else{
                    otherDocuments.add(objUW.Stip_Name__c);                
                }
            }
                        
            uwDocumentList.addAll(bankStatements);
            uwDocumentList.addAll(otherDocuments); 
            return uwDocumentList;
        }
        return null;
    }
}