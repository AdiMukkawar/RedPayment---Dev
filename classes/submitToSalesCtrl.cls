/*********************************************************
Author  | Date       | Description 
Neha    | 08/21/2018 | Controller for submitToSalesSupport VF Page
**********************************************************/

public class submitToSalesCtrl {
    public id loanId {get;set;}
    public Opportunity loan{get;set;}
    public Map<id,User> userRoleMap{get;set;}
    public Integer appCount{get;set;}
    public Integer bankStmtCount{get;set;}
    public Integer processingStmtCount{get;set;}
    public Boolean showPage{get;set;}
    
    public submitToSalesCtrl(ApexPages.StandardController stdCtrl){
        showPage = true;
        appCount = 0;
        bankStmtCount = 0;
        processingStmtCount = 0;
        loan = new Opportunity();
        loanId = ApexPages.currentPage().getParameters().get('Id');
        if(stdCtrl.getId() == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Page must be invoked from Loan.'));
            return;
        }
        if(loanId != null){
            loan = [select Id,Name,StageName,(select name,Cloufi__URL__c,Cloufi__Type__c,Stip_Name__c from Cloufi__Dropbox_Attachments__r where (Stip_Name__c LIKE '%Bank Statement%' OR Stip_Name__c='Signed Application' OR Stip_Name__c LIKE '%Processing Statement%') AND Cloufi__URL__c != null) from Opportunity where Id=:loanId limit 1];
        }
        
        Id roleId = [select id,name from UserRole where Name =: 'Sales Support' limit 1].Id;
        
        userRoleMap = new Map<id,User>([select id,name,Email from User where UserRoleId =: roleId]);
        
        for(Cloufi__UW_Document__c objUW : loan.Cloufi__Dropbox_Attachments__r){
            if(objUW.Stip_Name__c.tolowercase() == 'signed application'){
                appCount += 1;
            }
            if(objUW.Stip_Name__c.tolowercase().contains('bank statement')){
                bankStmtCount +=1;
            }
            if(objUW.Stip_Name__c.tolowercase().contains('processing statement')){
                processingStmtCount +=1;
            }
        }
        if(appCount==0){
            showPage = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Signed application is missing'));        
            return;
        } 
        
        if(bankStmtCount < 3 && processingStmtCount < 3){
            showPage = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Bank Statement/s or Processing Statment/s missing'));
            return; 
        }
    }
    
    public pageReference submitToSalesSupport(){
        if(showPage){
            List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
            List<Task> tasklist=new List<Task>();
            
            //get email Template Id
            Id supportTemplateId;
            List<EmailTemplate> templateList = [select id from EmailTemplate where DeveloperName = 'Submit_To_Sales_Support'];
            if(templateList!=null && templateList.size()>0){
                supportTemplateId = templateList[0].Id;
            }
            
            if(userRoleMap.size() > 0){
                for(User objUser : userRoleMap.values()){
                    
                    Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                    //List<String> emailIds = (new List<String>)objUser.Email; 
                    String[] emailIds = new String[] {objUser.Email};
                        List<String> BccEmailIds=new List<String>();
                    Id targetUser = objUser.Id;                       
                    
                    //Email Message
                    emailMsg.setToAddresses(emailIds);
                    emailMsg.setTargetObjectId(targetUser);
                    /*if(loan.Id != null){
                   		 emailMsg.setWhatId(loan.Id);
                    }*/
                    
                    emailMsg.setTemplateId(supportTemplateId);
                    emailMsg.SaveAsActivity = False;               
                    lstEmailMsg.add(emailMsg);
                    Task t=new task();
                    t.Type = 'Email';
                    t.Status='In Progress';
                    t.WhatId= loan.Id;
                    //t.whoId=loan.Id;
                    t.subject='Opportunity Submited to sales support : '+' '+objUser.Name;
                    tasklist.add(t);
                }   
                if(lstEmailMsg.size()>0){
                    Messaging.sendEmail(lstEmailMsg);
                }
                if(tasklist.size()>0 ){                
                    insert tasklist; 
                }
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Opportunity has been submitted to sales support') );
                return null;
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'User not specified for sales support') );
                return null;
            }            
        }
        return null;
    }
}