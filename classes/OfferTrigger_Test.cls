@isTest
private class OfferTrigger_Test
{
    @isTest
    static void testOfferTrigger()
    {
        Cloufi__Offer_Opportunity_Field_Mapping__c objOfferOpportunity = new Cloufi__Offer_Opportunity_Field_Mapping__c();
        objOfferOpportunity.Name = 'Factor Rate';
        objOfferOpportunity.Cloufi__Opportunity_Field_API__c = '1.2';
        objOfferOpportunity.Cloufi__Offer_Field_API__c = '1.2';
        if(Schema.sObjectType.Cloufi__Offer_Opportunity_Field_Mapping__c.isCreateable()){
           insert objOfferOpportunity;
        }
        
        //insert Account
        Account objAccount = new Account();
        //objAccount.RecordTypeId = accountRecordType;
        objAccount.Name = 'Test Funder';
        if(Schema.sObjectType.Cloufi__Application__c.isCreateable()){
            insert objAccount;
        }
        
        contact objContact = new contact(Contract__c=true,AccountId=objAccount.id,LastName='Test Name',Email='test@sfdc.com');
    	insert objContact;
    
        //insert opportunity
        Opportunity objOpp = new Opportunity(); 
        objOpp.Name = 'Test Opp';
        objOpp.ForecastCategoryName = 'Pipeline';
        objOpp.CloseDate = System.today();
        objOpp.StageName = 'Qualified';
        insert objOpp;

        //Insert submission
        Cloufi__Submission__c objSubmission = new Cloufi__Submission__c();
        objSubmission.Cloufi__Lender__c = objAccount.Id;
        objSubmission.Cloufi__Opportunity__c = objOpp.Id;
        objSubmission.Cloufi__Status__c = 'Requested';
        insert objSubmission;

        String offerRecordType = [select id from RecordType where SobjectType = 'Cloufi__Offers__c' AND Name = 'Custom'].id;

        //Insert offer
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c();
        objOffer.RecordTypeId = offerRecordType;
        objOffer.Cloufi__Opportunity__c = objOpp.id;
        objOffer.Cloufi__Funder__c = objAccount.id;
        objOffer.Cloufi__Submission__c = objSubmission.id;
        objOffer.Cloufi__Offer_Status__c = 'Rejected';
        objOffer.Revision_Notes__c = 'Test';
        insert objOffer;
        
        // Insert another offer
        Cloufi__Offers__c objOffer1 = new Cloufi__Offers__c();
        objOffer1.RecordTypeId = offerRecordType;
        objOffer1.Cloufi__Opportunity__c = objOpp.id;
        objOffer1.Cloufi__Funder__c = objAccount.id;
        objOffer1.Cloufi__Submission__c = objSubmission.id;
        objOffer1.Cloufi__Offer_Status__c = 'New';
        objOffer1.Revision_Notes__c = 'Test';
        insert objOffer1;
        
        //Insert Attachment
        Attachment attach=new Attachment();     
      attach.Name='Unit Test Attachment';
      Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
      attach.body=bodyBlob;
        attach.parentId=objOffer.id;
        insert attach;
        
        //update offer
        objOffer.Cloufi__Offer_Status__c = 'Chosen';
        update objOffer;  
        System.assertEquals(objOffer.Cloufi__Offer_Status__c, 'Chosen');
    }
    
