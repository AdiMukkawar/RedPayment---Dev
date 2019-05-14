/******************************************************************************
Author             | Date           | Description
Aditya Mukkawar    | 6/14/2018      | Complete Application Form Controller
******************************************************************************
 Updates
* Author           | Date           | Description
* Aditya Mukkawar  | 06/14/2018     | Controller for CompleteApplicationForm
* Aditya Mukkawar  | 12/10/2018     | Expire Application form once Application status is completed
**********************************************************************************/
public class CompleteApplicationForm_Ctl_clone{
    public id applicationId{get;set;}
    public Cloufi__Application__c objApplication{get;set;}
    public Cloufi__Application__c objApp{get;set;}
    public Boolean displayAddress{get;set;}
    public Lead objLead{get;set;}
    public List<picklistToCheckbox> closeBussinessList{get; set;}
    public List<picklistToCheckbox> oweMoneyList{get; set;}
    public List<picklistToCheckbox> stateFederalTaxList{get; set;}
    public List<picklistToCheckbox> LawsuitsList{get; set;}
    public List<StipAttachment> listStipAttachment{get;set;}
    public List<Cloufi__UW_Document__c> lstStips{get;set;}
    public List<String> lstDocs {get;set;}
    public StipAttachment objStip{get;set;}
    public boolean fileSection{get;set;}
    public string saveNCont{get;set;}
    public List<UW_Documents_Settings__c> lstCustomSet{get;set;}
    public Opportunity objOpportunity{get;set;}
    public Map<String, Cloufi__UW_Document__c> mapDocs{get;set;}
    public String url{get;set;}
    
    public CompleteApplicationForm_Ctl_clone(ApexPages.StandardController controller) {
        applicationId = ApexPages.currentPage().getParameters().get('id');
        closeBussinessList = new list<picklistToCheckbox>();
        oweMoneyList = new list<picklistToCheckbox>();
        stateFederalTaxList = new list<picklistToCheckbox>();
        LawsuitsList = new list<picklistToCheckbox>();
        listStipAttachment = new List<StipAttachment>();
        lstDocs = new List<String>();
        lstStips = new List<Cloufi__UW_Document__c>();
        lstCustomSet = new List<UW_Documents_Settings__c>();
        fileSection = false;
        objOpportunity = new Opportunity();
        mapDocs = new Map<String, Cloufi__UW_Document__c>();
        url = '';
        if(applicationId != null){
            objApp = [SELECT id,Cloufi__Lead__c,Owner1Ownership__c,Signature_URL__c,Cloufi__Application_Status__c FROM Cloufi__Application__c WHERE id=:applicationId];
            if(objApp.Cloufi__Application_Status__c=='Completed'){
                system.debug('Status=>'+objApp.Cloufi__Application_Status__c);
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Application is Expire'));
                return;
            }else{
                init();
            }
        }
    }
    
