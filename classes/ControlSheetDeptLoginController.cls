/******************************************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: ControlSheetDeptLoginController
* Test Class: ControlSheetDeptLoginController_Test
* Created Date: 11-April-2019
* Description: Controller for Control Sheet portal
*******************************************************************
*Author             | Date       | Description
*
******************************************************************************************/

public class ControlSheetDeptLoginController{
    
    public Contact objContact {get; set;}
    public List<Contact> tempUserId;

    public String username {get; set;}
    public string password {get;set;} 
    public string confirmPassword {get;set;}
    public String accessCode{get;set;}
    public String NewPassword {get;set;}
    public String ConfirmNewPassword {get;set;}
    public string userid {get;set;}

    public List<opportunity> requestedOpportunityList{get; set;}
    public List<opportunity> pendingOpportunityList{get; set;}
    public boolean displayPanel{get;set;}
    public boolean displayOppPanel{get;set;}
    public boolean displaySheetPanel{get;set;}
    public string selectedOppId{get;set;}
    public String msg{get; set;}
    public String initMsg{get; set;}
    public String contactName{get; set;}
    public List<Cloufi__UW_Document__c> UWList{get;set;}
    public List<Cloufi__UW_Document__c> controlSheet{get;set;}
    public boolean showHideButton {get;set;}
    public boolean isDownloadSpecificButtonDisabled {get; set;}
    public List<Cloufi__UW_Document__c> lstUWDuplicate{get;set;}
    public Cloufi__UW_Document__c objControlSheet{get;set;}
    public Opportunity objOpportunity{get;set;}
    public string customStipFileName{get;set;}
    public transient Blob customStipFileBody{get;set;}

    // Constructor
    public ControlSheetDeptLoginController(ApexPages.StandardController controller) {
        displayPanel= false;
        displayOppPanel = false;
        accessCode = '';
        userid = Apexpages.currentPage().getParameters().get('id');  
        System.debug('New check on the user ID = '+userid); 
        tempUserId = new List<Contact> ();
    }


    // Method to initialize opportunity records
    public void initializeOpportunityRecords(){
        Set<Id> requestedOppIds = new Set<Id>();
        Set<Id> pendingOppIds = new Set<Id>();
        requestedOpportunityList = new List<opportunity>();
        pendingOpportunityList = new List<opportunity>();
        Contact objCon = [Select Id, Name from Contact Where Id =: userid];
        contactName = objCon.Name;
        List<UW_Document_Share__c> uwDocShareList = new List<UW_Document_Share__c>();
        uwDocShareList = [SELECT id,Account__c,Control_Sheet_Contact__c,Opportunity__c,UW_Documents__c,UW_Documents__r.Status__c,UW_Documents__r.Cloufi__Type__c FROM UW_Document_Share__c WHERE Control_Sheet_Contact__c=:userid AND UW_Documents__r.Cloufi__Type__c = 'Control Sheet' AND (UW_Documents__r.Status__c='Requested' OR UW_Documents__r.Status__c='Pending')];
        for(UW_Document_Share__c objUWShare:uwDocShareList){
            if(objUWShare.UW_Documents__r.Status__c=='Requested'){
                requestedOppIds.add(objUWShare.Opportunity__c);
            }else{
                pendingOppIds.add(objUWShare.Opportunity__c);
            }
        }
        
        if(requestedOppIds.size() > 0 || pendingOppIds.size() > 0){
            displayOppPanel = true;
            if(requestedOppIds.size() > 0){
                requestedOpportunityList = [SELECT Id, Name From Opportunity WHERE ID IN: requestedOppIds];
            }
            if(pendingOppIds.size() > 0){
                pendingOpportunityList = [SELECT Id, Name From Opportunity WHERE ID IN: pendingOppIds];
            }
            msg = 'Please select Opportunity to upload Control Sheet Document';
            initMsg = '';
        }else{
            displayOppPanel = false;
            msg = '';
            initMsg = 'No Opportunities found!!!';
        }
    }

