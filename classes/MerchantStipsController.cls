/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: MerchantStipsController
* Created Date: 26-September-2018
* Description: Controller to show completed Documents to Merchant
*******************************************************************/
public class MerchantStipsController{
    public id opportunityId{get;set;}
    public opportunity objOpp{get;set;}
    public List<Cloufi__UW_Document__c> lstStips{get;set;}
    public boolean showHideButton {get;set;}
    public boolean isDownloadSpecificButtonDisabled {get; set;}
    public List<String> filesPathList{get;set;}
    
    public MerchantStipsController(ApexPages.StandardController controller) {
        opportunityId = ApexPages.currentPage().getParameters().get('id');
        objOpp = new Opportunity();
        lstStips = new List<Cloufi__UW_Document__c>();
        if(opportunityId != null){
            init();                               
        }
    }
    
    
    public void init(){        
        //Get the documents list
        objOpp  = [SELECT ID,Name,Cloufi__Dropbox_Folder_Path__c FROM Opportunity WHERE ID =: opportunityId];
        lstStips = new List<Cloufi__UW_Document__c>(); 
        lstStips = [select id,stip_Name__c,Cloufi__URL__c,Sent_to_Lender__c,Cloufi__Opportunity__c,Name,Cloufi__Type__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c=:opportunityId AND Cloufi__URL__c!=null AND Stip_Name__c !='Signed Application' AND Stip_Name__c!='Contract' AND Status__c = 'Completed' AND Sent_to_Lender__c=true];
        system.debug('lstStips=>'+lstStips);
        filesPathList = new List<String>();
        if(opportunityId != null){         
            for(Cloufi__UW_Document__c objDoc : [SELECT Id, Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c, Cloufi__Opportunity__r.id, Cloufi__URL__c FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c=:opportunityId AND Cloufi__URL__c!=null AND Stip_Name__c !='Signed Application' AND Stip_Name__c!='Contract' AND Status__c = 'Completed' AND Sent_to_Lender__c=true]){
                if(objDoc.Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c != null){
                    showHideButton = true;
                    String filepath = '';
                    filepath = objDoc.Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c.trim();
                    filepath += '/' + objDoc.Cloufi__URL__c.substringAfterLast('/').substringBefore('?').replace('%20',' ');
                    filesPathList.add(filePath);
                }else{
                    showHideButton = false;
                }
                if(objDoc.Cloufi__URL__c != null){
                    isDownloadSpecificButtonDisabled = false;
                }else{
                    isDownloadSpecificButtonDisabled = true;
                }
            }
            system.debug('filesPathList=>'+filesPathList);
        }
        
    }
   
}