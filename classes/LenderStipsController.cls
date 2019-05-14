/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: LenderStipsController
* Created Date: 01/09/2019
* Description: Controller to show completed Documents to Lender
*******************************************************************/
public class LenderStipsController{
    public id opportunityId{get;set;}
    public id funderId{get;set;}
    public opportunity objOpp{get;set;}
    public List<Cloufi__UW_Document__c> lstStips{get;set;}
    public String StipType {get;set;}
    public String StipComment {get;set;}
    public boolean isRequestStip {get;set;}
    public boolean showHideButton {get;set;}
    public boolean isDownloadSpecificButtonDisabled {get; set;}
    public boolean isAddstip {get;set;}
    public List<StipTypeWrapper> lstStipTypeWrapper {get;set;}
    public Cloufi__UW_Document__c objStip {get;set;}
    public Map<String,UW_Document_Share__c> UWShareMap{get;set;}
    public List<UW_Document_Share__c> stipsToShare{get;set;}
    public List<StipWrapper> stipWrapperList{get;set;}
    public Cloufi__Submission__c Submission{get;set;}
    public List<Cloufi__UW_Document__c> lstStipToInsert{get;set;}
    public Opportunity loan{get;set;}
    public Map<String,Cloufi__UW_Document__c> UWDocMap;
    public List<String> filesPathList{get;set;}
    public boolean showPage {get;set;}
    
    public LenderStipsController(ApexPages.StandardController controller) {
        opportunityId = ApexPages.currentPage().getParameters().get('id');
        funderId = ApexPages.currentPage().getParameters().get('funderId');
        objStip = new Cloufi__UW_Document__c();
        showPage = true;
        system.debug('funderId >>'+funderId);
        system.debug('opportunityId >>'+opportunityId);
        if(opportunityId != null){
            init();                               
        }
    }    
    
