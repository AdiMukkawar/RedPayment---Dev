public with sharing class DownloadUWDocCntl {
    public Opportunity objOpportunity{get;set;}
    public List<String> filesPathList{get;set;}
    
    public DownloadUWDocCntl(ApexPages.StandardController controller) {
        String oppId = ApexPages.currentPage().getParameters().get('id');
        objOpportunity = new Opportunity();
        filesPathList = new List<String>();
        if(oppID != null){            
            objOpportunity = [SELECT ID,Name,Cloufi__Dropbox_Folder_Path__c FROM Opportunity WHERE ID =: oppID];            
            for(UW_Document_Share__c objDoc : [SELECT Id, Opportunity__r.Cloufi__Dropbox_Folder_Path__c, UW_Documents__c, UW_Documents__r.Cloufi__URL__c FROM UW_Document_Share__c WHERE UW_Documents__c != null AND UW_Documents__r.Cloufi__URL__c != null AND Opportunity__c =: oppId]){
                String filepath = '';
                filepath = objDoc.Opportunity__r.Cloufi__Dropbox_Folder_Path__c.trim();
                filepath += '/' + objDoc.UW_Documents__r.Cloufi__URL__c.substringAfterLast('/').substringBefore('?').replace('%20',' ');
                filesPathList.add(filePath);
            }
        }
    }
}