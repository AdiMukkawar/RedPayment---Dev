public class Opp_CTR_DownloadAttachment {
    public static String accessToken;
    public static void downloadFiles(Id opportunityId){
        String filepath;
        String docName = 'apex-zip-'+opportunityId+'.zip'; // Document's name
        try{
            Cloufi__Dropbox_Settings__c dropBoxSetting = Cloufi__Dropbox_Settings__c.getOrgDefaults();
            accessToken = dropBoxSetting.Cloufi__Access_Token__c;
            
            for(Cloufi__UW_Document__c objDoc : [SELECT Id, Name, Cloufi__URL__c, Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c =: opportunityId]){
                if(objDoc.Cloufi__URL__c != null){
                    filepath = '';
                    filepath = objDoc.Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c.trim();
                    filepath += '/' + objDoc.Cloufi__URL__c.substringAfterLast('/').substringBefore('?').replace('%20',' ');
                }
            }
            
            if(filepath != null){
                Document doc = new Document();
                doc.FolderId = UserInfo.getUserId();
                doc.Name = docName;
                doc.Body = null;
                insert doc;
                System.debug('doc '+doc);
            }
            //PageReference objDoc = new PageReference();
            
        }catch(Exception ex){
            system.debug('Error message==> '+ex.getMessage());
            system.debug('Error Trace ==> '+ex.getStackTRaceString());
        }
    }
    
    public static Blob callout(String filepath){
        System.debug('filepath==>'+filepath);
        String uploadOppAttach = 'https://content.dropboxapi.com/2/files/download';
        String pathOppUpload = '{"path":"'+filepath+'"}';
        HttpRequest requestupload = new HttpRequest();
        requestupload.setEndpoint(uploadOppAttach);
        requestupload.setMethod('POST');
        requestupload.setHeader('Authorization','Bearer '+accessToken);
        requestupload.setHeader('Dropbox-API-Arg', pathOppUpload);
        requestupload.setTimeout(12000);
        Http hpPutUpload = new Http();
        HttpResponse responseFileUpload;
        String jsonFileResUpload;
        
        if(!Test.isRunningTest()){
            responseFileUpload = hpPutUpload.send(requestupload);
            jsonFileResUpload = responseFileUpload.getBody();
        }
        else{
            jsonFileResUpload = '200,4,48.5,-123.67';
        }        
        //system.debug('jsonFileResUpload-->'+jsonFileResUpload);
        blob filebodyBlob;
        
        if(jsonFileResUpload != null){
            String convertedText = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256',Blob.valueOf(jsonFileResUpload)));
            System.debug('convertedText '+convertedText+ 'length '+convertedText.length());
            filebodyBlob = Blob.valueOf(jsonFileResUpload); //EncodingUtil.base64Decode(convertedText);
            String test = EncodingUtil.base64Encode(filebodyBlob);
            System.debug('test '+test);
            //filebodyBlob = Crypto.generateDigest('SHA-256',Blob.valueOf(jsonFileResUpload));
            //System.debug('filebodyBlob '+filebodyBlob);
            
            return filebodyBlob;
        }
        return null;
    }
    
    /*public class parameters{
public String fileName;
public String fileBody;

public parameters(String fileName, String fileBody){
this.fileName = fileName;
this.fileBody = fileBody;
}
}*/
}