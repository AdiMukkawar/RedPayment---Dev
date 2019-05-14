@isTest
public class ContractSignedEmailUpdateComp_CtlTest{    
    public static testmethod void validateContract(){  
    
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
            
        Lead objLead = new Lead( Cloufi__Amount_Requested__c=213,AnnualRevenue=1562,Cloufi__Application_Received_Date__c=System.today(),Fax ='sdvasd',
                                City='pune',Cloufi__Credit_Score__c=50.00,
                                Description='Desc',Email='test@gmail.com',FirstName='name',Website ='www.w3schools.com',Industry = 'Agriculture',MobilePhone = '45455',Cloufi__Monthly_Gross_Sale__c = 46,
                                Phone='6546546',Street='zdjfbksjdbkj kbkj',Title='Title',LastName='Name',Company='Company',Status='Open - Not Contacted',
                                NumberOfEmployees = 52,Rating ='Hot',
                                Cloufi__Years_in_Business__c = 47);
        insert ObjLead;
                    
        Cloufi__Application__c objApplication = new Cloufi__Application__c(Cloufi__First_Name__c= 'Test Name',Cloufi__Lead__c = ObjLead.id,
                                                                           Cloufi__Website__c='www.tech.com',Cloufi__Loan_Term__c = 15,Cloufi__Owner_1_Home_Address__c='skjdb sdvsdf sdgf',
                                                                           Cloufi__Business_Legal_Name__c='sdfb b',Cloufi__Business_DBA_Name__c='SXbvsfdvbr',Cloufi__Amount_Requested__c=4565,
                                                                           Cloufi__Type_of_Business__c ='Partnership',Cloufi__Expected_Funding_Date__c =System.today(),
                                                                           Cloufi__Gross_Profit__c=4656);
        insert objApplication;  
                    
        Cloufi__UW_Document__c ObjStips = new Cloufi__UW_Document__c();
        ObjStips.name = 'test';
        ObjStips.Cloufi__Application__c = objApplication.id;    
        ObjStips.Cloufi__Type__c = 'Articles of Incorporation /LLC Formation';
        ObjStips.Cloufi__Opportunity__c = ObjLoan.id;
        ObjStips.Cloufi__URL__c ='www.google.com';
        ObjStips.Status__c = 'Requested';          
        insert ObjStips;
                  
        ContractSignedEmailUpdateComp_Ctl objContractSignedEmailUpdateComp_Ctl = new ContractSignedEmailUpdateComp_Ctl();
        objContractSignedEmailUpdateComp_Ctl.oppId = ObjLoan.id;
        objContractSignedEmailUpdateComp_Ctl.getOppLink();
        objContractSignedEmailUpdateComp_Ctl.getRequestedDocs();
    }
    
    public static testmethod void validateContractOne(){  
    
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
                  
        ContractSignedEmailUpdateComp_Ctl objContractSignedEmailUpdateComp_Ctl = new ContractSignedEmailUpdateComp_Ctl();
        objContractSignedEmailUpdateComp_Ctl.oppId = ObjLoan.id;
        objContractSignedEmailUpdateComp_Ctl.getOppLink();
        objContractSignedEmailUpdateComp_Ctl.getRequestedDocs();
    }    
}