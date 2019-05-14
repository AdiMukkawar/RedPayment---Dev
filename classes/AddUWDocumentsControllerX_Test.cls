/**
Author | Date       | Description
Neha   | 08/14/2018 | Test class for AddUWDocumentsControllerX
**/

@isTest
public class AddUWDocumentsControllerX_Test {
    public static testmethod void testAddUWDocumentsControllerX(){
        
        UW_Documents_Settings__c objUWSettings = new UW_Documents_Settings__c();
        objUWSettings.Name = 'Test doc';
        objUWSettings.Type__c = 'Stips';
        objUWSettings.Stage__c = 'Offer';
        insert objUWSettings;
        
        Contact objContact = new Contact();
        objContact.LastName = 'Testing';
        objContact.Email = 'test@gmail.com';
        insert objContact;        
        
        Opportunity ObjLoan = new Opportunity();
        ObjLoan.Name = 'test';
        ObjLoan.Cloufi__Funder_Date__c = System.Today();
        ObjLoan.StageName = 'Qualified';
        ObjLoan.amount = 335;
        ObjLoan.Cloufi__Payback_Amount__c= 1335;   
        ObjLoan.Cloufi__Daily_Payback_Amt__c= 3335;
        ObjLoan.Cloufi__Factor_Rate__c= 335;
        ObjLoan.Cloufi__Loan_Term__c= 335;        
        ObjLoan.Cloufi__Percentage_Of_Gross__c= 3345;
        ObjLoan.Cloufi__Borrower_Email__c = 'test@gmail.com';
        ObjLoan.CloseDate =System.Today();
        insert ObjLoan;
        System.assertNotEquals(ObjLoan.id,null);
        
        // Insert Lead & Application
        Lead objLead = new Lead( Cloufi__Amount_Requested__c=213,AnnualRevenue=1562,Cloufi__Application_Received_Date__c=System.today(),Fax ='sdvasd',
                                City='pune',Cloufi__Credit_Score__c=50.00,
                                Description='Desc',Email='test@gmail.com',FirstName='name',Website ='www.w3schools.com',Industry = 'Agriculture',MobilePhone = '45455',Cloufi__Monthly_Gross_Sale__c = 46,
                                Phone='6546546',Street='zdjfbksjdbkj kbkj',Title='Title',LastName='Name',Company='Company',Status='Open - Not Contacted',
                                NumberOfEmployees = 52,Rating ='Hot',
                                Cloufi__Years_in_Business__c = 47);
        insert ObjLead;
        
        System.assertNotEquals(ObjLead.id,null);
        
        Cloufi__Application__c objApplication = new Cloufi__Application__c(Cloufi__First_Name__c= 'Test Name',Cloufi__Lead__c = ObjLead.id,
                                                                           Cloufi__Website__c='www.tech.com',Cloufi__Loan_Term__c = 15,Cloufi__Owner_1_Home_Address__c='skjdb sdvsdf sdgf',
                                                                           Cloufi__Business_Legal_Name__c='sdfb b',Cloufi__Business_DBA_Name__c='SXbvsfdvbr',Cloufi__Amount_Requested__c=4565,
                                                                           Cloufi__Type_of_Business__c ='Partnership',Cloufi__Expected_Funding_Date__c =System.today(),
                                                                           Cloufi__Gross_Profit__c=4656);
        insert objApplication;   
        
        
        OpportunityContactRole objOpportunityContactRole = new OpportunityContactRole();
        objOpportunityContactRole.OpportunityId = ObjLoan.id;
        objOpportunityContactRole.ContactId = objContact.id;
        insert objOpportunityContactRole;
        
        ApexPages.currentPage().getParameters().put('id',ObjLoan.Id);
        
        Cloufi__UW_Document__c ObjStips = new Cloufi__UW_Document__c();
        ObjStips.name = 'test';
        ObjStips.Cloufi__Application__c = objApplication.id;    
        ObjStips.Cloufi__Type__c = 'Articles of Incorporation /LLC Formation';
        ObjStips.Cloufi__Opportunity__c = ObjLoan.id;
        ObjStips.Cloufi__URL__c ='';          
        insert ObjStips;
        
        Attachment objAttach = new Attachment();
        
        
        Cloufi__Dropbox_Settings__c ObjDropboxSetting = new Cloufi__Dropbox_Settings__c();
        ObjDropboxSetting.Cloufi__Access_Token__c = 'test';
        ObjDropboxSetting.Cloufi__Name__c = 'Access Token';
        insert ObjDropboxSetting;
        
        Long Value = 12345;
        List<AddUWDocumentsControllerX.StipTypeWrapper> lstWrapper = new List<AddUWDocumentsControllerX.StipTypeWrapper>();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ObjLoan);
        AddUWDocumentsControllerX ObjController = new AddUWDocumentsControllerX(sc);
        ObjController.showSubmitBtn  = true;
        ObjController.AddStipsData = 'test';
        AddUWDocumentsControllerX.getUWDocumentName(ObjStips.Id);
        AddUWDocumentsControllerX.generateRandomString(20);
        ObjController.init();
        ObjController.addRow(); 
        ObjController.attNames = 'Testing NameSplits'; 
        ObjController.attNames = 'Testing NameSplits1'; 
        ObjController.prepareSFDocuments();
        ObjController.CreateUWCDocument();
        ObjController.updateDocs();  
        ObjController.getDisplaySize(Value);         
        AddUWDocumentsControllerX.getDropboxToken();
        ObjController.sendStips();
        ObjController.retrieveDocs();
        
        ObjController.selectedStatementType = 'Bank Statement';
        ObjController.selectedMonths = 5;
        ObjController.createStatements();

        ObjController.selectedStatementType = 'Processing Statement';
        ObjController.selectedMonths = 5;
        ObjController.createStatements();
        
        AddUWDocumentsControllerX ObjInTempController = new AddUWDocumentsControllerX(sc);
        ObjInTempController.objApplication =  objApplication;
        AddUWDocumentsControllerX.StipWrapper objStipWrapper = new AddUWDocumentsControllerX.StipWrapper (ObjStips);
        AddUWDocumentsControllerX.StipTypeWrapper ObjWrap = new AddUWDocumentsControllerX.StipTypeWrapper(ObjStips.Cloufi__Type__c,true,ObjStips);
        ObjWrap.objAttachment = objAttach;    
        ObjWrap.stipType = 'Accounts payable aging';
        ObjWrap.IsSelected = true;
        lstWrapper.add(ObjWrap);
        ObjInTempController.lstStipTypeWrapper = lstWrapper;
        ObjInTempController.SaveAns();
        // ObjInTempController.backToQuestionPage();
        
        // For Long Value
        Long Value1 = 123;
        ObjController.getDisplaySize(Value1);            
        
        Long Value2 = 12334623;
        ObjController.getDisplaySize(Value2); 
        
        Long Value3 = 1233462343;
        ObjController.getDisplaySize(Value3);  
        
        objController.CreateUWCDocument();
        
        objController.CreateCustomUWCDocument();
        
        ObjController.stipName='Testing 1';
        ObjController.customStipFileBody =Blob.valueOf('test');
        ObjController.customStipFileName = 'Test Doc';
        ObjController.customUWDocumentComment = 'Test';
        objController.CreateCustomUWCDocument();
        
        ObjController.stipName='Testing 1';
        objController.CreateCustomUWCDocument();
    }
}