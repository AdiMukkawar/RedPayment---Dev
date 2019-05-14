/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: SendStipstoSalesRepComp_Ctl
* Test Class Name: SendStipstoSalesRepComp_Ctl_Test
* Created Date: 09/18/2018
* Description: controller class for SendStipstoSalesRepComp VF component
-------------------------------------------------------------------
Aditya Mukkawar | 10/10/2018 | Checking docs whose status is requested, pending with no docs and  Rejected 
*******************************************************************/
public class SendStipstoSalesRepComp_Ctl{
    
    public String Site_URL { get; set; }
    public Id oppid {get;set;}
    public Opportunity objOpp{get;set;}
    
    public string getOpp(){
        String baseUrl = Label.Base_URL;
        if(oppid != null){
            return baseUrl+'/'+oppid;
        }
        return null;
    }
    
    public List<String> getMissingDocs(){
        if(oppid != null){
            List<String> uwDocumentList = new List<String>();
            Set<String> bankStatements = new Set<String>();
            Set<String> otherDocuments = new Set<String>();
            
            Opportunity objOpp = [SELECT id,Owner.Email,Lead__c,Owner_1_Email__c,(SELECT id,Cloufi__URL__c,Stip_Name__c,Cloufi__Type__c  FROM Cloufi__Dropbox_Attachments__r WHERE (Status__c='Requested' OR Status__c='Rejected' OR (Status__c='Pending' AND Cloufi__URL__c=null)) AND Cloufi__Type__c!='Processing Statement' AND Cloufi__Type__c!='Control Sheet' AND Cloufi__Type__c!='Control Sheet Completed' AND Stip_Name__c!='ESC Reports' ORDER BY Stip_Name__c ASC) FROM Opportunity WHERE id=:oppid];
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