/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Prashant Mahajan)
* Class Name: OpportunityOffersController
* Created Date: 23-Aug-2018
* Description: Class to display Opportunity related offers & submissions for sidebar component
-------------------------------------------------------------------
Aditya Mukkawar | 17/09/2018 | Send email to Opp owner with all the pending documents
Aditya Mukkawar | 17/09/2018 | Send an email to Sales Support for Requested Documents are uploaded with the Opportunity link
Aditya Mukkawar | 20/09/2018 | If Role/Profile of Opportunity Owner is 'Cash Advance Sales Agent' then show only offers which are not New
Aditya Mukkawar | 26/09/2018 | Created 'Send for Final UW' button to send mail to Lender
*******************************************************************/
public class OpportunityOffersController{
    @AuraEnabled public Opportunity objopp {get;set;}   
    
    public static List<FieldSetWrapper> getFieldSet(String sObj, String fSetName){
        Schema.FieldSet sObjFset = Schema.getGlobalDescribe().get(sObj).getDescribe().fieldSets.getMap().get(fSetName);
        system.debug('sObjFset'+sObjFset);
        List<Schema.FieldSetMember> fieldSet = sObjFset.getFields();
        List<FieldSetWrapper> fMaplist = new List<FieldSetWrapper>();
        for (Schema.FieldSetMember fmem: fieldSet) {
            fMaplist.add(new FieldSetWrapper(fmem.getLabel(), fmem.getFieldPath(), fmem));
        }
        return fMaplist;
    }
    
    // fetches the sObjRecords for the passed sObject and the Field Set Name
    @AuraEnabled
    public static Map<String, List<FieldSetWrapper>> getsObjRecords(String sObj, String fSetName,Id oppId, String sObjType){
        Id currentUserId = UserInfo.getUserId();    
        User objUser = [Select Id,UserRole.Name from User WHERE id =: currentUserId];   
        List<FieldSetWrapper> fSetlist = getFieldSet(sObj, fSetName);
        String fAPIname = '';
        String soqlQuery = '';        
        for(FieldSetWrapper fName : fSetlist){
            fAPIname += fName.fAPIName + ',';
        }
        fAPIname += ' Id ';
        if(sObj == 'Cloufi__Submission__c'){                
            soqlQuery = 'Select ' + fAPIname + ',Cloufi__Lender__r.Name from ' + sObj + '  WHERE Cloufi__Opportunity__c =:oppId ';                
        }else if(sObj == 'Cloufi__Offers__c' && sObjType == 'Cloufi__Submission__c'){
            soqlQuery = 'Select ' + fAPIname + ' from ' + sObj + '  WHERE Cloufi__Submission__c =:oppId ';
            system.debug('sObjType ->'+sObjType);
            system.debug('soqlQuery ->'+soqlQuery);
        }else if(sObj == 'Cloufi__Offers__c'){
            soqlQuery = 'Select ' + fAPIname + ' from ' + sObj + '  WHERE Cloufi__Opportunity__c =:oppId ';                 
            
            if(objUser.UserRole.Name == 'Sales Support' && sObj == 'Cloufi__Offers__c'){
                // This query if sales support      
                soqlQuery += ' AND Cloufi__Offer_Status__c != \'New\'';                    
            }
        }else if(sObj == 'CloufiServicing__Syndication__c'){                
            soqlQuery = 'Select ' + fAPIname + ',CloufiServicing__Syndicating_Account__r.Name from ' + sObj + '  WHERE CloufiServicing__Opportunity__c =:oppId ';                
        }else if(sObj == 'Cloufi__UW_Document__c'){
            soqlQuery = 'Select ' + fAPIname + ' from ' + sObj + '  WHERE Cloufi__Opportunity__c =:oppId ';
        }
        
        
        List<sObject> sObjRecs = Database.query(soqlQuery);
        system.debug(sObjRecs);
       
        Opportunity objOpp = [SELECT id,Owner.Profile.name,Owner.UserRole.Name FROM Opportunity WHERE id=:oppId];
        List<FieldSetWrapper> fSetWrapperlist = new List<FieldSetWrapper>();
        for(sObject sObjRec : sObjRecs){
            if(sObj == 'Cloufi__Submission__c'){                
                fSetWrapperlist.add(new FieldSetWrapper(sObjRec, (String)sObjRec.getsObject('Cloufi__Lender__r').get('Name')));
            }else if(sObj == 'Cloufi__Offers__c' && sObjType == 'Cloufi__Submission__c'){
                fSetWrapperlist.add(new FieldSetWrapper(sObjRec, null));    
            }else if(sObj == 'Cloufi__Offers__c'){
                if(objOpp.Owner.UserRole.Name=='Cash Advance Sales Agent' || objOpp.Owner.Profile.name=='Cash Advance Sales Agent'){
                    Cloufi__Offers__c objoffer=(Cloufi__Offers__c)sObjRec;
                    if(objoffer.Cloufi__Offer_Status__c!= 'New'){
                        system.debug('Inside If=>'+objoffer.Cloufi__Offer_Status__c);
                        fSetWrapperlist.add(new FieldSetWrapper(sObjRec, null));
                    }
                }else{
                    system.debug('Inside Else=>');
                    fSetWrapperlist.add(new FieldSetWrapper(sObjRec, null));
                }               
            }else if(sObj == 'CloufiServicing__Syndication__c'){
                fSetWrapperlist.add(new FieldSetWrapper(sObjRec, (String)sObjRec.getsObject('CloufiServicing__Syndicating_Account__r').get('Name')));
            }else if(sObj == 'Cloufi__UW_Document__c'){
                fSetWrapperlist.add(new FieldSetWrapper(sObjRec, null));    
            }
            
        }
        Map<String, List<FieldSetWrapper>> fSetWrapperMap = new Map<String, List<FieldSetWrapper>>();
        fSetWrapperMap.put('sObjlist', fSetWrapperlist);
        fSetWrapperMap.put('fieldSetlist', fSetlist);
        
        return fSetWrapperMap;
    }
    
