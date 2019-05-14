/*
Author      | Date        | Description
Pradeep     | 19-06-2018  | Send Application Page to Site User
Aditya      | 09-07-2018  | 1) On click of Send Application convert lead.
                            2) If Application is not created under Lead then create Application first.
Aditya      | 19-07-2018  | Removed convert lead functionality 
Aditya      | 28-07-2018  | Added Send PDF and checkbox for Send Application
Aditya      | 13-08-2018  | Added convert lead functionality
Aditya      | 08-02-2019  | Re-direct the user to Opportunity record, once the "Send Application" button is clicked
*/

public with sharing class SendApplicationController {
    
    public static List<Cloufi_Twilio__Country_Code__mdt> countrycodeList;
    public Map<String,String> countryCodeMap;
    public List<Cloufi__Application__c> objApplist {get;set;}
    public Cloufi__Application__c objApp {get;set;}
    public Lead objLead {get;set;}
    public id leadid{get;set;}
    public id oppId{get;set;}
    /*public Account objAccount{get;set;}
    public Contact objContact{get;set;}*/
    public Opportunity objOpportunity{get;set;}
    public boolean sendAppLink{get;set;}
    public boolean sendPDF{get;set;}
    public boolean sendMobile{get;set;}  
    public boolean adobePDF{get;set;}
    public Twilio_Setting__c setting;
    public string formatedNumber{get;set;}
    public Adobe_Templates__c adobeTemplateList{get;set;}
    public string templateId{get;set;}
    public Boolean showSend{get;set;}
    
    public SendApplicationController (ApexPages.StandardController controller ) {
        leadid = ApexPages.currentPage().getParameters().get('id');
        objApplist = new List<Cloufi__Application__c>();
        objApp = new Cloufi__Application__c();
        
        objLead = [Select id,IsConverted,Email,FirstName,LastName,Name,Company,Phone, MobilePhone,CountryCode, Owner.Phone,OwnerId,Interested_within_2_4_weeks__c,Purpose_of_Funding__c,Cloufi__Amount_Requested__c,Time_in_Business__c,Average_Monthly_Revenue__c,Current_Payment_Plan__c,Are_you_in_Bankruptcy_Consumer_Proposal__c, Unconverted_Lead_ByPass__c from Lead where id=:leadid];
        objApplist = [Select id,name, Application_URL__c from Cloufi__Application__c where Cloufi__Lead__c =:leadid Order By CreatedDate Desc];
        if(objLead.IsConverted){
            showSend = false;
        }else{
            showSend = true;
        }
        adobeTemplateList = Adobe_Templates__c.getInstance('Adobe Template Id');
        if(adobeTemplateList.TemplateId__c !=null){
            templateId = adobeTemplateList.TemplateId__c;
            system.debug('templateId--->'+templateId);
        }        
        setting = new Twilio_Setting__c();
        //Get Twillo login credentilas
        List<Twilio_Setting__c> settingList = [SELECT Id, Name, From_Number__c,Default_Country_Code__c FROM Twilio_Setting__c WHERE Name = 'Twilio Account' LIMIT 1];
        
        if(settingList.size() > 0){
            setting = settingList[0];
        }
        
        // Get CountryCodes from metadata
        
        countryCodeMap = new Map<String,String>();

        for(Cloufi_Twilio__Country_Code__mdt countryCode : [SELECT DeveloperName, Cloufi_Twilio__Area_Code__c FROM Cloufi_Twilio__Country_Code__mdt Where DeveloperName != null AND Cloufi_Twilio__Area_Code__c != null ]){
            countryCodeMap.put(countryCode.DeveloperName,countryCode.Cloufi_Twilio__Area_Code__c);
            system.debug('countryCodeMap -> '+countryCodeMap);
        }
        
        sendAppLink = false;
        sendPDF = false;
        sendMobile = false;
        adobePDF = false;
        //sendPhone = false;
    }
    
    public void convertLeadAction(){
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(leadid);
        lc.ConvertedStatus = 'Converted';
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        oppId = lcr.getOpportunityId();
        if(objApp.id !=null){
            Cloufi__Application__c  objAppl = [SELECT id,Cloufi__Opportunity__c, Application_Sent_by_Rep__c FROM Cloufi__Application__c WHERE id=:objApp.id];
            if(objAppl.Cloufi__Opportunity__c == null){
                objAppl.Cloufi__Opportunity__c = oppId;                
            }
            objAppl.Application_Sent_by_Rep__c = true;
            update objAppl;
        }
    }
    
    public Pagereference SendApplication(){
        try{
            
            String OwnerId = objLead.OwnerId;
            system.debug('objLead.Phone=>'+objLead.Phone);
            system.debug('objLead.MobilePhone=>'+objLead.MobilePhone);
            if(objLead.LastName==''  || objLead.Email==null || (objLead.Phone==null && objLead.MobilePhone==null) || (objLead.Average_Monthly_Revenue__c==null || objLead.Average_Monthly_Revenue__c=='$0 - $4,999') || (objLead.Time_in_Business__c==null || objLead.Time_in_Business__c=='0-3 Months') || (objLead.Are_you_in_Bankruptcy_Consumer_Proposal__c==true && objLead.Current_Payment_Plan__c!='Yes') || objLead.Cloufi__Amount_Requested__c==null || objLead.Purpose_of_Funding__c==null || objLead.Interested_within_2_4_weeks__c==false){
                showSend = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Is Application Checklist Completed?' ));
                return null;
            }
            if(!OwnerId.startsWith('005')){
                showSend = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Please assign this record to a User and then try sending the Application.' ));
                return null;
            }
            
            if(sendMobile){
                String msgBody = '';
                for(Cloufi__Application__c objApplication : objApplist){
                    msgBody += 'Hi'+ ' ' +objLead.FirstName + ',' + ' To give you funding offers, Complete the application using this link ' + ' ' + objApplication.Application_URL__c;
                    msgBody += '. If you have any question, you can call '+objLead.Owner.Phone+' or text back. Thank you';                  
                }
                System.debug('msgBody '+msgBody);
                sendURLInSMS(msgBody);
                sendMobile = false;
            }/*else if(sendPhone){
                String msgBody = '';
                for(Cloufi__Application__c objApplication : objApplist){
                    msgBody += 'Hello'+ ' ' +objLead.Name + ',' + 'Please click on below link to open submitted form' + ' ' + objApplication.Application_URL__c;
                }
                System.debug('msgBody '+msgBody);
                sendURLInSMS(msgBody);
                sendPhone = false;
            }*/
            
            if(sendAppLink && sendPDF){
                if(objApplist.size()>0){
                    objApp = objApplist[0];
                    sendEmail();
                    sendPDFAttach();
                    sendAppLink = false;
                    sendPDF = false;                    
                }/*else{
                    Cloufi__Application__c objApplication = new Cloufi__Application__c();
                    objApplication.Cloufi__Last_Name__c = objLead.LastName;
                    objApplication.Cloufi__First_Name__c = objLead.FirstName;
                    objApplication.Cloufi__Email__c = objLead.Email;
                    objApplication.Cloufi__Business_Legal_Name__c = objLead.Company;
                    objApplication.Cloufi__Phone_Bank_Info__c = objLead.Phone;
                    objApplication.Cloufi__Lead__c = objLead.id;
                    insert objApplication;
                    objApp = objApplication;
                    sendEmail();
                    sendPDFAttach();
                    sendAppLink = false;
                    sendPDF = false;
                }*/
            }
            if(sendAppLink && !sendPDF){
                if(objApplist.size()>0){
                    objApp = objApplist[0];
                    sendEmail();
                    sendAppLink = false;
                }/*else{
                    Cloufi__Application__c objApplication = new Cloufi__Application__c();
                    objApplication.Cloufi__Last_Name__c = objLead.LastName;
                    objApplication.Cloufi__First_Name__c = objLead.FirstName;
                    objApplication.Cloufi__Email__c = objLead.Email;
                    objApplication.Cloufi__Business_Legal_Name__c = objLead.Company;
                    objApplication.Cloufi__Phone_Bank_Info__c = objLead.Phone;
                    objApplication.Cloufi__Lead__c = objLead.id;
                    insert objApplication;
                    objApp = objApplication;
                    sendEmail();
                    sendAppLink = false;
                }*/
            }
            if(sendPDF && !sendAppLink){
                if(objApplist.size()>0){
                    objApp = objApplist[0];
                    sendPDFAttach();
                    sendPDF = false;
                }/*else{
                    Cloufi__Application__c objApplication = new Cloufi__Application__c();
                    objApplication.Cloufi__Last_Name__c = objLead.LastName;
                    objApplication.Cloufi__First_Name__c = objLead.FirstName;
                    objApplication.Cloufi__Email__c = objLead.Email;
                    objApplication.Cloufi__Business_Legal_Name__c = objLead.Company;
                    objApplication.Cloufi__Phone_Bank_Info__c = objLead.Phone;
                    objApplication.Cloufi__Lead__c = objLead.id;
                    insert objApplication;
                    objApp = objApplication;
                    sendPDFAttach();
                    sendPDF = false;
                }*/
            }
            
            /*if(!sendPDF && !sendAppLink && !sendPDF){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.warning, 'Please select atleast one checkbox.'));
                return null;
            }*/
            /*if(adobePDF){
                //Adobe_Templates__c adobeTemplateList = Adobe_Templates__c.getInstance('Adobe Template Id');
                //string templateId = adobeTemplateList.TemplateId__c;
                //system.debug('templateId--->'+templateId);
                if(!sendAppLink && !sendPDF && !sendMobile){
                    convertLeadAction();    
                }           
                PageReference objPage = new PageReference('/apex/echosign_dev1__AgreementTemplateProcess?masterId=' + oppId+'&TemplateId='+templateId);
                return objPage;
            }else{
                return null;
            }*/
            //return null;
            if(oppId !=null){
                showSend = false;
                PageReference oppPage = new PageReference('/' + oppId);
                oppPage.setRedirect(true);
                return oppPage;
                /*return null;*/
            }else{
                return null;
            }
            
            
        }catch(Exception ex){
            System.debug('Exception '+ex.getMessage());
            System.debug('Exception '+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            return null;
        }
        
        
    }
    
    public Pagereference sendPDFAttach(){
        System.debug('In sendPDFAttach ->'+sendPDF);
        List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
        Lead objLd = [Select id,Email, Name, Unconverted_Lead_ByPass__c, OwnerId from Lead where id=:leadid];
        User objUser = [Select Id,Manager.Email FROM User WHERE id=:objLd.OwnerId];
        List<String> ccEmailIds = new List<String>();
        if(objUser.Manager.Email !=null){
            ccEmailIds.add(objUser.Manager.Email);
        }
        Cloufi__Application__c ObjApplication = [select Id,CreatedDate,LastModifiedDate,Name from Cloufi__Application__c where id=:objApp.id];
        if(ObjApplication !=Null){ 
            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            List<String> emailIds = new List<String>();
            emailIds.add(objLd.Email);
            emailMsg.setToAddresses(emailIds);
            if(ccEmailIds.size()>0){
                emailMsg.setCcAddresses(ccEmailIds);
            }
            emailMsg.setTargetObjectId(leadid);
            emailMsg.setWhatId(objApp.id);   
            emailMsg.SaveAsActivity = false;  
            emailMsg.setTemplateId([select id from EmailTemplate where DeveloperName = 'Send_PDF_Template'].id);
             //Attachments
            List<StaticResource> objPDF = [Select body, name from StaticResource where Name = 'MapleAppPDF'];
            Messaging.EmailFileAttachment[] objEmailAttachments = new Messaging.EmailFileAttachment[1];
            Messaging.EmailFileAttachment objPDFAttachment = new Messaging.EmailFileAttachment();
            objPDFAttachment.setBody(objPDF[0].Body);
            objPDFAttachment.setFileName(objPDF[0].name + '.pdf');
            objEmailAttachments[0] = objPDFAttachment;
            emailMsg.setFileAttachments(objEmailAttachments);
            
            lstEmailMsg.add(emailMsg);
            System.debug('Email Message' +emailMsg);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmailMsg);
            System.debug('results' +results);
            
            objLd.Unconverted_Lead_ByPass__c = true;
            update objLd;
            /*if(adobePDF){
                PageReference objPage = new PageReference('/apex/echosign_dev1__AgreementTemplateProcess?masterId=' + oppId+'&TemplateId='+templateId);
                return objPage;
            }else{*/
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'PDF has been sent to ' +objLd.Email ));
                convertLeadAction();
                return null;
            //}
            /*if (results[0].success) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'PDF has been sent to ' +objLd.Email ));
                convertLeadAction();
            }*/
        }
        return null;
    }
    
    public void sendEmail(){
        
        List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
        Lead objLd = [Select id,Email, Name, Unconverted_Lead_ByPass__c,Lead.OwnerId from Lead where id=:leadid];
        User objUser = [Select Id,Manager.Email FROM User WHERE id=:objLd.OwnerId];
        List<String> ccEmailIds = new List<String>();
        if(objUser.Manager.Email !=null){
            ccEmailIds.add(objUser.Manager.Email);
        }
        Cloufi__Application__c ObjApplication = [select Id,CreatedDate,LastModifiedDate,Name from Cloufi__Application__c where id=:objApp.id];
        if(ObjApplication !=Null){ 
            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            List<String> emailIds = new List<String>();
            emailIds.add(objLd.Email);
            emailMsg.setToAddresses(emailIds);
            if(ccEmailIds.size()>0){
                emailMsg.setCcAddresses(ccEmailIds);
            }
            emailMsg.setTargetObjectId(leadid);
            emailMsg.setWhatId(objApp.id);   
            emailMsg.SaveAsActivity = false;  
            emailMsg.setTemplateId([select id from EmailTemplate where DeveloperName = 'SendApplication'].id);
            lstEmailMsg.add(emailMsg);
            System.debug('Email Message' +emailMsg);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmailMsg);
            objLd.Unconverted_Lead_ByPass__c = true;
            update objLd;
            /*if(adobePDF){
                PageReference objPage = new PageReference('/apex/echosign_dev1__AgreementTemplateProcess?masterId=' + oppId+'&TemplateId='+templateId);
                return objPage;
            }else{*/
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Application has been sent to ' +objLd.Email ));
                if(sendAppLink && !sendPDF && !sendMobile){
                    convertLeadAction();
                    //return null;
                }
            //}
            
            /*if (results[0].success) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Application has been sent to ' +objLd.Email ));
                if(sendAppLink && !sendPDF && !sendMobile){
                    convertLeadAction();
                }
            }*/
        }
        //return null;
    }
    
    public pageReference sendURLInSMS(String msgBody){
        if(sendMobile){
            formatedNumber = !(String.valueOf(objLead.MobilePhone).contains('+')) ? addCountryCode(objLead.CountryCode,String.valueOf(objLead.MobilePhone)) : String.valueOf(objLead.MobilePhone);
            System.debug('formatedNumber Mobile'+formatedNumber);
            System.debug('msgBody inside Mobile'+msgBody);
        }/*else if(sendPhone){
            formatedNumber = !(String.valueOf(objLead.Phone).contains('+')) ? addCountryCode(objLead.CountryCode,String.valueOf(objLead.Phone)) : String.valueOf(objLead.Phone);    
            System.debug('formatedNumber Phone'+formatedNumber);
            System.debug('msgBody inside Phone'+msgBody);
        }*/
        
        if(msgBody == '' || msgBody == null){
            System.debug('msgBody inside if'+msgBody);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Application link does not exist to send SMS.' ));
        }else if(setting.From_Number__c != null && formatedNumber != null && msgBody != null){
            System.debug('msgBody inside else'+msgBody);
            Cloufi_Twilio.SMSUtil.sendSms(formatedNumber, setting.From_Number__c, msgBody, objLead.Id);
            System.debug('Value '+ApexPages.hasMessages(ApexPages.Severity.ERROR));
            if(!ApexPages.hasMessages(ApexPages.Severity.ERROR)){
                if(!sendAppLink && !sendPDF){
                    objLead.Unconverted_Lead_ByPass__c = true;
                    update objLead;
                    convertLeadAction();
                }
            }
            /*if(adobePDF){
                PageReference objPage = new PageReference('/apex/echosign_dev1__AgreementTemplateProcess?masterId=' + oppId+'&TemplateId='+templateId);
                return objPage;
            }else{
                return null;
            }*/
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