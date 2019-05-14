/*****************************************************************
* Author: Techila Global Services Pvt Ltd.(Neha Harle)
* Class Name: SendToControlSheetDeptControllerX
* Created Date: 24-August-2018
* Description: Extension to submit to control sheet department
*******************************************************************
* Updates
* Author            | Date          | Description
* Aditya            | 09/03/2018    | To avoid duplicate control Sheet and To create next version of Control sheet
* Aditya            | 08/04/2018    | To create UW Document Share for Selected control sheet contacts
**********************************************************************************/


public with sharing class SendToControlSheetDeptControllerX {
    public Integer Size{get;set;}   
    public List < String > ToAddresses {get;set;}
    public ID loanId {get;set;}
    public String htmlBody {get;set;}
    public String Subject {get;set;}
    public Opportunity Loan {get;set;}    
    public List<Account> accountList{get;set;}
    public String SiteURL{get;set;}
    public List<ContactWrapper> wrapList{get;set;}
    public List<Cloufi__UW_Document__c> lstUWDocs{get;set;}
    public Cloufi__UW_Document__c objUWControlSheet{get;set;}
    public Cloufi__UW_Document__c objUWCompletedControlSheet{get;set;}
    public List<StipWrapper> stipWrapperList {get;set;}
    public List<Cloufi__UW_Document__c> uwDocumentList{get;set;}
    public List<UW_Document_Share__c> uwDocShareList{get;set;}
    
    public SendToControlSheetDeptControllerX(ApexPages.StandardController controller) {
        loanId = ApexPages.currentPage().getParameters().get('Id');
        init();
    }
    public void init(){
        wrapList = new List<ContactWrapper>();
        stipWrapperList = new List<StipWrapper>();
        uwDocumentList = new List<Cloufi__UW_Document__c>();

        if(loanId == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please open this page from opportunity'));
        }else{
            Loan = [Select id, Cloufi__Email_Address__c, Name,Company_Logo__c, (SELECT id FROM cloufi__Dropbox_Attachments__r WHERE Stip_Name__c like '%Control Sheet%') from Opportunity where id = : loanId];
            uwDocumentList = DevUtil.fetchDocument(loanId);
        }
        if(uwDocumentList.size()==0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'To send Control sheet Bank statements should be Completed.'));
        }
        uwDocShareList = [SELECT Id,Account__c,Control_Sheet_Contact__c,Opportunity__c,UW_Documents__c,UW_Documents__r.Cloufi__Type__c,UW_Documents__r.Status__c FROM UW_Document_Share__c WHERE Opportunity__c=:loanId AND UW_Documents__r.Cloufi__Type__c='Control Sheet' LIMIT 1];// AND UW_Documents__r.Status__c ='Requested'

        Map<string,Cloufi__LendingXL_Settings__c> LendingXLSettings = Cloufi__LendingXL_Settings__c.getAll();
        SiteURL = LendingXLSettings.get('Site_URL')!=null?LendingXLSettings.get('Site_URL').Cloufi__value__c:'';
		accountList = [select id, name, (select id,name,Email from Contacts where email != null) from account where Name='Control Sheet Department'];
		if(accountList.size()>0){
			populateEmailBody();
			system.debug('uwDocumentList=>'+uwDocumentList.size());
			if(uwDocumentList.size() > 0){
				for(Cloufi__UW_Document__c objUWDocument : uwDocumentList){
					if(objUWDocument.Cloufi__URL__c != null){
						stipWrapperList.add(new StipWrapper(true, objUWDocument));
					}
				}
			}
		}else{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Please create Control Sheet Department Account.'));
		}
    }
    
    public void populateEmailBody() {        
        accountList = [select id, name, (select id,name,Email from Contacts where email != null) from account where Name='Control Sheet Department'];
        Size=accountList[0].contacts.size();
               
        if(accountList[0].contacts.size()>0){
            for(contact objContact : accountList[0].contacts){
                wrapList.add(new ContactWrapper(true,objContact));
            }
        }
        subject ='Control Sheet Request for '+Loan.Name;
        
        htmlBody = 'Hello,<br/><br/>';
        htmlBody += 'Please review the New Application for <b>'+Loan.Name+'</b>. ';
        htmlBody += 'Please complete and upload the control sheet at your earliest convenience.<br/><br/>';
        htmlBody += '<b><a href='+SiteURL+'ControlSheetUpload?id='+loanId+'>Click Here</a></b> to upload Control Sheet<br/><br/><br/>';
        htmlBody += 'Thank you<br/>';        
    }
    
    public pageReference Send() {
        try {
            lstUWDocs = new List<Cloufi__UW_Document__c>();
            //List<Cloufi__UW_Document__c> objControlSheetDoc = new List<Cloufi__UW_Document__c>();
            lstUWDocs = [SELECT Id, Cloufi__URL__c, Stip_Name__c FROM Cloufi__UW_Document__c WHERE Cloufi__Type__c = 'Control Sheet' AND Cloufi__Opportunity__c =: loanId LIMIT 1];
            List<UW_Document_Share__c> createUWShare =  new List<UW_Document_Share__c>();
            if(uwDocumentList.size()==0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'To send Control sheet Bank statements should be Completed.'));
                return null;
            }
            ToAddresses = new List < String > ();
            for(contactWrapper wrap : wrapList){
                if(wrap.IsSelected){
                    ToAddresses.add(String.valueOf(wrap.objContact.Email));
                }
            }
            
            if(ToAddresses.size()==0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Select contact from list'));
                return null;
            }

            Boolean isValidEmail = true;
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            system.debug('ToAddresses>>'+ToAddresses);
            message.setToAddresses(ToAddresses);
            message.subject = subject ;//= 'Opportunity submitted to control sheet department:' + Loan.Name;
            message.setHtmlBody(htmlBody);
            message.SaveAsActivity = true;
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

            
            if(lstUWDocs.size()>0){
                objUWControlSheet = new Cloufi__UW_Document__c();
                objUWControlSheet = lstUWDocs[0];
            }else{
                objUWControlSheet = new Cloufi__UW_Document__c();
                objUWControlSheet.Name = 'Control Sheet';
                objUWControlSheet.Stip_Name__c = 'Control Sheet';
                objUWControlSheet.Cloufi__Type__c = 'Control Sheet';
                objUWControlSheet.Cloufi__Opportunity__c = loanId;
                objUWControlSheet.Status__c = 'Requested';
            }
            
            objUWControlSheet.Control_Sheet_Recipients__c = String.valueOf(ToAddresses);
            objUWControlSheet.Control_Sheet_requested_Date_Time__c = System.now();
            
            lstUWDocs = new List<Cloufi__UW_Document__c>();
            lstUWDocs = [SELECT Id, Cloufi__URL__c, Stip_Name__c FROM Cloufi__UW_Document__c WHERE Cloufi__Type__c = 'Control Sheet Completed' AND Cloufi__Opportunity__c =: loanId];
            if(lstUWDocs.size()>0){
                objUWCompletedControlSheet = new Cloufi__UW_Document__c();
                objUWCompletedControlSheet = lstUWDocs[0];
            }else{
                objUWCompletedControlSheet = new Cloufi__UW_Document__c();
                objUWCompletedControlSheet.Name = 'Control Sheet Completed';
                objUWCompletedControlSheet.Stip_Name__c = 'Control Sheet Completed';
                objUWCompletedControlSheet.Cloufi__Type__c = 'Control Sheet Completed';
                objUWCompletedControlSheet.Cloufi__Opportunity__c = loanId;
                objUWCompletedControlSheet.Status__c = 'Requested';
            }

            if (results[0].success) {
                System.debug('The email was sent successfully.');
                // Aditya - Start
                if(objUWControlSheet !=null){
                    upsert objUWControlSheet;
                }

                if(objUWCompletedControlSheet != null){
                    upsert objUWCompletedControlSheet;
                }

                for(contactWrapper wrap : wrapList){
                    if(wrap.IsSelected){
                        UW_Document_Share__c objShare = new UW_Document_Share__c();
                        objShare.Account__c = accountList[0].id;
                        objShare.Control_Sheet_Contact__c = wrap.objContact.Id;
                        objShare.Opportunity__c = loanId;
                        objShare.UW_Documents__c = objUWControlSheet.id;
                        createUWShare.add(objShare);
                    }
                }
                if(createUWShare.size()>0){
                    insert createUWShare;
                }
                if(uwDocShareList.size()>0){
                    delete uwDocShareList;
                }
                List<Cloufi__UW_Document__c> uwDocumentList = new List<Cloufi__UW_Document__c>();

                for(StipWrapper objStipWrap : stipWrapperList){
                    if(objStipWrap.IsSelected){
                        objStipWrap.Stip.Sent_to_Control_Sheet_Dept__c = true;                        
                    }else{
                        objStipWrap.Stip.Sent_to_Control_Sheet_Dept__c = false;
                    }
                    uwDocumentList.add(objStipWrap.Stip);
                }
                if(uwDocumentList.size() > 0){
                    update uwDocumentList;
                }
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Submitted to control sheet department'));
                system.debug('------->' + message);
            } else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
            init();
        }catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'mail cannot been sent '+e+'On this line number::'+e.getLineNumber()));
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

     public class StipWrapper {            
        public Boolean IsSelected {get;set;}
        public Cloufi__UW_Document__c Stip{get;set;}
        public StipWrapper(Boolean selected, Cloufi__UW_Document__c Stip) {             
            this.IsSelected = selected;
            this.Stip = Stip;
        }
    }    
}