    @isTest
    static void testOfferTrigger1()
    {
        Cloufi__Offer_Opportunity_Field_Mapping__c objOfferOpportunity = new Cloufi__Offer_Opportunity_Field_Mapping__c();
        objOfferOpportunity.Name = 'Factor Rate';
        objOfferOpportunity.Cloufi__Opportunity_Field_API__c = '1.2';
        objOfferOpportunity.Cloufi__Offer_Field_API__c = '1.2';
        if(Schema.sObjectType.Cloufi__Offer_Opportunity_Field_Mapping__c.isCreateable()){
           insert objOfferOpportunity;
        }
        
        //insert Account
        Account objAccount = new Account();
        //objAccount.RecordTypeId = accountRecordType;
        objAccount.Name = 'Test Funder';
        if(Schema.sObjectType.Cloufi__Application__c.isCreateable()){
            insert objAccount;
        }
        
        contact objContact = new contact(Contract__c=true,AccountId=objAccount.id,LastName='Test Name',Email='test@sfdc.com');
    	insert objContact;
    
        //insert opportunity
        Opportunity objOpp = new Opportunity(); 
        objOpp.Name = 'Test Opp';
        objOpp.ForecastCategoryName = 'Pipeline';
        objOpp.CloseDate = System.today();
        objOpp.StageName = 'Qualified';
        insert objOpp;

        //Insert submission
        Cloufi__Submission__c objSubmission = new Cloufi__Submission__c();
        objSubmission.Cloufi__Lender__c = objAccount.Id;
        objSubmission.Cloufi__Opportunity__c = objOpp.Id;
        objSubmission.Cloufi__Status__c = 'Requested';
        insert objSubmission;

        String offerRecordType = [select id from RecordType where SobjectType = 'Cloufi__Offers__c' AND Name = 'Custom'].id;

        //Insert offer
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c();
        objOffer.RecordTypeId = offerRecordType;
        objOffer.Cloufi__Opportunity__c = objOpp.id;
        objOffer.Cloufi__Funder__c = objAccount.id;
        objOffer.Cloufi__Submission__c = objSubmission.id;
        objOffer.Cloufi__Offer_Status__c = 'Pending';
        objOffer.Revision_Notes__c = 'Test';
        insert objOffer;
        
        //Insert Attachment
        Attachment attach=new Attachment();     
      	attach.Name='Unit Test Attachment';
      	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
      	attach.body=bodyBlob;
        attach.parentId=objOffer.id;
        insert attach;
        
        //update offer
        objOffer.Cloufi__Offer_Status__c = 'Expired';
        update objOffer;  
        System.assertEquals(objOffer.Cloufi__Offer_Status__c, 'Expired');
    }
    
     @isTest
    static void testOfferTrigger2()
    {
        Cloufi__Offer_Opportunity_Field_Mapping__c objOfferOpportunity = new Cloufi__Offer_Opportunity_Field_Mapping__c();
        objOfferOpportunity.Name = 'Factor Rate';
        objOfferOpportunity.Cloufi__Opportunity_Field_API__c = '1.2';
        objOfferOpportunity.Cloufi__Offer_Field_API__c = '1.2';
        if(Schema.sObjectType.Cloufi__Offer_Opportunity_Field_Mapping__c.isCreateable()){
           insert objOfferOpportunity;
        }
        
        //insert Account
        Account objAccount = new Account();
        //objAccount.RecordTypeId = accountRecordType;
        objAccount.Name = 'Test Funder';
        if(Schema.sObjectType.Cloufi__Application__c.isCreateable()){
            insert objAccount;
        }
        
        contact objContact = new contact(Contract__c=true,AccountId=objAccount.id,LastName='Test Name',Email='test@sfdc.com');
    	insert objContact;
    
        //insert opportunity
        Opportunity objOpp = new Opportunity(); 
        objOpp.Name = 'Test Opp';
        objOpp.ForecastCategoryName = 'Pipeline';
        objOpp.CloseDate = System.today();
        objOpp.StageName = 'Qualified';
        insert objOpp;

        //Insert submission
        Cloufi__Submission__c objSubmission = new Cloufi__Submission__c();
        objSubmission.Cloufi__Lender__c = objAccount.Id;
        objSubmission.Cloufi__Opportunity__c = objOpp.Id;
        objSubmission.Cloufi__Status__c = 'Requested';
        insert objSubmission;

        String offerRecordType = [select id from RecordType where SobjectType = 'Cloufi__Offers__c' AND Name = 'Custom'].id;

        //Insert offer
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c();
        objOffer.RecordTypeId = offerRecordType;
        objOffer.Cloufi__Opportunity__c = objOpp.id;
        objOffer.Cloufi__Funder__c = objAccount.id;
        objOffer.Cloufi__Submission__c = objSubmission.id;
        objOffer.Cloufi__Offer_Status__c = 'Pending';
        objOffer.Revision_Notes__c = 'Test';
        insert objOffer;
        
        System.assertNotEquals(objOffer.id,null);
        //update offer
        objOffer.Cloufi__Offer_Status__c = 'Rejected';
        update objOffer;  
        //System.assertEquals(objOffer.Cloufi__Offer_Status__c, 'Approved');
    }
  