    public void init(){
        if(objApp.Cloufi__Lead__c !=null){
            objLead = [SELECT id,Legal_Corporate_Name__c,Cloufi__Business_DBA_Name__c,Website,Street,State,City,PostalCode,Phone,Fax,Email FROM Lead WHERE id=:objApp.Cloufi__Lead__c LIMIT 1];
        }
        // Query Addition Documents from Custom Setting
        lstCustomSet = [SELECT Name,Type__c,stage__c FROM UW_Documents_Settings__c WHERE Type__c='Document' AND stage__c='Application'];
        
        //Retrieve all fields of Application
        List<Cloufi__Application__c> ApplicationList = new List<Cloufi__Application__c>();
        DescribeSobjectResult decribeResult= Cloufi__Application__c.getSobjectType().getDescribe();
        List<String> fieldNames=new List<String>(decribeResult.fields.getMap().KeySet());
        String Query = 'SELECT ' + String.join( fieldNames, ',' );
        Query+=' FROM '+decribeResult.getName()+' WHERE Id='+'\''+applicationId+'\'' ;
        system.debug('Query >>'+Query);
        ApplicationList = Database.query(Query);
        
        //Get the documents list
        lstStips = [SELECT id,Cloufi__Application__c,Name,Cloufi__Display_Size__c,Cloufi__View__c,Cloufi__Type__c,Cloufi__URL__c, Stip_Name__c from Cloufi__UW_Document__c where Cloufi__Application__c=:applicationId  Order By Cloufi__URL__c ASC];
        System.debug('lstStips ->'+lstStips+' Size ->'+lstStips.size());
        if(ApplicationList.size()>0){
            objApplication = ApplicationList[0];
        }
        system.debug('objApplication >>'+objApplication);
        List<SelectOption> options = new List<SelectOption>();

        for(Schema.PicklistEntry f : Cloufi__Application__c.Do_you_usually_close_the_business_during__c.getDescribe().getPicklistValues()){
            system.debug('f.getValue() >>'+f.getValue());
            system.debug('objApplication.Do_you_usually_close_the_business_during__c >>'+objApplication.Do_you_usually_close_the_business_during__c);
            if(f.getValue() == objApplication.Do_you_usually_close_the_business_during__c){
                if(objApplication.Do_you_usually_close_the_business_during__c == 'Yes'){
                    closeBussinessList.add(new picklistToCheckbox('Yes',true));
                }else if(objApplication.Do_you_usually_close_the_business_during__c == 'No'){
                    closeBussinessList.add(new picklistToCheckbox('No',true));
                }else{
                    closeBussinessList.add(new picklistToCheckbox(f.getValue(),true));
                }
            }else{
                closeBussinessList.add(new picklistToCheckbox(f.getValue(),false));
            }
            
        }
        
        for(Schema.PicklistEntry f : Cloufi__Application__c.Do_You_Owe_Money_To_The_CRA__c.getDescribe().getPicklistValues()){
            if(f.getValue() == objApplication.Do_You_Owe_Money_To_The_CRA__c){
                if(objApplication.Do_You_Owe_Money_To_The_CRA__c == 'Yes'){
                    oweMoneyList.add(new picklistToCheckbox('Yes',true));
                }else if(objApplication.Do_You_Owe_Money_To_The_CRA__c == 'No'){
                    oweMoneyList.add(new picklistToCheckbox('No',true));
                }else{
                    oweMoneyList.add(new picklistToCheckbox(f.getValue(),true));
                }
                
            }else{
                oweMoneyList.add(new picklistToCheckbox(f.getValue(),false));
            }
            
        }
        
        for(Schema.PicklistEntry f : Cloufi__Application__c.Any_open_State_Federal_Tax_Liens_Against__c.getDescribe().getPicklistValues()){
            if(f.getValue() == objApplication.Any_open_State_Federal_Tax_Liens_Against__c){
                if(objApplication.Any_open_State_Federal_Tax_Liens_Against__c == 'Yes'){
                    stateFederalTaxList.add(new picklistToCheckbox('Yes',true));
                }else if(objApplication.Any_open_State_Federal_Tax_Liens_Against__c == 'No'){
                    stateFederalTaxList.add(new picklistToCheckbox('No',true));
                }else{
                    stateFederalTaxList.add(new picklistToCheckbox(f.getValue(),true));
                }
            }else{
                stateFederalTaxList.add(new picklistToCheckbox(f.getValue(),false));
            }
        }
        
        for(Schema.PicklistEntry f : Cloufi__Application__c.Any_Lawsuits_or_Judgments_Pending_agains__c.getDescribe().getPicklistValues()){
            if(f.getValue() == objApplication.Any_Lawsuits_or_Judgments_Pending_agains__c){
                if(objApplication.Any_Lawsuits_or_Judgments_Pending_agains__c == 'Yes'){
                    LawsuitsList.add(new picklistToCheckbox('Yes',true));
                }else if(objApplication.Any_Lawsuits_or_Judgments_Pending_agains__c == 'No'){
                    LawsuitsList.add(new picklistToCheckbox('No',true));
                }else{
                    LawsuitsList.add(new picklistToCheckbox(f.getValue(),true));
                }
            }else{
                LawsuitsList.add(new picklistToCheckbox(f.getValue(),false));
            }
            
        }       

        for(Cloufi__UW_Document__c uw: lstStips){
            listStipAttachment.add(new StipAttachment(uw,new Attachment(Name=uw.Stip_Name__c)));
        }        

        if(objApplication.Cloufi__Business_Legal_Name__c != null){
            objApplication.Cloufi__Business_DBA_Name__c = objApplication.Cloufi__Business_Legal_Name__c;
        }
        if(objApplication.Cloufi__Email__c != null){
            objApplication.Business_Email__c = objApplication.Cloufi__Email__c;
        }
        
    }
   
    public void refreshAttachment(){
        lstStips = [SELECT id,Cloufi__Application__c,Name,Cloufi__Display_Size__c,Cloufi__View__c,Cloufi__Type__c,Cloufi__URL__c, Stip_Name__c from Cloufi__UW_Document__c where Cloufi__Application__c=:applicationId  Order By Cloufi__URL__c ASC];
        listStipAttachment = new List<StipAttachment>();
        for(Cloufi__UW_Document__c uw: lstStips){
            listStipAttachment.add(new StipAttachment(uw,new Attachment(Name=uw.Stip_Name__c)));
        }        
    }

