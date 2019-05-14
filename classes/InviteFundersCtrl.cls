/*********************************************************
Author  | Date | Description 
Sneha   | 11/21/2017 | Controller for InviteLender VF Page
Sneha   | 12/6/2017 | Modularize the code. Make use of Utility class
Neha    | 08/06/2018 | Implemented new UW document flow
**********************************************************/
public with sharing class InviteFundersCtrl {
    public List<ProgramUtility.ProgramCustom> listProgramCustom{get;set;}
    public Opportunity loan{get;set;}
    public List<Cloufi__Program_Matching_Criteria__c> listProgramCriteria{get;set;}
    public ApexPages.StandardController ctrl;
    public List<StipWrapper> lstStipWrapper {get;set;}
    public List<Cloufi__UW_Document__c> stipsList {get;set;}    
    public List<UW_Document_Share__c> lstDocsShareInsert;
    public Integer appCount{get;set;}
    public Integer bankStmtCount{get;set;}
    public Boolean showPage{get;set;}
    public Map<String,Cloufi__Submission__c> programSubmissionMap{get;set;}
    public List<Cloufi__Application__c> objApplication; 
    private Map<Id, Set<String>> accountUWDocumentShareMap;

    public InviteFundersCtrl(ApexPages.StandardController controller) {        
        init(controller);
    }

    public void init(ApexPages.StandardController controller){
        ctrl = controller;
        loan = new Opportunity();
        listProgramCustom = new List<ProgramUtility.ProgramCustom>();
        loan = (Opportunity) controller.getRecord();
        objApplication = new List<Cloufi__Application__c>();
        lstStipWrapper = new List<StipWrapper>();
        stipsList = new List < Cloufi__UW_Document__c > ();        
        programSubmissionMap = new Map<String,Cloufi__Submission__c>();
        appCount = 0;
        bankStmtCount = 0;
        showPage = true;
        accountUWDocumentShareMap = new Map<Id, Set<String>>();

        if(controller.getId() == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Page must be invoked from Loan.'));
            return;
        }
        
        listProgramCriteria = new List<Cloufi__Program_Matching_Criteria__c>();    
        if(Schema.sObjectType.Cloufi__Program_Matching_Criteria__c.isAccessible() 
            && Schema.sObjectType.Cloufi__Program_Matching_Criteria__c.fields.Id.isAccessible() && 
           Schema.sObjectType.Cloufi__Program_Matching_Criteria__c.fields.Cloufi__Application_Field__c.isAccessible() && 
           Schema.sObjectType.Cloufi__Program_Matching_Criteria__c.fields.Cloufi__Opportunity__c.isAccessible() 
           && Schema.sObjectType.Cloufi__Program_Matching_Criteria__c.fields.Cloufi__Criteria__c.isAccessible() 
           && Schema.sObjectType.Cloufi__Program_Matching_Criteria__c.fields.Cloufi__Program_Field__c.isAccessible() ){
          
           listProgramCriteria = [select id,Cloufi__Application_Field__c,Hide_Value__c,Cloufi__Criteria__c,Cloufi__Program_Field__c,Cloufi__Opportunity__c from 
                                Cloufi__Program_Matching_Criteria__c where Cloufi__Opportunity__c!=null and
                                Cloufi__Program_Field__c!=null order by Sort_Order__c]; 
        }       
        
        //If Matching criteria not saved
        if(listProgramCriteria==null || listProgramCriteria.size()==0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please set up Program Matching Criteria'));
        }
        
        ProgramUtility programUtil = new ProgramUtility(listProgramCriteria);                                

        loan = programUtil.getOpportunity(loan.Id);
        
        //Populate years of bussiness on funder page header
        if(loan.Business_Start_Date__c != null){
            decimal monthsTotal = decimal.valueOf(loan.Business_Start_Date__c.monthsBetween(Date.today()));
            loan.Years_In_Business__c = monthsTotal.divide(12,2);
        }
        
        //Populate CC processing on funder page header
        if(loan.Do_you_Process_Credit_card__c != null && loan.Do_you_Process_Credit_card__c== 'Yes'){
            loan.Credit_Card_Processing__c = true;
        }else{
            loan.Credit_Card_Processing__c = false;
        }           
        
        for(Cloufi__UW_Document__c objUW : loan.Cloufi__Dropbox_Attachments__r){
            if(objUW.Stip_Name__c.tolowercase() == 'signed application'){
                if(objUW.Status__c == 'Completed'){
                    appCount += 1;
                }
            }
            if(objUW.Cloufi__Type__c == 'Bank Statement'){
                if(objUW.Status__c == 'Completed'){
                    bankStmtCount +=1;
                }
            }
        }
        
        System.debug('appCount-->'+appCount);
        System.debug('bankStmtCount-->'+bankStmtCount);
        if(appCount==0){
            showPage = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Signed application is Missing or Pending'));        
            return;
        }            

        if(bankStmtCount < 3){
            showPage = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Bank Statement/s Missing or Not Completed'));
            return; 
        }
        
        for(Cloufi__Submission__c objSubmission : [select id,Cloufi__Status__c,Cloufi__Program__c,Cloufi__Opportunity__c,Cloufi__Lender__c,Cloufi__Lender__r.Name from Cloufi__Submission__c where Cloufi__Opportunity__c =: loan.Id]){         
            programSubmissionMap.put(String.valueOf(objSubmission.Cloufi__Lender__c)+'+'+String.valueOf(objSubmission.Cloufi__Program__c),objSubmission);
        }
        
        for(ProgramUtility.ProgramCustom program: programUtil.getPrograms(loan.Id)){
            System.debug('program-->'+program);
            System.debug('show funder-->'+program.showFunder);
            if(programSubmissionMap.containsKey(program.program.Cloufi__Account__c+'+'+program.program.Id) && programSubmissionMap.get(program.program.Cloufi__Account__c+'+'+program.program.Id) != null){
                if(programSubmissionMap.get(program.program.Cloufi__Account__c+'+'+program.program.Id).Cloufi__Status__c == 'Approved'){
                System.debug('in map');
                    program.showFunder = true;                    
                }                
            }
            listProgramCustom.add(program);
        }
        
        SYstem.debug('listProgramCustom-->'+listProgramCustom);
        if(listProgramCustom.size()==0){
            showPage = false;
            if(Label.Invite_Funder_Lender_Missing != null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,Label.Invite_Funder_Lender_Missing));
            }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'No lenders are present for the country'));
            }           
            return;
        }
                   
        stipsList = [Select Name, Cloufi__URL__c,Stip_Name__c, Cloufi__Display_Size__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c = :loan.Id AND Cloufi__URL__c != null ORDER BY Name ASC]; //AND URL__c !=''];

       
        for(UW_Document_Share__c objUWShare : [select Name,Account__c,Account__r.Name,Opportunity__c,UW_Documents__r.Name,UW_Documents__c,UW_Documents__r.Cloufi__URL__c,UW_Documents__r.Stip_Name__c from UW_Document_Share__c where Opportunity__c = : loan.Id]){            
            if(accountUWDocumentShareMap.get(objUWShare.Account__c) == null){
                accountUWDocumentShareMap.put(objUWShare.Account__c, new Set<String>{objUWShare.UW_Documents__r.Name});
            }else{
                accountUWDocumentShareMap.get(objUWShare.Account__c).add(objUWShare.UW_Documents__r.Name);
            }
        }        
        Map<String,Cloufi__UW_Document__c> UWDOcMap = new Map<String,Cloufi__UW_Document__c>();
        for (Cloufi__UW_Document__c UWDoc: stipsList) {
            lstStipWrapper.add(new StipWrapper(true,UWDoc));
            UWDOcMap.put(UWDoc.Name, UWDoc);
        }
    }

    //Invite Lenders 
    public pagereference inviteFunders(){

        try{
            Integer inviteCount = 0;
            List<Cloufi__Submission__c> listLenders = new List<Cloufi__Submission__c>();        
            lstDocsShareInsert = new List<UW_Document_Share__c> ();

            Set<String> submissionLenderIdSet = new Set<String>();
           // for(Cloufi__Submission__c objSubmission : [SELECT Id, Cloufi__Lender__c,Decline_Reason__c FROM Cloufi__Submission__c WHERE Cloufi__Opportunity__c =: loan.Id AND Cloufi__Status__c != 'Declined']){
            for(Cloufi__Submission__c objSubmission : [SELECT Id, Cloufi__Lender__c  FROM Cloufi__Submission__c WHERE Cloufi__Opportunity__c =: loan.Id AND Cloufi__Status__c != 'Declined']){
                submissionLenderIdSet.add(objSubmission.Cloufi__Lender__c);
            }
            
            for(ProgramUtility.ProgramCustom program: listProgramCustom){
                
                System.debug('program.contactEmail-->'+program.contactEmail);
                
                if(program.isSelected){
                    if(program.contactEmail==null){
                        program.submission.addError('No Email id present in one of the selected Funder. Please select another Type');
                        return null;
                    }

                    if(!programSubmissionMap.containsKey(program.program.Cloufi__Account__c+'+'+program.program.Id)){
                        listLenders.add(program.submission);                        
                    }else if(programSubmissionMap.containsKey(program.program.Cloufi__Account__c+'+'+program.program.Id)){
                        Cloufi__Submission__c objSubmission = programSubmissionMap.get(program.program.Cloufi__Account__c+'+'+program.program.Id);
                        //if(objSubmission.Cloufi__Status__c == 'Declined'){
                            objSubmission.Cloufi__Status__c = 'Requested';
                            //objSubmission.Decline_Reason__c = '';
                            listLenders.add(objSubmission);
                        //}
                    }
                    inviteCount++;

                    //insert document share under selected lender
                    for(StipWrapper wrap : lstStipWrapper){
                        if(wrap.IsSelected){
                            UW_Document_Share__c UWShare = new UW_Document_Share__c();
                            UWShare.Opportunity__c=loan.Id;
                            UWShare.UW_Documents__c=wrap.Stip.Id;
                            UWShare.Account__c=program.program.Cloufi__Account__c;
                            
                            if(accountUWDocumentShareMap.get(UWShare.Account__c) != null){
                                if(!(accountUWDocumentShareMap.get(UWShare.Account__c).contains(wrap.Stip.Name))){                                    
                                    lstDocsShareInsert.add(UWShare);                                    
                                    accountUWDocumentShareMap.get(UWShare.Account__c).add(wrap.Stip.Name);
                                }                                
                            }else{
                                lstDocsShareInsert.add(UWShare);
                                accountUWDocumentShareMap.put(UWShare.Account__c, new Set<String>{wrap.Stip.Name});                                
                            }
                        }
                    }                    
                }
            }

            if(inviteCount==0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please select atleast one Lender.'));
                return null;
            }
            else{
                if(listLenders.size()>0){
                    upsert listLenders;                    
                }
                if(lstDocsShareInsert.size()>0){
                        insert lstDocsShareInsert;
                }
                List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
                List<Task> tasklist=new List<Task>();
                
                
                
                
                //get Funder Template Id
                Id funderTemplateId;
                List<EmailTemplate> templateList = [select id from EmailTemplate where DeveloperName = 'New_Funder'];
                //List<EmailTemplate> templateList = [select id from EmailTemplate where DeveloperName = 'New_Funder_Email'];
                if(templateList!=null && templateList.size()>0){
                    funderTemplateId = templateList[0].Id;
                }

                //Create email for each program
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: Label.CPS_Sales_Support_Email];
                
                
                for(ProgramUtility.ProgramCustom program: listProgramCustom){
                    if(program.isSelected){
                        Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                        List<String> emailIds = program.contactEmail; //new List<String>{program.contactEmail};
                        System.debug('emailIds-->'+emailIds);
                        List<String> BccEmailIds=new List<String>();
                        Id targetContact= new List<Id> (program.contactId)[0];                       
                        
                        //Email Message
                        if ( owea.size() > 0 ) {
                            emailMsg.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        emailMsg.setToAddresses(emailIds);
                        emailMsg.setTargetObjectId(targetContact);
                        if(program.submission.Id != null){
                            emailMsg.setWhatId(program.submission.Id);
                        }else if(programSubmissionMap.containsKey(program.program.Cloufi__Account__c+'+'+program.program.Id)){
                            emailMsg.setWhatId(programSubmissionMap.get(program.program.Cloufi__Account__c+'+'+program.program.Id).Id);
                        }
                        
                        emailMsg.setTemplateId(funderTemplateId);
                        emailMsg.SaveAsActivity = False;               
                        lstEmailMsg.add(emailMsg);
                        if(Schema.sObjectType.Task.isCreateable() && Schema.sObjectType.Task.fields.Type.isCreateable() && 
                           Schema.sObjectType.Task.fields.Status.isCreateable() && Schema.sObjectType.Task.fields.WhatId.isCreateable() 
                           && Schema.sObjectType.Task.fields.whoId.isCreateable() && Schema.sObjectType.Task.fields.subject.isCreateable() 
                           && Schema.sObjectType.Cloufi__Product__c.isCreateable() && Schema.sObjectType.Cloufi__Product__c.fields.Cloufi__Account__c.isCreateable())
                           {
                               for(Id contactId : program.contactId){
                                Task t=new task();
                                t.Type = 'Email';
                                t.Status='In Progress';
                                t.WhatId= program.submission.Id;
                                t.whoId= contactId;
                                t.subject='Invitation to Lender '+' '+program.program.Cloufi__Account__r.Name;
                                tasklist.add(t);
                               }
                           }                   
                    }
                }
                if(lstEmailMsg.size()>0){
                    Messaging.sendEmail(lstEmailMsg);
                }
                if(tasklist.size()>0 && Schema.sObjectType.Task.isCreateable()){                
                    insert tasklist; 
                }   

                if(loan.StageName == 'App Sent' || loan.StageName == 'App In Missing Info'){
                    loan.StageName = 'UW';
                }    

                update loan;     
            }
            init(ctrl);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Invitation has been sent successfully') );
            return null;
        }catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()+e.getLineNumber()));
            return null;
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