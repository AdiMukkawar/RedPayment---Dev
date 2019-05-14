/*****************************************************************
* Author: Techila Global Services Pvt Ltd (Aditya)
* Class Name: ReviseOfferController
* Created Date: 24-Aug-2018
* Description: Controller for Revise offer
*******************************************************************/

/*
Author  | Date       | Description
*/

global with sharing class ReviseOfferController {

    public Opportunity loan{get;set;}
    public String loanId{get;set;}
    public List<Cloufi__Offers__c> ListOfferRecord{get;set;}
    public List<OfferWrapperClass> OfferWrapperList{get;set;}
    public List<OfferWrapperClass> OfferWrapperListOutput{get;set;}
    //public boolean Flag{get;set;}
    public Integer getIndex{get;set;}
    public ID accountId{get;set;}
    public Cloufi__Application__c objApplication {get;set;}
    //public boolean isFundingDeclined {get;set;}
    public List<UW_Document_Share__c> stipsToShare{get;set;}
    public ID submissionId{get;set;}
    public Cloufi__Offers__c objOffer {get;set;}
    public String updateStatus {get;set;}
    public Map<String,Cloufi__UW_Document__c> UWDocMap;
    public boolean showOfferPage{get;set;}
    public id offerId{get;set;}
    public boolean relatedOffer{get;set;}
    public boolean showButton{get;set;}
    public Cloufi__Offers__c objOfr {get;set;}
    public List<String> filesPathList{get;set;}
    public boolean showHideButton {get;set;}
    public boolean isDownloadSpecificButtonDisabled {get; set;}
    public Boolean showSpinner{get;set;}

    private Set<String> loanFieldsSet = new Set<String>{'Name','Cloufi__Legal_Corporate_Name__c','CreatedDate','Factor_Rate__c','Cloufi__Monthly_Gross_Sale__c','Amount', 'Cloufi__Business_DBA_Name__c', 'Cloufi__Credit_Score__c', 
                                                        'Cloufi__Avg_Daily_Bank_Bal__c','Cloufi__Loan_Term__c'};//'Cloufi__Business_DBA_Years_in_Business__c', 
                                                       
    
    public ReviseOfferController() {
        showSpinner = false;
        showOfferPage = true;
        offerId = ApexPages.currentPage().getParameters().get('id');
        relatedOffer = false;
        showButton = true;
        loan = new Opportunity();
        stipsToShare = new List<UW_Document_Share__c>();
        OfferWrapperList = new List < OfferWrapperClass > ();
        OfferWrapperListOutput = new List < OfferWrapperClass > ();
        
        if(OfferId == null){
            showOfferPage=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Invalid Offer'));
        }
        if(OfferId != null){
           if(OfferId != null){
                objOfr = [SELECT id,Cloufi__Offer_Status__c,Cloufi__Submission__c,Cloufi__Funder__c,Cloufi__Opportunity__c,(SELECT id FROM Offers__r) FROM Cloufi__Offers__c WHERE id=:OfferId];
                if(objOfr.Cloufi__Offer_Status__c=='Rejected'){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Offer is Rejected'));
                }
                if(objOfr.Offers__r.size()>0){
                    relatedOffer = true;
                }
                
            }
            //queryRelatedOffer();
            accountId = objOfr.Cloufi__Funder__c;
            submissionId = objOfr.Cloufi__Submission__c;
            loanId = objOfr.Cloufi__Opportunity__c;
            
            //isFundingDeclined = false;
        
            Cloufi__Submission__c Submission = new Cloufi__Submission__c();
            if(submissionId != null){
                Submission = [select name,Cloufi__Status__c,Cloufi__Submission_Type__c from Cloufi__Submission__c where id=:submissionId];            
            }

            /*if(Submission.Cloufi__Status__c == 'Approved'){
                showOfferPage=false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Submission is closed'));
                //return;
            }*/
            
             if(Submission.Cloufi__Status__c == 'Declined'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Submission is declined previously'));
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

                String strQueryLoan = 'Select ' + String.join(new List < String > (loanFieldsSet), ',') + ' FROM Opportunity where id =: loanId';//,Cloufi__Gross_Profit__c
                loan = Database.query(strQueryLoan);

                List<Cloufi__Offers__c> lstOfferFunderDeclined = new List<Cloufi__Offers__c>();

                if(Schema.sObjectType.Cloufi__Offers__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Id.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Cloufi__Daily_PB_Amount__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Cloufi__Offer_Status__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Factor_Rate__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Cloufi__Opportunity__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Cloufi__Payback_Amount__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Cloufi__Percentage_Of_Gross__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Cloufi__Terms_In_Months__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Cloufi__Funder__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Cloufi__Funding_Amount__c.isAccessible()) {
                  
                    ListOfferRecord = [SELECT Program__c,Product_Name__c,Additional_Fees__c, Program_Type__c, Payment_Schedule__c, Risk_Assessment_Fee__c, Origination_Fee__c, Cloufi__Notes__c, Holdback_Per__c, Cloufi__Daily_PB_Amount__c, Cloufi__Offer_Status__c, Factor_Rate__c, Cloufi__Funding_Amount__c, Cloufi__Opportunity__c, Cloufi__Payback_Amount__c, Cloufi__Percentage_Of_Gross__c, Cloufi__Terms_In_Months__c, Id,Revision_Notes__c,Offer__c,(SELECT Program__c,Product_Name__c,Additional_Fees__c, Program_Type__c, Payment_Schedule__c, Risk_Assessment_Fee__c, Origination_Fee__c, Cloufi__Notes__c, Holdback_Per__c, Cloufi__Daily_PB_Amount__c, Cloufi__Offer_Status__c, Factor_Rate__c, Cloufi__Funding_Amount__c, Cloufi__Opportunity__c, Cloufi__Payback_Amount__c, Cloufi__Percentage_Of_Gross__c, Cloufi__Terms_In_Months__c, Id,Revision_Notes__c,Offer__c FROM Offers__r) FROM Cloufi__Offers__c where id = :offerId AND Cloufi__Offer_Status__c = 'Revision' LIMIT 1];
                }
                stipsToShare = [select Name,Account__c,Opportunity__c,UW_Documents__c,UW_Documents__r.Cloufi__URL__c,UW_Documents__r.Stip_Name__c from UW_Document_Share__c where Opportunity__c = : loanId AND Account__c =: accountId ORDER BY UW_Documents__r.Stip_Name__c ASC];
                
                //system.debug('ListOfferRecord[0]'+ListOfferRecord[0].Cloufi__Percentage_Of_Gross__c);
                if(ListOfferRecord.size()>0){
                    if(ListOfferRecord.size() > 0 && !relatedOffer){
                        for(Cloufi__Offers__c offer: ListOfferRecord){
                            OfferWrapperListOutput.add(new OfferWrapperClass(offer, OfferWrapperList.size()));
                        }
                    }else{
                        for(Cloufi__Offers__c offer: ListOfferRecord[0].Offers__r){
                            OfferWrapperListOutput.add(new OfferWrapperClass(offer, OfferWrapperList.size()));
                        }
                    }
                    for(OfferWrapperClass O: OfferWrapperListOutput) {
                        O.IsEditable = true;
                    }
                }
                    
                
                if(ListOfferRecord.size() > 0){
                    RecordType rt = [SELECT id, Name FROM RecordType WHERE SobjectType = 'Cloufi__Offers__c' AND DeveloperName = 'Standard' LIMIT 1];
                    if (Schema.sObjectType.Cloufi__Offers__c.isCreateable()) {                      
                        OfferWrapperList.add(new OfferWrapperClass(new Cloufi__Offers__c(RecordTypeId = rt.Id, Cloufi__Opportunity__c = loan.Id, Cloufi__Funder__c = accountId, Cloufi__Terms_In_Months__c = ListOfferRecord[0].Cloufi__Terms_In_Months__c, Cloufi__Funding_Amount__c = ListOfferRecord[0].Cloufi__Funding_Amount__c, Factor_Rate__c = ListOfferRecord[0].Factor_Rate__c,Cloufi__Offer_Status__c = 'New',Program_Type__c=ListOfferRecord[0].Program_Type__c,Program__c=ListOfferRecord[0].Program__c,Product_Name__c=ListOfferRecord[0].Product_Name__c,Payment_Schedule__c=ListOfferRecord[0].Payment_Schedule__c,Cloufi__Payback_Amount__c=ListOfferRecord[0].Cloufi__Payback_Amount__c,Cloufi__Daily_PB_Amount__c=ListOfferRecord[0].Cloufi__Daily_PB_Amount__c,Holdback_Per__c=ListOfferRecord[0].Holdback_Per__c,Risk_Assessment_Fee__c=ListOfferRecord[0].Risk_Assessment_Fee__c,Origination_Fee__c=ListOfferRecord[0].Origination_Fee__c,Cloufi__Percentage_Of_Gross__c=ListOfferRecord[0].Cloufi__Percentage_Of_Gross__c,Offer__c=ListOfferRecord[0].id,Additional_Fees__c = ListOfferRecord[0].Additional_Fees__c,Cloufi__Notes__c=ListOfferRecord[0].Cloufi__Notes__c), OfferWrapperList.size(), loan));
                        
                        for(OfferWrapperClass objW:OfferWrapperList){
                            if(objOfr.offers__r.size()>0){
                                objW.IsEditable = true;
                            }else{
                                objW.IsEditable = false;
                            }
                        }
                        
                    }
                }
            }
        }
        
        filesPathList = new List<String>();
        if(loanId != null){         
            for(UW_Document_Share__c objDoc : [SELECT Id, Opportunity__r.Cloufi__Dropbox_Folder_Path__c, UW_Documents__c, UW_Documents__r.Cloufi__URL__c 
                FROM UW_Document_Share__c WHERE UW_Documents__c != null AND UW_Documents__r.Cloufi__URL__c != null AND Opportunity__c =: loanId]){
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
    
    public void queryRelatedOffer(){
        if(OfferId != null){
            objOfr = [SELECT id,Cloufi__Submission__c,Cloufi__Funder__c,Cloufi__Opportunity__c,(SELECT id FROM Offers__r) FROM Cloufi__Offers__c WHERE id=:OfferId];
            if(objOfr.Offers__r.size()>0){
                relatedOffer = true;
                system.debug('objOfr.Offers__r'+objOfr.Offers__r);
            }
        }
    }
    
    public void updateSubmission() {
        if (Schema.sObjectType.Cloufi__Submission__c.isAccessible() && Schema.sObjectType.Cloufi__Submission__c.fields.Id.isAccessible() && Schema.sObjectType.Cloufi__Submission__c.fields.Cloufi__Status__c.isAccessible()) {
            if(submissionId != null) {
                Cloufi__Submission__c objSubmission = [SELECT Id, Cloufi__Status__c FROM Cloufi__Submission__c WHERE Id = :submissionId];
                System.debug('objSubmission-->' + objSubmission);
                if(Schema.sObjectType.Cloufi__Submission__c.isUpdateable() && Schema.sObjectType.Cloufi__Submission__c.fields.Cloufi__Status__c.isUpdateable() ) {
                    objSubmission.Cloufi__Status__c = updateStatus;
                    update objSubmission;
                }
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
                    if(objOffer.Payment_Schedule__c == 'Weekly')
                    {
                        this.Offer.Cloufi__Daily_PB_Amount__c = this.Offer.Cloufi__Daily_PB_Amount__c*5;//Math.round(this.Offer.Cloufi__Daily_PB_Amount__c*5);
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
                        system.debug('this.Offer.Cloufi__Daily_PB_Amount__c=>'+this.Offer.Cloufi__Daily_PB_Amount__c);
                    }
                    if(objOffer.Payment_Schedule__c == 'Weekly')
                    {
                        this.Offer.Cloufi__Daily_PB_Amount__c = this.Offer.Cloufi__Daily_PB_Amount__c*5;//Math.round(this.Offer.Cloufi__Daily_PB_Amount__c*5);
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
    
   
    // save the offer    
    public Pagereference SaveOffer() {
        try {
            system.debug('Get Index -------->' + getIndex);
            if(accountId == null && Schema.sObjectType.Opportunity.isUpdateable()) update loan;
            Integer q = getIndex;
    
            if(Cloufi__Offers__c.sObjectType.getDescribe().isUpdateable() && Cloufi__Offers__c.sObjectType.getDescribe().isCreateable()) {
                OfferWrapperList.get(q).Offer.Cloufi__Submission__c = submissionId;
                Cloufi__Offers__c objOffer = OfferWrapperList.get(q).Offer;  

                if(objOffer.Program_Type__c == 'MCA'){
                    objOffer.Cloufi__Daily_PB_Amount__c = 0;
                    objOffer.Cloufi__Percentage_Of_Gross__c = 0;
                }else{
                    objOffer.Holdback_Per__c = 0;
                }

                if(objOffer.Cloufi__Terms_In_Months__c != null && objOffer.Cloufi__Funding_Amount__c != null && objOffer.Cloufi__Payback_Amount__c != null && objOffer.Factor_Rate__c != null && objOffer.Cloufi__Daily_PB_Amount__c != null && objOffer.Cloufi__Percentage_Of_Gross__c != null) {
                    insert OfferWrapperList.get(q).Offer;
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Blank Offer can not be Saved'));
                    return null;
                }
            }
    
            OfferWrapperList.get(q).IsEditable = true;
            //flag = false;
            updateStatus = 'Received';
            updateSubmission();
            showButton = false;
            //queryRelatedOffer();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Revise Offer has been Saved'));
            return null;
        }
        Catch(Exception ex) {
            System.debug('Error Message ->' + ex.getMessage());
            System.debug('Error Stack Trace ->' + ex.getStackTraceString());
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
            return null;
        }
    
    }
}