    // Fetch control sheet doc for selected Opportunity
    public void fetchConrolSheet(){
        displaySheetPanel = true;
        customStipFileName = '';
        customStipFileBody = null;
        UWList = new List<Cloufi__UW_Document__c>();
        controlSheet = new List<Cloufi__UW_Document__c>();

        if(selectedOppId != null && selectedOppId !=''){
            String query = '';
            query += 'SELECT '+ String.join(DevUtil.getFieldsOfsObject('Opportunity'),',');
            query += ' FROM Opportunity WHERE Id = '+'\''+ selectedOppId +'\'';
            objOpportunity = Database.query(query);
            for(Cloufi__UW_Document__c objUWDocument : [SELECT Name, Control_Sheet_Version__c, Stip_Name__c,Cloufi__URL__c, Status__c, Cloufi__Type__c FROM Cloufi__UW_Document__c WHERE Stip_Name__c LIKE '%Control Sheet%' AND (Cloufi__Type__c = 'Control Sheet' OR Cloufi__Type__c = 'Control Sheet Completed') AND Cloufi__Opportunity__c =: selectedOppId]){//,Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c
                if(objUWDocument.Cloufi__Type__c == 'Control Sheet Completed'){
                    if(objUWDocument.Cloufi__URL__c != null && objUWDocument.Status__c == 'Completed'){
                        controlSheet.add(objUWDocument);
                    }
                }else{
                    objControlSheet = objUWDocument;
                    controlSheet.add(objUWDocument);
                }
            }
            system.debug('controlSheet=>'+controlSheet);

            UWList = [SELECT Name,Stip_Name__c,Cloufi__URL__c FROM Cloufi__UW_Document__c WHERE Sent_to_Control_Sheet_Dept__c = true AND Cloufi__Opportunity__c =: selectedOppId AND Cloufi__URL__c != null ORDER BY Cloufi__Type__c];
        }else{
            displaySheetPanel = false;
            msg = 'Please select Opportunity to upload Control Sheet Document';
            initMsg = '';
        }
    }

    // Method to generate Dropbox URL
    public void uploadControlSheet(){
        system.debug('customStipFileName=>'+customStipFileName);
        system.debug('objControlSheet=>'+objControlSheet);
        system.debug('customStipFileBody=>'+customStipFileBody);
        if(customStipFileName!=null && customStipFileBody!=null && objControlSheet != null && objControlSheet.Id != null){
            String attachmentName;
            string randomString = generateRandomString(10);
            system.debug('controlSheet[0].Control_Sheet_Version__c =>'+controlSheet[0].Control_Sheet_Version__c );
            system.debug('customStipFileName =>'+customStipFileName);
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
            /*if(objControlSheet.Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c != null && objControlSheet.Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c != ''){
                pathOppUpload = '{"path":"'+objControlSheet.Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c+'/'+attachmentName+'","mode": "add","autorename": true,"mute": false}';
            }else{*/
                pathOppUpload = '{"path":"/Salesforce%20Documents/'+attachmentName+'","mode": "add","autorename": true,"mute": false}';
            //}
            
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
        selectedOppId = '';
        initializeOpportunityRecords();
        fetchConrolSheet();
    }
    
    public PageReference checkSession(){  
        system.debug('checkSession method call');
        if(userid == null || userid == ''){  
            PageReference pg = new PageReference('/apex/ControlSheetDeptLogin');
            pg.setRedirect(false);
            return pg;
        }
        return null;
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
    
    // Login Method
    Public PageReference LoginUser(){
        displayPanel= false;
            userid = ControlSheetUtil.LoginUserMethod(username, password);
        if(userid != null && userid.length() > 0){
            System.Debug('userid=>' + userid);
            objContact = [Select id,Last_Login_Date__c,Name,Access_Code__c,Email from Contact where id = : userid LIMIT 1];
            PageReference pg = new PageReference('/apex/ControlSheetConfirmAccess');
            pg.setRedirect(false);
            return pg;
            
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Username or Password is incorrect.');
            apexpages.addmessage(myMsg);
            return null;
        }
    } 

    // method called on click of confirm access
    public PageReference confirmLogin(){
        displayPanel = false;
        system.debug('accessCode'+accessCode);
        if(objContact.Access_Code__c == accessCode){
            //if(objContact.Last_Login_Date__c == null && NewPassword == ConfirmNewPassword){
                objContact.Password__c = password;
                objContact.Last_Login_Date__c = System.Today();                
            //}
            update objContact;
            PageReference pg = new PageReference('/apex/ControlSheetPortal');
            initializeOpportunityRecords();
            pg.setRedirect(false);
            return pg;            
        }else if(accessCode == null || accessCode == ''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Access Code.');
            apexpages.addmessage(myMsg);
            return null;            
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Access Code is incorrect.');
            apexpages.addmessage(myMsg);
            return null;            
        }
    }

    // Method called on click of forgot password button
      public PageReference forgetPassword() {   
        displayPanel= false;
        if(username == null || username=='') {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please Enter Email.');
            apexpages.addmessage(myMsg);
            return null;
        }
        List<Contact> conList = [select id,Name,Password__c,Email From Contact a Where Email = : username limit 1];
        System.debug('forget passwor=>' + conList);
        if(!conList.isEmpty()){
            objContact = conList[0]; 
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please Contact support to update Email Address');
            apexpages.addmessage(myMsg);
            return null;
        }
        PageReference pg = ControlSheetUtil.ControlSheetUserForgotPassword(objContact, tempUserId);
        return pg;
    }

    
    // Logout method
    Public PageReference Logout() {
        PageReference Pref = new PageReference('/apex/ControlSheetDeptLogin');
        Pref.setRedirect(true);
        return Pref;
    }

}