/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Neha Harle)
* Class Name: ControlSheetUploadController
* Created Date: 24-August-2018
* Description: Extension to upload control sheet
*******************************************************************
* Updates
* Author            | Date          | Description
* Aditya            | 08/29/2018    | To avoid creating duplicate control Sheet
* Aditya            | 15/02/2019    | After upload file should visible
**********************************************************************************/

public class ControlSheetUploadController {
    public List<Cloufi__UW_Document__c> UWList{get;set;}
    public List<Cloufi__UW_Document__c> controlSheet{get;set;}
    public id loanId{get;set;}
    public boolean showHideButton {get;set;}
    public boolean isDownloadSpecificButtonDisabled {get; set;}
    //public Attachment myfile{get;set;}
    public List<Cloufi__UW_Document__c> lstUWDuplicate{get;set;}
    public Cloufi__UW_Document__c objControlSheet{get;set;}
    public Opportunity objOpportunity{get;set;}
    public List<String> filesPathList{get;set;}
    public Opportunity loan{get; set;}
    public string customStipFileName{get;set;}
    public transient Blob customStipFileBody{get;set;}

    public ControlSheetUploadController(ApexPages.StandardController controller){
        
        if(controller.getId() == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please open this page from opportunity'));
        }
        
        init();
    }

