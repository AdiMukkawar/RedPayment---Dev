public with sharing class DownloadAllUWDocumentsControllerX {
    
    public String opportunityId{get;set;}
    public Opportunity objOpportunity{get;set;}
    
    public DownloadAllUWDocumentsControllerX(ApexPages.StandardController controller) {
        if(ApexPages.currentPage().getParameters().get('id') != null){
            opportunityId = ApexPages.currentPage().getParameters().get('id');
            objOpportunity = [SELECT Id, Name, (SELECT Id, Cloufi__URL__c FROM Cloufi__Dropbox_Attachments__r WHERE Cloufi__URL__c != null) FROM Opportunity WHERE Id =: opportunityId];
            if(objOpportunity.Cloufi__Dropbox_Attachments__r.size()>0){
                for(Cloufi__UW_Document__c objUWDocument : objOpportunity.Cloufi__Dropbox_Attachments__r){
                    
                }
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No Documents under this Opportunity'));
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Page must be invoked from Opportunity'));
        }
    }
    
    public PageReference downloadAllUWDocs(){
        Cloufi__Dropbox_Settings__c dropBoxSetting = Cloufi__Dropbox_Settings__c.getOrgDefaults();
        //String token = dropBoxSetting.Cloufi__Access_Token__c;    	
        String token = 'FnQByQGyL9AAAAAAAAAAD3cwjlULUEZDtxHGa9B4zgF_yedi9HC5o9SqbcAZmw9b';
        String downloadZipPath = 'https://content.dropboxapi.com/2/files/download_zip';
        String downloadPath = '{"path": "/Merchant Services/Techila Testing 21 Jan"}'; //'{"path": "","query": "'+organizationName+'","start": 0,"max_results": 100,"mode": "filename"}';
        HttpRequest requestDownloadZip = new HttpRequest();
        requestDownloadZip.setEndpoint(downloadZipPath);
        requestDownloadZip.setMethod('POST');
        requestDownloadZip.setHeader('Authorization','Bearer '+token);
        requestDownloadZip.setHeader('Dropbox-API-Arg', downloadPath);
        //requestDownloadZip.setbody(downloadPath);        
        requestDownloadZip.setTimeout(12000);
        Http hpPutOrgSearch = new Http();
        HttpResponse responseOrgSearch;
        String jsonOrgresSearch;  
        System.debug('requestDownloadZip ->'+requestDownloadZip);
        if(!Test.isRunningTest()){
            responseOrgSearch = hpPutOrgSearch.send(requestDownloadZip);
            System.debug('jsonOrgresSearch Blob->'+blob.valueOf(responseOrgSearch.getBody()));
            System.debug('jsonOrgresSearch body->'+responseOrgSearch.getBody());
            jsonOrgresSearch = responseOrgSearch.getBody();	
            System.debug('jsonOrgresSearch ->'+jsonOrgresSearch);
            System.debug('jsonOrgresSearch Blob->'+blob.valueOf(jsonOrgresSearch));
        }else{
            jsonOrgresSearch = '200,4,48.5,-123.67';
        }
        
        
        /*Http objHttp = new Http();
HttpResponse objResponse = new HttpResponse();
objResponse = objHttp.send(requestDownloadZip);
String jsonOrgresSearch = objResponse.getBody();
System.debug('objResponse Body ->'+objResponse.getBody());*/
        return null;
    }
    
    public PageReference downloadOneUWDoc(){
        Cloufi__Dropbox_Settings__c dropBoxSetting = Cloufi__Dropbox_Settings__c.getOrgDefaults();
        //String token = dropBoxSetting.Cloufi__Access_Token__c;    	
        String token = 'FnQByQGyL9AAAAAAAAAAD3cwjlULUEZDtxHGa9B4zgF_yedi9HC5o9SqbcAZmw9b';
        String downloadZipPath = 'https://content.dropboxapi.com/2/files/download';
        String downloadPath = '{"path": "/Merchant Services/Techila Testing 21 Jan/Chrysanthemum d8ACzoQi7M.jpg"}'; //'{"path": "","query": "'+organizationName+'","start": 0,"max_results": 100,"mode": "filename"}';
        HttpRequest requestDownloadZip = new HttpRequest();
        requestDownloadZip.setEndpoint(downloadZipPath);
        requestDownloadZip.setMethod('POST');
        requestDownloadZip.setHeader('Authorization','Bearer '+token);
        requestDownloadZip.setHeader('Dropbox-API-Arg', downloadPath);
        //requestDownloadZip.setbody(downloadPath);        
        requestDownloadZip.setTimeout(12000);
        Http hpPutOrgSearch = new Http();
        HttpResponse responseOrgSearch;
        String jsonOrgresSearch;  
        System.debug('requestDownloadZip ->'+requestDownloadZip);
        if(!Test.isRunningTest())
        {
            responseOrgSearch = hpPutOrgSearch.send(requestDownloadZip);
            System.debug('jsonOrgresSearch->'+responseOrgSearch);
            System.debug('jsonOrgresSearch Blob->'+blob.valueOf(responseOrgSearch.getBody()));
            System.debug('jsonOrgresSearch body->'+responseOrgSearch.getBody());
            jsonOrgresSearch = responseOrgSearch.getBody();	
            System.debug('jsonOrgresSearch ->'+jsonOrgresSearch);
            System.debug('jsonOrgresSearch Blob->'+blob.valueOf(jsonOrgresSearch));
        }else{
            jsonOrgresSearch = '200,4,48.5,-123.67';
        }
        
        Attachment objAttachement = new Attachment();
        objAttachement.ParentId = objOpportunity.Id;
        objAttachement.Body = blob.valueOf(jsonOrgresSearch);
        objAttachement.Name = 'Chrysanthemum d8ACzoQi7M.jpg';
        insert objAttachement;
        /*Http objHttp = new Http();
HttpResponse objResponse = new HttpResponse();
objResponse = objHttp.send(requestDownloadZip);
String jsonOrgresSearch = objResponse.getBody();
System.debug('objResponse Body ->'+objResponse.getBody());*/
        //return null;
        PageReference objPR = new PageReference('/'+objAttachement.Id);
        return objPR;
    }    
}