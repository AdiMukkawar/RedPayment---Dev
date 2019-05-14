/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: PricingOptionCalculatorExtension
* Created Date: 18-Feb-2016
* Description: Extension for invited funder
*******************************************************************/

/*
Author  | Date       | Description
Neha    | 14/04/2018 | Updated controller to insert offer status on inserting new offer
Aditya  | 28/09/2018 | Updated offer query to exclude custom offers
Neha    | 10/2/2018  | Added UW documents under custom offer
*/

global with sharing class PricingOptionCalculatorExtension {

    public Opportunity loan{get;set;}
    public String loanId{get;set;}
    public List<Cloufi__Offers__c> ListOfferRecord{get;set;}
    public List<OfferWrapperClass> OfferWrapperList{get;set;}
    public List<Cloufi__Offers__c> DeletedOfferRecords {get;set;}
    public List<ID> ListSelectedOffer {get;set;}
    public boolean Flag{get;set;}
    public Integer getIndex{get;set;}
    public Integer getNoteIndex{get;set;}
    public ID accountId{get;set;}
    public Cloufi__Application__c objApplication {get;set;}
    public List<Cloufi__UW_Document__c> stipsList {get;set;}
    public List<UW_Document_Share__c> stipsToShare{get;set;}
    public List<StipTypeWrapper> lstStipTypeWrapper {get;set;}
    public boolean isRequestStip {get;set;}
    public boolean isShowOffers {get;set;}
    public boolean isFundingDeclined {get;set;}
    public boolean declineFunding {get;set;}
    public boolean isAddstip {get;set;}
    public Id ContactId;
    public List<Opportunity> oppList{get;set;}
    public List<Cloufi__UW_Document__c> lstStipToInsert{get;set;}
    public Cloufi__UW_Document__c objStip {get;set;}
    public String StipType {get;set;}
    public String StipComment {get;set;}
    public Cloufi__Offers__c objectOffer {get;set;}
    public ID submissionId{get;set;}
    public Cloufi__Offers__c objOffer {get;set;}
    public Attachment myfile{get;set;}
    public boolean customOffer{get;set;}
    public String updateStatus {get;set;}  
    public String declineReason {get;set;}  
    public Map<String,UW_Document_Share__c> UWShareMap{get;set;}
    public Map<String,Cloufi__UW_Document__c> UWDocMap;
    public boolean showOfferPage{get;set;}
    public Cloufi__Submission__c Submission{get;set;}
    public Cloufi__UW_Document__c objCustomOfferStip;

    public List<OfferWrapperClass> loanOfferList{get;set;}
    public List<OfferWrapperClass> mcaOfferList{get;set;}
    public List<OfferWrapperClass> advanceOfferList{get;set;}
    public Blob attachmentBlob{get;set;}
    public String fileNameStr{get;set;}
    public List<StipWrapper> stipWrapperList{get;set;}
    public List<String> filesPathList{get;set;}
    public boolean showHideButton {get;set;}
    public boolean isDownloadSpecificButtonDisabled {get; set;}

    //private Set<String> loanFieldsSet = new Set<String>{'Name','Cloufi__Legal_Corporate_Name__c','CreatedDate','Cloufi__Factor_Rate__c','Cloufi__Monthly_Gross_Sale__c','Amount', 'Cloufi__Business_DBA_Name__c', 'Cloufi__Credit_Score__c', 'Cloufi__Avg_Daily_Bank_Bal__c','Cloufi__Loan_Term__c'};
    private Set<String> loanFieldsSet = new Set<String>{'Name','Cloufi__Legal_Corporate_Name__c','CreatedDate','Cloufi__Factor_Rate__c','Cloufi__Monthly_Gross_Sale__c','Amount', 'Cloufi__Business_DBA_Name__c', 'Cloufi__Credit_Score__c', 
                                                         'Cloufi__Avg_Daily_Bank_Bal__c','Cloufi__Loan_Term__c'};//'Cloufi__Business_DBA_Years_in_Business__c',
       
                                                       
    
    public PricingOptionCalculatorExtension(ApexPages.StandardController controller) {
        system.debug('Inside Constructor');
        showOfferPage = true;
        accountId = ApexPages.currentPage().getParameters().containsKey('accId') ? ApexPages.currentPage().getParameters().get('accId') : null;
        submissionId = ApexPages.currentPage().getParameters().containsKey('submissionId') ? ApexPages.currentPage().getParameters().get('submissionId') : null;
        myfile = new Attachment();
        lstStipTypeWrapper = new List < StipTypeWrapper > ();
        loanId = controller.getRecord().id;
        loan = new Opportunity();
        OfferWrapperList = new List < OfferWrapperClass > ();
        stipsList = new List < Cloufi__UW_Document__c > ();
        stipsToShare = new List<UW_Document_Share__c>();
        isShowOffers = false;
        isFundingDeclined = false;
        declineFunding = false;
        objStip = new Cloufi__UW_Document__c();
        loanOfferList = new List<OfferWrapperClass>();
        mcaOfferList = new List<OfferWrapperClass>();
        advanceOfferList = new List<OfferWrapperClass>();
        objCustomOfferStip = new Cloufi__UW_Document__c();
        lstStipToInsert = new List<Cloufi__UW_Document__c>();
        declineReason = '';
        ListOfferRecord = new List<Cloufi__Offers__c>();
        stipWrapperList = new List<StipWrapper>();
    
        if(loanId == null){
            showOfferPage=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Page must be invoked from Loan.'));
        }
        Submission = new Cloufi__Submission__c();
        if(submissionId != null){
            Submission = [SELECT Name,Cloufi__Status__c,Cloufi__Submission_Type__c,Decline_Reason__c, Cloufi__Program__c, Cloufi__Lender__c, Cloufi__Lender__r.Name FROM Cloufi__Submission__c WHERE id=:submissionId];            
        }

        if(Submission.Cloufi__Status__c == 'Approved'){
            showOfferPage=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Deal is closed'));
            //return;
        }
        
         if(Submission.Cloufi__Status__c == 'Declined'){
            //showOfferPage=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Deal is declined previously'));
            //return;
        }
    
        for(Schema.FieldSetMember objFSM: SObjectType.Opportunity.FieldSets.Cloufi__Funder_Offer_Calculate.getFields()) {
            loanFieldsSet.add(objFSM.getFieldPath());
        }
    
        for(Schema.FieldSetMember objFSM: SObjectType.Opportunity.FieldSets.Cloufi__Company_Information.getFields()) {
            loanFieldsSet.add(objFSM.getFieldPath());
        }
    
        for(Schema.FieldSetMember objFSM: SObjectType.Opportunity.FieldSets.Cloufi__Banking_Information.getFields()) {
            loanFieldsSet.add(objFSM.getFieldPath());
        }
        
        

        objApplication = new Cloufi__Application__c();
        if(objApplication != null) {
            try{
                if(Schema.sObjectType.Cloufi__Application__c.isAccessible() && Schema.sObjectType.Opportunity.isAccessible() && Schema.sObjectType.Cloufi__Application__c.fields.Id.isAccessible() && Schema.sObjectType.Cloufi__Application__c.fields.Cloufi__Opportunity__c.isAccessible() && Schema.sObjectType.Cloufi__Application__c.fields.Name.isAccessible()) {
                    objApplication = [SELECT id, Name FROM Cloufi__Application__c where Cloufi__Opportunity__c = :loanID ORDER BY LastModifiedDate DESC LIMIT 1];
                }
            }catch(Exception e) {
    
            }    
        }
    
        if(Schema.sObjectType.Opportunity.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.isAccessible()){

            String strQueryLoan = 'Select ' + String.join(new List < String > (loanFieldsSet), ',') + ',Sales_Support_Email__c,Opportunity_Owner_Manager__r.Email,Owner.Email,Opportunity_Owner_Manager__c,Owner.Company_Logo__c FROM Opportunity where id =: loanId';
            /*String strQueryLoan;//,Cloufi__Gross_Profit__c
            if(!test.isRunningTest()){
                system.debug('Not isRunningTest');
                strQueryLoan = 'Select ' + String.join(new List < String > (loanFieldsSet), ',') + ',Cloufi__Gross_Profit__c,Sales_Support_Email__c,Opportunity_Owner_Manager__r.Email,Owner.Email,Opportunity_Owner_Manager__c,Owner.Company_Logo__c FROM Opportunity where id =: loanId';
            }else{
                system.debug('isRunningTest');
                strQueryLoan = 'Select ' + String.join(new List < String > (loanFieldsSet), ',') + ',Sales_Support_Email__c,Opportunity_Owner_Manager__r.Email,Owner.Email,Opportunity_Owner_Manager__c,Owner.Company_Logo__c FROM Opportunity where id =: loanId';
            }*/
            loan = Database.query(strQueryLoan);

            List<Cloufi__Offers__c> lstOfferFunderDeclined = new List<Cloufi__Offers__c>();

            if(Schema.sObjectType.Cloufi__Offers__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Id.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Cloufi__Daily_PB_Amount__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Cloufi__Offer_Status__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Factor_Rate__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Cloufi__Opportunity__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Cloufi__Payback_Amount__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Cloufi__Percentage_Of_Gross__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Cloufi__Terms_In_Months__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Cloufi__Funder__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Cloufi__Funding_Amount__c.isAccessible()) {
                
                if(accountId != null) {
                    // Aditya - 28-Sep-2018 - Added Record Type condition to Remove custom offers to show
                    ListOfferRecord = [SELECT RecordType.Name,Product_Name__c, Program_Type__c, Payment_Schedule__c, Additional_Fees__c, Origination_Fee__c, Cloufi__Notes__c, Holdback_Per__c, Cloufi__Daily_PB_Amount__c, Cloufi__Offer_Status__c, Factor_Rate__c, Cloufi__Funding_Amount__c, Cloufi__Opportunity__c, Cloufi__Payback_Amount__c, Cloufi__Percentage_Of_Gross__c, Cloufi__Terms_In_Months__c, Id FROM Cloufi__Offers__c where Cloufi__Funder__c = :accountId and Cloufi__Opportunity__c = :loan.id AND Cloufi__Offer_Status__c != 'Funder Declined' AND RecordType.Name!='Custom'];
    
                    lstOfferFunderDeclined = [SELECT Product_Name__c, Program_Type__c, Payment_Schedule__c, Additional_Fees__c, Origination_Fee__c, Cloufi__Notes__c, Holdback_Per__c, Cloufi__Daily_PB_Amount__c, Cloufi__Offer_Status__c, Factor_Rate__c, Cloufi__Funding_Amount__c, Cloufi__Opportunity__c, Cloufi__Payback_Amount__c, Cloufi__Percentage_Of_Gross__c, Cloufi__Terms_In_Months__c, Id FROM Cloufi__Offers__c where Cloufi__Funder__c = :accountId and Cloufi__Opportunity__c = :loan.id AND Cloufi__Offer_Status__c = 'Funder Declined'];
                    isFundingDeclined = !lstOfferFunderDeclined.isEmpty();
                }
                else ListOfferRecord = [SELECT RecordType.Name,Product_Name__c, Program_Type__c, Payment_Schedule__c, Additional_Fees__c, Origination_Fee__c, Cloufi__Notes__c, Holdback_Per__c, Cloufi__Daily_PB_Amount__c, Cloufi__Offer_Status__c, Factor_Rate__c, Cloufi__Funding_Amount__c, Cloufi__Opportunity__c, Cloufi__Payback_Amount__c, Cloufi__Percentage_Of_Gross__c, Cloufi__Terms_In_Months__c, Id FROM Cloufi__Offers__c where Cloufi__Opportunity__c = :loan.id AND Cloufi__Offer_Status__c != 'Funder Declined' AND RecordType.Name!='Custom'];
            }
            system.debug('ListOfferRecord >>'+ListOfferRecord);
            if(ListOfferRecord.size() > 0){
                for(Cloufi__Offers__c offer: ListOfferRecord){
                    OfferWrapperList.add(new OfferWrapperClass(offer, OfferWrapperList.size()));
                    if(offer.Program_Type__c == 'Loan'){
                        loanOfferList.add(new OfferWrapperClass(offer, loanOfferList.size()));
                    }else if(offer.Program_Type__c == 'MCA'){
                        mcaOfferList.add(new OfferWrapperClass(offer, mcaOfferList.size()));
                    }else if(offer.Program_Type__c == 'ACH'){
                        advanceOfferList.add(new OfferWrapperClass(offer, advanceOfferList.size()));
                    }
                }
            }
            system.debug('OfferWrapperList >>'+OfferWrapperList);
            for(OfferWrapperClass O: OfferWrapperList) {
                O.IsEditable = True;
            }
    
            UWDocMap = new Map<String,Cloufi__UW_Document__c>();
                for(Cloufi__UW_Document__c objUW : [Select Name,Requested_By_Lender__c,Stip_Name__c,Cloufi__URL__c, Cloufi__Type__c, Cloufi__Display_Size__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c = :loanId ORDER BY Name ASC])//AND URL__c !=''];
                {
                    if(objUW.Stip_Name__c != null){
                        UWDocMap.put(objUW.Stip_Name__c,objUW);
                    }                    
                } 
           
            UWShareMap = new Map<String,UW_Document_Share__c>();
            stipsToShare = [select Name,Account__c,Opportunity__c,UW_Documents__c,UW_Documents__r.Cloufi__URL__c,UW_Documents__r.Stip_Name__c from UW_Document_Share__c where Opportunity__c = : loanId AND Account__c =: accountId ORDER BY UW_Documents__r.Stip_Name__c ASC];
            for(UW_Document_Share__c objShare : stipsToShare){
                UWShareMap.put(objShare.UW_Documents__r.Stip_Name__c,objShare);
                stipWrapperList.add(new StipWrapper(UWDocMap.get(objShare.UW_Documents__r.Stip_Name__c), true));
            }            
            
            for(String stipName : UWDocMap.keySet()){
                if(!UWShareMap.containsKey(stipName) && UWDocMap.get(stipName).Requested_By_Lender__c){
                    //stipsToShare.add(new UW_Document_Share__c(UW_Documents__c=UWDocMap.get(stipName).Id, Opportunity__c=UWDocMap.get(stipName).Cloufi__Opportunity__c));
                    stipWrapperList.add(new StipWrapper(UWDocMap.get(stipName), false));
                }
            }


            System.debug('UWShareMap-->'+UWShareMap);
            
            //Map<String, UW_Documents_Settings__c> uwDocumentSettingsMap = UW_Documents_Settings__c.getAll();
            Map<String, UW_Documents_Settings__c> uwDocumentSettingsMap = new Map<String, UW_Documents_Settings__c>([select Name,Stage__c,Type__c from UW_Documents_Settings__c where Type__c='Stip']);
            List<String> uwDocumentSettingNameList = new List<String>();
            for(UW_Documents_Settings__c objUWSetting : uwDocumentSettingsMap.values()){
                uwDocumentSettingNameList.add(objUWSetting.Name);
            }
            //uwDocumentSettingNameList.addAll(uwDocumentSettingsMap.keySet());
            uwDocumentSettingNameList.sort();
            for(String uwDocumentName : uwDocumentSettingNameList) {
                if(!UWShareMap.containsKey(uwDocumentName)){
                    lstStipTypeWrapper.add(new StipTypeWrapper(uwDocumentName,false,'',false));
                }
            }            
        }
    
        DateTime dt = loan.CreatedDate;
        String Month = dt.format('MMMM');
    
        Datetime lastmonth = dt - 30;
        String LastM = lastmonth.format('MMMM');
    
        DateTime lastToLast = dt - 60;
        String lastT = lastToLast.format('MMMM');
        updateStatus = '';
        
        filesPathList = new List<String>();
        if(loanId != null){         
            for(UW_Document_Share__c objDoc : [SELECT Id, Opportunity__r.Cloufi__Dropbox_Folder_Path__c, UW_Documents__c, UW_Documents__r.Cloufi__URL__c 
                FROM UW_Document_Share__c WHERE UW_Documents__c != null AND UW_Documents__r.Cloufi__URL__c != null AND Opportunity__c =: loanId AND Account__c =: accountId]){
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

    public void showOffers() {
        isShowOffers = true;
        declineFunding = false;
        isFundingDeclined = false;
        declineReason = '';
        if (ListOfferRecord.size() == 0) AddOffer();
    }
    
    public void requestStipsSave() {
        
        String submissionMaker = '';
        if(Submission.Cloufi__Lender__c!=null){
            system.debug('submission made by >>'+Submission.Cloufi__Lender__r.Name);
            submissionMaker = Submission.Cloufi__Lender__r.Name;
        }
        
        lstStipToInsert = new List<Cloufi__UW_Document__c> ();
        List<UW_Document_Share__c> lstSharedStipToInsert = new List<UW_Document_Share__c> ();

        Map<Id,Cloufi__UW_Document__c> stipsMap = new  Map<Id,Cloufi__UW_Document__c>();

        try {
            String strStipRequests = '';
            String stipTypeString = '';
            for(StipTypeWrapper stipWrap: lstStipTypeWrapper) {
                
                if(stipWrap.isCustom){
                    stipTypeString = 'Custom Document';
                }else{
                    stipTypeString = 'Stip';
                }
                if(stipWrap.IsSelected) {
                    stipWrap.strComment = String.isNotEmpty(stipWrap.strComment) ? stipWrap.strComment + '. Requested by: '+ submissionMaker: 'Requested By Funder '+submissionMaker;
                    strStipRequests += stipWrap.stipType + ', ';
                    if(UWDocMap.containsKey(stipWrap.stipType)){
                        Cloufi__UW_Document__c objStip = UWDocMap.get(stipWrap.stipType);
                        System.debug('StipType  ---->>>'+StipType);
                        System.debug('stipWrap.stipType  ---->>>'+stipWrap.stipType);
                        if(StipType == stipWrap.stipType){
                            objStip.Requested_By_Lender__c = true;
                        }
                        objStip.Cloufi__Type__c = stipTypeString;
                        lstStipToInsert.add(objStip);
                    }
                    else { //(!UWDocMap.containsKey(stipWrap.stipType))
                        lstStipToInsert.add(new Cloufi__UW_Document__c(Name = stipWrap.stipType, Requested_By_Lender__c = true, Stip_Name__c = stipWrap.stipType,Cloufi__Type__c = stipTypeString, Cloufi__Opportunity__c = loanId, Comment__c = stipWrap.strComment));                        
                    }                    
                }
            }

            if(lstStipToInsert.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one stip!'));
                return;
            }
            if(lstStipToInsert.size() > 0){
                if(Schema.sObjectType.Cloufi__UW_Document__c.isCreateable()){
                    upsert lstStipToInsert;
                }
    
                UWDocMap = new Map<String,Cloufi__UW_Document__c>();
                for(Cloufi__UW_Document__c objUW : [Select Name,Requested_By_Lender__c,Stip_Name__c,Cloufi__URL__c, Cloufi__Type__c, Cloufi__Display_Size__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c = :loanId ORDER BY Name ASC])//AND URL__c !=''];
                {
                    if(objUW.Stip_Name__c != null){
                        UWDocMap.put(objUW.Stip_Name__c,objUW);
                    }                    
                }
                
                if(Opportunity.sObjectType.getDescribe().isUpdateable()){
                    if(Schema.sObjectType.Opportunity.fields.Cloufi__Stip_Request__c.isUpdateable() && Schema.sObjectType.Opportunity.fields.Cloufi__Upload_Stips__c.isUpdateable()){
                        loan.Cloufi__Stip_Request__c = strStipRequests;
                        loan.Cloufi__Upload_Stips__c = true;
                    }
                    update loan;
                }
            }

            for(Cloufi__UW_Document__c objUW : lstStipToInsert){

                if(!UWDocMap.containsKey(objUW.Name)){
                    lstSharedStipToInsert.add(new UW_Document_Share__c(Opportunity__c=loanId,UW_Documents__c=objUW.Id,Account__c=accountId));
                }else{
                    //lstSharedStipToInsert.add(new UW_Document_Share__c(Opportunity__c=loanId,UW_Documents__c=objUW.Id,Account__c=accountId));
                }
            }

            //Insert share document
            if(lstSharedStipToInsert.size()>0){
                insert lstSharedStipToInsert;
            }

            isRequestStip = false;
            stipWrapperList = new List<StipWrapper>();

            lstStipTypeWrapper = new List<StipTypeWrapper>();
            UWShareMap = new Map<String,UW_Document_Share__c>();
            stipsToShare = [select Name,Account__c,Opportunity__c,UW_Documents__c,UW_Documents__r.Cloufi__URL__c,UW_Documents__r.Stip_Name__c from UW_Document_Share__c where Opportunity__c = : loanId AND Account__c =: accountId ORDER BY UW_Documents__r.Stip_Name__c ASC];
            for(UW_Document_Share__c objShare : stipsToShare){
                UWShareMap.put(objShare.UW_Documents__r.Stip_Name__c,objShare);
                stipWrapperList.add(new StipWrapper(UWDocMap.get(objShare.UW_Documents__r.Stip_Name__c),true));
            }            
            
            for(String stipName : UWDocMap.keySet()){
                if(!UWShareMap.containsKey(stipName) && UWDocMap.get(stipName).Requested_By_Lender__c){
                    //stipsToShare.add(new UW_Document_Share__c(UW_Documents__c=UWDocMap.get(stipName).Id, Opportunity__c=UWDocMap.get(stipName).Cloufi__Opportunity__c));
                    stipWrapperList.add(new StipWrapper(UWDocMap.get(stipName), false));
                }
            }
            
            //Map<String, UW_Documents_Settings__c> uwDocumentSettingsMap = UW_Documents_Settings__c.getAll();
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

            sendStips();
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage() + e.getLineNumber()));
        }
    }
    
    public void sendStips(){
        String Site_URL = '';
        Cloufi__LendingXL_Settings__c LendingXLSettings = Cloufi__LendingXL_Settings__c.getinstance('Site_URL');
        if(LendingXLSettings != null){
            Site_URL = LendingXLSettings.Cloufi__Value__c;
        }
        try{
    
            List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
    
            LoanId = ApexPages.currentPage().getParameters().get('id');
    
            if(Schema.sObjectType.OpportunityContactRole.isAccessible() && Schema.sObjectType.OpportunityContactRole.fields.Id.isAccessible() && Schema.sObjectType.OpportunityContactRole.fields.ContactId.isAccessible() && Schema.sObjectType.OpportunityContactRole.fields.OpportunityId.isAccessible()) {
                for(OpportunityContactRole ocr: [SELECT id, ContactId FROM OpportunityContactRole WHERE OpportunityId = :LoanId]) {
                    ContactId = ocr.ContactId;
                }
            }
    
            if(Schema.sObjectType.Opportunity.isAccessible() && Schema.sObjectType.User.isAccessible() && Schema.sObjectType.Opportunity.fields.Id.isAccessible() && Schema.sObjectType.Opportunity.fields.Name.isAccessible() && Schema.sObjectType.Opportunity.fields.Cloufi__Borrower_Email__c.isAccessible()) {
                oppList = [SELECT id, Name, Cloufi__Borrower_Email__c, Owner.Sales_Support_Email__c, owner.Name,Owner.Id FROM Opportunity WHERE id = :LoanId LIMIT 1];
            }
            
            //System.debug('base url-->'+new);
            if(oppList[0] != Null && oppList[0].owner.Sales_Support_Email__c != null && oppList[0].owner.Id != null) {
                Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                List < String > emailIds = new List < String > ();
                emailIds.add(oppList[0].owner.Sales_Support_Email__c);
                emailMsg.setToAddresses(emailIds);
                //emailMsg.setTargetObjectId(oppList[0].owner.Id);
                emailMsg.setSubject('Request for new Stips');
                String htmlBody = 'Dear ' + oppList[0].Name + '<br/><br/>';
                htmlBody += 'Please provide the below newly added stips for the opportunity <a href="https://merchantservices.lightning.force.com/'+oppList[0].Id+'">'+oppList[0].Name+'</a><br/>';
                if(lstStipToInsert.size() > 0) {
                    System.debug('lstStipToInsert-->'+lstStipToInsert);
                    htmlBody += '<ol>';
                    for(Cloufi__UW_Document__c l: lstStipToInsert) {
                        htmlBody += '<li>' + l.Stip_Name__c + '</li> ';    
                    }
                    htmlBody += '</ol>';
                    /*if(objStip != Null) {
                        htmlBody += '' + StipType + ', <br/> <br/>';
                    }*/
                }
    
                htmlBody += 'Thank You!';
                emailMsg.setHtmlBody(htmlBody);
                emailMsg.setWhatId(LoanId);
                lstEmailMsg.add(emailMsg);
                System.debug('Email Message' + emailMsg);
            }
            Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmailMsg);

            if(results.size()>0){
                if(results[0].success) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Request Submitted'));
                }else{
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                }
            }
    
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage() + ex.getLineNumber()));
            System.debug('Errors------>' + ex.getMessage() + ex.getLineNumber());
            return;
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
    
    public void fundingDeclined() {
        
        declineFunding = true;
        if(declineReason != null && declineReason != ''){
            isFundingDeclined = true;
            updateStatus = 'Declined';
            updateSubmission();
        }
    }
    
    //Atul - Update Submission Status 
    public void updateSubmission() {
        if (Schema.sObjectType.Cloufi__Submission__c.isAccessible() && Schema.sObjectType.Cloufi__Submission__c.fields.Id.isAccessible() && Schema.sObjectType.Cloufi__Submission__c.fields.Cloufi__Status__c.isAccessible()) {
            if(submissionId != null) {
                Cloufi__Submission__c objSubmission = [SELECT Id,Name, Cloufi__Status__c,Decline_Reason__c FROM Cloufi__Submission__c WHERE Id = :submissionId];
                if(updateStatus == 'Received' ) {
                    objSubmission.Decline_Reason__c = '';
                    objSubmission.Cloufi__Status__c = updateStatus;                                        
                }
                if(updateStatus == 'Declined' && declineReason != null && declineReason != ''){
                    objSubmission.Cloufi__Status__c = updateStatus;
                    objSubmission.Decline_Reason__c = declineReason;
                }

                /*if(objSubmission.Cloufi__Status__c == 'Declined'){
                    notifySalesSupport(objSubmission);
                    notifySalesRep(objSubmission.Decline_Reason__c);
                }*/
                update objSubmission;
            }
        }
    }
    
    public void notifySalesSupport(Cloufi__Submission__c objSubmission){
        try{
            List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
            List<Account> accList = [select name from Account where id=:accountId];
            List<Task> tasklist=new List<Task>();               
            Set<Id> lenderId = new Set<id>();
            List<String> ToEmailIds=new List<String>();            
            EmailTemplate emailTemp;
            
            List<EmailTemplate> templateList = new List<EmailTemplate>();
            templateList = [SELECT Id, Body, Subject FROM EmailTemplate WHERE DeveloperName = 'Funding_Declined'];
            
            if(templateList!=null && templateList.size()>0){
                emailTemp = templateList[0];
                String htmlBody = emailTemp.Body;
                String emailSubject = emailTemp.Subject;
                //htmlBody = htmlBody.replace('OpportunityName', '<a href="'+System.URL.getSalesforceBaseURL().toExternalForm()+'/'+ loan.Id + '" target="_blank">'+loan.Name+'</a>');
                //htmlBody = htmlBody.replace('OpportunityName', loan.Name);
                htmlBody = htmlBody.replace('declineReason',objSubmission.Decline_Reason__c);
                htmlBody = htmlBody.replace('submissionLink','<a href="'+Label.Base_URL+'/'+ objSubmission.Id + '" target="_blank">'+objSubmission.Name+'</a>' );
                emailSubject = emailSubject.replace('lenderName',accList[0].Name);
                emailSubject = emailSubject.replace('dealName',loan.Name);
                Id targetObject;
                
                if(loan.Sales_Support_Email__c != null){
                    ToEmailIds.add(loan.Sales_Support_Email__c);
                    Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                    //Email Message
                    emailMsg.setToAddresses(ToEmailIds);
                    //emailMsg.subject = emailTemp.Subject;           
                    //emailMsg.setTargetObjectId(targetObject);
                    emailMsg.setWhatId(objSubmission.Id);
                    emailMsg.setHtmlBody(htmlBody);
                    emailMsg.setSubject(emailSubject);
                    emailMsg.setTemplateId(emailTemp.Id);
                    emailMsg.SaveAsActivity = False;
                    lstEmailMsg.add(emailMsg);
                    
                    if(lstEmailMsg.size()>0){
                        Messaging.sendEmail(lstEmailMsg);
                    }
                }
                System.debug('lstEmailMsg-->'+lstEmailMsg);
            }

            
        }catch(exception ex){
            System.debug('error -->'+ex.getMessage()+' on line --> '+ex.getLineNumber());
            System.debug('*****error*****'+ex.getStackTraceString());
        }
    }

    public void notifySalesRep(String decReason){
        try{
            List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();   
            List<String> ToEmailIds=new List<String>();
            List<String> CCEmailIds=new List<String>();            
            EmailTemplate emailTemp;
            
            List<EmailTemplate> templateList = new List<EmailTemplate>();
            templateList = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Funding_Declined_To_Sales_Rep'];
            List<Account> accList = [select name from Account where id=:accountId];
            
            if(templateList!=null && templateList.size()>0){
                emailTemp = templateList[0];
                String htmlBody = emailTemp.HtmlValue;
                String emailSubject = emailTemp.Subject;
                //htmlBody = htmlBody.replace('OpportunityName', '<a href="'+System.URL.getSalesforceBaseURL().toExternalForm()+'/'+ loan.Id + '" target="_blank">'+loan.Name+'</a>');
                //htmlBody = htmlBody.replace('OpportunityName', loan.Name);
                htmlBody = htmlBody.replace('declineReason',decReason);
                htmlBody = htmlBody.replace('oppName',loan.Name);
                htmlBody = htmlBody.replace('dealName','<a href="'+Label.Base_URL+'/'+ loan.Id + '" target="_blank">'+loan.Name+'</a>' );
                htmlBody = htmlBody.replace('companyLogo','<img src="'+loan.Owner.Company_Logo__c+'"/>');
                emailSubject = emailSubject.replace('dealName',loan.Name);
                emailSubject = emailSubject.replace('lenderName',accList[0].Name);
                Id targetObjectId = loan.Owner.Id;
                if(loan.Owner.Email != null){
                    ToEmailIds.add(loan.Owner.Email);
                    if(loan.Opportunity_Owner_Manager__c != null && loan.Opportunity_Owner_Manager__r.Email != null){
                        CCEmailIds.add(loan.Opportunity_Owner_Manager__r.Email);
                    }
                    
                    Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                    //Email Message
                    emailMsg.setToAddresses(ToEmailIds);
                    //emailMsg.subject = emailTemp.Subject;           
                    //emailMsg.setTargetObjectId(targetObjectId);
                    emailMsg.setWhatId(loan.Id);
                    emailMsg.setHtmlBody(htmlBody);
                    emailMsg.setSubject(emailSubject);
                    emailMsg.setTemplateId(emailTemp.Id);
                    emailMsg.setCcAddresses(CCEmailIds);
                    emailMsg.SaveAsActivity = False;
                    lstEmailMsg.add(emailMsg);

                    
                    if(lstEmailMsg.size()>0){
                        Messaging.sendEmail(lstEmailMsg);
                    }
                }
                System.debug('lstEmailMsg-->'+lstEmailMsg);
            }

            
        }catch(exception ex){
            System.debug('error -->'+ex.getMessage()+' on line --> '+ex.getLineNumber());
            System.debug('*****error*****'+ex.getStackTraceString());
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

    public List < Schema.FieldSetMember > getFields() {
        return SObjectType.Opportunity.FieldSets.Cloufi__Company_Information.getFields();
    }
    
    //wrapper Class
    public Class OfferWrapperClass {
        public Cloufi__Offers__c Offer {get;set;}
        public boolean IsSelected {get;set;}
        public boolean IsEditable {get;set;}
        public integer Index {get;set;}
    
        public OfferWrapperClass(Cloufi__Offers__c objOffer, Integer Index) {
            if(Schema.sObjectType.Cloufi__Offers__c.isAccessible()) {
                this.Offer = objOffer;
                this.Index = Index;
                this.IsEditable = false;
                isSelected = true;
                if(objOffer.Cloufi__Funding_Amount__c != null && objOffer.Factor_Rate__c != null) {
                    this.Offer.Cloufi__Payback_Amount__c = objOffer.Cloufi__Funding_Amount__c * objOffer.Factor_Rate__c;
                    if(objOffer.Cloufi__Terms_In_Months__c != null) {
                        this.Offer.Cloufi__Daily_PB_Amount__c = (this.Offer.Cloufi__Payback_Amount__c / (objOffer.Cloufi__Terms_In_Months__c*20)).setscale(2);
                    }
                    if(objOffer.Payment_Schedule__c == 'Weekly'){
                        this.Offer.Cloufi__Daily_PB_Amount__c = this.Offer.Cloufi__Daily_PB_Amount__c*5;//Math.round(this.Offer.Cloufi__Daily_PB_Amount__c*5)
                    }
                }
            }
        }
        public OfferWrapperClass(Cloufi__Offers__c objOffer, Integer Index, Opportunity objOpp){
            if(Schema.sObjectType.Cloufi__Offers__c.isAccessible()){
                this.Offer = objOffer;
                this.Index = Index;
                this.IsEditable = false;
                isSelected = true;
                if(objOffer.Cloufi__Funding_Amount__c != null && objOffer.Factor_Rate__c != null){
                    this.Offer.Cloufi__Payback_Amount__c = objOffer.Cloufi__Funding_Amount__c * objOffer.Factor_Rate__c;
                    if(objOffer.Cloufi__Terms_In_Months__c != null){
                        this.Offer.Cloufi__Daily_PB_Amount__c = (this.Offer.Cloufi__Payback_Amount__c / (objOffer.Cloufi__Terms_In_Months__c*20)).setscale(2);
                    }
                    if(objOffer.Payment_Schedule__c == 'Weekly'){
                        this.Offer.Cloufi__Daily_PB_Amount__c = this.Offer.Cloufi__Daily_PB_Amount__c*5;//Math.round(this.Offer.Cloufi__Daily_PB_Amount__c*5)
                    }
                    if(objOpp.Cloufi__Gross_Profit__c != null && this.Offer.Cloufi__Daily_PB_Amount__c != null){
                        this.Offer.Cloufi__Percentage_Of_Gross__c = ((this.Offer.Cloufi__Daily_PB_Amount__c * 20) / objOpp.Cloufi__Gross_Profit__c).setScale(2);
                    }else{
                        this.Offer.Cloufi__Percentage_Of_Gross__c = 0;
                    }
                }
            }
        }
    }
    
    public void DeleteOffer() {
        try{
            Cloufi__Offers__c off = new Cloufi__Offers__c();
            DeletedOfferRecords = new List < Cloufi__Offers__c > ();
            system.debug('-------> getIndex Value' + getIndex);
            Integer q = getIndex;
            if(getIndex != null && getIndex < OfferWrapperList.size()) {
    
                OfferWrapperClass detetedRecrd = OfferWrapperList.remove(q);
                if(detetedRecrd.Offer.Id != null) {
                    if(Schema.sObjectType.Cloufi__Offers__c.isDeletable()) {
                        off.id = detetedRecrd.Offer.Id;
                        DeletedOfferRecords.add(off);
                    }
                }
                system.debug('Delete Record List -------> ' + DeletedOfferRecords);
                if(Cloufi__Offers__c.sObjectType.getDescribe().isDeletable()) {
                    delete DeletedOfferRecords;
                }
    
                flag = false;
                for(Integer i = 0; i < OfferWrapperList.size(); i++) {
                    OfferWrapperList[i].index = i;
                }
    
            }else{
                apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, 'Unable to delete record'));
            }
            apexpages.addMessage(new Apexpages.Message(ApexPages.severity.Confirm, 'Record has been deleted'));
    
        }catch(Exception e) {
            apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, e.getMessage()));
        }
    }
    //addding a new offer
    public PageReference AddOffer() {
        
        try{
            
            RecordType rt = [SELECT id, Name FROM RecordType WHERE SobjectType = 'Cloufi__Offers__c' AND DeveloperName = 'Standard' LIMIT 1];
            if(flag == true) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Save the current offer which you are working!'));
            }else {
                
                //Neha --Added offer status - New
                if (Schema.sObjectType.Cloufi__Offers__c.isCreateable()) {
                    OfferWrapperList.add(new OfferWrapperClass(new Cloufi__Offers__c(RecordTypeId = rt.Id, Cloufi__Opportunity__c = loan.Id, Cloufi__Funder__c = accountId, Cloufi__Terms_In_Months__c = loan.Cloufi__Loan_Term__c, Cloufi__Funding_Amount__c = loan.Amount, Factor_Rate__c = loan.Cloufi__Factor_Rate__c,Cloufi__Offer_Status__c = 'New',Program_Type__c='Loan'), OfferWrapperList.size(), loan));
                    flag = true;
                }
            }
        }catch(Exception e) {
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
           System.debug('Error Message ->' + e.getMessage());
            System.debug('Error Stack Trace ->' + e.getStackTraceString());
            return null;
        }
        return null;
    }

    // save the offer
    
    public Pagereference SaveOffer() {
        system.debug('OfferWrapperList in SaveOffer >>'+OfferWrapperList );
        try {
            system.debug('Get Index -------->' + getIndex);
           
            if(accountId == null && Schema.sObjectType.Opportunity.isUpdateable()) update loan;
            Integer q = getIndex;
              //system.debug('Program Type -------->' + OfferWrapperList.get(q).Offer.Cloufi__Percentage_Of_Gross__c);
            if(Cloufi__Offers__c.sObjectType.getDescribe().isUpdateable() && Cloufi__Offers__c.sObjectType.getDescribe().isCreateable()) {
                OfferWrapperList.get(q).Offer.Cloufi__Submission__c = submissionId;
                Cloufi__Offers__c objOffer = OfferWrapperList.get(q).Offer;
                system.debug('objOffer >>'+objOffer);
                
                if(objOffer.Program_Type__c == 'MCA'){
                    objOffer.Cloufi__Daily_PB_Amount__c = 0;
                    objOffer.Cloufi__Percentage_Of_Gross__c = 0;
                    system.debug('INNNN');
                    if(OfferWrapperList.get(q).Offer.Cloufi__Percentage_Of_Gross__c != null){
                        system.debug('INNNN--->');
                        objOffer.Cloufi__Percentage_Of_Gross__c = OfferWrapperList.get(q).Offer.Cloufi__Percentage_Of_Gross__c;
                        system.debug(' objOffer.Cloufi__Percentage_Of_Gross__c -------->' +  objOffer.Cloufi__Percentage_Of_Gross__c);
                    }
                }else {
                        objOffer.Holdback_Per__c = 0;
                        //objOffer.Cloufi__Daily_PB_Amount__c = objOffer.Cloufi__Payback_Amount__c / objOffer.Cloufi__Terms_In_Months__c;
                        if(loan.Cloufi__Gross_Profit__c != null && objOffer.Cloufi__Daily_PB_Amount__c != null){
                            objOffer.Cloufi__Percentage_Of_Gross__c = ((objOffer.Cloufi__Daily_PB_Amount__c * 20) / loan.Cloufi__Gross_Profit__c).setScale(2);
                        }else{
                            objOffer.Cloufi__Percentage_Of_Gross__c = 0;
                        }
                }

                if(Submission.Cloufi__Program__c != null){
                    objOffer.Program__c = Submission.Cloufi__Program__c;
                }
                
                if(objOffer.Cloufi__Terms_In_Months__c != null && objOffer.Cloufi__Funding_Amount__c != null && objOffer.Cloufi__Payback_Amount__c != null && objOffer.Factor_Rate__c != null && objOffer.Cloufi__Daily_PB_Amount__c != null && objOffer.Cloufi__Percentage_Of_Gross__c != null) {
                    upsert OfferWrapperList.get(q).Offer;
                     system.debug('OfferWrapperList.get(q).Offer -------->' +OfferWrapperList.get(q).Offer);
                    //AddUWDocuments();
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Blank Offer can not be Saved'));
                    return null;
                }
                System.debug('Submission.Cloufi__Program__c ->'+Submission.Cloufi__Program__c);

            }
            
            
            OfferWrapperList.get(q).IsEditable = true;
            flag = false;
            updateStatus = 'Received';
            updateSubmission();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Offer has been Saved'));
            return null;
        }
        Catch(Exception ex) {
            System.debug('Error Message ->' + ex.getMessage());
            System.debug('Error Stack Trace ->' + ex.getStackTraceString());
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
            return null;
        }
    
    }
    
      public pagereference SaveCustomOffer() {
        try{
            RecordType rt = [select id, Name from RecordType where SobjectType = 'Cloufi__Offers__c' AND DeveloperName = 'Custom' LIMIT 1];
                Map<string,cloufi__LendingXL_Settings__c> LendingXLSettings = cloufi__LendingXL_Settings__c.getAll();
                string Site_URL = LendingXLSettings.get('cloufi__Site_URL')!=null?LendingXLSettings.get('cloufi__Site_URL').cloufi__value__c:'';
                system.debug('Site_URL=>'+Site_URL);
                string retURl = Site_URL+'Cloufi__PriceCalculatorFunder?Id='+loan.Id+'&accId='+accountId+'&submissionId='+submissionId;
                system.debug('retURl=>'+retURl);
            if(accountId == null) {
                if(Opportunity.sObjectType.getDescribe().isUpdateable()) {
                    update loan;
                }
            }
    
            /*if(Schema.sObjectType.Offers__c.isUpdateableAccessible() && Schema.sObjectType.Offers__c.fields.Id.isAccessible() &&
                Schema.sObjectType.Offers__c.fields.Notes__c.isAccessible()){
                List<Offers__c> listOffer = [Select id,Notes__c,RecordTypeId  from Offers__c where id=:submissionId];
                
               //objectOffer = [Select id,Notes__c,RecordTypeId from Offers__c where id=:submissionId];
                if(Offers__c.sObjectType.getDescribe().isUpdateable() && Offers__c.sObjectType.getDescribe().isCreateable()){
                    objectOffer = new Offers__c();
                    if(listOffer !=null && listOffer.size()>0){
                        objectOffer = listOffer[0];
                    }
                 }
                    System.debug('Offer----->'+objectOffer);  
                    if(Schema.sObjectType.Offers__c.fields.RecordTypeId.isUpdateable() && 
                        Schema.sObjectType.Offers__c.fields.Notes__c.isUpdateable() &&
                        Schema.sObjectType.Offers__c.fields.RecordTypeId.isCreateable() && 
                        Schema.sObjectType.Offers__c.fields.Notes__c.isCreateable() 
                        ){
                        objectOffer.RecordTypeId = rt.id;
                        objectOffer.Notes__c = objOffer.Notes__c;
                    }           
                    
                    System.debug('Object Offer --->'+objectOffer);
                    
                    upsert objectOffer;
                }*/
    
            objectOffer = new Cloufi__Offers__c();
            //Sneha - associate it with submission

            objectOffer.Cloufi__Submission__c = submissionId;
            objectOffer.Cloufi__Opportunity__c = loan.Id;
            objectOffer.Cloufi__Funder__c = accountId;
            objectOffer.RecordTypeId = rt.id;
            objectOffer.Cloufi__Notes__c = objOffer.Cloufi__Notes__c;
            objectOffer.Cloufi__Offer_Status__c = 'New';
            if(Submission.Cloufi__Program__c != null){
                objectOffer.Program__c = Submission.Cloufi__Program__c;
            }
            if(Schema.sObjectType.Cloufi__Offers__c.isUpdateable() && Schema.sObjectType.Cloufi__Offers__c.isCreateable()) {
                upsert objectOffer;
            }

            updateStatus = 'Received';
            updateSubmission();

            system.debug('fileNameStr=>'+fileNameStr+'attachmentBlob=>'+attachmentBlob);
            if(fileNameStr != null && attachmentBlob != null) {
                system.debug('fileNameStr=>'+fileNameStr);
                String documentName = fileNameStr;
                List<String> docNameList = documentName.split('\\.');
                if(docNameList.size() > 0){
                    String extension = docNameList[docNameList.size()-1];
                    system.debug('documentName=>'+documentName);
                    if(docNameList[0].length()>=70){
                        documentName = docNameList[0].subString(0,69)+'.'+extension;
                        system.debug('Inside If=>');
                    }else{
                        documentName = docNameList[0]+'.'+extension;
                        system.debug('Inside else=>');
                    }
                    objCustomOfferStip = new Cloufi__UW_Document__c(Name = 'Custom Offer Attachment',Stip_Name__c='Custom Offer Attachment',Offer__c = objectOffer.Id);
                    insert objCustomOfferStip;
                    system.debug('objCustomOfferStip =>'+objCustomOfferStip);
                    //if (Attachment.sObjectType.getDescribe().isCreateable() && Schema.sObjectType.Attachment.fields.parentId.isCreateable()) {
                        Attachment objAttach = new Attachment();
                        objAttach.parentId = objCustomOfferStip.id;
                        objAttach.name = documentName;
                        objAttach.body = attachmentBlob;
                        insert objAttach;
                        system.debug('objAttach=>'+objAttach);
                    //}
                }
                
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Offer has been Saved!!!'));
            pageReference pg = new pageReference('/PriceCalculatorFunder?Id='+loan.Id+'&accId='+accountId+'&submissionId='+submissionId);
            return pg.setRedirect(true);
           //return null;
        }catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
            system.debug('====>>>>' + ex.getStackTraceString());
            return null;
        }
        //return null;
    }
    
    public pagereference addCustomOffer() {
        customOffer = true;
        objOffer = new Cloufi__Offers__c();
        myfile = new Attachment();
        objCustomOfferStip = new Cloufi__UW_Document__c();
        return null;
    }
    
    public pagereference cancelCustomOffer() {
        customOffer = false;
        return null;
    }
    
    public void SaveNAddNewOffer() {
        SaveOffer();
        AddOffer();
    }

    //Cancel the offer
    public void CancelOffer() {  
        //if(OfferWrapperList.size()>0 && OfferWrapperList.size()-1==getIndex){  
            OfferWrapperList.get(getIndex).isEditable = true;
            if(OfferWrapperList.get(getIndex).Offer.Id == null){
                OfferWrapperList.remove(getIndex);
            }
            flag = false;
        //}
    }
    
    //Edit the offer
    public void EditOffer() {
        if(flag == true) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Save the current offer which you are working!!!'));
        }else{
            //if(OfferWrapperList.size()>0 && OfferWrapperList.size()-1==getIndex){
                if(OfferWrapperList.get(getIndex).isEditable == true) {
                    OfferWrapperList.get(getIndex).isEditable = false;
                }else{
                    OfferWrapperList.get(getIndex).isEditable = true;
                }
                flag = true;
            //}
        }
    }
    
    public Pagereference SendEmail() {
        ListSelectedOffer = new List < ID > ();
        for(OfferWrapperClass offerWrapper: OfferWrapperList) {
            if(offerWrapper.isSelected == true) {
                ListSelectedOffer.add(offerWrapper.Offer.id);
            }
    
        }
        String strExternalParam = ApexPages.currentPage().getParameters().containsKey('externalPage') ? ApexPages.currentPage().getParameters().get('externalPage') : '';
        PageReference EmailOffer = new PageReference('/apex/SentEmailOffers?id=' + loanId + '&externalPage=' + strExternalParam + '&accId=' + accountId);
        EmailOffer.setRedirect(true);
        EmailOffer.getParameters().put('SelectedList', String.join(ListSelectedOffer, ','));
        EmailOffer.getParameters().put('oId', submissionId);
        return EmailOffer;
    }
}