    public void init(){ 
        objOpp = new Opportunity();
        loan = new Opportunity();
        lstStips = new List<Cloufi__UW_Document__c>();
        UWShareMap = new Map<String,UW_Document_Share__c>();
        stipsToShare = new List<UW_Document_Share__c>();
        lstStipTypeWrapper = new List < StipTypeWrapper > ();
        stipWrapperList = new List<StipWrapper>();
        Submission = new Cloufi__Submission__c();
        lstStipToInsert = new List<Cloufi__UW_Document__c>();
        UWDocMap = new Map<String,Cloufi__UW_Document__c>();       
        //Get the documents list
        objOpp  = [select id,Name,Cloufi__Funder__c FROM Opportunity WHERE id=:opportunityId];
        
        if(funderId!=  String.valueOf(objOpp.Cloufi__Funder__c).substring(0, 15)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Your association with this deal has expired.'));
            showPage = false;
        }
        
        
        lstStips = new List<Cloufi__UW_Document__c>(); 
        lstStips = [select id,Sent_for_Contract__c,Stip_Name__c,Cloufi__URL__c,Cloufi__Opportunity__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c=:opportunityId AND Sent_for_Contract__c=true];
        system.debug('objOpp.Cloufi__Funder__c=>'+objOpp.Cloufi__Funder__c);
        if(objOpp.Cloufi__Funder__c !=null){
           // Submission = [SELECT Name,Cloufi__Status__c,Cloufi__Submission_Type__c,Decline_Reason__c, Cloufi__Program__c, Cloufi__Lender__c, Cloufi__Lender__r.Name FROM Cloufi__Submission__c WHERE Cloufi__Status__c='Approved' AND Cloufi__Lender__c=:objOpp.Cloufi__Funder__c AND cloufi__Opportunity__c=:opportunityId LIMIT 1];
            Submission = [SELECT Name,Cloufi__Status__c,Cloufi__Submission_Type__c, Cloufi__Program__c, Cloufi__Lender__c, Cloufi__Lender__r.Name FROM Cloufi__Submission__c WHERE Cloufi__Status__c='Approved' AND Cloufi__Lender__c=:objOpp.Cloufi__Funder__c AND cloufi__Opportunity__c=:opportunityId LIMIT 1];
                UWDocMap = new Map<String,Cloufi__UW_Document__c>();
                for(Cloufi__UW_Document__c objUW : [Select Name,Requested_By_Lender__c,Stip_Name__c,Cloufi__URL__c, Cloufi__Type__c, Cloufi__Display_Size__c,Sent_for_Contract__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c = :opportunityId  ORDER BY Name ASC])
                {
                    if(objUW.Stip_Name__c != null){
                        UWDocMap.put(objUW.Stip_Name__c,objUW);
                    }                    
                } 
           
            UWShareMap = new Map<String,UW_Document_Share__c>();
            stipsToShare = [select Name,Account__c,Opportunity__c,UW_Documents__c,UW_Documents__r.Cloufi__URL__c,UW_Documents__r.Stip_Name__c,UW_Documents__r.Sent_for_Contract__c,UW_Documents__r.Status__c from UW_Document_Share__c where Opportunity__c = : opportunityId AND Account__c =: funderId AND UW_Documents__r.Sent_for_Contract__c = true ORDER BY UW_Documents__r.Stip_Name__c ASC];
            system.debug('stipsToShare >>'+stipsToShare);
            system.debug('stipsToShare size >>'+stipsToShare.size());
            for(UW_Document_Share__c objShare : stipsToShare){
                UWShareMap.put(objShare.UW_Documents__r.Stip_Name__c,objShare);
                if(UWDocMap.get(objShare.UW_Documents__r.Stip_Name__c) != null){
                    stipWrapperList.add(new StipWrapper(UWDocMap.get(objShare.UW_Documents__r.Stip_Name__c), true));
                }
            } 
            
            Map<String, UW_Documents_Settings__c> uwDocumentSettingsMap = new Map<String, UW_Documents_Settings__c>([select Name,Stage__c,Type__c from UW_Documents_Settings__c where Type__c='Stip']);
            List<String> uwDocumentSettingNameList = new List<String>();
            for(UW_Documents_Settings__c objUWSetting : uwDocumentSettingsMap.values()){
                uwDocumentSettingNameList.add(objUWSetting.Name);
            }
            uwDocumentSettingNameList.sort();
            for(String uwDocumentName : uwDocumentSettingNameList) {
                if(!UWShareMap.containsKey(uwDocumentName)){
                    lstStipTypeWrapper.add(new StipTypeWrapper(uwDocumentName,false,'',false));
                }
            }
        }
        
        filesPathList = new List<String>();
        objOpp  = new Opportunity(); 
        filesPathList = new List<String>();
        objOpp = [SELECT ID,Name,Cloufi__Dropbox_Folder_Path__c, Cloufi__Funder__c FROM Opportunity WHERE ID =: opportunityId];
        for(UW_Document_Share__c objDoc : [SELECT Id, Opportunity__r.Cloufi__Dropbox_Folder_Path__c, UW_Documents__c, UW_Documents__r.Cloufi__URL__c 
                                           FROM UW_Document_Share__c WHERE UW_Documents__c != null AND UW_Documents__r.Cloufi__URL__c != null AND Opportunity__c =: opportunityId 
                                           AND UW_Documents__r.Sent_for_Contract__c = true AND Account__c =: funderId]){
                if(objDoc.Opportunity__r.Cloufi__Dropbox_Folder_Path__c != null){
                        showHideButton = true;
                        String filepath = '';
                        filepath = objDoc.Opportunity__r.Cloufi__Dropbox_Folder_Path__c.trim();
                        filepath += '/' + objDoc.UW_Documents__r.Cloufi__URL__c.substringAfterLast('/').substringBefore('?').replace('%20',' ');
                        filesPathList.add(filePath);
                    }else{
                        showHideButton = false;
                    }
                if(objDoc.UW_Documents__r.Cloufi__URL__c != null){
                    isDownloadSpecificButtonDisabled = false;
                }else{
                    isDownloadSpecificButtonDisabled = true;
                }
        }
    }

    public void requestStipShow(){
        isRequestStip = true;
    }
    public void AddCustomStip(){
        isAddstip = true;
        isRequestStip = false;
    }
    public void AddCustomStipCancel(){
        isAddstip = false;
    }
    
    public void requestStipShowCancel(){
        isRequestStip = false;
    }

