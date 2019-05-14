public with sharing class ControlSheetPortalController {
	public string userid {get;set;}
	public List<opportunity> requestedOpportunityList{get; set;}
	public List<opportunity> rejectedOpportunityList{get; set;}
    public boolean displayPanel{get;set;}
    public boolean displayOppPanel{get;set;}
    public boolean displaySheetPanel{get;set;}
    public List<Cloufi__UW_Document__c> uwDocList{get; set;}
    public string selectedOppId{get;set;}
    public String msg{get; set;}
    public String initMsg{get; set;}
    public String contactName{get; set;}
    public List<Cloufi__UW_Document__c> UWList{get;set;}
    public List<Cloufi__UW_Document__c> controlSheet{get;set;}
    public id loanId{get;set;}
    public boolean showHideButton {get;set;}
    public boolean isDownloadSpecificButtonDisabled {get; set;}
    public List<Cloufi__UW_Document__c> lstUWDuplicate{get;set;}
    public Cloufi__UW_Document__c objControlSheet{get;set;}
    public Opportunity objOpportunity{get;set;}
    public List<String> filesPathList{get;set;}
    public Opportunity loan{get; set;}
    public string customStipFileName{get;set;}
    public transient Blob customStipFileBody{get;set;}

	public ControlSheetPortalController(ApexPages.StandardController controller) {
		init();
	}

	public void init(){
		userid = Apexpages.currentPage().getParameters().get('id');
		Set<Id> requestedOppIds = new Set<Id>();
		Set<Id> rejectedOppIds = new Set<Id>();
		requestedOpportunityList = new List<opportunity>();
		rejectedOpportunityList = new List<opportunity>();
        Contact objCon = [Select Id, Name from Contact Where Id =: userid];
        contactName = objCon.Name;
        customStipFileName = '';
        List<UW_Document_Share__c> uwDocShareList = new List<UW_Document_Share__c>();
        uwDocShareList = [SELECT id,Account__c,Control_Sheet_Contact__c,Opportunity__c,UW_Documents__c,UW_Documents__r.Status__c,UW_Documents__r.Cloufi__Type__c FROM UW_Document_Share__c WHERE Control_Sheet_Contact__c=:userid AND UW_Documents__r.Cloufi__Type__c = 'Control Sheet' AND (UW_Documents__r.Status__c='Requested' OR UW_Documents__r.Status__c='Rejected')];
        for(UW_Document_Share__c objUWShare:uwDocShareList){
        	if(objUWShare.UW_Documents__r.Status__c=='Requested'){
            	requestedOppIds.add(objUWShare.Opportunity__c);
        	}else{
        		rejectedOppIds.add(objUWShare.Opportunity__c);
        	}
        }
        
        if(requestedOppIds.size() > 0 || rejectedOppIds.size() > 0){
            displayOppPanel = true;
            if(requestedOppIds.size() > 0){
            	requestedOpportunityList = [SELECT Id, Name From Opportunity WHERE ID IN: requestedOppIds];
            }
            if(rejectedOppIds.size() > 0){
            	rejectedOpportunityList = [SELECT Id, Name From Opportunity WHERE ID IN: rejectedOppIds];
            }
            msg = 'Please select Opportunity to upload Control Sheet Document';
            initMsg = '';
        }else{
            displayOppPanel = false;
            msg = '';
            displaySheetPanel = false;
            initMsg = 'No Opportunities found!!!';
        }
	}

	// Logout method
    Public PageReference Logout() {
        PageReference Pref = new PageReference('/apex/ControlSheetDeptLogin');
        Pref.setRedirect(true);
        return Pref;
    }

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
            for(Cloufi__UW_Document__c objUWDocument : [SELECT Name, Control_Sheet_Version__c, Stip_Name__c,Cloufi__URL__c, Status__c, Cloufi__Type__c,Cloufi__Opportunity__r.Cloufi__Dropbox_Folder_Path__c FROM Cloufi__UW_Document__c WHERE Stip_Name__c LIKE '%Control Sheet%' AND (Cloufi__Type__c = 'Control Sheet' OR Cloufi__Type__c = 'Control Sheet Completed') AND Cloufi__Opportunity__c =: selectedOppId]){
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

    public void uploadControlSheet(){
    	system.debug('customStipFileName=>'+customStipFileName);
    	system.debug('objControlSheet=>'+objControlSheet);
    	system.debug('customStipFileBody=>'+customStipFileBody);
	    if(customStipFileName!=null && customStipFileBody!=null && objControlSheet != null && objControlSheet.Id != null){
	        String attachmentName;
	        string randomString = generateRandomString(10);
	        
	        if(customStipFileName.length()>50){
	            attachmentName =   'Conrtol Sheet_'+ controlSheet[0].Control_Sheet_Version__c + ' ' + randomString + '.' + customStipFileName.substringAfterLast('.');
	        }else{
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
	    selectedOppId = '';
	    init();
	    fetchConrolSheet();
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