    // Method to save application form.
    public void SaveApplication(){
        try{
            id appId = ApexPages.currentPage().getParameters().get('id');
            refreshAttachment();
            objApp = [SELECT id,Cloufi__Lead__c,Cloufi__Application_Status__c FROM Cloufi__Application__c WHERE id=:appId];
            if(objApp.Cloufi__Lead__c !=null){
                objLead = [SELECT id,Legal_Corporate_Name__c,IsConverted,Cloufi__Business_DBA_Name__c,Website,Street,State,City,PostalCode,Phone,Fax,Email FROM Lead WHERE id=:objApp.Cloufi__Lead__c LIMIT 1];
                system.debug('objLead'+objLead);
                fileSection = false;
                if(!objLead.IsConverted){
                    objLead.Legal_Corporate_Name__c =objApplication.Cloufi__Business_Legal_Name__c;
                    objLead.Cloufi__Business_DBA_Name__c =objApplication.Cloufi__Business_DBA_Name__c;
                    objLead.Website =objApplication.Cloufi__Website__c;
                    objLead.Street =objApplication.Physical_Address__c;
                    //objLead.State =objApplication.Physical_Province__c;
                    objLead.City =objApplication.Physical_City__c;
                    objLead.PostalCode =objApplication.Physical_Postal_Code__c;
                    objLead.Phone =objApplication.Telephone_Number__c;
                    objLead.Fax =objApplication.Cloufi__Fax_Bank_Info__c;
                    objLead.Email =objApplication.Cloufi__Email__c;
                    update objLead;
                    
                    Database.LeadConvert lc = new database.LeadConvert();
                    lc.setLeadId(objLead.id);
                    lc.ConvertedStatus = 'Converted';
                    Database.LeadConvertResult lcr = Database.convertLead(lc);
                    
                    objOpportunity = [SELECT id,Name FROM Opportunity WHERE id=:lcr.getOpportunityId()];
                    objApplication.Cloufi__Opportunity__c= objOpportunity.id;
                }
            }
            objApplication.Application_Completed__c = false;
            system.debug('objApplication.Same_Address__c=>'+objApplication.Same_Address__c);
            if(!!objApplication.Same_Address__c){
                system.debug('Same Address=>');
                objApplication.Same_Address__c = true;
            }else{
                system.debug('Blank Add=>');
                objApplication.Cloufi__Mailing_Street__c = objApplication.Physical_Address__c ;
                objApplication.Cloufi__Mailing_Zip_Code__c = objApplication.Physical_Postal_Code__c;
                objApplication.Cloufi__Mailing_City__c = objApplication.Physical_City__c;
                objApplication.MailingState__c  = objApplication.Physical_Province__c;
                objApplication.Same_Address__c = false;
            }
            //commented for Ownership
            if(objApplication.Owner1Ownership__c <= 50){
                objApplication.Corporate_Officer_Name__c = objApplication.Corporate_Officer_Name__c;
                objApplication.Corporate_Officer_Last_Name__c = objApplication.Corporate_Officer_Last_Name__c;
                objApplication.Corporate_Date_of_Birth__c = objApplication.Corporate_Date_of_Birth__c;
                objApplication.Corporate_Length_of_Ownership__c = objApplication.Corporate_Length_of_Ownership__c;
                objApplication.Corporate_Address__c = objApplication.Corporate_Address__c;
                objApplication.Corporate_City__c = objApplication.Corporate_City__c;
                objApplication.Corporate_Province__c = objApplication.Corporate_Province__c;
                objApplication.Corporate_Postal_Code__c = objApplication.Corporate_Postal_Code__c;
                objApplication.Corporate_Email__c = objApplication.Corporate_Email__c;
                objApplication.Corporate_Home_Phone_Number__c = objApplication.Corporate_Home_Phone_Number__c;
                objApplication.Corporate_Cell_Phone_Number__c = objApplication.Corporate_Cell_Phone_Number__c;
                objApplication.Corporate_Ownership__c = objApplication.Corporate_Ownership__c;
                objApplication.Corporate_Social_security_Number__c = objApplication.Corporate_Social_security_Number__c;
                objApplication.Corporate_credit_info__c = objApplication.Corporate_credit_info__c;
            }
            else{
                objApplication.Corporate_Officer_Name__c = '';
                objApplication.Corporate_Officer_Last_Name__c = '';
                objApplication.Corporate_Date_of_Birth__c = null;
                objApplication.Corporate_Length_of_Ownership__c = '';
                objApplication.Corporate_Address__c = '';
                objApplication.Corporate_City__c = '';
                objApplication.Corporate_Province__c = '';
                objApplication.Corporate_Postal_Code__c = '';
                objApplication.Corporate_Email__c = '';
                objApplication.Corporate_Home_Phone_Number__c = '';
                objApplication.Corporate_Cell_Phone_Number__c = '';
                objApplication.Corporate_Ownership__c = null;
                objApplication.Corporate_Social_security_Number__c = '';
                objApplication.Corporate_credit_info__c = false;
            }
            
            if(objApplication.Do_you_Process_Credit_card__c == 'No'){
                objApplication.Current_Processing_Company__c = '';
                objApplication.Average_Monthly_Credit_Card_Sales__c = '';
                objApplication.No_of_terminals__c = '';
                objApplication.Do_you_Own_Lease_your_terminals__c = '';
            }
            if(objApplication.Line_of_Credit__c != null){
                system.debug('objApplication.Line_of_Credit__c=>'+objApplication.Line_of_Credit__c);
                objApplication.Line_of_Credit__c = Decimal.ValueOf(string.valueOf(objApplication.Line_of_Credit__c).replace('$', ''));
            }
            
            if(objApplication.Cloufi__Gross_Profit__c != null){
                objApplication.Cloufi__Gross_Profit__c = Decimal.ValueOf(string.valueOf(objApplication.Cloufi__Gross_Profit__c).replace('$', ''));
            }
            if(objApplication.Cloufi__Amount_Requested__c != null){
                objApplication.Cloufi__Amount_Requested__c = Decimal.ValueOf(string.valueOf(objApplication.Cloufi__Amount_Requested__c).replace('$', ''));
            }
            if(objApplication.Monthly_Rent_or_Mortgage__c != null){
                objApplication.Monthly_Rent_or_Mortgage__c = Decimal.ValueOf(string.valueOf(objApplication.Monthly_Rent_or_Mortgage__c).replace('$', ''));
            }
            if(objApplication.Current_Balance__c != null){
                //if(Decimal.ValueOf(string.valueOf(objApplication.Current_Balance__c).replace('$', '')) !=null){
                    objApplication.Current_Balance__c = Decimal.ValueOf(string.valueOf(objApplication.Current_Balance__c).replace('$', ''));
               // }
            }
            
            //Save Selected Business Date
            string selectedBuss='';
            for(picklistToCheckbox selectedWrapObj: closeBussinessList){
                if(selectedWrapObj.isSelected == true){
                    selectedBuss = selectedWrapObj.label;
                }
            }
            if(selectedBuss!=''){
                objApplication.Do_you_usually_close_the_business_during__c = selectedBuss; 
            }else{
                system.debug('Inside Else');
                objApplication.Do_you_usually_close_the_business_during__c = '';
            }
            // save selected Owe Money To The CRA
            string oweMoney='';
            for(picklistToCheckbox selectedWrapObj: oweMoneyList){
                if(selectedWrapObj.isSelected == true){
                    oweMoney = selectedWrapObj.label;
                }
            }
            if(oweMoney!=''){
                objApplication.Do_You_Owe_Money_To_The_CRA__c = oweMoney; 
            }else{
                objApplication.Do_You_Owe_Money_To_The_CRA__c ='';
            }
            // Save Federal Tax
            string selectedFedTax='';
            for(picklistToCheckbox selectedWrapObj: stateFederalTaxList){
                if(selectedWrapObj.isSelected == true){
                     selectedFedTax = selectedWrapObj.label;
                }
            }
            if(selectedFedTax!=''){
                objApplication.Any_open_State_Federal_Tax_Liens_Against__c = selectedFedTax; 
            }else{
                objApplication.Any_open_State_Federal_Tax_Liens_Against__c ='';
            }
            
            // Save Law suits
            string selectedLawsuits='';
            for(picklistToCheckbox selectedWrapObj: LawsuitsList){
                if(selectedWrapObj.isSelected == true){
                     selectedLawsuits = selectedWrapObj.label;
                }
            }
            if(selectedLawsuits!=''){
                objApplication.Any_Lawsuits_or_Judgments_Pending_agains__c = selectedLawsuits; 
            }else{
                objApplication.Any_Lawsuits_or_Judgments_Pending_agains__c ='';
            }
            //if(objApplication.TabNumber__c != 4){
                update objApplication;
            //}
            if(objApplication.TabNumber__c == 4){
                fileSection = true;
            }
            
            if(objApplication.TabNumber__c == 4){                
                createDocusignDataPostURL();                   
            }

        }catch(Exception ex){
            System.debug('Exception '+ex.getMessage());
            System.debug('Exception '+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
        }
        
        //return null;
        
    }
    
    public PageReference saveAndSign(){
        SaveApplication();
        /*PageReference objPR = new PageReference(url);
        objPR.setRedirect(true);
        return objPR;*/
        PageReference objPR = new PageReference('/apex/ApplicationDocuments?id='+objApplication.Id);
        objPR.setRedirect(true);
        return objPR; 
    }

    public void createDocusignDataPostURL(){
        //url = 'https://www.google.com';
        //commented for Ownership
        if(objApplication.Owner1Ownership__c <= 50){
            url = 'https://na3.docusign.net/Member/PowerFormSigning.aspx?PowerFormId=cc2ae344-3fc8-4053-9cd5-d8f17ccca065';
            url += '&';
            if(objApplication.Corporate_Officer_Name__c != null && objApplication.Corporate_Officer_Last_Name__c != null){
                url += 'Merchant2_UserName='+objApplication.Corporate_Officer_Name__c+' '+objApplication.Corporate_Officer_Last_Name__c+'&';
            }
            if(objApplication.Corporate_Email__c != null){
                url += 'Merchant2_Email='+objApplication.Corporate_Email__c+'&';
            }            
        }else{
            url = 'https://na3.docusign.net/Member/PowerFormSigning.aspx?PowerFormId=40a0b5cb-7298-4d7e-8775-5f476ad4724a';
            url += '&';
        }
        String oppId = [SELECT Id, Cloufi__Opportunity__c FROM Cloufi__Application__c WHERE Id =: objApplication.Id].Cloufi__Opportunity__c;
        if(oppId != null){
            Opportunity objOpp = [SELECT Id, Application_Sent_by_Rep__c, Owner.Name, Owner.Email, Owner.Phone, Owner.Fax FROM Opportunity WHERE Id =: oppId];
            system.debug('objOpp=>'+objOpp);
            if(objOpp.Application_Sent_by_Rep__c){
                if(objOpp.Owner.Name != null){
                    url += 'repName='+objOpp.Owner.Name+'&';
                }
                if(objOpp.Owner.Email != null){
                    url += 'repEmail='+objOpp.Owner.Email+'&';
                }
                if(objOpp.Owner.Phone != null){
                    url += 'repPhone='+objOpp.Owner.Phone+'&';
                }
                if(objOpp.Owner.Fax != null){
                    url += 'repFax='+objOpp.Owner.Fax+'&';
                }
            }
        }
        if(oppId != null){
            url += 'opportunityId='+oppId+'&';
        }
        if(objApplication.Cloufi__First_Name__c != null && objApplication.Cloufi__Last_Name__c != null){
            url += 'Merchant_UserName='+objApplication.Cloufi__First_Name__c+' '+objApplication.Cloufi__Last_Name__c+'&';
            url += 'owner1Name='+objApplication.Cloufi__First_Name__c+' '+objApplication.Cloufi__Last_Name__c+'&';
        }
        if(objApplication.Business_Email__c != null){
            url += 'Merchant_Email='+objApplication.Business_Email__c+'&';   
        }
        if(objApplication.Legal_Corporate_Name__c != null){
            url += 'legalName='+objApplication.Legal_Corporate_Name__c+'&';
        }
        if(objApplication.Cloufi__Business_DBA_Name__c != null){
            url += 'DBA='+objApplication.Cloufi__Business_DBA_Name__c+'&';
        }
        if(objApplication.Cloufi__Website__c != null){
            url += 'websiteAddress='+objApplication.Cloufi__Website__c+'&';
        }
        if(objApplication.Physical_Address__c != null){
            url += 'physicalAddress='+objApplication.Physical_Address__c+'&';
        }
        if(objApplication.Physical_City__c != null){
            url += 'physicalAddCity='+objApplication.Physical_City__c+'&';
        }
        if(objApplication.Physical_Province__c != null){
            url += 'physicalAddProvince='+objApplication.Physical_Province__c+'&';
        }
        if(objApplication.Physical_Postal_Code__c != null){
            url += 'physicalAddPostal='+objApplication.Physical_Postal_Code__c+'&';
        }
        if(objApplication.Cloufi__Mailing_Street__c != null){
            url += 'mailingAddress='+objApplication.Cloufi__Mailing_Street__c+'&';
        }
        if(objApplication.Cloufi__Mailing_City__c != null){
            url += 'mailingCity='+objApplication.Cloufi__Mailing_City__c+'&';
        }
        if(objApplication.MailingState__c != null){
            url += 'mailingProvince='+objApplication.MailingState__c+'&';
        }
        if(objApplication.Cloufi__Mailing_Zip_Code__c != null){
            url += 'mailingPostal='+objApplication.Cloufi__Mailing_Zip_Code__c+'&';
        }
        if(objApplication.Business_Cell_Phone_Number__c != null){
            url += 'businessTelephoneNumber='+objApplication.Business_Cell_Phone_Number__c+'&';
        }
        if(objApplication.Fax_Number__c != null){
            url += 'businessFaxNumber='+objApplication.Fax_Number__c+'&';
        }
        if(objApplication.Business_Email__c != null){
            url += 'businessEmail='+objApplication.Business_Email__c+'&';
        }
        if(objApplication.Province_of_Registration__c != null){
            url += 'provinceOfRegistration='+objApplication.Province_of_Registration__c+'&';
        }
        if(objApplication.Cloufi__Business_Start_Date__c != null){
            Date businessStartDate = objApplication.Cloufi__Business_Start_Date__c;
            String businessStartDateString = businessStartDate.month()+'/'+businessStartDate.day()+'/'+businessStartDate.year();
            url += 'businessStartDate='+businessStartDateString+'&';
        }
        if(objApplication.Type_of_Entity__c != null){
            if(objApplication.Type_of_Entity__c == 'Corporation'){
                url += 'TOECorp=true&';
            }else if(objApplication.Type_of_Entity__c == 'Partnership'){
                url += 'TOEPartnership=true&';
            }else if(objApplication.Type_of_Entity__c == 'LLC'){
                url += 'TOEllc=true&';
            }else if(objApplication.Type_of_Entity__c == 'Sole Proprietorship'){
                url += 'TOESoleProp=true&';                
            }
        }
        if(objApplication.Line_of_Credit__c != null){
            url += 'lineOfCredit='+objApplication.Line_of_Credit__c+'&';            
        }
        if(objApplication.GST_HST__c != null){
            url += 'gsthst='+objApplication.GST_HST__c+'&';            
        }
        if(objApplication.Cloufi__Type_Of_Business__c != null){
            if(objApplication.Cloufi__Type_Of_Business__c == 'Retail'){
                url += 'TOBRetail=true&';
            }else if(objApplication.Cloufi__Type_Of_Business__c == 'Wholesale'){
                url += 'TOBWholeSale=true&';
            }else if(objApplication.Cloufi__Type_Of_Business__c == 'Services'){
                url += 'TOBService=true&';
            }else if(objApplication.Cloufi__Type_Of_Business__c == 'Automotive'){
                url += 'TOBAutomotive=true&';                
            }else if(objApplication.Cloufi__Type_Of_Business__c == 'Restaurant/Bar'){
                url += 'TOBRestaurant=true&';                
            }else if(objApplication.Cloufi__Type_Of_Business__c == 'Construction'){
                url += 'TOBConstruction=true&';                
            }else if(objApplication.Cloufi__Type_Of_Business__c == 'Lodging'){
                url += 'TOBLodging=true&';                
            }else if(objApplication.Cloufi__Type_Of_Business__c == 'Home-Based'){
                url += 'TOBHomeBased=true&';                
            }else if(objApplication.Cloufi__Type_Of_Business__c == 'Other'){
                url += 'TOBOther=true&';                
            }
        }
        if(objApplication.How_will_you_use_the_loan__c != null){
            url += 'useOfFunds='+objApplication.How_will_you_use_the_loan__c+'&';            
        }
        if(objApplication.Product_Service_Sold__c != null){
            url += 'productSold='+objApplication.Product_Service_Sold__c+'&';            
        }

        if(objApplication.Length_of_Ownership__c != null){
            url += 'owner1LengthofOwnership='+objApplication.Length_of_Ownership__c+'&';            
        }
        if(objApplication.Owner_1_Address_Street__c != null){
            url += 'owner1HomeAddress='+objApplication.Owner_1_Address_Street__c+'&';            
        }
        if(objApplication.Owner_1_City__c != null){
            url += 'owner1City='+objApplication.Owner_1_City__c+'&';            
        }
        if(objApplication.Owner_1_Province__c != null){
            url += 'owner1Province='+objApplication.Owner_1_Province__c+'&';            
        }
        if(objApplication.Owner_1_Postal_Code__c != null){
            url += 'owner1PostalCode='+objApplication.Owner_1_Postal_Code__c+'&';            
        }
        if(objApplication.Owner1Ownership__c != null){
            url += 'owner1OwnershipPer='+objApplication.Owner1Ownership__c+'&';            
        }
        if(objApplication.Owner_Date_Of_Birth__c != null){
            Date owner1DOB = objApplication.Owner_Date_Of_Birth__c;
            String owner1DOBString = owner1DOB.month()+'/'+owner1DOB.day()+'/'+owner1DOB.year();
            url += 'owner1DOB='+owner1DOBString+'&';            
        }
        if(objApplication.Social_Security_Number__c != null){
            url += 'owner1SSN='+objApplication.Social_Security_Number__c+'&';            
        }
        if(objApplication.Owner_Home_Phone_Number__c != null){
            url += 'owner1HomePhone='+objApplication.Owner_Home_Phone_Number__c+'&';            
        }
        if(objApplication.Telephone_Number__c != null){
            url += 'owner1CellPhone='+objApplication.Telephone_Number__c+'&';            
        }

        if(objApplication.Corporate_Officer_Name__c != null && objApplication.Corporate_Officer_Last_Name__c != null){
            url += 'owner2Name='+objApplication.Corporate_Officer_Name__c+' '+objApplication.Corporate_Officer_Last_Name__c+'&';            
        }
        if(objApplication.Corporate_Length_of_Ownership__c != null){
            url += 'owner2LengthofOwnership='+objApplication.Corporate_Length_of_Ownership__c+'&';            
        }
        if(objApplication.Corporate_Address__c != null){
            url += 'owner2HomeAdd='+objApplication.Corporate_Address__c+'&';            
        }
        if(objApplication.Corporate_City__c != null){
            url += 'owner2City='+objApplication.Corporate_City__c+'&';            
        }
        if(objApplication.Corporate_Province__c != null){
            url += 'owner2Province='+objApplication.Corporate_Province__c+'&';            
        }
        if(objApplication.Corporate_Postal_Code__c != null){
            url += 'owner2PostalCode='+objApplication.Corporate_Postal_Code__c+'&';            
        }
        if(objApplication.Corporate_Ownership__c != null){
            url += 'owner2OwnershipPer='+objApplication.Corporate_Ownership__c+'&';            
        }
        if(objApplication.Corporate_Date_of_Birth__c != null){
            Date owner2DOB = objApplication.Corporate_Date_of_Birth__c;
            String owner2DOBString = owner2DOB.month()+'/'+owner2DOB.day()+'/'+owner2DOB.year();
            url += 'owner2DOB='+owner2DOBString+'&';            
        }
        if(objApplication.Corporate_Social_security_Number__c != null){
            url += 'owner2SSN='+objApplication.Corporate_Social_security_Number__c+'&';            
        }
        if(objApplication.Corporate_Home_Phone_Number__c != null){
            url += 'owner2HomePhone='+objApplication.Corporate_Home_Phone_Number__c+'&';            
        }
        if(objApplication.Corporate_Cell_Phone_Number__c != null){
            url += 'owner2CellPhone='+objApplication.Corporate_Cell_Phone_Number__c+'&';            
        }
        if(objApplication.Own_Lease__c != null){
            url += 'ownOrLease='+objApplication.Own_Lease__c+'&';            
        }
        if(objApplication.Years_at_This_Location__c != null){
            url += 'timeAtThisLocation='+objApplication.Years_at_This_Location__c+'&';            
        }

        if(objApplication.Monthly_Rent_or_Mortgage__c != null){
            url += 'monthlyRent='+objApplication.Monthly_Rent_or_Mortgage__c+'&';            
        }
        if(objApplication.Date_Lease_Ends__c != null){
            Date dateLeaseEndDate = objApplication.Date_Lease_Ends__c;
            String dateLeaseEndDateString = dateLeaseEndDate.month()+'/'+dateLeaseEndDate.day()+'/'+dateLeaseEndDate.year();
            url += 'dateLeaseEnds='+dateLeaseEndDateString+'&';            
        }
        if(objApplication.Business_Landlord_or_Mortgage_Bank__c != null){
            url += 'businessLandlord='+objApplication.Business_Landlord_or_Mortgage_Bank__c+'&';            
        }
        if(objApplication.Contact_Name_and_or_Account_No__c != null){
            url += 'contactorAccountNo='+objApplication.Contact_Name_and_or_Account_No__c+'&';            
        }
        if(objApplication.Office_Mobile_Number__c != null){
            url += 'officeMobileNumber='+objApplication.Office_Mobile_Number__c+'&';            
        }
        if(objApplication.Current_Processing_Company__c != null){
            url += 'currentProcessingCompany='+objApplication.Current_Processing_Company__c+'&';            
        }
        if(objApplication.No_of_terminals__c != null){
            url += 'numberOfTerminals='+objApplication.No_of_terminals__c+'&';            
        }
        if(objApplication.Average_Monthly_Credit_Card_Sales__c != null){
            String avgMonthlyCCSale = objApplication.Average_Monthly_Credit_Card_Sales__c;
            avgMonthlyCCSale = avgMonthlyCCSale.replace('$', '');
            url += 'averageMonthlyCCSale='+avgMonthlyCCSale+'&';            
        }

        if(objApplication.Prior_Current_Cash_Advance_Company__c != null){
            url += 'priorCashAdvanceCompany='+objApplication.Prior_Current_Cash_Advance_Company__c+'&';            
        }
        if(objApplication.Current_Balance__c != null){
            url += 'currentBalance='+objApplication.Current_Balance__c+'&';            
        }
        if(objApplication.Do_you_Own_Lease_your_terminals__c != null){
            if(objApplication.Do_you_Own_Lease_your_terminals__c == 'Own'){
                url += 'TerminalOwn=true&';
            }else if(objApplication.Do_you_Own_Lease_your_terminals__c == 'Lease'){
                url += 'TerminalLease=true&';
            }else if(objApplication.Do_you_Own_Lease_your_terminals__c == 'Rent'){
                url += 'TerminalRent=true&';
            }            
        }

        if(objApplication.Cloufi__Amount_Requested__c != null){
            url += 'requestedAdvanceAmount='+objApplication.Cloufi__Amount_Requested__c+'&';            
        }
        if(objApplication.Do_you_usually_close_the_business_during__c != null){
            if(objApplication.Do_you_usually_close_the_business_during__c == 'Yes'){
                url += 'CloseBusinessYes=true&';
            }else if(objApplication.Do_you_usually_close_the_business_during__c == 'No'){
                url += 'CloseBusinessNo=true&';
            }            
        }
        if(objApplication.Details_for_close_the_business__c != null){
            url += 'closeBusinessDetails='+objApplication.Details_for_close_the_business__c+'&';            
        }
        if(objApplication.Do_You_Owe_Money_To_The_CRA__c != null){
            if(objApplication.Do_You_Owe_Money_To_The_CRA__c == 'Yes'){
                url += 'CRAYes=true&';
            }else if(objApplication.Do_You_Owe_Money_To_The_CRA__c == 'No'){
                url += 'CRANo=true&';
            }            
        }
        if(objApplication.Details_Do_You_Owe_Money_To_The_CRA__c != null){
            url += 'CRADetails='+objApplication.Details_Do_You_Owe_Money_To_The_CRA__c+'&';            
        }

        if(objApplication.Any_open_State_Federal_Tax_Liens_Against__c != null){
            if(objApplication.Any_open_State_Federal_Tax_Liens_Against__c == 'Yes'){
                url += 'BankruptcyYes=true&';
            }else if(objApplication.Any_open_State_Federal_Tax_Liens_Against__c == 'No'){
                url += 'BankruptcyNo=true&';
            }            
        }
        if(objApplication.Details_State_Federal_Tax_Liens__c != null){
            url += 'BankruptcyDetails='+objApplication.Details_State_Federal_Tax_Liens__c+'&';            
        }  

        if(objApplication.Any_Lawsuits_or_Judgments_Pending_agains__c != null){
            if(objApplication.Any_Lawsuits_or_Judgments_Pending_agains__c == 'Yes'){
                url += 'LawsuitYes=true&';
            }else if(objApplication.Any_Lawsuits_or_Judgments_Pending_agains__c == 'No'){
                url += 'LawsuitNo=true&';
            }            
        }
        if(objApplication.Details_Lawsuits_or_Judgments__c != null){
            url += 'LawsuitDetails='+objApplication.Details_Lawsuits_or_Judgments__c+'&';            
        }
        if(objApplication.Average_Monthly_Revenue__c != null){
            String avgMonthlyRev = objApplication.Average_Monthly_Revenue__c;
            avgMonthlyRev = avgMonthlyRev.replace('$', '');
            url += 'averageMonthlyTotalSales='+avgMonthlyRev+'&';            
        }
        if(objApplication.Id != null){
            url += 'applicationId='+objApplication.Id+'&';
        }
        url = url.substring(0, url.length()-1);
        System.debug('url ->'+url);
    }

    public class picklistToCheckbox {
        public string label {get; set;}
        public Boolean isSelected {get; set;}
        public picklistToCheckbox(string lb,Boolean selected) {
            label = lb;
            isSelected = selected;
        }
    }
    
    //Upload documents
    public PageReference uploadDocuments(){
        try{            
            List<Attachment> listAttachment = new List<Attachment>();     
            //Add attachments
            for(StipAttachment s : listStipAttachment){
                if(s.attachment.body != null){
                    listAttachment.add(s.attachment);
                }
            }            

            if(listAttachment.size()>0){
                upsert listAttachment;
            }

            String missingDoc = '';
            List<string> lstMissingDocs = new List<string>();
            for(StipAttachment s: listStipAttachment){
                if(s.attachment.Body == null && s.stip.Cloufi__URL__c == null){
                    missingDoc += ',' + s.stip.Stip_Name__c;
                    missingDoc = missingDoc.removeStart(',');
                    lstMissingDocs.add(s.stip.Stip_Name__c);
                }
                
            }
            objApplication.Missing_Documents_Types__c = missingDoc;
            update objApplication;
            system.debug('lstMissingDocs=>'+lstMissingDocs);
            Integer appCount = 0;
            Integer bankStmtCount = 0;
            Integer processingStmtCount = 0;
            
            for(string objUW : lstMissingDocs){
                if(!objUW.tolowercase().contains('bank statement') && !objUW.tolowercase().contains('processing statement')){
                    appCount += 1;
                }
                if(objUW.tolowercase().contains('bank statement')){
                    bankStmtCount +=1;
                }
                if(objUW.tolowercase().contains('processing statement')){
                    processingStmtCount +=1;
                }
            }
            system.debug('appCount=>'+appCount);
            system.debug('bankStmtCount=>'+bankStmtCount);
            system.debug('processingStmtCount=>'+processingStmtCount);
            system.debug('lstCustomSet=>'+lstCustomSet.size());
            if(bankStmtCount != 0){// String.isNotBlank(missingDoc) && String.isNotEmpty(missingDoc)
                // Send Emails
                system.debug('Inside Bank Statement=>');
                Cloufi__Application__c objApp = [SELECT id,Cloufi__Lead__c,Cloufi__Referral_Partner__r.Email FROM Cloufi__Application__c WHERE id=:objApplication.Id];
                // If application has email id
                if(objApplication.Id!=null && objApplication.Cloufi__Email__c !=null){
                    Messaging.SingleEmailMessage mailToSend = new Messaging.SingleEmailMessage();
                    EmailTemplate templateId = [Select id from EmailTemplate where name = 'Missing Documents Info 1'];
                    mailToSend.setToAddresses(new String[]{objApplication.Cloufi__Email__c });
                    mailToSend.setTemplateID(templateId.Id); 
                    mailToSend.setSaveAsActivity(false);
                    mailToSend.setWhatId(objApplication.Id);
                    mailToSend.setTargetObjectId(objApp.Cloufi__Lead__c);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mailToSend});
                }
            }else if(lstCustomSet.size()>0){
                if(lstCustomSet.size() <= appCount){// || lstCustomSet.size()==0
                    system.debug('Inside CS=>');
                    Cloufi__Application__c objApp = [SELECT id,Cloufi__Lead__c,Cloufi__Referral_Partner__r.Email FROM Cloufi__Application__c WHERE id=:objApplication.Id];
                    // If application has email id
                    if(objApplication.Id!=null && objApplication.Cloufi__Email__c !=null){
                    Messaging.SingleEmailMessage mailToSend = new Messaging.SingleEmailMessage();
                    EmailTemplate templateId = [Select id from EmailTemplate where name = 'Missing Documents Info 1'];
                    mailToSend.setToAddresses(new String[]{objApplication.Cloufi__Email__c });
                    mailToSend.setTemplateID(templateId.Id); 
                    mailToSend.setSaveAsActivity(false);
                    mailToSend.setWhatId(objApplication.Id);
                    mailToSend.setTargetObjectId(objApp.Cloufi__Lead__c);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mailToSend});
                    }
                }
            }
            /*objApplication.Application_Completed__c = true;
            update objApplication;*/
            PageReference cmpPage = new PageReference('/apex/ApplicationThankYou');
            cmpPage.setRedirect(true);
            return cmpPage;
        }catch(Exception e){
            System.debug('Msg '+e.getMessage());
            System.debug('Msg '+e.getStackTraceString());
            return null;
        }
    }
    
    public class StipAttachment{
        public Cloufi__UW_Document__c stip{get;set;}
        public Attachment attachment{get;set;}
        
        public StipAttachment(Cloufi__UW_Document__c s,Attachment att){
            stip=s;
            attachment=att;
            attachment.ParentId = s.Id;
        }
    }
}