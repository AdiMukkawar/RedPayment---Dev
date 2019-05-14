public with sharing class SendForFundingControllerX {

    public ID opportunityId {get;set;}
    public Opportunity objOpportunity {get;set;} 
    public String htmlBody {get;set;}
    public String subject {get;set;}
   
    public List<Account> accountList{get;set;}
    public List<ContactWrapper> wrapList{get;set;}

    public Integer size{get;set;}   
    public List<String> toAddresses{get;set;}


    public SendForFundingControllerX(ApexPages.StandardController controller) {
        opportunityId = ApexPages.currentPage().getParameters().get('Id');
        objOpportunity = new Opportunity();
        htmlBody = '';
        subject = '';
        accountList = new List<Account>();
        wrapList = new List<ContactWrapper>();
        size = 0;
        toAddresses = new List<String>();

        if(opportunityId == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please open this page from opportunity'));
            //return;
        }else{
            objOpportunity = [Select id, Cloufi__Email_Address__c, Name,Company_Logo__c from Opportunity where id = : opportunityId];
        }
        populateEmailBody();
    }

    public void populateEmailBody() {        
        accountList = [SELECT Id, Name, (SELECT Id, Name, Email FROM Contacts WHERE email != null) FROM Account WHERE Name='Funding Department'];
        size = accountList[0].contacts.size();
               
        if(size>0){
            for(Contact objContact : accountList[0].contacts){
                wrapList.add(new ContactWrapper(true,objContact));
            }
        }

        subject ='Funding Request for '+objOpportunity.Name;
        
        htmlBody = 'Hello,<br/><br/>';
        htmlBody += 'This <b>'+objOpportunity.Name+'</b> is ready for funding.<br/><br/>';
        htmlBody += '<b>Opportunity: <a href="'+System.URL.getSalesforceBaseURL().toExternalForm()+'/'+objOpportunity.Id+'">'+objOpportunity.Name+'</a></b><br/><br/><br/>';
        htmlBody += 'Thank you.<br/>';        
    }

    public pageReference send() {
        toAddresses = new List<String>();
        for(contactWrapper wrap : wrapList){
            if(wrap.IsSelected){
                toAddresses.add(String.valueOf(wrap.objContact.Email));
            }
        }
        
        if(toAddresses.size()==0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Select contact from list'));
            return null;
        }

        Boolean isValidEmail = true;
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(toAddresses);
        message.subject = subject;
        message.setHtmlBody(htmlBody);
        message.SaveAsActivity = true;
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if(results.size()>0){
	        if(results[0].success){
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Email Sent to Funding Department'));
	        }else{
	            System.debug('The email failed to send: ' + results[0].errors[0].message);
	        }
	    }
        return null;
    }
    
    public class ContactWrapper {
        public Boolean IsSelected {get;set;}
        public Contact objContact {get;set;}
        public ContactWrapper( Boolean selected, Contact objContact) {
            this.IsSelected = selected;
            this.objContact = objContact;
        }
    }    
}