    public void requestStipsSave() {
        try {
            String submissionMaker = '';
            if(Submission.Cloufi__Lender__c!=null){
                submissionMaker = Submission.Cloufi__Lender__r.Name;
            }
            
            lstStipToInsert = new List<Cloufi__UW_Document__c> ();
            List<UW_Document_Share__c> lstSharedStipToInsert = new List<UW_Document_Share__c> ();
            String strStipRequests = '';
            String stipTypeString = '';
            for(StipTypeWrapper stipWrap: lstStipTypeWrapper) {
                if(UWShareMap.containsKey(stipWrap.stipType)){
                    init();
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Duplicate document cannot be Created!'));
                    return;
                }
                if(stipWrap.isCustom){
                    stipTypeString = 'Custom Document';
                }else{
                    stipTypeString = 'Stip';
                }
                if(stipWrap.IsSelected) {
                    stipWrap.strComment = String.isNotEmpty(stipWrap.strComment) ? stipWrap.strComment + '. Requested by: '+ submissionMaker: 'Requested By Funder '+submissionMaker;
                    strStipRequests += stipWrap.stipType + ', ';
                    system.debug('UWDocMap >>'+UWDocMap);
                    
                    if(UWDocMap.containsKey(stipWrap.stipType)){
                        Cloufi__UW_Document__c objStip = UWDocMap.get(stipWrap.stipType);
                        System.debug('StipType  ---->>>'+StipType);
                        System.debug('stipWrap.stipType  ---->>>'+stipWrap.stipType);
                        if(StipType == stipWrap.stipType){
                            objStip.Requested_By_Lender__c = true;
                        }
                        objStip.Cloufi__Type__c = stipTypeString;
                        //objStip.Status__c = 'Requested';//production change
                        lstStipToInsert.add(objStip);
                    }
                    else {
                        lstStipToInsert.add(new Cloufi__UW_Document__c(Name = stipWrap.stipType, Requested_By_Lender__c = true, Stip_Name__c = stipWrap.stipType,Cloufi__Type__c = stipTypeString, Cloufi__Opportunity__c = opportunityId, Comment__c = stipWrap.strComment,Sent_for_Contract__c = false));//, Status__c='Requested'                    
                    }                    
                }
            }

            if(lstStipToInsert.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Please select at least one stip!'));
                return;
            }
            if(lstStipToInsert.size() > 0){
                upsert lstStipToInsert;
            }
            UWDocMap = new Map<String,Cloufi__UW_Document__c>();
            for(Cloufi__UW_Document__c objUW : [Select Name,Requested_By_Lender__c,Stip_Name__c,Cloufi__URL__c, Cloufi__Type__c, Cloufi__Display_Size__c,Sent_for_Contract__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c = :opportunityId AND Sent_for_Contract__c=true ORDER BY Name ASC]){
                
                if(objUW.Stip_Name__c != null){
                    UWDocMap.put(objUW.Stip_Name__c,objUW);
                }                    
            }

            for(Cloufi__UW_Document__c objUW : lstStipToInsert){
                lstSharedStipToInsert.add(new UW_Document_Share__c(Opportunity__c=opportunityId,UW_Documents__c=objUW.Id,Account__c=objOpp.Cloufi__Funder__c));
            }
            system.debug('Before lstSharedStipToInsert=>'+lstSharedStipToInsert);
            //Insert share document
            if(lstSharedStipToInsert.size()>0){
                insert lstSharedStipToInsert;
            }
            system.debug('After lstSharedStipToInsert=>'+lstSharedStipToInsert);
            isRequestStip = false;
            init();
                       
            Map<String, UW_Documents_Settings__c> uwDocumentSettingsMap = new Map<String, UW_Documents_Settings__c>([select Name,Stage__c,Type__c from UW_Documents_Settings__c where Type__c='Stip']);
            List<String> uwDocumentSettingNameList = new List<String>();
            for(UW_Documents_Settings__c objUWSetting : uwDocumentSettingsMap.values()){
                uwDocumentSettingNameList.add(objUWSetting.Name);
            }
            uwDocumentSettingNameList.sort();
            for(String uwDocumentName : uwDocumentSettingNameList) {
                if(!UWShareMap.containsKey(uwDocumentName)){
                    lstStipTypeWrapper.add(new StipTypeWrapper(uwDocumentName,false,'',false));
                }
            }
            showPage = true;
            //sendStips();
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage() + e.getLineNumber()));
        }
    }

    public void AddcustomStipsSave() {
    
        lstStipTypeWrapper.add(new StipTypeWrapper(StipType, true, StipComment,true));
        System.debug('lstStipTypeWrapper -->>'+lstStipTypeWrapper+' Size->'+lstStipTypeWrapper.size());

        try{
            requestStipsSave();
            objStip = new Cloufi__UW_Document__c();
            StipType = '';
            StipComment = '';
            isAddstip = false;
        }catch(DMLException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }

    public class StipTypeWrapper {
    
        public String stipType {get;set;}
        public Boolean IsSelected {get;set;}
        public String strComment {get;set;}
        public Boolean isCustom {get;set;}
        public StipTypeWrapper(String stipType, Boolean selected, String strComment,Boolean isCustom) {
            this.stipType = stipType;
            this.IsSelected = selected;
            this.strComment = strComment;
            this.isCustom = isCustom;
        }
    }
    public class StipWrapper{
        public String stipName{get;set;}
        public String documentURL{get;set;}
        public StipWrapper(Cloufi__UW_Document__c objUWDocument, Boolean isURLNull){
            if(objUWDocument.Stip_Name__c != null){
                this.stipName = objUWDocument.Stip_Name__c;
            }
            if(objUWDocument.Cloufi__URL__c != null && isURLNull){
                this.documentURL = objUWDocument.Cloufi__URL__c;
            }
        }
    }
}