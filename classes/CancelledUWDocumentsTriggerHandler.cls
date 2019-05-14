public class CancelledUWDocumentsTriggerHandler{
    public static void moveDropboxFile(List<Cancelled_UW_Document__c> cancelledUDDocList){
        Set<Id> cancelledUDDocIdSet = new Set<Id>();
        for(Cancelled_UW_Document__c objCancelledUDDoc : cancelledUDDocList){
            cancelledUDDocIdSet.add(objCancelledUDDoc.Id);
        } 
        if(cancelledUDDocIdSet.size()>0){
            CancelledUWDocumentsTriggerHandler.moveDropboxFile(cancelledUDDocIdSet);
        }  
    }
    
    
    public static void deleteDropboxFile(String URL , String folderPath, String cancelledFolderPath){
        
        if(URL != null && URL !='' && folderPath !=null && folderPath != '' && cancelledFolderPath != null && cancelledFolderPath !=''){
            CancelledUWDocumentsTriggerHandler.deleteDropboxFiles(URL,folderPath,cancelledFolderPath);
        }
        
    }

    @Future(callout=true)
    public static void moveDropboxFile(Set<Id> cancelledUDDocIdSet){

        for(Cancelled_UW_Document__c canceledUDDOc : [SELECT Id, URL__c,UW_Documents__r.Cloufi__Opportunity__r.Cancelled_Dropbox_Folder_Path__c,UW_Documents__r.Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c FROM Cancelled_UW_Document__c WHERE Id IN : cancelledUDDocIdSet]){
            Cloufi__Dropbox_Settings__c dropBoxSetting = Cloufi__Dropbox_Settings__c.getOrgDefaults();
            String token = dropBoxSetting.Cloufi__Access_Token__c;      
            
            string fileName = String.valueOf(canceledUDDOc.URL__c);     
            fileName = fileName.substringAfterLast('/');
            fileName = fileName.substringBefore('?');
            
            String requestBody = '{"from_path": "'+canceledUDDOc.UW_Documents__r.Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c+'/'+fileName+'","to_path": "'+canceledUDDOc.UW_Documents__r.Cloufi__Opportunity__r.Cancelled_Dropbox_Folder_Path__c+'/'+fileName+'","autorename": true,"allow_ownership_transfer": true}';
            requestBody = requestBody.replace('%20',' ');
            
            
            String moveFilerURL = 'https://api.dropboxapi.com/2/files/move_v2';
            HttpRequest createFolderRequest = new HttpRequest();
            createFolderRequest.setEndpoint(moveFilerURL);
            createFolderRequest.setMethod('POST');
            createFolderRequest.setHeader('Authorization','Bearer '+token);
            createFolderRequest.setHeader('Content-Type', 'application/json');
            createFolderRequest.setBody(requestBody);
            createFolderRequest.setTimeout(12000);
            Http objHTTP = new Http();
            HttpResponse objHTTPResponse;
            String responseString;  
            System.debug('createFolderRequest -> '+createFolderRequest);
            objHTTPResponse = objHTTP.send(createFolderRequest);
            responseString = objHTTPResponse.getBody();
        }
    }
    
    @Future(callout=true)
    public static void deleteDropboxFiles(String URL , String folderPath, String cancelledFolderPath){
        
        
        
        Cloufi__Dropbox_Settings__c dropBoxSetting = Cloufi__Dropbox_Settings__c.getOrgDefaults();
        String token = dropBoxSetting.Cloufi__Access_Token__c;
        
        string fileName = EncodingUtil.urlDecode(URL, 'UTF-8');
        System.debug('fileName -> '+fileName);
        fileName = fileName.substringAfterLast('/');
        fileName = fileName.substringBefore('?');
        
        String requestBody = '{"from_path": "'+folderPath+'/'+fileName+'","to_path": "'+cancelledFolderPath+'/'+fileName+'","autorename": true,"allow_ownership_transfer": true}';
        requestBody = requestBody.replace('%20',' ');
        

        String moveFilerURL = 'https://api.dropboxapi.com/2/files/move_v2';
        HttpRequest createFolderRequest = new HttpRequest();
        createFolderRequest.setEndpoint(moveFilerURL);
        createFolderRequest.setMethod('POST');
        createFolderRequest.setHeader('Authorization','Bearer '+token);
        createFolderRequest.setHeader('Content-Type', 'application/json');
        createFolderRequest.setBody(requestBody);
        createFolderRequest.setTimeout(12000);
        Http objHTTP = new Http();
        HttpResponse objHTTPResponse;
        String responseString;  
        System.debug('createFolderRequest -> '+createFolderRequest);
        if(!Test.isRunningTest()){
       	objHTTPResponse = objHTTP.send(createFolderRequest);
        responseString = objHTTPResponse.getBody();
        }
    }
 }