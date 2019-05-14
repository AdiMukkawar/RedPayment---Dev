/*Author | Date       | Description
Neha   | 08/13/2018 | Test class for inviteFunderCtrl
*/

@isTest
public class InviteFundersCtrl_Test {
    
    public static testMethod void testInviteFunderCtrl(){
        Test.startTest();     
        List <Cloufi__Program_Matching_Criteria__c> criteriaList ;
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'test';
        oppObj.StageName = 'Application';
        oppobj.CloseDate = system.today();
        oppobj.isPrivate=true;
        oppobj.Cloufi__Monthly_Revenue__c = 10000;
        oppobj.Cloufi__Type_of_Business__c = 'test';
        oppobj.CloufiServicing__Submission_Country__c = 'United States';
        insert oppObj;
        System.assertNotEquals(oppObj.id,null); 
        
        RecordType rtype = [select id from RecordType where sobjectType='Account' and DeveloperName='Lender'];
        
        Account objAccount = new Account(RecordTypeId =rtype.Id,Name='Test',Country__c ='United States');
        insert objAccount;
        System.assertNotEquals(objAccount.id,null); 
        
        Contact objContact = new Contact(FirstName='Test',LastName='Test',AccountId = objAccount.Id,Email='test@test.com',Submission__c=true);
        insert objContact;
        
        Cloufi__Product__c objProgram = new Cloufi__Product__c(Name='test',Cloufi__Minimum_Annual_Revenue__c=10000,Cloufi__Account__c=objAccount.Id);
        insert objProgram;
        System.assertEquals(10000, objProgram.Cloufi__Minimum_Annual_Revenue__c);
        
        Cloufi__Program_Matching_Criteria__c objProgMatchCriteria = new Cloufi__Program_Matching_Criteria__c();
        objProgMatchCriteria.Cloufi__Opportunity__c = 'Eligible__c'; 
        
        objProgMatchCriteria.Cloufi__Criteria__c = 'equals to';
        objProgMatchCriteria.Cloufi__Program_Field__c = 'Cloufi__is_Profitable__c';
        
        insert objProgMatchCriteria; 
        
        Cloufi__Program_Matching_Criteria__c PMCObj = new Cloufi__Program_Matching_Criteria__c();
        PMCObj.Cloufi__Opportunity__c = 'Cloufi__Type_of_Business__c';
        PMCObj.Cloufi__Criteria__c = 'equals to';
        PMCObj.Cloufi__Program_Field__c = 'Cloufi__Program_Type__c';
        insert PMCObj;
        
        Cloufi__Program_Matching_Criteria__c PMCObj1 = new Cloufi__Program_Matching_Criteria__c();
        PMCObj1.Cloufi__Opportunity__c = 'Cloufi__Monthly_Revenue__c';
        PMCObj1.Cloufi__Criteria__c = 'equals to';
        PMCObj1.Cloufi__Program_Field__c = 'Cloufi__Minimum_Annual_Revenue__c';
        insert PMCObj1;
        
        Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c();
        objUW.Name = 'Signed Application';
        objUW.Stip_Name__c = 'Signed Application';
        objUW.Cloufi__URL__c = 'www.dropbox.com';
        objUW.Status__c = 'Completed';
        objUW.Cloufi__Opportunity__c = oppObj.Id;
        insert objUW;
        
        List<Cloufi__UW_Document__c> UWList = new List<Cloufi__UW_Document__c>();
        for(integer i =0;i<4;i++){
            Cloufi__UW_Document__c objUW1 = new Cloufi__UW_Document__c();
            objUW1.Name = 'May Bank Statement';
            objUW1.Cloufi__Type__c = 'Bank Statement';
            objUW1.Stip_Name__c = 'May Bank Statement '+i;
            objUW1.Cloufi__URL__c = 'www.dropbox.com';
            objUW1.Status__c = 'Completed';
            objUW1.Cloufi__Opportunity__c = oppObj.Id;
            UWList.add(objUW1);            
        }  
        insert UWList;
        
        Cloufi__Submission__c objSub = new Cloufi__Submission__c(Cloufi__Lender__c=objAccount.id,Cloufi__Opportunity__c=oppObj.id,Cloufi__Status__c='Requested');
        insert objSub;

        criteriaList = new List<Cloufi__Program_Matching_Criteria__c>();
        criteriaList.add(objProgMatchCriteria);    
        ApexPages.StandardController sc = new ApexPages.StandardController(oppObj);
        InviteFundersCtrl objLoanProgramsCtrl  = new InviteFundersCtrl(sc);
        System.debug('objLoanProgramsCtrl.listProgramCustom-->'+objLoanProgramsCtrl.listProgramCustom);
        if(objLoanProgramsCtrl.listProgramCustom.size()>0){  
            objLoanProgramsCtrl.listProgramCustom[0].isSelected = true; 
        }
        objLoanProgramsCtrl.inviteFunders();
        List<Cloufi__Submission__c> objSubmission = [select id,Cloufi__Status__c,Cloufi__Lender__c,Cloufi__Opportunity__c from Cloufi__Submission__c where Cloufi__Lender__c =: objAccount.id AND Cloufi__Opportunity__c =: oppObj.id];
        System.assertEquals('Requested',objSubmission[0].Cloufi__Status__c);
        Test.stopTest(); 
    }
}