    public void init(){
        customStipFileName = '';
        UWList = new List<Cloufi__UW_Document__c>();
        controlSheet = new List<Cloufi__UW_Document__c>();
        //myfile = new Attachment();
        loanId = ApexPages.currentPage().getParameters().get('Id');

        if(loanId != null){
            //UWList = [SELECT Name,Stip_Name__c,Cloufi__URL__c FROM Cloufi__UW_Document__c WHERE (Stip_Name__c LIKE '%Bank Statement%' OR Stip_Name__c LIKE '%Processing Statement%' OR Stip_Name__c LIKE '%Control Sheet Completed%') AND Cloufi__URL__c != null AND Cloufi__Opportunity__c =: loanId order by Cloufi__URL__c];
            //controlSheet = [select name,Stip_Name__c,Cloufi__URL__c from Cloufi__UW_Document__c where Cloufi__URL__c != null AND Stip_Name__c = 'Control Sheet' AND Cloufi__Opportunity__c =: loanId LIMIT 1];
            for(Cloufi__UW_Document__c objUWDocument : [SELECT Name, Control_Sheet_Version__c, Stip_Name__c,Cloufi__URL__c, Status__c, Cloufi__Type__c,Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c FROM Cloufi__UW_Document__c WHERE Stip_Name__c LIKE '%Control Sheet%' AND (Cloufi__Type__c = 'Control Sheet' OR Cloufi__Type__c = 'Control Sheet Completed') AND Cloufi__Opportunity__c =: loanId]){
                if(objUWDocument.Cloufi__Type__c == 'Control Sheet Completed'){
                    if(objUWDocument.Cloufi__URL__c != null && objUWDocument.Status__c == 'Completed'){
                        controlSheet.add(objUWDocument);
                    }
                }else{
                    objControlSheet = objUWDocument;
                    controlSheet.add(objUWDocument);
                }
            }
            //lstUWDuplicate = [SELECT id,Name,Stip_Name__c,Cloufi__Opportunity__c FROM Cloufi__UW_Document__c WHERE Cloufi__URL__c = NULL AND Stip_Name__c LIKE '%Control Sheet%' AND Cloufi__Opportunity__c =: loanId LIMIT 1];
            system.debug('controlSheet=>'+controlSheet);

            UWList = [SELECT Name,Stip_Name__c,Cloufi__URL__c FROM Cloufi__UW_Document__c WHERE Sent_to_Control_Sheet_Dept__c = true AND Cloufi__Opportunity__c =: loanId AND Cloufi__URL__c != null ORDER BY Cloufi__Type__c];

        loan = new Opportunity();  
        filesPathList = new List<String>();
            loan = [Select Id, Name from Opportunity where id =: loanId];
            for(Cloufi__UW_Document__c objDoc : [SELECT Id, Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c, Cloufi__Opportunity__r.id, Cloufi__URL__c 
                FROM Cloufi__UW_Document__c WHERE Cloufi__URL__c != null AND Cloufi__Opportunity__r.id =: loanId AND Sent_to_Control_Sheet_Dept__c = true]){
                system.debug('objDoc=>'+objDoc);
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
        } 
    }

public void uploadControlSheet(){ 
    if(customStipFileName!=null && customStipFileBody!=null && objControlSheet != null && objControlSheet.Id != null){
        String attachmentName;
        string randomString = generateRandomString(10);
        
        if(customStipFileName.length()>50){
            //attachmentName =  customStipFileName.left(50) + ' ' + randomString + '.' + customStipFileName.substringAfterLast('.');
            attachmentName =   'Conrtol Sheet_'+ controlSheet[0].Control_Sheet_Version__c + ' ' + randomString + '.' + customStipFileName.substringAfterLast('.');
        }else{
            //attachmentName =  customStipFileName.substringBeforeLast('.') + ' ' + randomString + '.' + customStipFileName.substringAfterLast('.');
            attachmentName =  'Conrtol Sheet_'+ controlSheet[0].Control_Sheet_Version__c + ' ' + randomString + '.' + customStipFileName.substringAfterLast('.');
        }
        system.debug('attachmentName=>'+attachmentName);
        //Generate Dropbox URL
        Cloufi__Dropbox_Settings__c dropBoxSetting = Cloufi__Dropbox_Settings__c.getOrgDefaults();
        String dropBoxToken = dropBoxSetting.Cloufi__Access_Token__c;
        String uploadOppAttach = 'https://content.dropboxapi.com/2/files/upload';
        
        String pathOppUpload = '';
        if(objControlSheet.Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c != null && objControlSheet.Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c != ''){
            pathOppUpload = '{"path":"'+objControlSheet.Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c+'/'+attachmentName+'","mode": "add","autorename": true,"mute": false}';
        }else{
            pathOppUpload = '{"path":"/Salesforce%20Documents/'+attachmentName+'","mode": "add","autorename": true,"mute": false}';
        }
        
        System.debug('pathOppUpload -> '+pathOppUpload);
        
        HttpRequest requestupload = new HttpRequest();
        requestupload.setEndpoint(uploadOppAttach);
        requestupload.setMethod('POST');
        requestupload.setHeader('Authorization','Bearer '+dropBoxToken);
        requestupload.setHeader('Dropbox-API-Arg', pathOppUpload);
        requestupload.setHeader('Content-Type', 'application/octet-stream');
        requestupload.setBodyAsBlob(customStipFileBody);
        requestupload.setTimeout(12000);
        Http hpPutUpload = new Http();
        HttpResponse responseFileUpload;
        String jsonFileResUpload;
        
        responseFileUpload = hpPutUpload.send(requestupload);
        jsonFileResUpload = responseFileUpload.getBody();
        
        system.debug('jsonFileResUpload-->'+jsonFileResUpload);
    
        String path_lowerFile;
        Map<String, Object> jsonURLMapUpload = (Map<String, Object>)JSON.deserializeUntyped(jsonFileResUpload);
        if(jsonURLMapUpload.get('path_lower')!= null){
            path_lowerFile = (String)jsonURLMapUpload.get('path_lower');
            //callout to create shared link of uploaded file
            String ShareOppUrl = 'https://api.dropboxapi.com/2/sharing/create_shared_link_with_settings';
            String inputSharePath = '{"path":"'+path_lowerFile+'" ,"settings": {"requested_visibility": "public"}}';
            HttpRequest requestForSearchUrl = new HttpRequest();
            requestForSearchUrl.setEndpoint(ShareOppUrl);
            requestForSearchUrl.setMethod('POST');
            requestForSearchUrl.setHeader('Authorization','Bearer '+dropboxToken);
            requestForSearchUrl.setHeader('Content-Type','application/json');        
            requestForSearchUrl.setBody(inputSharePath);        
            requestForSearchUrl.setTimeout(12000);
            Http hpShare = new Http();
            HttpResponse responseShare;
            String jsonResShare;
              
            responseShare = hpShare.send(requestForSearchUrl);
            jsonResShare = responseShare.getBody();

            System.debug('response body -->> '+jsonResShare);

            String jsonSearchURL;
            Map<String, Object> jsonURLShareNew = (Map<String, Object>)JSON.deserializeUntyped(jsonResShare);
            if(jsonURLShareNew.get('url')!= null){
                jsonSearchURL = (String)jsonURLShareNew.get('url');
                jsonSearchURL = jsonSearchURL.replace('?dl=0', '?dl=1');
                System.debug('url -->> '+jsonSearchURL);
                objControlSheet.Cloufi__URL__c = jsonSearchURL;
                update objControlSheet;
            }
        }
    }
    init();
}

    //method to generate random string to append before file name
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
}