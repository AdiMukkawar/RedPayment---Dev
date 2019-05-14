/*****************************************************************
 * Author: Techila Global Services Pvt Ltd. (Gaurav Agrawal)
 * Class Name: CreateSplitPaymentControllerX
 * Created Date: 10-April-2018
 * Description: Controller Extension for CreateSplitPayments Page
 **********************************************************************************
 * Updates
 * Author            | Date          | Description
 * Prashant          | 04-16-2018    | Controller for Split Payments VF page
 *******************************************************************/
public class CreateSplitPaymentControllerX {

    public String getPayList() {
        return null;
    }
    
    public String contentType{get;set;}
    public string nameFile {get;set;}
    public Blob contentFile {get;set;}  
    public Opportunity objOpp {get;set;}
    public Decimal totalSales {get;set;}
    public String[] filelines {get;set;}//
    public List <Cloufi__Payments__c> objPayList{get;set;}
    public List <Cloufi__Payments__c> successPayList{get;set;}
    public List <Cloufi__Payments__c> errorPayList{get;set;}
    public List <Cloufi__Payments__c> payList{get;set;}
    public List <Cloufi__Payments__c> failurePayList{get;set;}
    public List <String> failureList{get;set;}
    public String paymentProcessorId {get;set;}
    public String DocName {get;set;}    
    public String getDocCSV {get;set;}
    
    public CreateSplitPaymentControllerX(ApexPages.StandardController std) {
        objOpp = new Opportunity();
        payList= new List <Cloufi__Payments__c>();
        objPayList = new List <Cloufi__Payments__c>();
        successPayList = new List <Cloufi__Payments__c>();
        errorPayList = new List <Cloufi__Payments__c>();
        failureList = new List<String>();
        filelines = new String[] {};
        paymentProcessorId = '';
        contentType = '';
        nameFile = '';        
    }