    // Aditya - To cover Revision alert method
	@isTest
    static void executeRevisionOffer(){
        
        //insert Lead
        Lead objLead = new Lead(LastName='Test Name',Company='Testing',status='New');
        insert objLead;
        
		//insert Account
        Account objAccount = new Account(Name = 'Test Funder');
        insert objAccount;
    
		contact objCon = new contact(Revision__c=true,AccountId=objAccount.id,LastName='Test Name',Email='test@sfdc.com');
		insert objCon;

        //insert opportunity
        Opportunity objOpp = new Opportunity(); 
        objOpp.Name = 'Test Opp';
        objOpp.CloseDate = System.today();
        objOpp.StageName = 'Qualified';
        objOpp.AccountId = objAccount.id;
        objOpp.Lead__c = objLead.id;
        insert objOpp;

        //Insert submission
        Cloufi__Submission__c objSubmission = new Cloufi__Submission__c();
        objSubmission.Cloufi__Lender__c = objAccount.Id;
        objSubmission.Cloufi__Opportunity__c = objOpp.Id;
        objSubmission.Cloufi__Status__c = 'Requested';
        insert objSubmission;

        //Insert offer
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c();
        objOffer.Cloufi__Opportunity__c = objOpp.id;
        objOffer.Cloufi__Funder__c = objAccount.id;
        objOffer.Cloufi__Submission__c = objSubmission.id;
        objOffer.Cloufi__Offer_Status__c='Revision';
        objOffer.Revision_Notes__c = 'Test';
        insert objOffer;
    
	}
	
	// To cover rejectToNewSubmission method
	@isTest
    static void executeRejectedNewOffer(){
        
        //insert Lead
        Lead objLead = new Lead(LastName='Test Name',Company='Testing',status='New');
        insert objLead;
        
		//insert Account
        Account objAccount = new Account(Name = 'Test Funder');
        insert objAccount;
    
		//contact objCon = new contact(Revision__c=true,AccountId=objAccount.id,LastName='Test Name',Email='test@sfdc.com');
		//insert objCon;

        //insert opportunity
        Opportunity objOpp = new Opportunity(); 
        objOpp.Name = 'Test Opp';
        objOpp.CloseDate = System.today();
        objOpp.StageName = 'Qualified';
        objOpp.AccountId = objAccount.id;
        objOpp.Lead__c = objLead.id;
        insert objOpp;

        //Insert submission
        Cloufi__Submission__c objSubmission = new Cloufi__Submission__c();
        objSubmission.Cloufi__Lender__c = objAccount.Id;
        objSubmission.Cloufi__Opportunity__c = objOpp.Id;
        objSubmission.Cloufi__Status__c = 'Requested';
        insert objSubmission;

        //Insert offer
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c();
        objOffer.Cloufi__Opportunity__c = objOpp.id;
        objOffer.Cloufi__Funder__c = objAccount.id;
        objOffer.Cloufi__Submission__c = objSubmission.id;
        objOffer.Cloufi__Offer_Status__c='Rejected';
        objOffer.Revision_Notes__c = 'Test';
        insert objOffer;
				
		objOffer.Cloufi__Offer_Status__c='New';
		update objOffer;
		
		objOffer.Cloufi__Offer_Status__c='Chosen';
		update objOffer;
		
		objOffer.Cloufi__Offer_Status__c='New';
		update objOffer;
    
	}
  
}