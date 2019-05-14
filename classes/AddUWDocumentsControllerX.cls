/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: AddUWDocumentsControllerX
* Created Date: 17-Jan-2018
* Description: Controller Extension for adding Underwriting Documents for Opportunity
*******************************************************************/

global   class AddUWDocumentsControllerX{

    public ID recordID{get;set;}
    public boolean IsSelected{get;set;}
    public boolean enableNewWrapper{get;set;}
    public boolean showSubmitBtn{get;set;}
    public List<StipWrapper> ListWrapper{get;set;}
    public List<StipWrapper> ListWrapperNew {get;set;}
    public Map <String, Cloufi__UW_Document__c> objInterviewMap;
    public List<Cloufi__UW_Document__c> lstStips{get;set;}
    //public Map<Id, Interview__c> objInterviewData;
    public string attNames{get;set;}
    public List<Cloufi__UW_Document__c> docs{get;set;}
    public boolean addToStip {get;set;}
    transient List<Schema.PicklistEntry> ple = new List<Schema.PicklistEntry>();
    public String AddStipsData{get;set;}
    public Cloufi__Application__c objApplication{get;set;}
    //public id LoanId{get;set;}
    //public Boolean isEmailSent {get;set;}
    public Opportunity objOpportunity{get;set;}
    public List<Cloufi__UW_Document__c> lstStip{get;set;}
    public List<String> lstStipType{get;set;}
    public List<StipTypeWrapper> lstStipTypeWrapper {get;set;}
    public string type{get;set;}
    public Map<String,StipTypeWrapper> avoidDuplicateStips{get;set;}
    public Map<String,StipTypeWrapper> reqStipsMap{get;set;}
    public Boolean renderStipsQuestions{get;set;}
    /*public Boolean renderRequestDocument{get;set;}
    public List<StipWrapper> sendRequestDocWrapList{get;set;}    
    public List<Id> selectedStipIdList{get;set;}*/
    public String stipName{get;set;}
    public List<SelectOption> statementType{get;set;}
    public String selectedStatementType{get;set;}
    public Integer selectedMonths{get;set;}

    public List<String> stipNames{get;set;}
    public string customStipFileName{get;set;}
    public Blob customStipFileBody{get;set;}
    public String customUWDocumentComment{get;set;}
    static Map<Id, String> uwDocumentMap{get;set;}
    public Integer controlSheetCreated{get;set;}
    public Integer controlSheetCompletedCreated{get;set;}

    @RemoteAction
    global static String getUWDocumentName(String uwDocId) {
        system.debug('Inside getUWDocumentName');
        String uwDocName = [SELECT Name FROM Cloufi__UW_Document__c WHERE Id =: uwDocId].Name;
        system.debug('uwDocName >>'+uwDocName);
        return uwDocName;
    }

    public AddUWDocumentsControllerX(ApexPages.StandardController controller) {
        recordID = ApexPages.currentPage().getParameters().get('id');
        enableNewWrapper = true;
        objOpportunity=new Opportunity();
        lstStipType =new List<String>(); 
        lstStipTypeWrapper = new List<StipTypeWrapper>();
        avoidDuplicateStips = new Map<String,StipTypeWrapper>();
        reqStipsMap = new Map<String,StipTypeWrapper>(); 
        renderStipsQuestions = false;
        stipNames = new List<string>();
        customStipFileName = '';
        customUWDocumentComment = '';
        uwDocumentMap = new Map<Id, String>();
        controlSheetCreated = 0;
        controlSheetCompletedCreated = 0;
        /*renderRequestDocument = false;
        sendRequestDocWrapList = new List<StipWrapper>();*/
        system.debug('AttNames '+attNames);
        if(recordID!=null){
            lstStip = [select id,Name,Cloufi__View__c,Cloufi__Type__c,Cloufi__URL__c,Stip_Name__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c=:recordID  Order By Name ASC];
            system.debug('==>>lstStip '+lstStip+' Size->'+lstStip.size());
            
            for(Cloufi__UW_Document__c reqSt : lstStip ){
                stipNames.add(reqSt.Stip_Name__c);
                avoidDuplicateStips.put(reqSt.Stip_Name__c,new StipTypeWrapper(reqSt.Stip_Name__c,false,null));
                uwDocumentMap.put(reqSt.Id, reqSt.Name);
                if(reqSt.Cloufi__Type__c =='Control Sheet'){
                    controlSheetCreated = controlSheetCreated+1;
                }
                if(reqSt.Cloufi__Type__c =='Control Sheet Completed'){
                    controlSheetCompletedCreated = controlSheetCompletedCreated+1;
                }
            }
            system.debug('controlSheetCreated==>>'+controlSheetCreated);
            system.debug('controlSheetCompletedCreated==>>'+controlSheetCompletedCreated);
            //uwDocumentMap.put('a0K180000046RQCEA2', 'Signed Application');
            system.debug('==>>avoidDuplicateStips size'+avoidDuplicateStips.size());
            objOpportunity = [SELECT Id, Name, Cloufi__Dropbox_Folder_Path__c FROM Opportunity WHERE Id =: recordID];
        }
        /*Schema.DescribeFieldResult fieldResult = Cloufi__UW_Document__c.Cloufi__Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();*/
        for (UW_Documents_Settings__c UWStips : [select name,Stage__c,Type__c from UW_Documents_Settings__c where Type__c!=null]) {
              lstStipType.add(UWStips.name);
        }
        system.debug('==>>lstStipType '+lstStipType);
        lstStipType.sort();
        for(String str : lstStipType){
            if(!avoidDuplicateStips.containsKey(str)){
                //for(Cloufi__UW_Document__c objStip : lstStip){
                    reqStipsMap.put(str,new StipTypeWrapper(str,false,null));
                //}
            }
        }
        if(reqStipsMap.keySet().size()>0){
            renderStipsQuestions = true;
        }

        init();
        addRow();        
    }

    public void init(){
        objInterviewMap = new Map <String, Cloufi__UW_Document__c>();
        //objInterviewData = new Map<Id, Interview__c>();
        recordID = ApexPages.currentPage().getParameters().get('id');
        //enableNewWrapper = false; 
        lstStips = new List<Cloufi__UW_Document__c>();
        docs = new List<Cloufi__UW_Document__c>();
        ListWrapperNew = new List<StipWrapper>(); 

        if(recordID!=null){
            for(Cloufi__UW_Document__c  objInterview:[SELECT Id, Name, Cloufi__View__c, Cloufi__Type__c, Stip_Name__c FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c=: recordID Order By Stip_Name__c ASC]){
                objInterviewMap.put(objInterview.Name, objInterview);
                //objInterviewData.put(objInterview.Id, objInterview);
            }            

            lstStips = [select id,Name,Cloufi__View__c,Cloufi__Type__c,Cloufi__URL__c, Stip_Name__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c=:recordID Order By Cloufi__Type__c ASC];
            
            for(Cloufi__UW_Document__c  objStip : lstStips){
                system.debug('::objStip::'+objStip.Cloufi__URL__c);
                if(objStip.Cloufi__URL__c == null || objStip.Cloufi__URL__c == '')
                    showSubmitBtn = true;
            } 
        }
        
        System.debug('objInterviewMap---'+objInterviewMap);
        ListWrapper=new List<StipWrapper>();        
        system.debug('lstStips ------------->'+lstStips.size());
        stipName = '';
        selectedStatementType = '';
        statementType = new List<SelectOption>();
        statementType.add(new SelectOption('','---None---'));
        statementType.add(new SelectOption('Bank Statement','Bank Statement'));
        statementType.add(new SelectOption('Processing Statement','Processing Statement'));
        selectedMonths = 0;
    }
 
    public void addRow() {
        //enableNewWrapper = true;
        Cloufi__UW_Document__c objStipAttachment = new Cloufi__UW_Document__c();
        IsSelected = true;
        //objStipAttachment.Type__c = true;
        
        //ListWrapper.add(new StipWrapper(objInterViewTemplate,IsSelected ));
        ListWrapperNew.add(new StipWrapper(objStipAttachment,IsSelected));
        docs.add(objStipAttachment);       
        system.debug('Add Row Docs'+docs);
    }
    
    
    public Pagereference prepareSFDocuments(){ 
    system.debug('In prepareSFDocuments');         
        try{     
            system.debug('**prepareSFDocuments'+attNames);
           
            attNames = attNames.removeEnd('\n').trim();
            List<string> atts = attNames.split('\n');        
            docs = new List<Cloufi__UW_Document__c>(); 
            
            for(String attName : atts){
                List<string> nameSplit = attName.split('\t');       
                
                system.debug('nameSplit==>'+nameSplit+','+nameSplit.size());
                Cloufi__UW_Document__c doc = new Cloufi__UW_Document__c(Name='test', Cloufi__Opportunity__c=recordID);
                if(nameSplit.size()>0){                  
                    doc.Name = nameSplit[0];
                }
                if(nameSplit.size()>1){
                    doc.Cloufi__Display_Size__c = getDisplaySize(Long.valueOf(nameSplit[1]));
                    doc.Cloufi__size__c=Long.valueOf(nameSplit[1]);
                }
                
                lstStips.add(doc);
                if(lstStips.size()>0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Stips Added Successfully.') );
                }

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Thank you for Submitting Answers')); 
               
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Stips Added Successfully.') );
            system.debug('test==>doc'+lstStips+' Size->'+lstStips.size());
        }catch(Exception ex){
            system.debug('In catch block of prepareSFDocuments');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()+'\n'+ex.getStackTraceString());
            ApexPages.addMessage(myMsg);
        }
        return null;
    }


    public Pagereference CreateCustomUWCDocument(){
        system.debug('In CreateCustomUWCDocument');
        system.debug('stipName=>'+stipName);
        system.debug('customStipFileName=>'+customStipFileName);
        system.debug('customStipFileBody=>'+customStipFileBody);
        system.debug('controlSheetCreated==>>'+controlSheetCreated);
        system.debug('controlSheetCompletedCreated==>>'+controlSheetCompletedCreated);
        
        try{
            if(String.isBlank(stipName)){
                system.debug('Inside null name'+stipName);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Underwriting document type cannot be blank.'));
                return null;
            }
            
            
            if(!stipNames.contains(stipName)){            
                /*if(customStipFileName!=null && customStipFileBody!=null){
                    String attachmentName;
                    string randomString = generateRandomString(10);
                    
                    if(customStipFileName.length()>50){
                        attachmentName =  customStipFileName.left(50) + ' ' + randomString + '.' + customStipFileName.substringAfterLast('.');
                    }else{
                        attachmentName =  customStipFileName.substringBeforeLast('.') + ' ' + randomString + '.' + customStipFileName.substringAfterLast('.');
                    }
                    system.debug('attachmentName=>'+attachmentName);
                    //Generate Dropbox URL
                    if(!test.isRunningTest()){
                        Cloufi__Dropbox_Settings__c dropBoxSetting = Cloufi__Dropbox_Settings__c.getOrgDefaults();
                        String dropBoxToken = dropBoxSetting.Cloufi__Access_Token__c;
                        String uploadOppAttach = 'https://content.dropboxapi.com/2/files/upload';
                        String pathOppUpload = '{"path":"/Salesforce%20Documents/'+attachmentName+'","mode": "add","autorename": true,"mute": false}';
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
                                Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c();
                                objUW.Name = stipName;
                                objUW.Stip_Name__c = stipName;
                                objUW.Cloufi__Type__c = 'Custom Document';
                                objUW.Cloufi__Opportunity__c = recordID;
                                objUW.Cloufi__URL__c = jsonSearchURL;
                                objUW.Comment__c = customUWDocumentComment;
                                insert objUW;
                                system.debug('objUW=>'+objUW);
                            }
                        }
                    }
                }else{*/
                    Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c();
                    objUW.Name = stipName;
                    objUW.Stip_Name__c = stipName;
                    if(stipName.contains('Control Sheet Completed')){//stipName == 'Control Sheet Completed'
                        objUW.Cloufi__Type__c = 'Control Sheet Completed';
                        system.debug('Inside Control Sheet Completed');
                        if(controlSheetCompletedCreated != 0){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Control Sheet Completed can not be created more than One.'));
                            return null;
                        }
                    }else if(stipName.contains('Control Sheet')){//stipName == 'Control Sheet'
                        objUW.Cloufi__Type__c = 'Control Sheet';
                        system.debug('controlSheetCreated=>'+controlSheetCreated);
                        if(controlSheetCreated != 0){
                            system.debug('Inside Control Sheet');
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Control Sheet can not be created more than One.'));
                            return null;
                        }
                    }else{
                        objUW.Cloufi__Type__c = 'Custom Document';
                    }
                    objUW.Comment__c = customUWDocumentComment;
                    objUW.Cloufi__Opportunity__c = recordID;
                    insert objUW;
                //}
            }else{
                //stipName = '';
                //customUWDocumentComment = '';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Duplicate Document cannot be added.'));
                return null; 
            }
            
            PageReference objPageStips = new PageReference('/apex/AddUWDocuments?id='+recordID);
            objPageStips.setRedirect(true);
            return objPageStips;
        }catch(Exception ex){
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()+'\n'+ex.getStackTraceString());
            //ApexPages.addMessage(myMsg);
            System.debug('Exception '+ex.getMessage());
            System.debug('Exception '+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            return null;
        }
    }

    public Pagereference CreateUWCDocument(){          
        try{     
            system.debug('**prepareSFDocuments'+attNames);
           
            attNames = attNames.removeEnd('\n').trim();
            List<string> atts = attNames.split('\n');        
            docs = new List<Cloufi__UW_Document__c>(); 
            
            for(String attName : atts){
                List<string> nameSplit = attName.split('\t');       
                
                system.debug('nameSplit==>'+nameSplit+','+nameSplit.size());
                Cloufi__UW_Document__c doc = new Cloufi__UW_Document__c(Name='test', Cloufi__Opportunity__c=recordID);
                if(nameSplit.size()>0){
                    doc.Name = nameSplit[0];
                }
                if(nameSplit.size()>1){
                    doc.Cloufi__Display_Size__c = getDisplaySize(Long.valueOf(nameSplit[1]));
                    doc.Cloufi__size__c=Long.valueOf(nameSplit[1]);
                }
                //  docs[0].Cloufi__Type__c != null || docs[0].Cloufi__Type__c !=''
                    doc.Stip_Name__c = stipName;
                    doc.Name = doc.Stip_Name__c;
                    doc.Cloufi__Type__c = 'Custom Document';
                    docs.add(doc);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Stips Added Successfully.') );
                  
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Thank you for Submitting Answers')); 
                    system.debug('doc --'+doc);              
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Stips Added Successfully.') );
            system.debug('test==>doc'+lstStips);

            //Integer.valueOf('***'+docs.size());
        }catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()+'\n'+ex.getStackTraceString());
            ApexPages.addMessage(myMsg);
        }
        return null;
    }
    

    public void retrieveDocs(){
        if(recordID !=null){
            docs= [SELECT Cloufi__Application__c,CreatedDate,Cloufi__Display_Size__c,Id,Name,Cloufi__Opportunity__c,Cloufi__Size__c,Cloufi__Type__c,Cloufi__URL__c,Cloufi__View__c
                            FROM Cloufi__UW_Document__c where Cloufi__Application__c=:recordID Order by CreatedDate DESC ];
            system.debug(':::docs::'+docs);
        }
    }
    public String getDisplaySize(Long Value)  {
        /* string representation if a file's size, such as 2 KB, 4.1 MB, etc */
        if(Value < 1024){
            return string.valueOf(Value) + ' Bytes';
        }else if (Value >= 1024 && Value < (1024*1024)){
            //KB
            Decimal kb = Decimal.valueOf(Value);
            kb = kb.divide(1024,2);
            return string.valueOf(kb) + ' KB';
        }else if (Value >= (1024*1024) && Value < (1024*1024*1024)){
            //MB
            Decimal mb = Decimal.valueOf(Value);
            mb = mb.divide((1024*1024),2);
            return string.valueOf(mb) + ' MB';
        }else{
            //GB
            Decimal gb = Decimal.valueOf(Value);
            gb = gb.divide((1024*1024*1024),2);            
            return string.valueOf(gb) + ' GB';
        }    
    }
    
    public pagereference updateDocs(){
        //Integer.valueof('pare'+parentId);
        try{            
           system.debug('lstStips.size()=>'+lstStips.size());
            if(lstStips.size()>0){
                
                list<Cloufi__UW_Document__c> docList = new list<Cloufi__UW_Document__c>(); 
                for(Cloufi__UW_Document__c da : lstStips){
                    if(enableNewWrapper || (da.Cloufi__URL__c !=Null && da.Cloufi__URL__c !='') ){
                        da.Cloufi__Opportunity__c=recordID ;
                        if(da.Stip_Name__c != null && da.Stip_Name__c != ''){
                            if(stipName == 'Contract' && da.Stip_Name__c == stipName){
                                stipName = '';
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Can not create Duplicate Contract'));
                                return null;
                            }
                            if(stipName == 'Signed Contract' && da.Stip_Name__c == stipName){
                                stipName = '';
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Can not create Duplicate Signed Contract'));
                                return null;
                            }
                            if(da.Name.length() > 60){
                                String documentName = da.Name;
                                List<String> docNameList = documentName.split('\\.');
                                if(docNameList.size() > 0){
                                    String extension = docNameList[docNameList.size()-1];
                                    if(docNameList[0].length()>=60){
                                        documentName = docNameList[0].subString(0,59)+'.'+extension;
                                    }else{
                                        documentName = docNameList[0]+'.'+extension;
                                    }
                                }                        
                                da.Name = documentName;
                            }
                            docList.add(da);
                        }                                                 
                    }                 
                }
                system.debug('test==>asasd lstStips'+docList);
                upsert docList;
                //update docList;     
                System.debug('docList ->'+docList+' Size->'+docList.size());       
            }

            if(docs.size()>0){
                
                list<Cloufi__UW_Document__c> docList = new list<Cloufi__UW_Document__c>(); 
                for(Cloufi__UW_Document__c da : docs){
                    if(da.Cloufi__URL__c !=Null && da.Cloufi__URL__c !=''){da.Cloufi__Opportunity__c=recordID ;
                       docList.add(da);
                    }                 
                }
                 system.debug('test==>asasd docs'+docList);                
                upsert docList;  
                //update docList;
            }
            PageReference objPageStips = new PageReference('/apex/AddUWDocuments?id='+recordID);
            objPageStips.setRedirect(true);
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Thank you for Uploading Documents')); 
            return objPageStips;
            //init();
            // return null;
        }catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(myMsg);
        }
        return null;
    }
    
    /*public void renderReqDocument(){
        sendRequestDocWrapList = new List<StipWrapper>();
        renderRequestDocument = true;
        for(Cloufi__UW_Document__c objStip : lstStips){
            if(objStip.Cloufi__URL__c == null){
                sendRequestDocWrapList.add(new StipWrapper(objStip));
            }
        }
    }*/

    public void sendStips(){       
        /*selectedStipIdList = new List<Id>();
        for(StipWrapper objStipWrap : sendRequestDocWrapList){
            if(objStipWrap.IsSelected && objStipWrap.objStip.URL__c == null){
                selectedStipIdList.add(objStipWrap.objStip.Id);
            }
        }
        renderRequestDocument = false;*/       

        try{            
            List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
            
            //LoanId = ApexPages.currentPage().getParameters().get('id');
            Id ContactId;
            String contactName;
            for(OpportunityContactRole ocr:[select id, ContactId, Contact.Name from OpportunityContactRole where OpportunityId = :recordID]){
                 ContactId = ocr.ContactId;
                 contactName = ocr.Contact.Name;
            }
            
            List<Opportunity> oppList = [SELECT id,Name,Cloufi__Referral_Partner__c,Cloufi__Referral_Partner__r.Email/*,Cloufi__BDO__r.id,Cloufi__BDO__r.name,Cloufi__BDO__r.Email*/, Cloufi__Borrower_Email__c FROM Opportunity WHERE id=:recordID LIMIT 1];

            if(oppList[0] != null && ((oppList[0].Cloufi__Referral_Partner__c!=null && oppList[0].Cloufi__Referral_Partner__r.Email!=null) || (oppList[0].Cloufi__Borrower_Email__c != null && ContactId != null)) ){ 

                /*Map<string,Cloufi__MCA_Settings__c> MCASettings = Cloufi__MCA_Settings__c.getAll();
                String MCA_Site_URL = MCASettings.get('MCA_Site_URL')!=null?MCASettings.get('MCA_Site_URL').Cloufi__value__c:'';
                MCA_Site_URL += 'Cloufi__SendUWDocuments?Id='+recordID+'&selectedStips='+String.join(selectedStipIdList, ','); */

                Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                List<String> emailIds = new List<String>();                
                /*String emailBody = '';
                emailBody += '<html lang="en">\n';
                emailBody += '<title>Email</title>\n';
                emailBody += '</head>\n';
                emailBody += '<body style=" margin:0; padding:0;"> \n';
                emailBody += '<div class="row">\n';
                emailBody += '<div class="main-container" style="width:100%;background:#f4f4f4; font-family: Arial;font-size: 0.9em;padding-bottom: 3%;" >\n';
                emailBody += '<div  class="inner-container" style="margin:2% auto 2% auto;background:#ffffff;min-height:200px;min-height:35%;padding:20px;line-height:25px;border:1px solid rgb(229,229,229)"> \n';
                emailBody += '<h2>Hi '+contactName+'</h2>\n';
                emailBody += '<span style="display:inline-block;"><a style="color:#999999;" target="_blank" href="'+MCA_Site_URL+'">Click Here </a></span> to add Following documents\n';
                
                emailBody += '<table style="width:50%">\n';
                for(StipWrapper objStipWrap : sendRequestDocWrapList){
                    if(objStipWrap.IsSelected && objStipWrap.objStip.URL__c == null){
                        emailBody += '<tr><td>'+objStipWrap.objStip.Cloufi__Type__c+'</td></tr>\n';
                    }
                }
                emailBody += '</table>\n';

                emailBody += '</div>\n';              
                emailBody += '</div>\n';
                emailBody += '</div>\n';
                emailBody += '</body>\n';
                emailBody += '</html>';*/

                //emailIds.add(oppList[0].Cloufi__BDO__r.Email);
                if(oppList[0].Cloufi__Referral_Partner__c!=null && oppList[0].Cloufi__Referral_Partner__r.Email!=null){
                    emailIds.add(oppList[0].Cloufi__Referral_Partner__r.Email);
                    emailMsg.setTargetObjectId(oppList[0].Cloufi__Referral_Partner__c);
                }
                else{
                    emailIds.add(oppList[0].Cloufi__Borrower_Email__c);
                    emailMsg.setTargetObjectId(ContactId);
                }
                
                emailMsg.setToAddresses(emailIds);

                emailMsg.setTemplateId([select id from EmailTemplate where DeveloperName = 'Request_for_uploading_Document'].id);
                emailMsg.setWhatId(recordID);
                //emailMsg.setHtmlBody(emailBody);
                //emailMsg.setSubject('Request for uploading Documents');
                lstEmailMsg.add(emailMsg);
                System.debug('Email Message' +emailMsg);
                
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'No email id present to send email'));
                return ;                
            }
           
            Integer count=0;
            For(Cloufi__UW_Document__c objStip:lstStip){
                if(objStip.Cloufi__URL__c == null || objStip.Cloufi__URL__c == ''){
                    count++;
                }
            }
            
            if(count >= 1){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmailMsg);
                if(results.size()>0){
                    if(results[0].isSuccess()) {
                        System.debug('The email was sent successfully.');
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Request Sent Successfully'));
                        system.debug('------->' + lstEmailMsg);
                        //isEmailSent = true;
                    } else {
                        System.debug('The email failed to send: ' + results[0].errors[0].message);
                    }
                }
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Documents are already attached.'));
                
            } 
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()+' Stack Trace ->'+ex.getStackTraceString()));
            System.debug('Errors------>'+ex.getMessage()+ex.getLineNumber());
            return ;
        }      
    }    

    public PageReference SaveAns(){
        system.debug('Type==>>'+type);
        
        list<String> selectedRecords= new List<String>();
        list<Cloufi__UW_Document__c> lstStipToInsert = new List<Cloufi__UW_Document__c>();
        Map<String, UW_Documents_Settings__c> UWDocSettings = UW_Documents_Settings__c.getAll();
        try{
            for(StipTypeWrapper que : reqStipsMap.values()){//lstStipTypeWrapper
                if(que.IsSelected && que.stipType!= null){selectedRecords.add(que.stipType );}
            }
            if(selectedRecords.size()==0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one stip!'));
            }else{
                for(String str : selectedRecords){
                    Cloufi__UW_Document__c objStip = new Cloufi__UW_Document__c();
                    objStip.Cloufi__Opportunity__c = recordID;
                    //objStip.Cloufi__Type__c = str;
                    objStip.Name = str;
                    objStip.Stip_Name__c = str;
                    //objStip.Cloufi__URL__c = ;
                    if(UWDocSettings.values().size()>0){
                        for(UW_Documents_Settings__c objUWDocSettings : UWDocSettings.values()){
                            if(objUWDocSettings.name == str){
                                objStip.Cloufi__Type__c = objUWDocSettings.Type__c;
                                break;
                            }
                        }
                        if(!UWDocSettings.containsKey(str)){
                            objStip.Cloufi__Type__c = 'Custom Document';
                            break;
                        }
                    }
                    lstStipToInsert.add(objStip);
                }
            }
            
            if(lstStipToInsert.size()>0){
                insert lstStipToInsert;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Questions Has been added'));
                 PageReference questionPage = new PageReference('/apex/AddUWDocuments?id='+recordID);
                 questionPage.setRedirect(true);
                 return questionPage;
            }
        }Catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()+e.getLineNumber()));
        }
        return null;
    }
    
    public Pagereference createStatements(){
        if(selectedMonths > 36){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'You can only add upto last 3 Year Bank/Processing Statements'));
            return null;
        }
        List<Cloufi__UW_Document__c> uwDocumentList = new List<Cloufi__UW_Document__c>();
        Map<String, Map<String, Cloufi__UW_Document__c>> bankStatementMap = new Map<String, Map<String, Cloufi__UW_Document__c>>(); 
        Map<String, Map<String, Cloufi__UW_Document__c>> processingStatementMap = new Map<String, Map<String, Cloufi__UW_Document__c>>();

        for(Cloufi__UW_Document__c objUWDocument : [SELECT Id, Name, Cloufi__Type__c, Month__c, Year__c FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c =:recordID AND (Cloufi__Type__c = 'Bank Statement' OR Cloufi__Type__c = 'Processing Statement')]){
            if(objUWDocument.Month__c != null && objUWDocument.Year__c != null){
                if(objUWDocument.Cloufi__Type__c == 'Bank Statement'){
                    if(bankStatementMap.containsKey(objUWDocument.Year__c)){                        
                        bankStatementMap.get(objUWDocument.Year__c).put(objUWDocument.Month__c, objUWDocument);                        
                    }else{                        
                        bankStatementMap.put(objUWDocument.Year__c, new Map<String, Cloufi__UW_Document__c>{objUWDocument.Month__c=>objUWDocument});
                    }
                }else{
                    if(processingStatementMap.containsKey(objUWDocument.Year__c)){                        
                        processingStatementMap.get(objUWDocument.Year__c).put(objUWDocument.Month__c, objUWDocument);                        
                    }else{                        
                        processingStatementMap.put(objUWDocument.Year__c, new Map<String, Cloufi__UW_Document__c>{objUWDocument.Month__c=>objUWDocument});
                    }
                }
            }
        }

        if(selectedStatementType != null && selectedMonths != null && selectedMonths > 0){
            Date todayDate = System.today();            
            Map<Integer, String> monthMap = new Map<Integer, String>{1 =>'January', 2=>'February', 3=>'March', 4=>'April', 5=>'May',6=>'June', 7=>'July', 8=>'August', 9=>'September',10=>'October',11=>'November', 12=>'December'};        

            for(Integer i=selectedMonths;i>0;i--){
                Date d = todayDate.addMonths(-i);
                String year = String.valueOf(d.year());
                String month = monthMap.get(d.month());
                if(selectedStatementType == 'Bank Statement'){
                    if(bankStatementMap.get(year) != null){
                        if(bankStatementMap.get(year).get(month) == null){
                            Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c();
                            objUWDocument.Name = month+'-'+ year + ' Bank Statement';
                            objUWDocument.Stip_Name__c = objUWDocument.Name;
                            objUWDocument.Cloufi__Type__c = 'Bank Statement';
                            objUWDocument.Month__c = month;
                            objUWDocument.Year__c = year;
                            objUWDocument.Cloufi__Opportunity__c = recordID;
                            uwDocumentList.add(objUWDocument);                        
                        }
                    }else{
                        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c();
                        objUWDocument.Name = month+'-'+ year + ' Bank Statement';
                        objUWDocument.Stip_Name__c = objUWDocument.Name;
                        objUWDocument.Cloufi__Type__c = 'Bank Statement';
                        objUWDocument.Month__c = month;
                        objUWDocument.Year__c = year;
                        objUWDocument.Cloufi__Opportunity__c = recordID;
                        uwDocumentList.add(objUWDocument);
                        bankStatementMap.put(objUWDocument.Year__c, new Map<String, Cloufi__UW_Document__c>{objUWDocument.Month__c=>objUWDocument});                         
                    }
                }
                if(selectedStatementType == 'Processing Statement'){
                    if(processingStatementMap.get(year) != null){
                        if(processingStatementMap.get(year).get(month) == null){
                            Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c();
                            objUWDocument.Name = month+'-'+ year + ' Processing Statement';
                            objUWDocument.Stip_Name__c = objUWDocument.Name;
                            objUWDocument.Cloufi__Type__c = 'Processing Statement';
                            objUWDocument.Month__c = month;
                            objUWDocument.Year__c = year;
                            objUWDocument.Cloufi__Opportunity__c = recordID;
                            uwDocumentList.add(objUWDocument);                        
                        }
                    }else{
                        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c();
                        objUWDocument.Name = month+'-'+ year + ' Processing Statement';
                        objUWDocument.Stip_Name__c = objUWDocument.Name;
                        objUWDocument.Cloufi__Type__c = 'Processing Statement';
                        objUWDocument.Month__c = month;
                        objUWDocument.Year__c = year;
                        objUWDocument.Cloufi__Opportunity__c = recordID;
                        uwDocumentList.add(objUWDocument);
                        processingStatementMap.put(objUWDocument.Year__c, new Map<String, Cloufi__UW_Document__c>{objUWDocument.Month__c=>objUWDocument});                           
                    }
                }
            }
            
            if(uwDocumentList.size()>0){                
                insert uwDocumentList;                
            }
        }
        System.debug('uwDocumentList ->'+uwDocumentList);
        Pagereference objPR = new Pagereference('/apex/AddUWDocuments?id='+recordID);
        objPR.setRedirect(true);        
        return objPR;
    }

    /*public void goBack(){
        renderRequestDocument = false;
    }*/

    public class StipWrapper {
        public Cloufi__UW_Document__c objStip{get;set;}
        //public String Question {get;set;}
        public Boolean IsSelected {get;set;}
        //public Id recId{get;set;}

        public StipWrapper(Cloufi__UW_Document__c objStip, Boolean selected){
            this.objStip = objStip;
            this.IsSelected  = selected;
        }

        public StipWrapper(Cloufi__UW_Document__c objStip){
            this.objStip = objStip;
            this.IsSelected = false;
        }
    }

    public class StipTypeWrapper{           
       public String stipType{get;set;}
       public Attachment objAttachment {get;set;}
       public Boolean IsSelected {get;set;}
       public Cloufi__UW_Document__c reqSt {get;set;}
     
          public StipTypeWrapper(String stipType, Boolean selected,Cloufi__UW_Document__c reqSt){//,Attachment objAttachment
            this.stipType = stipType;
            this.IsSelected  = selected;
            this.reqSt  = reqSt;
            //this.objAttachment  = objAttachment;
        }
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
    
    @RemoteAction
    global static string getDropboxToken(){
        return [select Cloufi__Access_Token__c from Cloufi__Dropbox_Settings__c where Cloufi__Name__c = 'Access Token'].Cloufi__Access_Token__c; 
    }
}