    /***This function reads the CSV file and inserts records. ***/
    public Pagereference uploadFile() {
        try {
            if(nameFile == null || nameFile == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please Select File To Upload'));
            }else{
                DocName = nameFile;              
                system.debug('DocName ->'+DocName);
                getDocCSV = DocName.substringAfterLast('.');
                system.debug('DocName ->'+DocName);
                if(getDocCSV != 'csv' && getDocCSV != 'txt'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please Upload CSV File'));
                    return null;
                }
            }
            // Get RecordType ID Here
              Id recId = Schema.SObjectType.Cloufi__Payments__c.getRecordTypeInfosByName().get('Payment In').getRecordTypeId();
            if(contentFile == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please Select File To Upload'));
                return null;
            }
            //Convert the uploaded file which is in BLOB format into a string                
            //nameFile = blobToString(contentFile, 'ISO-8859-1');
            if(contentFile != null){
                nameFile = contentFile.toString();                          
                //Now sepatate every row of the excel file
                filelines = nameFile.split('\n');
                String[] fileHeader = filelines[0].split(',');                
                
                    /*String headerNameIntegrity = fileHeader[2];
                    System.Debug('headerName-->'+headerNameIntegrity);
                    
                    System.Debug('headerName-->'+headerNamePaySmith);
                    String[] fileHeaderPivotalUS = filelines[0].split(',');
                    String headerNamePivotalUS = fileHeader[0];
                    System.Debug('headerName-->'+headerNamePivotalUS);*/
                    /*** Template Mapping For Integrity Starts Here ***/                
                    if (paymentProcessorId.trim() == 'Integrity') {
                        Set < String > merID = new Set < String > ();
                        Map < String, Decimal > opportunitySalesMap = new Map < String, Decimal > ();
                        Map < String, Cloufi__Payments__c > addPaymentsMap = new Map < String, Cloufi__Payments__c > ();
                        for (Integer i = 1; i < filelines.size(); i++) {
                            String[] inputvalues = new String[] {};
                            inputvalues = filelines[i].split(',');  
                            String merchIDWithFormat = inputvalues[2].split('\\.',2)[0];    
                            if(paymentProcessorId.trim() == 'Integrity' && fileHeader[2] != 'MID'){
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please Select File For Integrity'));
                                return null;
                            } 
                            String Amount = inputvalues[4];                                                                     
                            if (merchIDWithFormat != null && merchIDWithFormat != '') {
                                if (!merchIDWithFormat.contains(',')) {
                                    merID.add(merchIDWithFormat.trim());
                                    if (merchIDWithFormat.trim() != null && merchIDWithFormat.trim() != '' && !opportunitySalesMap.containsKey(merchIDWithFormat.trim()) && inputvalues[4] != null && inputvalues[4] != '') {
                                        opportunitySalesMap.put(merchIDWithFormat.trim(), Decimal.valueOf(inputvalues[4].trim()));
                                        
                                    } else if (inputvalues[4] != null && inputvalues[4] != '') {
                                        totalSales = 0;
                                        totalSales = Decimal.valueOf(inputvalues[4]) + opportunitySalesMap.get(merchIDWithFormat.trim());
                                        opportunitySalesMap.put(merchIDWithFormat.trim(), totalSales);
                                    }
                                }

                            }
                        }                   
                        //Integer.valueOf('opportunitySalesMap -> '+opportunitySalesMap.size());
                        Map < String, Opportunity > merchantOpportunityMap = new Map < String, Opportunity > ();

                        for (Opportunity objOpp: [SELECT ID, AccountID, CloufiServicing__Merchant_ID__c FROM Opportunity WHERE CloufiServicing__Merchant_ID__c IN: opportunitySalesMap.keySet()]) {
                            if (objOpp.CloufiServicing__Merchant_ID__c != null)
                                merchantOpportunityMap.put(objOpp.CloufiServicing__Merchant_ID__c, objOpp);
                        }
                        //Iterate through every line and create a record for each row
                        objPayList = new List < Cloufi__Payments__c > ();
                        for (Integer i = 1; i < filelines.size(); i++) {
                            String[] inputvalues = new String[] {};
                            inputvalues = filelines[i].split(',');
                            system.debug('inputvalues ->'+inputvalues);
                            String merchIDWithFormat = inputvalues[2].split('\\.',2)[0];
                            system.debug('merchIDWithFormat ->'+merchIDWithFormat);
                            if (merchIDWithFormat.trim() != null && merchIDWithFormat.trim() != '' && !addPaymentsMap.containsKey(merchIDWithFormat.trim())) {
                                system.debug('In Integrity');
                                String IntegrityAmount = String.valueOf(opportunitySalesMap.get(merchIDWithFormat));
                                if(IntegrityAmount != null & IntegrityAmount != ''){
                                    Cloufi__Payments__c objPayments = new Cloufi__Payments__c();
                                    objPayments.Cloufi__Status__c = 'Settled';
                                    objPayments.Cloufi__Effective_Date__c = system.today();
                                    objPayments.CloufiServicing__Expected_Settlement_Date__c = system.today();
                                    objPayments.RecordTypeId = recId;
                                    objPayments.Cloufi__Payment_Type__c = 'Payment';
                                    objPayments.Cloufi__Payment_Method__c = 'Split Payment';                                
                                    objPayments.Cloufi__Payment_Amount__c = opportunitySalesMap.get(merchIDWithFormat);                      
                                    String merchantID = merchIDWithFormat;
                                    objPayments.Merchant_ID__c = merchantID.trim();
                                    if (merchantOpportunityMap.containsKey(merchantID.trim())) {                                                                        
                                        objPayments.Cloufi__Opportunity__c = merchantOpportunityMap.get(merchantID.trim()).ID;
                                        objPayments.Cloufi__Account__c = merchantOpportunityMap.get(merchantID.trim()).AccountID;
                                        system.debug('OppId ->'+objPayments.Cloufi__Opportunity__c);
                                        system.debug('AccId ->'+objPayments.Cloufi__Account__c);
                                    }
                                    objPayList.add(objPayments);
                                    system.debug('objPayList ->'+objPayList);
                                    addPaymentsMap.put(merchIDWithFormat.trim(), objPayments);
                                    system.debug('addPaymentsMap ->'+addPaymentsMap);
                                }
                            }
                        }
                    }
                    /*** Template Mapping For Integrity Ends Here ***/

                    /*** Template Mapping for Pivotal US Starts Here ***/

                    if (paymentProcessorId.trim() =='Pivotal US' || paymentProcessorId.trim() =='Pivotal Canada') {
                        Set < String > merID = new Set < String > ();
                        for (Integer i = 1; i < filelines.size(); i++) {
                            String[] inputvalues = new String[] {};
                            inputvalues = filelines[i].split(',');
                            String merchIDWithFormat = inputvalues[0].split('\\.',2)[0];
                            if((paymentProcessorId.trim() == 'Pivotal US' || paymentProcessorId.trim() == 'Pivotal Canada') && fileHeader[0] != 'mid'){
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please Select File For Pivotal US / Pivotal Canada'));
                                return null;
                            }
                            if (merchIDWithFormat != null && merchIDWithFormat != '') {
                                if (!merchIDWithFormat.contains(',')) {
                                    merID.add(merchIDWithFormat.trim());
                                }
                            }
                        }
                        Map < String, Opportunity > merchantOpportunityMap = new Map < String, Opportunity > ();
                        for (Opportunity objOpp: [SELECT ID, AccountID, CloufiServicing__Merchant_ID__c FROM Opportunity WHERE CloufiServicing__Merchant_ID__c IN: merID]) {
                            if (objOpp.CloufiServicing__Merchant_ID__c != null)
                                merchantOpportunityMap.put(objOpp.CloufiServicing__Merchant_ID__c, objOpp);
                        }
                        //Iterate through every line and create a record for each row
                        objPayList = new List < Cloufi__Payments__c > ();
                        for (Integer i = 1; i < filelines.size(); i++) {
                            String[] inputvalues = new String[] {};
                            inputvalues = filelines[i].split(',');    
                            String merchIDWithFormat = inputvalues[0].split('\\.',2)[0];                    
                            if(inputvalues[2] != null && inputvalues[2] != ''){
                                Cloufi__Payments__c objPayments = new Cloufi__Payments__c();
                                objPayments.Cloufi__Status__c = 'Settled';
                                objPayments.Cloufi__Effective_Date__c = system.today();
                                objPayments.CloufiServicing__Expected_Settlement_Date__c = system.today();
                                objPayments.RecordTypeId = recId;
                                objPayments.Cloufi__Payment_Type__c = 'Payment';
                                objPayments.Cloufi__Payment_Method__c = 'Split Payment';                                                              
                                objPayments.Cloufi__Payment_Amount__c = Double.valueOf(inputvalues[3]);                        
                                String merchantID = merchIDWithFormat;
                                objPayments.Merchant_ID__c = merchantID.trim();
                                if (merchantOpportunityMap.containsKey(merchantID.trim())) {
                                    System.debug('Inside contains');
                                    objPayments.Cloufi__Opportunity__c = merchantOpportunityMap.get(merchantID.trim()).ID;
                                    objPayments.Cloufi__Account__c = merchantOpportunityMap.get(merchantID.trim()).AccountID;
                                    //Integer.valueOF('objPayments.Cloufi__Account__c'+objPayments.Cloufi__Account__c);
                                }
                                objPayList.add(objPayments);
                            }   
                        }
                            
                    }
                    /*** Template Mapping For Pivotal US Ends Here***/
                    /*** Template Mapping For PaySmith Starts Here ***/

                    if (paymentProcessorId.trim() == 'PaySmith') {
                        if(filelines[5] != null && filelines[5] != ''){
                            if(filelines[5].split(',') != null){
                                String[] fileHeaderPaySmith = filelines[5].split(',');
                                if(fileHeaderPaySmith[3] != null && fileHeaderPaySmith[3] != ''){
                                    String headerNamePaySmith = fileHeaderPaySmith[3];                                  
                                    if(paymentProcessorId.trim() == 'PaySmith' && headerNamePaySmith != 'From Account'){
                                            system.debug('Insiide');
                                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please Select File For PaySmith'));
                                            return null;
                                    }
                                }   
                            }
                        }
                    
                        Set < String > merID = new Set < String > ();
                        for (Integer i = 7; i < filelines.size(); i++) {
                            String[] inputvalues = new String[] {};                    
                            inputvalues = filelines[i].split(',');                  
                            String merchIDWithFormat = inputvalues[3].split('\\.',2)[0];
                            system.debug('merchIDWithFormat--->'+merchIDWithFormat);
                            
                            if (merchIDWithFormat != null && merchIDWithFormat != '') {
                                if (!merchIDWithFormat.contains(',')) {
                                    merID.add(merchIDWithFormat.trim());
                                }
                            }
                        }
                        
                        Map < String, Opportunity > merchantOpportunityMap = new Map < String, Opportunity > ();
                        for (Opportunity objOpp: [SELECT ID, AccountID, CloufiServicing__Merchant_ID__c FROM Opportunity WHERE CloufiServicing__Merchant_ID__c IN: merID]) {
                            if (objOpp.CloufiServicing__Merchant_ID__c != null)
                                merchantOpportunityMap.put(objOpp.CloufiServicing__Merchant_ID__c, objOpp);
                        }
                        
                        //Integer.valueOF('>>'+merchantOpportunityMap.size());
                        //Iterate through every line and create a record for each row
                        objPayList = new List < Cloufi__Payments__c > ();
                        for (Integer i = 7; i < filelines.size(); i++) {
                            String[] inputvalues = new String[] {};
                            inputvalues = filelines[i].split(',');     
                            String merchIDWithFormat = inputvalues[3].split('\\.',2)[0];    
                            if(inputvalues[1] != null && inputvalues[1] != ''){
                                Cloufi__Payments__c objPayments = new Cloufi__Payments__c();
                                objPayments.Cloufi__Status__c = 'Settled';
                                objPayments.Cloufi__Effective_Date__c = system.today();
                                objPayments.CloufiServicing__Expected_Settlement_Date__c = system.today();
                                objPayments.RecordTypeId = recId;
                                objPayments.Cloufi__Payment_Type__c = 'Payment';
                                objPayments.Cloufi__Payment_Method__c = 'Split Payment';                        
                                objPayments.Cloufi__Payment_Amount__c = Double.valueOf(inputvalues[1]);                                                
                                String merchantID = merchIDWithFormat;
                                objPayments.Merchant_ID__c = merchantID.trim();
                                if (merchantOpportunityMap.containsKey(merchantID.trim())) {
                                    System.debug('Inside contains');
                                    objPayments.Cloufi__Opportunity__c = merchantOpportunityMap.get(merchantID.trim()).ID;
                                    objPayments.Cloufi__Account__c = merchantOpportunityMap.get(merchantID.trim()).AccountID;
                                }
                                objPayList.add(objPayments);
                            }
                        }
                    }
                
                /*** Teplate Mapping For PaySmith Ends Here ***/
                /*** Teplate Mapping For First Data Ends Here ***/
                if (paymentProcessorId.trim() == 'First Data') {
                    Set < String > merID = new Set < String > ();
                    Map < String, Decimal > opportunitySalesMap = new Map < String, Decimal > ();                       
                    Map < String,Cloufi__Payments__c > addPaymentsMap = new Map < String,Cloufi__Payments__c > ();
                    
                    for(integer i=0; i< filelines.size(); i++){
                        String merchIDWithFormat = filelines[i].substring(0,11);
                        String EndDate = filelines[i].substring(40,50);
                        Date EndDateWithFormat = Date.valueOF(EndDate);                           
                        String withDrawlAmount = filelines[i].substring(20,27); 
                                            
                        withDrawlAmount = withDrawlAmount.substring(0, withDrawlAmount.length()-2) + '.' + withDrawlAmount.substring(withDrawlAmount.length()-2, withDrawlAmount.length());
                        system.debug('withDrawlAmount ->'+withDrawlAmount);
                         if (merchIDWithFormat != null && merchIDWithFormat != '') {
                            if (!merchIDWithFormat.contains(',')) {
                                merID.add(merchIDWithFormat.trim());
                                if (merchIDWithFormat.trim() != null && merchIDWithFormat.trim() != '' && !opportunitySalesMap.containsKey(merchIDWithFormat.trim()+''+EndDateWithFormat) && withDrawlAmount != null && withDrawlAmount != '' ) {
                                    system.debug('success');
                                    
                                    opportunitySalesMap.put(merchIDWithFormat.trim()+''+EndDateWithFormat , Decimal.valueOf(withDrawlAmount.trim()));
                                    
                                    
                                } else if (withDrawlAmount != null && withDrawlAmount != '' ) {
                                    totalSales = 0;
                                    totalSales = Decimal.valueOf(withDrawlAmount) + opportunitySalesMap.get(merchIDWithFormat.trim()+''+EndDateWithFormat);
                                    opportunitySalesMap.put(merchIDWithFormat.trim()+''+EndDateWithFormat, totalSales); 
                                    
                                }
                            }
                        }
                    }
                    Map < String, Opportunity > merchantOpportunityMap = new Map < String, Opportunity > ();
                        for (Opportunity objOpp: [SELECT ID, AccountID, CloufiServicing__Merchant_ID__c FROM Opportunity WHERE CloufiServicing__Merchant_ID__c IN: merID]) {
                            if (objOpp.CloufiServicing__Merchant_ID__c != null)
                                merchantOpportunityMap.put(objOpp.CloufiServicing__Merchant_ID__c, objOpp);
                        }
                    //nameFile = contentFile.toString();
                    system.debug('nameFile ->'+nameFile);       
                        
                    for(integer i=0; i< filelines.size(); i++){
                        String merchIDWithFormat = filelines[i].substring(0,11);
                        String EndDate = filelines[i].trim().substring(40,50);                     
                        Date EndDateWithFormat = Date.valueOF(EndDate);                         
                        String FirstDataAmount = String.valueOf(opportunitySalesMap.get(merchIDWithFormat.trim()+''+EndDateWithFormat));
                        
                                               
                        if (merchIDWithFormat.trim() != null && merchIDWithFormat.trim() != '' && (!addPaymentsMap.containsKey(merchIDWithFormat.trim()+''+EndDateWithFormat))) {
                            if(FirstDataAmount != null && FirstDataAmount != ''){
                                Cloufi__Payments__c objPayments = new Cloufi__Payments__c();
                                objPayments.Cloufi__Status__c = 'Settled';                                
                                objPayments.Cloufi__Effective_Date__c = EndDateWithFormat;
                                objPayments.CloufiServicing__Expected_Settlement_Date__c = system.today();
                                objPayments.RecordTypeId = recId;
                                objPayments.Cloufi__Payment_Type__c = 'Payment';
                                objPayments.Cloufi__Payment_Method__c = 'Split Payment';
                                objPayments.Cloufi__Payment_Amount__c = opportunitySalesMap.get(merchIDWithFormat.trim()+''+EndDateWithFormat);                                
                                String merchantID = merchIDWithFormat;
                                objPayments.Merchant_ID__c = merchantID.trim();
                                if (merchantOpportunityMap.containsKey(merchantID.trim())) {
                                    
                                    objPayments.Cloufi__Opportunity__c = merchantOpportunityMap.get(merchantID.trim()).ID;                                    
                                    objPayments.Cloufi__Account__c = merchantOpportunityMap.get(merchantID.trim()).AccountID;
                                    
                                }
                                objPayList.add(objPayments);                            
                                addPaymentsMap.put(merchIDWithFormat.trim()+''+EndDateWithFormat,objPayments);                                                      
                            }
                        }   
                    }
                        
                }   
                /*** Teplate Mapping For First Data Ends Here ***/
        }
            
            Integer successCount = 0;
            Integer errorCount = 0;
            Set<ID> successRecordID = new Set<Id>();
            if (objPayList.size() > 0) {           
                List<Database.SaveResult> updateResults = Database.insert(objPayList, false);
                for(Integer i=0;i<updateResults.size();i++){
                    if (updateResults.get(i).isSuccess()){
                        updateResults.get(i).getId();
                        successRecordID.add(updateResults.get(i).getId());
                        successCount++;

                    }else if (!updateResults.get(i).isSuccess()){
                        errorCount++;
                        // DML operation failed
                        Database.Error error = updateResults.get(i).getErrors().get(0);
                        String failedRec = error.getMessage();
                        objPayList.get(i);//failed record from the list                        
                        objPayList.get(i).Error_Message__c = failedRec;
                        system.debug('Failed ID'+objPayList.get(i));
                     }
                }
                
            }
            successPayList.clear();
            for(Cloufi__Payments__c payment :[SELECT Id,Name,Cloufi__Payment_Type__c,Cloufi__Payment_Method__c,Cloufi__Payment_Amount__c,Merchant_ID__c,Cloufi__Status__c,Cloufi__Effective_Date__c,CloufiServicing__Expected_Settlement_Date__c FROM Cloufi__Payments__c WHERE ID IN:successRecordID] ){
                successPayList.add(payment);
            }
            Set<String> merchantIdSet = new Set<String>();
            //Map<String,Cloufi__Payments__c> payMap = new Map<String,Cloufi__Payments__c>();
            for(Cloufi__Payments__c successPay : successPayList){
                merchantIdSet.add(successPay.Merchant_ID__c);
            }
            
            for(Cloufi__Payments__c eachPay : objPayList){
                if(!merchantIdSet.contains(eachPay.Merchant_ID__c)){
                    errorPayList.add(eachPay);
                }
            }
            //Integer.valueOF('Success>> '+successCount + ' Error>> '+errorCount);
            if(successCount>0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, successCount +' Record Inserted Successfully')); 
            }
            if(errorCount>0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errorCount +' Record Failed To Insert.'));
            }
            
        } catch (Exception e) {
            
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, 'An error has occured:' + e.getMessage());            
            System.debug('Message -> '+e.getMessage());
            
            System.debug('Message -> '+e.getLineNumber());
            ApexPages.addMessage(errormsg);            
            /*if(e.getMessage().containsAny('Invalid decimal'))
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please Insert Valid Amount.'));
            }*/
        }
        return null;
    }
    
    public pageReference getRecords(){
    //List<Cloufi__Payments__c> payList = new List<Cloufi__Payments__c>();
    if(successPayList.size()>0){
        payList.addAll(successPayList);
        system.debug('obj Paylist 1 --->'+ successPayList);
        system.debug('obj payList 1 --->'+ payList);
        
    }
    return null;
    }
    
    /**** This function To fetch the list of records that were inserted ****/
    public List < Cloufi__Payments__c > getuploadedRecords() {
        if (successPayList.size()>0) {
            return successPayList;
        } else {
            return null;
        }
    }
    /*** Fetch Records Function Ends Here ***/

    // Convert BLOB to String
    public static String blobToString(Blob input, String inCharset) {
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for (Integer i = 0; i < bytesCount; ++i)
            bytes[i] = hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }

    public PageReference cancel(){
        PageReference pr = new PageReference('/');
        return pr;
    } 
  
    public List<SelectOption> getPaymentProcessor(){        
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Opportunity.CloufiServicing__Credit_Card_Processor__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for(Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(),f.getValue()));
        }
        return options;
    }    
}