/******************************************************************************
Author             | Date           | Description
Aditya Mukkawar    | 16-August-2018 | Update Opportunity stage depending on UW docs
******************************************************************************
 Updates
* Author            | Date            | Description
* Aditya Mukkawar   | 12-October-2018 | Once Signed Application UW Document is Signed make Application completed
* Aditya Mukkawar   | 19-February-2019| Send an email to Sales support address and avoid to send mail to sales support when Signed application is completed
**********************************************************************************/

@isTest
public class UWDocumentsTrigger_Test {
  public static testMethod void executeSignedApp(){
        Cancelled_UW_Document__c objCancelUWDOc = new Cancelled_UW_Document__c(Name = 'Test', URL__c = 'https://www.webopedia.com/TERM/U/URL.html');
        insert objCancelUWDOc;
        
        /*Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator()); 
        Test.stopTest();*/
          
        Account objAcc = new Account(Name='Test Acc');
        insert objAcc;
        
        contact objCon = new Contact(lastname='Test',Email='test@test.com',AccountId=objAcc.Id,Submission__c=true);
        insert objCon;
        
        Lead objLead = New Lead(LastName='Test1',Status='New',Company='TestCompany',Average_Monthly_Revenue__c='$10,000 - $24,999',Time_in_Business__c='1-3 Years',Phone='9632587410',country='Canada');
        insert objLead;
        
        Opportunity objOpp = new Opportunity(AccountId=objAcc.id,Opportunity_Owner_Manager__c=UserInfo.getUserId(),Name='Test Opp',StageName='App In Missing Info', CloseDate=system.today(),Lead__c=objLead.id, Cloufi__Dropbox_Folder_Path__c = 'test', Cancelled_Dropbox_Folder_Path__c = 'Test cancelled', Bank_statements_Email_to_Sales_Support__c = false);
        insert objOpp;
        
        Cloufi__Submission__c objSub = new Cloufi__Submission__c(Cloufi__Lender__c=objAcc.id,Cloufi__Opportunity__c=objOpp.id,Cloufi__Status__c='Requested');
        insert objSub;
        
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c(Cloufi__Funder__c=objAcc.id,Cloufi__Opportunity__c=objOpp.id,Cloufi__Submission__c=objSub.id,Cloufi__Offer_Status__c='Approved');
        insert objOffer;
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new BitlyHttpCalloutMock());
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator()); 
            Cloufi__Application__c objApp = new Cloufi__Application__c(short_url__c='abc',cloufi__Opportunity__c =objOpp.id,Cloufi__Lead__c=objLead.id,Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany',Cloufi__Business_Legal_Name__c='Test',Cloufi__Industry_Type__c='Construction',Average_Monthly_Revenue__c='$250,000+',Time_in_Business__c='3-5 Years',Cloufi__First_Name__c='TestName',Cloufi__Last_Name__c='Test1',Cloufi__Email__c='test@gmail.com');
            insert objApp;
        Test.stopTest();

        
        
        Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c(Cloufi__URL__c='www.sfdc.com',Name='Test',Stip_Name__c='Signed Application',Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application__c=objApp.id, Cloufi__Type__c='Application - Document', Status__c='Pending');
        insert objUW;
        objUW.Cloufi__URL__c = 'ww.salesforce.com';
        update objUW;
        
        Cloufi__UW_Document__c objBank ;
        List <Cloufi__UW_Document__c> uwList = new List <Cloufi__UW_Document__c>();
        for(Integer i=0; i<5; i++){
            objBank = new Cloufi__UW_Document__c();
            objBank.Cloufi__URL__c='www.sfdc.com';
            objBank.Name='Test';
            objBank.Stip_Name__c='February'+i+' Bank';
            objBank.Cloufi__Opportunity__c=objOpp.Id;
            objBank.Cloufi__Application__c=objApp.id;
            objBank.Cloufi__Type__c='Bank Statement';
            objBank.Status__c='Pending';
            uwList.add(objBank);
        }
        insert uwList;
        
        
        UW_Document_Share__c objShare = new UW_Document_Share__c(Account__c=objAcc.id,Opportunity__c=objOpp.id,UW_Documents__c=objUW.id);
        insert objShare;
    
        objOpp.stageName = 'Contract Requested';
        update objOpp;
    
        //delete objUW;
        Cloufi__UW_Document__c objUW2 = new Cloufi__UW_Document__c(Status__c = 'Requested',Cloufi__URL__c='https://www.sfdc.com',Name='Contract',Stip_Name__c='Contract',Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application__c=objApp.id);
        insert objUW2;
        delete  objUW2;
        
        objOpp.stageName = 'Contract Sent';
        update objOpp;
        
        Cloufi__UW_Document__c objUW1 = new Cloufi__UW_Document__c(Status__c = 'Completed',Name='Test',Stip_Name__c='Signed Contract',Cloufi__Opportunity__c=objOpp.Id,Cloufi__Application__c=objApp.id);
        insert objUW1;
        UW_Document_Share__c objShare1 = new UW_Document_Share__c(Account__c=objAcc.id,Opportunity__c=objOpp.id,UW_Documents__c=objUW1.id);
        insert objShare1;
        
        
    }
}