    //
    @AuraEnabled 
    public static user fetchUser(){
        // query current user information  
        User oUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
    
    // Aditya - Method to fetch Funder is available or not
    @AuraEnabled
    public static Boolean isFunderAvailable(Id oppId){
        Boolean funder = false;
        opportunity objOpp = [SELECT id,Cloufi__Funder__c FROM Opportunity WHERE id=:oppId];
        if(objOpp.Cloufi__Funder__c !=null){
            funder = true;
        }
        system.debug('funder=>'+funder);
        return funder;
    }   

    
    // Aditya -'Requested Docs Uploaded' button on component will be available to Sales Rep only
    @AuraEnabled
    public static Boolean showHideReqDocButtonC(Id oppId){
        Boolean showHide = false;
        opportunity objOpp = [SELECT id,OwnerId,Owner.Profile.name FROM Opportunity WHERE id=:oppId];
        Id profileId = userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        if(UserInfo.getUserId() == objOpp.OwnerId ){//|| profileName == 'System Administrator'
            showHide = true;
        }
        system.debug('showHide=>'+showHide);
        return showHide;
    }
    
    // Aditya - Send Missing Documents to Merchant
    @AuraEnabled
    public static String RequestStipAlertToMerchant(Id oppId){
        string msg='';
        try{
            Opportunity objOpp = [SELECT id,Owner.Email,Lead__c,Owner_1_Email__c,(SELECT id,Cloufi__URL__c FROM Cloufi__Dropbox_Attachments__r) FROM Opportunity WHERE id=:oppId];
            system.debug('objOpp=>'+objOpp);
            Boolean stipMissing = false;
            Boolean allStipsUploaded = true;
            if(objOpp.Cloufi__Dropbox_Attachments__r.size()>0){
                for(Cloufi__UW_Document__c objUW:objOpp.Cloufi__Dropbox_Attachments__r){
                    if(objUW.Cloufi__URL__c == null){
                        stipMissing = true;
                        allStipsUploaded = false;
                        break;
                    }
                }
            }else{
                msg +=  'There is no Document to upload';
            }
            
            if(stipMissing){
                Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                List<String> emailIds = new List<String>();
                if(objOpp.Owner_1_Email__c !=null){
                    emailIds.add(objOpp.Owner_1_Email__c);
                }
                emailMsg.setToAddresses(emailIds);
                emailMsg.setTargetObjectId(UserInfo.getUserId());
                emailMsg.setWhatId(objOpp.id);   
                emailMsg.SaveAsActivity = false;  
                emailMsg.setTemplateId([select id from EmailTemplate where DeveloperName = 'Request_Missing_Stips'].id);
                emailMsg.setTreatTargetObjectAsRecipient(false);
                system.debug('emailMsg=>'+emailMsg);
                if(emailIds.size()>0){
                    List<Messaging.SendEmailResult> results =  Messaging.sendEmail(new Messaging.Email[] {emailMsg});
                    system.debug('results=>'+results);
                    if (results.get(0).isSuccess()) {
                        msg += 'Missing Document mail has been sent to '+objOpp.Owner_1_Email__c;
                    }
                }else{
                    msg += 'Merchant email id is blank.';
                }
            }
            if(allStipsUploaded && objOpp.Cloufi__Dropbox_Attachments__r.size()>0){
                msg += 'All Documents are already Uploaded.';
            }
        }catch(Exception ex){
            System.debug('Exception '+ex.getMessage());
            System.debug('Exception '+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            return null;
        }
        return msg;
    }
    
    //Aditya - Get Selected UW records and mail it to Sales Support
    @AuraEnabled
    public static String showRequDocResult(Id oppId){
        try{
            string message = '';
            Opportunity objOpp = [SELECT id,Owner.Sales_Support_Email__c,OwnerId,Lead__c FROM Opportunity WHERE id=:oppId];
            EmailTemplate emailTemp = [select id from EmailTemplate where DeveloperName = 'Requested_Docs_uploaded'];
            system.debug('objOpp=>'+objOpp);
            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            List<String> ToEmailIds=new List<String>();
            if(objOpp.Owner.Sales_Support_Email__c!=null){
                ToEmailIds.add(objOpp.Owner.Sales_Support_Email__c);
            }
            emailMsg.setToAddresses(ToEmailIds);
            emailMsg.setTargetObjectId(userInfo.getUserId());
            emailMsg.setWhatId(objOpp.id);
            emailMsg.setTemplateId(emailTemp.id);
            emailMsg.SaveAsActivity = False;
            emailMsg.setTreatTargetObjectAsRecipient(false);
            if(ToEmailIds.size()>0){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMsg});
                message +='Message has been sent successfully to Sales Support';                
            }else{
                message +='Sales Support Email is not available';
            }
            system.debug('message=>'+message);
           return message;
        }catch(Exception ex){
            System.debug('Exception '+ex.getMessage());
            System.debug('Exception '+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            return null;
        }
    }
    
    // Aditya - Send mail to Sales Support
    @AuraEnabled
    public static string sendemailToOppOwner(Id oppId){
        string msg ='';
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
        List<Cloufi__UW_Document__c> lstUw = [select id,Stip_Name__c,Cloufi__Type__c,Cloufi__URL__c,Cloufi__Opportunity__c,Cloufi__Opportunity__r.Owner.Email,Cloufi__Opportunity__r.Owner_1_Email__c,Cloufi__Opportunity__r.Owner.Name, Cloufi__Opportunity__r.Owner.ManagerId, Cloufi__Opportunity__r.Owner.Manager.Email from Cloufi__UW_Document__c where Cloufi__Opportunity__c =: oppId AND Cloufi__URL__c=null AND (Cloufi__Type__c='Offer - Document' OR Cloufi__Type__c='Stip' OR Cloufi__Type__c='Custom Document')];
        if(lstUw.size()>0){
            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            List<String> emailIds = new List<String>();
            if(lstUw[0].Cloufi__Opportunity__r.Owner.Email !=null){
                emailIds.add(lstUw[0].Cloufi__Opportunity__r.Owner.Email);
            }
            //Copy Owner's Manager in all communications
            if(lstUw[0].Cloufi__Opportunity__r.Owner.ManagerId!=null){
                emailIds.add(lstUw[0].Cloufi__Opportunity__r.Owner.Manager.Email);
            }
            
            emailMsg.setToAddresses(emailIds);
            emailMsg.setTargetObjectId(UserInfo.getUserId());
            emailMsg.setWhatId(lstUw[0].Cloufi__Opportunity__c);   
            emailMsg.SaveAsActivity = false;  
            emailMsg.setTemplateId([select id from EmailTemplate where DeveloperName = 'Send_Stips_to_Sales_Rep'].id);
            emailMsg.setTreatTargetObjectAsRecipient(false);
            system.debug('emailMsg=>'+emailMsg);
            List<Messaging.SendEmailResult> results =  Messaging.sendEmail(new Messaging.Email[] {emailMsg});
            if (results.get(0).isSuccess()) {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Email send successfully'));
                return 'Email send successfully';
            }else{
                return 'Something went wrong';
            }
        }else{
            return 'No Pending Documents to Send.';
        }
    }
    
    // Aditya -  Get UW documents those are completed
     @AuraEnabled
    public static List<Cloufi__UW_Document__c> getUWDocumentList(Id oppId){
        return [select id,Stip_Name__c,Cloufi__URL__c,Cloufi__Opportunity__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c= : oppId and Cloufi__URL__c!=null AND (Cloufi__Type__c='Offer - Document' OR Cloufi__Type__c='Stip' OR Cloufi__Type__c='Custom Document')];
    }
    
    // Aditya - Send mail to Sales Support
    @AuraEnabled
    public static void sendEmailToLender(List<string> stipIds,Id oppId){
        try{
            system.debug('stipIds=>'+stipIds);
            List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
            List<Cloufi__UW_Document__c> lstUw = [select id,Sent_to_Lender__c,Stip_Name__c,Cloufi__URL__c,Cloufi__Opportunity__c from Cloufi__UW_Document__c where ID IN : stipIds];
            Opportunity objOpp = [SELECT id,(SELECT id,Cloufi__Offer_Status__c,Cloufi__Funder__c FROM Cloufi__Offers__r WHERE Cloufi__Offer_Status__c='Approved') FROM Opportunity WHERE id=:oppId];
            
            // Update the Send to Lender field on UW Document those are selected
            if(objOpp.Cloufi__Offers__r.size()>0 && lstUw.size()>0){
                List<Cloufi__UW_Document__c> lstToUpdateUw = new List<Cloufi__UW_Document__c>();
                for(Cloufi__UW_Document__c objUW:lstUw){
                    objUW.Sent_to_Lender__c = true;
                    lstToUpdateUw.add(objUW);
                }
                
                if(lstToUpdateUw.size()>0){
                    update lstToUpdateUw;
                    Account objAcc = [SELECt id,(SELECT id,Email,Submission__c FROM Contacts WHERE Submission__c=true) FROM Account WHERE id=:objOpp.Cloufi__Offers__r[0].Cloufi__Funder__c];
                    system.debug('objAcc.Contacts=>'+objAcc.Contacts);
                    EmailTemplate emailTemp = [select id from EmailTemplate where DeveloperName = 'Send_for_Final_UW'];
                    // Send a mail to Lender
                    Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                    List<String> ToEmailIds=new List<String>();
                    if(objAcc.Contacts.size()>0){
                        for(Contact objCon:objAcc.Contacts){
                            if(objCon.Email !=null){
                                ToEmailIds.add(objCon.Email);
                            }
                        }
                    }
                    emailMsg.setToAddresses(ToEmailIds);
                    emailMsg.setTargetObjectId(userInfo.getUserId());
                    emailMsg.setWhatId(oppId);
                    emailMsg.setTemplateId(emailTemp.id);
                    emailMsg.SaveAsActivity = False;
                    emailMsg.setTreatTargetObjectAsRecipient(false);
                    system.debug('emailMsg=>'+emailMsg);
                    if(ToEmailIds.size()>0){
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMsg});            
                    }
                    
                }
            }
        }catch(Exception ex){
            System.debug('Exception '+ex.getMessage());
            System.debug('Exception '+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
        }
    }
        
    public class FieldSetWrapper {
        @AuraEnabled public String fLabel;
        @AuraEnabled public String fAPIName;
        @AuraEnabled public String fSetMember;
        @AuraEnabled public sObject sObjRecord;
        @AuraEnabled public String childName;
        
        public FieldSetWrapper(String fieldlabel, String fieldAPIName, FieldSetMember fSetMem){
            fLabel = fieldlabel;
            fAPIName = fieldAPIName;
            fSetMember = JSON.serialize(fSetMem);
        }
        public FieldSetWrapper(sObject sObjRec,String subName){
            sObjRecord = sObjRec;
            childName = subName;
        }
    }
    
}