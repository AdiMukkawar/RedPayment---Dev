public with sharing class ResendApplicationControllerX {

    public Id opportunityId;
    public Opportunity objOpportunity{get;set;}
    public List<Opportunity> oppList = new List<Opportunity>();
    
    public boolean sendAppLink{get;set;}
    public boolean sendPDF{get;set;}
    public boolean sendMobile{get;set;}
    
    public List<Cloufi__Application__c> objApplist {get;set;}
    public Cloufi__Application__c objApp {get;set;}
    public Map<String,String> countryCodeMap;
    public string formatedNumber{get;set;}
    public Twilio_Setting__c setting;
    
    public ResendApplicationControllerX(ApexPages.StandardController controller) {
        sendAppLink = false;
        sendPDF = false;
        sendMobile = false;
        
        opportunityId = ApexPages.currentPage().getParameters().get('id');
        if(opportunityId != null){
            DescribeSObjectResult describeResult = Opportunity.getSObjectType().getDescribe();
        
            List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
            String query = ' SELECT Owner.Phone, ' + String.join( fieldNames, ',' )+ '  FROM ' + describeResult.getName() + '  WHERE Id = '+'\''+opportunityId+'\'';
            
            oppList = Database.query(query);
            System.debug('query--->'+query);   
          
            objOpportunity = oppList[0];
            
            objApplist = [Select id,name, Application_URL__c from Cloufi__Application__c where Cloufi__Opportunity__c =:opportunityId Order By CreatedDate Desc];
            
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Page must be open from Opportunity'));
        }
        
        countryCodeMap = new Map<String,String>();

        for(Cloufi_Twilio__Country_Code__mdt countryCode : [SELECT DeveloperName, Cloufi_Twilio__Area_Code__c FROM Cloufi_Twilio__Country_Code__mdt Where DeveloperName != null AND Cloufi_Twilio__Area_Code__c != null ]){
            countryCodeMap.put(countryCode.DeveloperName,countryCode.Cloufi_Twilio__Area_Code__c);
            system.debug('countryCodeMap -> '+countryCodeMap);
        }
        
        setting = new Twilio_Setting__c();
        //Get Twillo login credentilas
        List<Twilio_Setting__c> settingList = [SELECT Id, Name, From_Number__c,Default_Country_Code__c FROM Twilio_Setting__c WHERE Name = 'Twilio Account' LIMIT 1];
        
        if(settingList.size() > 0){
            setting = settingList[0];
        }
        
    }

    public  void sendEmailToMerchant(){
        Boolean pageError = false;
        Map<String,Cloufi__Opportunity_Application_Field_Mapping__c> mapOpptyToApplication = Cloufi__Opportunity_Application_Field_Mapping__c.getAll();
        List <Cloufi__UW_Document__c> existingUWDocumentList = new List <Cloufi__UW_Document__c>();
        List <Cloufi__UW_Document__c> updateExistingUW = new List <Cloufi__UW_Document__c>();
        List <Cloufi__Application__c> existingApplicationList = new List <Cloufi__Application__c>();
        Cloufi__Application__c appRecord = new Cloufi__Application__c();
        
        // Start - Logic for Sending out Application when following Renewals/Revival Flow
        if(objOpportunity.StageName=='Prospecting'){
            Cloufi__Application__c objApplication = new Cloufi__Application__c();
            system.debug('mapOpptyToApplication >>'+mapOpptyToApplication);
            
            for(Cloufi__Opportunity_Application_Field_Mapping__c mapOpptyApp : mapOpptyToApplication.values()){
                system.debug('mapOpptyApp >>'+mapOpptyApp);
                if(mapOpptyApp.Cloufi__Application_Field_API__c!='Application_URL__c'){
                    objApplication.put(mapOpptyApp.Cloufi__Application_Field_API__c, objOpportunity.get(mapOpptyApp.Cloufi__Opportunity_Field_API__c));
                }
            }
            
            objApplication.Cloufi__Opportunity__c = objOpportunity.id;
            system.debug('objApplication>>'+objApplication);
            insert objApplication;
            
            objOpportunity.StageName = 'App Sent';
            objOpportunity.Application_URL__c = Label.Site_URL+'/completeApplicationForm?id='+objApplication.Id;
            update objOpportunity;
            system.debug('objOpportunity.Application_URL__c>>'+objOpportunity.Application_URL__c);
            existingUWDocumentList = [SELECT Id, Status__c FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c=:objOpportunity.id AND Stip_Name__c='Signed Application'];
            for(Cloufi__UW_Document__c uwRecord: existingUWDocumentList){
                uwRecord.Status__c = 'Rejected';
                updateExistingUW.add(uwRecord);
            }
            if(!updateExistingUW.isEmpty()){
                update updateExistingUW;
            }
            
        }else if(objOpportunity.StageName=='App In Missing Info'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'To re-send an App, the Opportunity stage should be either in App Sent or Prospecting.'));
            pageError = true;
        }else if(objOpportunity.StageName=='App Sent' && objOpportunity.Application_URL__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'There is no Application record associated with this Opportunity yet.'));
            pageError = true;
        }else if(objOpportunity.StageName=='Revived'){
            existingUWDocumentList = [SELECT Id, Status__c FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c=:objOpportunity.id AND Stip_Name__c='Signed Application'];
            for(Cloufi__UW_Document__c uwRecord: existingUWDocumentList){
                uwRecord.Status__c = 'Rejected';
                updateExistingUW.add(uwRecord);
            }
            if(!updateExistingUW.isEmpty()){
                update updateExistingUW;
            }
            
            existingApplicationList = [SELECT Id, Cloufi__Application_Status__c FROM Cloufi__Application__c WHERE Cloufi__Opportunity__c=:objOpportunity.id LIMIT 1];
            if(!existingApplicationList.isEmpty()){
                appRecord = existingApplicationList[0];
                appRecord.Cloufi__Application_Status__c = 'In Progress';
                update appRecord;
            }
        }
        
        // End - Logic for Sending out Application when following Renewals/Revival Flow
        
        
        try{
            String OwnerId = objOpportunity.OwnerId;
            
            
            if(sendMobile){
                String msgBody = '';
                for(Cloufi__Application__c objApplication : objApplist){
                    msgBody += 'Hi'+ ' ' +objOpportunity.Owner_1_First_Name__c + ',' + ' To give you funding offers, Complete the application using this link ' + ' ' + objApplication.Application_URL__c;
                    msgBody += '. If you have any question, you can call '+objOpportunity.Owner.Phone+' or text back. Thank you';                  
                }
                System.debug('msgBody '+msgBody);
                sendURLInSMS(msgBody);
                sendMobile = false;
            }
            
            if(sendAppLink && sendPDF){
                if(objApplist.size()>0){
                    objApp = objApplist[0];
                    sendEmail();
                    sendPDFAttach();
                    sendAppLink = false;
                    sendPDF = false;                    
                }
            }
            if(sendAppLink && !sendPDF){
                if(objApplist.size()>0){
                    objApp = objApplist[0];
                    sendEmail();
                    sendAppLink = false;
                }
            }
            if(sendPDF && !sendAppLink){
                if(objApplist.size()>0){
                    objApp = objApplist[0];
                    sendPDFAttach();
                    sendPDF = false;
                }
            }
           
        }catch(Exception ex){
            System.debug('Exception >>'+ex.getMessage());
            System.debug('Exception >>'+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            
        } 
        
        
        /* if(!pageError){
            List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();        
            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            List<String> emailIds = new List<String>();
            emailIds.add(objOpportunity.Cloufi__Email_Address__c);
            emailMsg.setToAddresses(emailIds);
            emailMsg.setTargetObjectId(UserInfo.getUserId());
            emailMsg.setWhatId(opportunityId);   
            emailMsg.SaveAsActivity = false;  
            emailMsg.setTemplateId([select id from EmailTemplate where DeveloperName = 'ResendApplication'].id);
            lstEmailMsg.add(emailMsg);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmailMsg);
            if(results.size()>0){
                if(results[0].success){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Application has been sent to ' +objOpportunity.Cloufi__Email_Address__c));
                }else{
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                }
            }
        } */
    }
    
    
    public Pagereference sendPDFAttach(){
        System.debug('In sendPDFAttach ->'+sendPDF);
        List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
        Opportunity oppRecord = [Select id,Cloufi__Email_Address__c, Name from Opportunity where id=:opportunityId];
        Cloufi__Application__c ObjApplication = [select Id,CreatedDate,LastModifiedDate,Name from Cloufi__Application__c where id=:objApp.id];
        if(ObjApplication !=Null){ 
            //Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            List<String> emailIds = new List<String>();
            
            //emailMsg.setWhatId(opportunityId);  
            //emailMsg.setTargetObjectId(UserInfo.getUserId());
            //emailMsg.setTemplateId([select id from EmailTemplate where DeveloperName = 'Send_PDF_Template_Opp'].id);
            String userId = UserInfo.getUserId();
            String templateId = [select id from EmailTemplate where DeveloperName = 'Send_PDF_Template_Opp'].id;
            String whatId = opportunityId;
            
            Messaging.SingleEmailMessage emailMsg = Messaging.renderStoredEmailTemplate(templateId, userId, whatId);
            
            emailIds.add(oppRecord.Cloufi__Email_Address__c);
            emailMsg.setToAddresses(emailIds);
            emailMsg.SaveAsActivity = false;
            
            //Attachments
            List<StaticResource> objPDF = [Select body, name from StaticResource where Name = 'MapleAppPDF'];
            system.debug('objPDF >>'+objPDF);
            Messaging.EmailFileAttachment[] objEmailAttachments = new Messaging.EmailFileAttachment[1];
            Messaging.EmailFileAttachment objPDFAttachment = new Messaging.EmailFileAttachment();
            objPDFAttachment.setBody(objPDF[0].Body);
            objPDFAttachment.setFileName(objPDF[0].name + '.pdf');
            objEmailAttachments[0] = objPDFAttachment;
            system.debug('objPDFAttachment >>'+objPDFAttachment);
            emailMsg.setFileAttachments(objEmailAttachments);
            
            

            
            lstEmailMsg.add(emailMsg);
            System.debug('Email Message>>' +emailMsg);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmailMsg);
            System.debug('results' +results);
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'PDF has been sent to ' +oppRecord.Cloufi__Email_Address__c ));
            return null;
        }
        return null;
    }
    
    
    public void sendEmail(){
        List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
        Opportunity oppRecord = [Select id,Cloufi__Email_Address__c, Name from Opportunity where id=:opportunityId];
        Cloufi__Application__c ObjApplication = [select Id,CreatedDate,LastModifiedDate,Name from Cloufi__Application__c where id=:objApp.id];
        if(ObjApplication !=Null){ 
            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            List<String> emailIds = new List<String>();
            emailIds.add(oppRecord.Cloufi__Email_Address__c);
            emailMsg.setToAddresses(emailIds);
            emailMsg.setTargetObjectId(UserInfo.getUserId());
            emailMsg.setWhatId(opportunityId);   
            emailMsg.SaveAsActivity = false;  
            emailMsg.setTemplateId([select id from EmailTemplate where DeveloperName = 'ResendApplication'].id);//SendApplication
            lstEmailMsg.add(emailMsg);
            System.debug('Email Message' +emailMsg);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmailMsg);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Application has been sent to ' +oppRecord.Cloufi__Email_Address__c ));
        }
    }
    
    public pageReference sendURLInSMS(String msgBody){
        if(sendMobile){
            formatedNumber = !(String.valueOf(objOpportunity.Owner_1_CellPhone__c).contains('+')) ? addCountryCode(objOpportunity.CloufiServicing__Submission_Country__c,String.valueOf(objOpportunity.Owner_1_CellPhone__c)) : String.valueOf(objOpportunity.Owner_1_CellPhone__c);
            System.debug('formatedNumber Mobile'+formatedNumber);
            System.debug('msgBody inside Mobile'+msgBody);
        }
        
        if(msgBody == '' || msgBody == null){
            System.debug('msgBody inside if'+msgBody);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Application link does not exist to send SMS.' ));
        }else if(setting.From_Number__c != null && formatedNumber != null && msgBody != null){
            System.debug('msgBody inside else'+msgBody);
            Cloufi_Twilio.SMSUtil.sendSms(formatedNumber, setting.From_Number__c, msgBody, objOpportunity.Id);
            System.debug('Value '+ApexPages.hasMessages(ApexPages.Severity.ERROR));
        }
        return null;
    }
    
    // Method to add country codes
    public String addCountryCode(String contactCountry, String numberToFromat){
        
        String code = '';
        System.debug('countryCodeMap.get(contactCountry)>>'+countryCodeMap.get(contactCountry));
        if(contactCountry != null && countryCodeMap.get(contactCountry) != null && countryCodeMap.containsKey(contactCountry)){
            code =  countryCodeMap.get(contactCountry);
        }else{
            code = String.valueOf(Twilio_Setting__c.getValues('Twilio Account').Default_Country_Code__c);
        }
        string phoneDigits = '';
        string nondigits = '[^0-9]';
        //remove all non digit characters from number
        phoneDigits = numberToFromat.replaceAll(nondigits,'');
        return code+phoneDigits;
    }
}