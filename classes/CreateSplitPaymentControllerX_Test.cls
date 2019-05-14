/*****************************************************************
 * Author: Techila Global Services Pvt Ltd. (Gaurav Agrawal)
 * Class Name: CreateSplitPaymentControllerX
 * Created Date: 10-April-2018
 * Description: Controller Extension for CreateSplitPayments Page
 **********************************************************************************
 * Updates
 * Author            | Date          | Description
 * Prashant          | 04-16-2018    | Test Class For  Split Payments Controller
 *******************************************************************/
@isTest
public class CreateSplitPaymentControllerX_Test {
    
        
    public static testmethod void testfileuploadIntegrity(){
        
        string str = 'Date,Association Date,MID,Name,Net Sales,Transactions Held,Actual Holdback Amount,Hold Rate,Recipient Name,Source\n 3/30/2018,3/29/2018,6036335090049910,DRUMSTIX MARKET,4302.2,0,69.14,16.00%,Merchant Advance LLC,CR\n 3/30/2018,3/29/2018,6036335090049910,DRUMSTIX MARKET,4302.2,0,69.14,16.00%,Merchant Advance LLC,CR\n 3/30/2018,3/29/2018,6036335090049910,DRUMSTIX MARKET,4302.2,0,69.14,16.00%,Merchant Advance LLC,CR\n 3/30/2018,3/29/2018,6036335090049910,DRUMSTIX MARKET,4302.2,0,69.14,16.00%,Merchant Advance LLC,CR\n 3/30/2018,3/29/2018,6036335090049910,DRUMSTIX MARKET,4302.2,0,69.14,16.00%,Merchant Advance LLC,CR\n 3/30/2018,3/29/2018,6036335090049910,DRUMSTIX MARKET,4302.2,0,69.14,16.00%,Merchant Advance LLC,CR\n 3/30/2018,3/29/2018,6036335090049910,DRUMSTIX MARKET,4302.2,0,69.14,16.00%,Merchant Advance LLC,CR';            
        String[] csvFileLines;
        Blob contentFile;
        
        // Insert Account
        Account objAcc = new Account();
        objAcc.Name = 'Test Account';
        insert objAcc;
        
        // Insert Opportunity        
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Test Opportunity Name 1';
        objOpp.StageName = 'Prospecting';
        objOpp.CloseDate = system.today();        
        objOpp.Cloufi__Account__c = objAcc.Id;
        objOpp.CloufiServicing__Credit_Card_Processor__c= 'Integrity';
        insert objOpp;        
        contentFile = Blob.valueOf(str);
        String csvAsString = contentFile.toString();
        csvFileLines = csvAsString.split('\n'); 
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpp);
        CreateSplitPaymentControllerX objCreateSplitPaymentControllerX = new CreateSplitPaymentControllerX(sc);
        objCreateSplitPaymentControllerX.objOpp = objOpp;
        objCreateSplitPaymentControllerX.contentFile = contentFile;
        objCreateSplitPaymentControllerX.getPayList();
        objCreateSplitPaymentControllerX.paymentProcessorId = 'Integrity';
        objCreateSplitPaymentControllerX.DocName = 'test.jpg';
        objCreateSplitPaymentControllerX.uploadFile();              
        objCreateSplitPaymentControllerX.getuploadedRecords();
        objCreateSplitPaymentControllerX.getRecords();      
        objCreateSplitPaymentControllerX.cancel();
        objCreateSplitPaymentControllerX.getPaymentProcessor();
    }   
    
        public static testmethod void testfileuploadPaySmith(){
        
        string str = 'Post Date,Amount,Balance,From Acoount,To Account,Reference From Memo,Reference To Memo \n  Post Date,Amount,Balance,From Acoount,To Account,Reference From Memo,Reference To Memo \n Date,Amount,Balance,From Acoount,To Account,Reference From Memo,Reference To Memo \n Date,Amount,Balance,From Acoount,To Account,Reference From Memo,Reference To Memo \n Date,Amount,Balance,From Acoount,To Account,Reference From Memo,Reference To Memo \n Date,Amount,Balance,From Account,To Account,Reference From Memo,Reference To Memo \n 3/28/2018,50,1266.9,6036245090040010,6036340000000000,Repayment from ACH Deposit - 03/28/18 - 03/28/18,Repayment from ACH Deposit - 03/28/18 - 03/28/18 (35090049910) \n 3/28/2018,50,1266.9,6036245090040010,6036340000000000,Repayment from ACH Deposit - 03/28/18 - 03/28/18,Repayment from ACH Deposit - 03/28/18 - 03/28/18 (35090049910) \n 3/28/2018,50,1266.9,6036245090040010,6036340000000000,Repayment from ACH Deposit - 03/28/18 - 03/28/18,Repayment from ACH Deposit - 03/28/18 - 03/28/18 (35090049910) \n 3/28/2018,50,1266.9,6036245090040010,6036340000000000,Repayment from ACH Deposit - 03/28/18 - 03/28/18,Repayment from ACH Deposit - 03/28/18 - 03/28/18 (35090049910) ';
        String[] csvFileLines;
        Blob contentFile;
        
        // Insert Account
        Account objAcc = new Account();
        objAcc.Name = 'Test Account';
        insert objAcc;
        
        // Insert Opportunity        
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Test Opportunity Name 1';
        objOpp.StageName = 'Prospecting';
        objOpp.CloseDate = system.today();        
        objOpp.Cloufi__Account__c = objAcc.Id;   
        objOpp.CloufiServicing__Merchant_ID__c = '6036245090040010';
        insert objOpp;        
        contentFile = Blob.valueOf(str);
        String csvAsString = contentFile.toString();
        csvFileLines = csvAsString.split('\n'); 
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpp);
        CreateSplitPaymentControllerX objCreateSplitPaymentControllerX = new CreateSplitPaymentControllerX(sc);
        objCreateSplitPaymentControllerX.objOpp = objOpp;
        objCreateSplitPaymentControllerX.contentFile = contentFile;
        objCreateSplitPaymentControllerX.getPayList();
        objCreateSplitPaymentControllerX.paymentProcessorId = 'PaySmith';
        objCreateSplitPaymentControllerX.uploadFile();      
        objCreateSplitPaymentControllerX.getuploadedRecords();
        objCreateSplitPaymentControllerX.getRecords();      
        objCreateSplitPaymentControllerX.cancel();
        objCreateSplitPaymentControllerX.getPaymentProcessor();
    }

        public static testmethod void testfileuploadPivotalUS(){
        
        string str = 'MID,dba,transaction amount,withholding amount,\n 6036335090049910,DRUMSTIX MARKET,4302,20\n 6036335090049910,DRUMSTIX MARKET,4302,20';
        String[] csvFileLines;
        Blob contentFile;
        
        // Insert Account
        Account objAcc = new Account();
        objAcc.Name = 'Test Account';
        insert objAcc;
        
        // Insert Opportunity        
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Test Opportunity Name 1';
        objOpp.StageName = 'Prospecting';
        objOpp.CloseDate = system.today();
        objOpp.CloufiServicing__Merchant_ID__c = '6036335090049910.00';
        objOpp.Cloufi__Account__c = objAcc.Id;
        objOpp.CloufiServicing__Credit_Card_Processor__c = 'Pivotal US';
        insert objOpp;        
        contentFile = Blob.valueOf(str);
        String csvAsString = contentFile.toString();
        csvFileLines = csvAsString.split('\n'); 
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpp);
        CreateSplitPaymentControllerX objCreateSplitPaymentControllerX = new CreateSplitPaymentControllerX(sc);
        objCreateSplitPaymentControllerX.objOpp = objOpp;
        objCreateSplitPaymentControllerX.contentFile = contentFile;
        objCreateSplitPaymentControllerX.getPayList();              
        objCreateSplitPaymentControllerX.paymentProcessorId = 'Pivotal US';
        objCreateSplitPaymentControllerX.uploadFile();              
        objCreateSplitPaymentControllerX.getuploadedRecords();
        objCreateSplitPaymentControllerX.getRecords();      
        objCreateSplitPaymentControllerX.cancel();
        objCreateSplitPaymentControllerX.getPaymentProcessor();
        //CreateSplitPaymentControllerX.blobToString(contentFile,csvAsString);
    }
    public static testmethod void testfileuploadFirstData(){
        
        string str = '2560851001200600000-00002975322018-04-032018-05-0700601659755-2560851-001S';
        String[] csvFileLines;
        Blob contentFile;
        
        // Insert Account
        Account objAcc = new Account();
        objAcc.Name = 'Test Account';
        insert objAcc;
        
        // Insert Opportunity        
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Test Opportunity Name 1';
        objOpp.StageName = 'Prospecting';
        objOpp.CloseDate = system.today();        
        objOpp.Cloufi__Account__c = objAcc.Id;      
        insert objOpp;        
        contentFile = Blob.valueOf(str);
        String csvAsString = contentFile.toString();
        csvFileLines = csvAsString.split('\n'); 
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpp);
        CreateSplitPaymentControllerX objCreateSplitPaymentControllerX = new CreateSplitPaymentControllerX(sc);
        objCreateSplitPaymentControllerX.objOpp = objOpp;
        objCreateSplitPaymentControllerX.contentFile = contentFile;        
        objCreateSplitPaymentControllerX.paymentProcessorId = 'First Data';
        objCreateSplitPaymentControllerX.uploadFile();              
        
    }
}