/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Gaurav Agrawal)
* Class Name: CreateRenewalStackController
* Created Date: 12-March-2019
* Description: Controller Extension for CreateRenewalStack Page
*****************************************************************/

public with sharing class CreateRenewalStackController {
    
    //public varibales  
    public Opportunity objOpportunity{get;set;}
    public Opportunity objProspectingOpportunity{get;set;}
    public Boolean isValidForRenewal{get;set;}
    public Decimal totalMerchantPaymentIn;
    public String oppId;
    public CloufiServicing__Servicing_Error_Setting__c objErrorSetting{get;set;} 
    public List<UWDocumentWrapper> uwDocWrapperList{get;set;}
    public List<SelectOption> fundingTypes{get;set;}
    public String selectedFundingType{get;set;}

    //Contructor
    public CreateRenewalStackController(ApexPages.StandardController controller) {
        //Call method to initialize variables
        init();

        Opportunity objOppToClone;      

        objErrorSetting = CloufiServicing__Servicing_Error_Setting__c.getOrgDefaults();
    
        System.debug('Id-->'+(ApexPages.currentPage().getParameters().get('id')));
        //Query Opportunity
        if(ApexPages.currentPage().getParameters().get('id') != null){
            oppId = ApexPages.currentPage().getParameters().get('id');

            String query =  'SELECT CloufiServicing__Next_Opportunity__r.Name, CloufiServicing__Next_Opportunity__r.StageName, Owner.Name,  CloufiServicing__Parent_Opportunity__r.Name, '+ String.join(CashManagementUtil.getFieldsOfsObject('Opportunity'),',');
                   query += ',(SELECT '+String.join(CashManagementUtil.getFieldsOfsObject('Opportunity'),',');
                   query += ' FROM CloufiServicing__Opportunities__r) ';         
                   query += ' FROM Opportunity WHERE Id = '+'\''+ oppId +'\'';
                   
            System.debug('query ->'+query);
            objOpportunity = Database.query(query);   

            //Call method to validate deal for creation of Renewals
            validateDealForRenewal();       

            if(isValidForRenewal){          
                List<String> oppFields = new List<String>();
                for(FieldSetMember mem : SObjectType.Opportunity.FieldSets.CloufiServicing__Renewal_Fields.getFields()){
                    oppFields.add(mem.getFieldPath());
                }
                String oppFieldsStr = ','+String.join(oppFields,',');           
                objOppToClone = Database.query('SELECT id, Name, Type'+oppFieldsStr+' FROM Opportunity WHERE id=:oppId'); 

                objProspectingOpportunity = objOppToClone.clone(false, false, false, false);
                //objProspectingOpportunity.Type = null;

                query = '';
                query += 'SELECT '+String.join(CashManagementUtil.getFieldsOfsObject('Cloufi__UW_Document__c'),',');
                query += ' FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c = '+'\''+ oppId +'\' AND Status__c = \'Completed\' AND Cloufi__URL__c != null ORDER BY Cloufi__Type__c';
                
                for(Cloufi__UW_Document__c objUWDoc : Database.Query(query)){
                    uwDocWrapperList.add(new UWDocumentWrapper(objUWDoc));
                }
            }
            fundingTypes.add(new SelectOption('','---None---'));
            fundingTypes.add(new SelectOption('Existing - New','Existing - New'));
            fundingTypes.add(new SelectOption('Renewal','Renewal'));
            fundingTypes.add(new SelectOption('Stack','Stack'));
        }           
    }

    //Metthod to initialize variables
    public void init(){
        objOpportunity = new Opportunity();
        objProspectingOpportunity = new Opportunity();
        isValidForRenewal = true;
        totalMerchantPaymentIn = 0.0;
        uwDocWrapperList = new List<UWDocumentWrapper>();
        fundingTypes = new List<SelectOption>();
        selectedFundingType = '';
    }

    //Method for validating deal for creating Renewals bt Comparing criteria defined in Custom Setting
    public void validateDealForRenewal(){ 

        if(objOpportunity.StageName != 'Funded'){                
            isValidForRenewal = false;
            if(objErrorSetting != null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, objErrorSetting.CloufiServicing__Prospect_Opportunity_Created__c));
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Prospecting Opportunity can not be created'));
            }                
        }             

        if(isValidForRenewal){
            Map<String, List<CloufiServicing__Deal_Renewal_Criteria__c>> renewalCriteriaMap = new Map<String, List<CloufiServicing__Deal_Renewal_Criteria__c>>();
            Set<String> paymentProcessorSet = new Set<String>();

            List<CloufiServicing__Deal_Renewal_Criteria__c> dealRenewalCriteriaList = new List<CloufiServicing__Deal_Renewal_Criteria__c>();
            dealRenewalCriteriaList = CloufiServicing__Deal_Renewal_Criteria__c.getAll().values();
            
            for(CloufiServicing__Deal_Renewal_Criteria__c objRC : dealRenewalCriteriaList){
                if(objRC.CloufiServicing__Payment_Processor__c != null){
                    paymentProcessorSet.add(objRC.CloufiServicing__Payment_Processor__c);
                }
            }           

            for(String paymentProcessor : paymentProcessorSet){
                List<CloufiServicing__Deal_Renewal_Criteria__c> rcListTemp = new List<CloufiServicing__Deal_Renewal_Criteria__c>();
                for(CloufiServicing__Deal_Renewal_Criteria__c objRC : dealRenewalCriteriaList){
                    if(objRC.CloufiServicing__Payment_Processor__c == paymentProcessor){
                        rcListTemp.add(objRC);
                    }
                }
                renewalCriteriaMap.put(paymentProcessor, rcListTemp);
            }

            if(objOpportunity.Cloufi__Payment_Processor__c != null && renewalCriteriaMap.get(objOpportunity.Cloufi__Payment_Processor__c) != null){
                //Loop through the Renewal criteria/s defined in Custom Setting
                for(CloufiServicing__Deal_Renewal_Criteria__c objRenewalCriteria : renewalCriteriaMap.get(objOpportunity.Cloufi__Payment_Processor__c)){
                    System.debug('objRenewalCriteria ->'+objRenewalCriteria );
                    System.debug('Name ->'+objRenewalCriteria.CloufiServicing__Field__c);
                    System.debug('Data-->'+(objOpportunity.get(objRenewalCriteria.CloufiServicing__Field__c)));
                    //Check for null value 
                    if(objOpportunity.get(objRenewalCriteria.CloufiServicing__Field__c) != null){
                        
                        //If the comparison of Type 'Number'
                        system.debug('IN ->');
                        system.debug('type ->'+objRenewalCriteria.CloufiServicing__Field_Type__c.toLowerCase());
                        if(objRenewalCriteria.CloufiServicing__Field_Type__c.toLowerCase() == 'number'){
                            //Check the values for deiffrent filter criterias for Number 
                            String valueString = String.valueOf(objOpportunity.get(objRenewalCriteria.CloufiServicing__Field__c));
                            Decimal value = Decimal.valueOf(valueString);
                            if(objRenewalCriteria.CloufiServicing__Criteria__c.toLowerCase() == 'equals to'){
                                if(value != Decimal.valueOf(objRenewalCriteria.CloufiServicing__Value__c)){                      
                                    isValidForRenewal = false;              
                                }
                            }else if(objRenewalCriteria.CloufiServicing__Criteria__c.toLowerCase() == 'greater than'){
                                if(!(value > Decimal.valueOf(objRenewalCriteria.CloufiServicing__Value__c))){
                                    isValidForRenewal = false;              
                                }
                            }else if(objRenewalCriteria.CloufiServicing__Criteria__c.toLowerCase() == 'less than'){
                                if(!(value < Decimal.valueOf(objRenewalCriteria.CloufiServicing__Value__c))){            
                                    isValidForRenewal = false;
                                }            
                            }                   
                        }  

                        //If the comparison of Type 'Text'
                        else if(objRenewalCriteria.CloufiServicing__Field_Type__c.toLowerCase() == 'text'){
                            String valueString = String.valueOf(objOpportunity.get(objRenewalCriteria.CloufiServicing__Field__c));
                            //Check the values for deiffrent filter criterias for Text
                            if(objRenewalCriteria.CloufiServicing__Criteria__c.toLowerCase() == 'equals to'){
                                if(valueString != objRenewalCriteria.CloufiServicing__Value__c){                     
                                    isValidForRenewal = false;              
                                }
                            }else if(objRenewalCriteria.CloufiServicing__Criteria__c.toLowerCase() == 'not equals to'){
                                if(!(valueString == objRenewalCriteria.CloufiServicing__Value__c)){
                                    isValidForRenewal = false;              
                                }
                            }                   
                        }

                        //If the comparison of Type 'Number'
                        else if(objRenewalCriteria.CloufiServicing__Field_Type__c.toLowerCase() == 'date'){
                            Date d = Date.valueOf(objOpportunity.get(objRenewalCriteria.CloufiServicing__Field__c));
                            //Check the values for deiffrent filter criterias for Date
                            if(objRenewalCriteria.CloufiServicing__Criteria__c.toLowerCase() == 'equals to'){
                                if(d != objRenewalCriteria.CloufiServicing__Date_Value__c){                      
                                    isValidForRenewal = false;              
                                }
                            }else if(objRenewalCriteria.CloufiServicing__Criteria__c.toLowerCase() == 'greater than'){
                                if(!(d > objRenewalCriteria.CloufiServicing__Date_Value__c)){
                                    isValidForRenewal = false;              
                                }
                            }else if(objRenewalCriteria.CloufiServicing__Criteria__c.toLowerCase() == 'less than'){
                                if(!(d < objRenewalCriteria.CloufiServicing__Date_Value__c)){            
                                    isValidForRenewal = false;
                                }            
                            } 
                        }               
                    }

                    //If criteria field is null then throw that error
                    else{
                        isValidForRenewal = false;
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.WARNING, 'One of the field of deal defined for Renewal Criteria is null'));   
                    }
                }
            }

            //If any criteria fails then throw the error message on page and dont show fields and Save button on the page
            if(!isValidForRenewal){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.WARNING, 'This Deal is not Qualified for Renewals'));
            }           
        }

    }

    public PageReference saveRenewal(){
        if(selectedFundingType == null || selectedFundingType == ''){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.WARNING, 'Please specify Type of Funding for this Opportunity'));
            return null;
        }

        if(ApexPages.currentPage().getParameters().get('id') == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please use the Opportunity to open this page'));
            isValidForRenewal = false;
        }

        objProspectingOpportunity.Type = selectedFundingType;

        if(isValidForRenewal){
            Savepoint sp;
            try{
                sp = Database.setSavepoint();
                Opportunity latestOpp;
                objProspectingOpportunity.StageName = 'Prospecting';                
                if(objOpportunity.CloufiServicing__Latest_Opportunity__c != null){
                    objProspectingOpportunity.CloufiServicing__Previous_Opportunity__c = objOpportunity.CloufiServicing__Latest_Opportunity__c;
                    latestOpp = [SELECT Id, CloufiServicing__Next_Opportunity__c FROM Opportunity WHERE Id =: objOpportunity.CloufiServicing__Latest_Opportunity__c];
                }else{
                    objProspectingOpportunity.CloufiServicing__Previous_Opportunity__c = objOpportunity.Id;
                }

                if(objOpportunity.CloufiServicing__Parent_Opportunity__c != null){
                    objProspectingOpportunity.CloufiServicing__Parent_Opportunity__c = objOpportunity.CloufiServicing__Parent_Opportunity__c;                   
                }else{
                    objProspectingOpportunity.CloufiServicing__Parent_Opportunity__c = objOpportunity.Id;                  
                }
                
                objProspectingOpportunity.Original_Owner__c = objOpportunity.Owner.Name;
                objProspectingOpportunity.OwnerId = System.Label.Renewal_Owner_ID;

                Opportunity objParentOpportunity;

                if(objProspectingOpportunity.Type != null){
                    if(objOpportunity.CloufiServicing__Parent_Opportunity__c != null){
                        String opportunityName = '';
                        String version = '';
                        Integer existingNewCount=0, renewalCount=0, stackCount=0;
                        
                        objParentOpportunity = [SELECT Id, Name, CloufiServicing__Existing_New_Version__c, CloufiServicing__Renewal_Version__c, CloufiServicing__Stack_Version__c, (SELECT Id, Name, Type FROM CloufiServicing__Opportunities__r) FROM Opportunity WHERE Id =: objOpportunity.CloufiServicing__Parent_Opportunity__c LIMIT 1];
                        opportunityName +=  objParentOpportunity.Name;
                        for(Opportunity objRelatedOpportunity : objParentOpportunity.CloufiServicing__Opportunities__r){  
                            if(objRelatedOpportunity.Type == 'Existing - New'){
                                existingNewCount += 1;
                            }else if(objRelatedOpportunity.Type == 'Renewal'){
                                renewalCount += 1;
                            }else if(objRelatedOpportunity.Type == 'Stack'){
                                stackCount += 1;
                            }
                        }
                        if(objProspectingOpportunity.Type == 'Existing - New'){
                            version = String.valueOf(existingNewCount+1);
                            opportunityName += ' - N'+version;
                            objProspectingOpportunity.CloufiServicing__Version__c = (existingNewCount+1);
                            objParentOpportunity.CloufiServicing__Existing_New_Version__c = (existingNewCount+1);
                        }else if(objProspectingOpportunity.Type == 'Renewal'){
                            version = String.valueOf(renewalCount+1);
                            opportunityName += ' - R'+version;
                            objProspectingOpportunity.CloufiServicing__Version__c = (renewalCount+1);
                            objParentOpportunity.CloufiServicing__Renewal_Version__c = (renewalCount+1);
                        }else if(objProspectingOpportunity.Type == 'Stack'){
                            version = String.valueOf(stackCount+1);
                            opportunityName += ' - S'+version;
                            objProspectingOpportunity.CloufiServicing__Version__c = (stackCount+1);
                            objParentOpportunity.CloufiServicing__Stack_Version__c = (stackCount+1);
                        }
                        objProspectingOpportunity.Name = opportunityName;
                        update objParentOpportunity;
                    }
                    else{
                        objParentOpportunity = [SELECT Id, Name, CloufiServicing__Existing_New_Version__c, CloufiServicing__Renewal_Version__c, CloufiServicing__Stack_Version__c, (SELECT Id, Name, Type FROM CloufiServicing__Opportunities__r) FROM Opportunity WHERE Id =: objOpportunity.Id LIMIT 1];
                        String opportunityName = '';
                        String version = '';
                        Integer existingNewCount=0, renewalCount=0, stackCount=0;
                        
                        opportunityName +=  objParentOpportunity.Name;
                        for(Opportunity objRelatedOpportunity : objParentOpportunity.CloufiServicing__Opportunities__r){  
                            if(objRelatedOpportunity.Type == 'Existing - New'){
                                existingNewCount += 1;
                            }else if(objRelatedOpportunity.Type == 'Renewal'){
                                renewalCount += 1;
                            }else if(objRelatedOpportunity.Type == 'Stack'){
                                stackCount += 1;
                            }
                        }
                        if(objProspectingOpportunity.Type == 'Existing - New'){
                            version = String.valueOf(existingNewCount+1);
                            opportunityName += ' - N'+version;
                            objProspectingOpportunity.CloufiServicing__Version__c = (existingNewCount+1);
                            objParentOpportunity.CloufiServicing__Existing_New_Version__c = (existingNewCount+1);
                        }else if(objProspectingOpportunity.Type == 'Renewal'){
                            version = String.valueOf(renewalCount+1);
                            opportunityName += ' - R'+version;
                            objProspectingOpportunity.CloufiServicing__Version__c = (renewalCount+1);
                            objParentOpportunity.CloufiServicing__Renewal_Version__c = (renewalCount+1);
                        }else if(objProspectingOpportunity.Type == 'Stack'){
                            version = String.valueOf(stackCount+1);
                            opportunityName += ' - S'+version;
                            objProspectingOpportunity.CloufiServicing__Version__c = (stackCount+1);
                            objParentOpportunity.CloufiServicing__Stack_Version__c = (stackCount+1);
                        }
                        objProspectingOpportunity.Name = opportunityName;
                        update objParentOpportunity;                        
                    }
                }

                upsert objProspectingOpportunity;

                //Start: Clone the Signed Application from existing funded deal
                Cloufi__UW_Document__c uwCloneSignApplicationRecord = new Cloufi__UW_Document__c();
                List <Cloufi__UW_Document__c> uwExistingSignedApplicationList = new List <Cloufi__UW_Document__c>();
                List <Cloufi__UW_Document__c> uwExistingBankStatementsList = new List <Cloufi__UW_Document__c>();
                List <Cloufi__UW_Document__c> clonedBankStatementsList = new List <Cloufi__UW_Document__c>();
                List <Cloufi__UW_Document__c> updateCloneBankList = new List <Cloufi__UW_Document__c>();
                
                List <Cloufi__UW_Document__c> newUWSignedApplicationList = new List <Cloufi__UW_Document__c>([SELECT Id, Name, Stip_Name__c, Cloufi__Type__c, Cloufi__URL__c, Cloufi__Opportunity__c FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c=:objProspectingOpportunity.Id AND Cloufi__Type__c='Application - Document' LIMIT 1]);
                
                uwExistingSignedApplicationList = [SELECT Id, Name, Stip_Name__c, Cloufi__Type__c, Cloufi__URL__c, Cloufi__Opportunity__c FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c=:objOpportunity.Id AND Cloufi__Type__c='Application - Document' LIMIT 1];
                
                

                if(!newUWSignedApplicationList.isEmpty() && !uwExistingSignedApplicationList.isEmpty()){
                    uwCloneSignApplicationRecord.Id = newUWSignedApplicationList[0].Id;
                    uwCloneSignApplicationRecord.Cloufi__Opportunity__c = objProspectingOpportunity.Id;
                    uwCloneSignApplicationRecord.Cloufi__URL__c = uwExistingSignedApplicationList[0].Cloufi__URL__c;
                    update uwCloneSignApplicationRecord;
                }else{
                    if(!uwExistingSignedApplicationList.isEmpty() && newUWSignedApplicationList.isEmpty()){
                        uwCloneSignApplicationRecord = uwExistingSignedApplicationList[0].clone();
                        uwCloneSignApplicationRecord.Cloufi__URL__c = uwExistingSignedApplicationList[0].Cloufi__URL__c;
                        uwCloneSignApplicationRecord.Cloufi__Opportunity__c = objProspectingOpportunity.Id;
                        insert uwCloneSignApplicationRecord;
                    }
                }
                //End: Clone the Signed Application from existing funded deal
                
                if(latestOpp != null){
                    latestOpp.CloufiServicing__Next_Opportunity__c = objProspectingOpportunity.Id;
                    update latestOpp;
                }                
                
                if(objOpportunity.CloufiServicing__Next_Opportunity__c == null){
                    objOpportunity.CloufiServicing__Next_Opportunity__c = objProspectingOpportunity.Id;                
                }
                objOpportunity.CloufiServicing__Existing_New_Version__c = 0;
                objOpportunity.CloufiServicing__Renewal_Version__c = 0;
                objOpportunity.CloufiServicing__Stack_Version__c = 0;                
                update objOpportunity;

                if(objOpportunity.AccountId != null){
                    List<Opportunity> oppList = new List<Opportunity>();                    
                    for(Opportunity objOpp : [SELECT Id, CloufiServicing__Latest_Opportunity__c FROM Opportunity WHERE AccountId =: objOpportunity.AccountId]){
                        if(objOpp.Id != objProspectingOpportunity.Id){
                            objOpp.CloufiServicing__Latest_Opportunity__c = objProspectingOpportunity.Id;
                            oppList.add(objOpp);
                        }
                    }

                    if(oppList.size()>0){
                        update oppList;
                    }
                }

                //Return to newly created deal
                PageReference objPR = new PageReference('/'+objProspectingOpportunity.Id);
                return objPR; 
            }catch(Exception e){
                //Handle exceptions         
                Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, e.getMessage()));
                System.debug('Error Message ->'+e.getMessage());
                System.debug('Error Stack Trace ->'+e.getStackTraceString());               
                Database.rollback(sp);
                return null;
            } 
        }else{
            return null;
        }                    
    }

    public class UWDocumentWrapper{
        public Boolean isSelected{get;set;}
        public Cloufi__UW_Document__c objUWDocument{get;set;}

        public UWDocumentWrapper(Cloufi__UW_Document__c objUWDoc){
            this.objUWDocument = objUWDoc;
        }
    }
}