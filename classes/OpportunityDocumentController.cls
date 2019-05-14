/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: OpportunityDocumentController
* Created Date: 23-Aug-2018
* Description: Class to display Opportunity related Document for sidebar component
-------------------------------------------------------------------
Aditya Mukkawar | 17/09/2018 | Send email to Opp owner with all the pending documents
Aditya Mukkawar | 17/09/2018 | Send an email to Sales Support for Requested Documents are uploaded with the Opportunity link
Aditya Mukkawar | 20/09/2018 | If Role/Profile of Opportunity Owner is 'Cash Advance Sales Agent' then show only offers which are not New
Aditya Mukkawar | 26/09/2018 | Created 'Send for Final UW' button to send mail to Lender
Aditya Mukkawar | 10/10/2018 | For send Stip/Request stip will be checking docs whose status is requested, pending with no docs and  Rejected 
*******************************************************************/
public class OpportunityDocumentController {
    @AuraEnabled
    public static List<Cloufi__UW_Document__c> fetchDocument(Id oppId) {
        List<Cloufi__UW_Document__c> lstDocument = new List<Cloufi__UW_Document__c>();
        system.debug('oppId'+oppId);
        DescribeSObjectResult describeResultDocument = Cloufi__UW_Document__c.getSObjectType().getDescribe();
        List<String> documentfieldNames = new List<String>(describeResultDocument.fields.getMap().keySet());
        
        String query = ' SELECT ' + String.join( documentfieldNames, ',' ) + ' FROM Cloufi__UW_Document__c WHERE Cloufi__Type__c != \'Processing Statement\' AND Cloufi__Opportunity__c = '+'\''+oppId+'\' ORDER BY Cloufi__Type__c, Status__c';
        lstDocument = Database.query(query); 

        query = ' SELECT ' + String.join( documentfieldNames, ',' ) + ' FROM Cloufi__UW_Document__c WHERE Cloufi__Type__c = \'Processing Statement\' AND Cloufi__Opportunity__c = '+'\''+oppId+'\' ORDER BY Cloufi__Type__c, Status__c';
        
        List<Cloufi__UW_Document__c> lstProcessingStmtDocument = new List<Cloufi__UW_Document__c>();
        lstProcessingStmtDocument = Database.query(query); 
        lstDocument.addAll(lstProcessingStmtDocument);
        return lstDocument;
    }
    
    @AuraEnabled
    public static Map<String,String> saveDocument(List<Cloufi__UW_Document__c> lstDocument){
        Map<String,String> msg = new Map<String,String>();
        String currentUserProfile = '';
        Id currentUserProileId = UserInfo.getProfileId();
        currentUserProfile = [SELECT Name FROM Profile WHERE Id=:currentUserProileId].Name;
        try{
            system.debug('lstDocument >>'+lstDocument);
            system.debug('lstDocument.size() >>'+lstDocument.size());
            List<Cloufi__UW_Document__c> updateDocuments = new List<Cloufi__UW_Document__c>();
            List<Cloufi__UW_Document__c> notUpdateDocuments = new List<Cloufi__UW_Document__c>();
            List<Cloufi__UW_Document__c> escError = new List<Cloufi__UW_Document__c>();
            List<Cloufi__UW_Document__c> escDLogicError = new List<Cloufi__UW_Document__c>();
            List<Cloufi__UW_Document__c> profileErrorDocuments = new List<Cloufi__UW_Document__c>();
            Cloufi__UW_Document__c oldDoc;
            Map<Id,Cloufi__UW_Document__c> mapOldDocuments = new Map<Id,Cloufi__UW_Document__c>();
            for(Cloufi__UW_Document__c objUWDoc:[SELECT id,Cloufi__URL__c,Status__c, Cloufi__Type__c,Comment__c FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c=:lstDocument[0].Cloufi__Opportunity__c  ORDER BY Cloufi__Type__c]){
                system.debug('objUWDoc >>'+objUWDoc);
                mapOldDocuments.put(objUWDoc.id,objUWDoc);
            }
            system.debug('mapOldDocuments >>'+mapOldDocuments);
            if(mapOldDocuments.size()>0){
                
                for(integer i=0;i<lstDocument.size();i++){
                    oldDoc = mapOldDocuments.get(lstDocument[i].id);
                    if(lstDocument[i].Status__c != 'Completed' && lstDocument[i].Status__c !='Cancelled'){
                        system.debug('Inside If =>'+lstDocument[i].Status__c);
                        updateDocuments.add(lstDocument[i]);
                    }else{
                        if(currentUserProfile != 'Cash Advance Sales Agent'){
                            if(lstDocument[i].Status__c!=null){
                                if(oldDoc.id == lstDocument[i].id && lstDocument[i].Status__c == 'Completed' && oldDoc.Status__c != 'Completed'){
                                    system.debug('lstDocument[i].Comment__c=>'+lstDocument[i].Comment__c);
                                    String commnetTrim1;
                                    if(lstDocument[i].Comment__c!=null){
                                        commnetTrim1 = lstDocument[i].Comment__c.trim();
                                    }else{
                                        commnetTrim1 = lstDocument[i].Comment__c;
                                    }
                                    
                                    //Decision Logic Stip 
                                    if(lstDocument[i].Stip_Name__c!='Decision Logic' && lstDocument[i].Stip_Name__c!='Online Bank Login information'){
                                        if(lstDocument[i].Cloufi__URL__c==null || lstDocument[i].Cloufi__URL__c==''){
                                            notUpdateDocuments.add(lstDocument[i]);
                                        }else{
                                            updateDocuments.add(lstDocument[i]);
                                        }
                                    }else{
                                        if(commnetTrim1 == '' || commnetTrim1 == null){
                                            escError.add(lstDocument[i]);
                                        }else{
                                            updateDocuments.add(lstDocument[i]);
                                        }
                                    }
                                    
                                    system.debug('escError=>'+escError);
                                }else if(lstDocument[i].Comment__c != oldDoc.Comment__c){
                                    //updateDocuments.add(lstDocument[i]);
                                    String commnetTrim = lstDocument[i].Comment__c.trim();
                                    //if(lstDocument[i].Comment__c=='' || lstDocument[i].Comment__c==null){
                                    if(commnetTrim=='' || commnetTrim==null){
                                        escDLogicError.add(lstDocument[i]);
                                    }else{
                                        updateDocuments.add(lstDocument[i]);
                                    }
                                }
                                
                                if(oldDoc.id == lstDocument[i].id && lstDocument[i].Status__c == 'Cancelled' && oldDoc.Status__c != 'Cancelled'){
                                    system.debug('Inside else Cancelled oldDoc.Status__c =>'+oldDoc.Status__c);
                                    system.debug('Inside else Cancelled lstDocument[i].Status__c =>'+lstDocument[i].Status__c);
                                    updateDocuments.add(lstDocument[i]);
                                }
                            }
                        }else{
                            if(oldDoc.id == lstDocument[i].id && ((lstDocument[i].Status__c == 'Completed' && oldDoc.Status__c != 'Completed') || (lstDocument[i].Status__c == 'Cancelled' && oldDoc.Status__c != 'Cancelled'))){
                                profileErrorDocuments.add(lstDocument[i]);
                            }
                        }
                    }
                }
                system.debug('updateDocuments after removal>>'+updateDocuments);
                if(!profileErrorDocuments.isEmpty()){
                    update updateDocuments;
                    msg.put('Warning','Documents can only be marked Completed or Cancelled by a Sales Support or Admin');
                }
                
                if(notUpdateDocuments.size()>0){
                    update updateDocuments;
                    msg.put('Warning','One or more documents do not contain any File and so, cannot be marked Completed.');
                }
                
                if(escError.size() > 0){
                    update updateDocuments;
                    for(integer i = 0 ;i < escError.size(); i++){
                        msg.put('Warning','Add appropriate comment to '+escError[i].Stip_Name__c+' - UW Document before marking it Complete.');
                    }
                    //msg.put('Warning','Add appropriate comment to Decision Logic - UW Document before marking it Complete.');
                }

                if(escDLogicError.size()>0){
                    update updateDocuments;
                    msg.put('Warning','Can not remove comment for Decision Logic - Completed UW Document.');
                }
                
                if(updateDocuments.size()>0 && notUpdateDocuments.size()==0 && profileErrorDocuments.size()==0 && escError.size()==0 && escDLogicError.size()==0){
                    system.debug('updateDocuments finally updating >>'+updateDocuments);
                    update updateDocuments;
                    msg.put('Success','Document Updated');
                }
                
                
            }
            
        }catch(exception ex){
            string strMessageToDisplay='';
            System.debug('Exception  Message '+ex.getMessage());
            System.debug('Exception '+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            //msg.put('Error',ex.getMessage().substringAfter(':'));
            strMessageToDisplay = ex.getMessage().substringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION,');  
            strMessageToDisplay = strMessageToDisplay.substring(0,strMessageToDisplay.length()-4);
            System.debug('strMessageToDisplay=>'+strMessageToDisplay);
            msg.put('Error',strMessageToDisplay);
        }
        return msg;
    }
    
    @AuraEnabled
    public static List <Cloufi__UW_Document__c> cancelDocument(List<Cloufi__UW_Document__c> lstDocument) {
        String oppId = lstDocument[0].Cloufi__Opportunity__c;
        DescribeSObjectResult describeResultOffer = Cloufi__UW_Document__c.getSObjectType().getDescribe();
        List<String> OfferfieldNames = new List<String>(describeResultOffer.fields.getMap().keySet());     
        String query = ' SELECT ' + String.join( OfferfieldNames, ',' ) + ' FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c = '+'\''+oppId+'\' ORDER BY Cloufi__Type__c';
        lstDocument = Database.query(query); 
        return lstDocument;
    }
    
    @AuraEnabled 
    public static user fetchUser(){
        // query current user information  
        User oUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
    
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        List < String > allOpts = new list < String > ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        system.debug('Picklist values----->'+values);
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getlabel());
        }
        //allOpts.sort();
        return allOpts;
    }
    
    // Aditya - Method to fetch Funder is available or not
    @AuraEnabled
    public static Boolean isFunderAvailable(Id oppId){
        Boolean funder = false;
        opportunity objOpp = [SELECT id,Cloufi__Funder__c FROM Opportunity WHERE id=:oppId];
        if(objOpp.Cloufi__Funder__c !=null){
            funder = true;
        }
        return funder;
    }
    
    // Aditya - Opportunity stage should be 'Contract Signed Partial' or 'Final UW' to send Documents from 'Send for Final UW'
    @AuraEnabled
    public static Boolean checkOppStage(Id oppId){
        Boolean showSendButton = false;
        opportunity objOpp = [SELECT id,stageName FROM Opportunity WHERE id=:oppId];
        if(objOpp.stageName == 'Contract Signed Partial' || objOpp.stageName == 'Final UW'){
            showSendButton = true;
        }
        return showSendButton;
    }

    // Aditya - Show Request Stip button if Status is Requested/Rejected/Pending with no docs/Stip name can't be 'ESC Reports'/Type can't be 'Processing Statement' and 'Control Sheet'
    @AuraEnabled
    public static Boolean requestStipVisibleCtrl(Id oppId){
        Boolean visible = false;
        Opportunity objOpp = [SELECT id,Owner.Email,Lead__c,Owner_1_Email__c,(SELECT id,Cloufi__URL__c,Stip_Name__c,Cloufi__Type__c  FROM Cloufi__Dropbox_Attachments__r WHERE (Status__c='Requested' OR Status__c='Rejected' OR (Status__c='Pending' AND Cloufi__URL__c=null)) AND Cloufi__Type__c!='Processing Statement' AND Cloufi__Type__c!='Control Sheet' AND Cloufi__Type__c!='Control Sheet Completed' AND Stip_Name__c!='ESC Reports' ORDER BY Stip_Name__c ASC) FROM Opportunity WHERE id=:oppid];
        if(objOpp.Cloufi__Dropbox_Attachments__r.size()>0){
            visible = true;
        }
        return visible;
    }
    
    // Aditya - All documents should be in 'Completed', 'Rejected' or 'Cancelled'
    @AuraEnabled
    public static Boolean allDocumentsCompleted(Id oppId){
        Boolean docsCompleted = true;
        Opportunity objOpportunity = [SELECT Id, Name, Cloufi__Funder__c FROM Opportunity WHERE Id =:oppId LIMIT 1];
        List<Cloufi__UW_Document__c> returnDocList = new List<Cloufi__UW_Document__c>();
        set<Id> lenderDocsIds = new set<Id>();
        for(UW_Document_Share__c objShare: [select Name,Account__c,Opportunity__c,UW_Documents__c from UW_Document_Share__c where Opportunity__c = : oppId AND Account__c =: objOpportunity.Cloufi__Funder__c ORDER BY UW_Documents__r.Stip_Name__c ASC]){
            lenderDocsIds.add(objShare.UW_Documents__c);
        }
        returnDocList = [select id,Stip_Name__c,Cloufi__URL__c,Cloufi__Opportunity__c from Cloufi__UW_Document__c where Id IN: lenderDocsIds AND Cloufi__Opportunity__c= : oppId AND Cloufi__Type__c!='Processing Statement' AND Status__c != 'Completed' AND Status__c != 'Rejected' AND Status__c != 'Cancelled'];
        if(returnDocList.size()>0){
            docsCompleted = false;
        }else{
            docsCompleted = true;
        }
       return docsCompleted;
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
        return showHide;
    }
    
    // Aditya - Send Missing Documents to Merchant
    @AuraEnabled
    public static Map<String,String> RequestStipAlertToMerchant(Id oppId){
        Map<String,String> msg = new Map<String,String>();
        try{
            Opportunity objOpp = [SELECT id,Owner.Email,Lead__c,Cloufi__Email_Address__c,(SELECT id,Cloufi__URL__c,Status__c, Stip_Name__c, Cloufi__Type__c FROM Cloufi__Dropbox_Attachments__r WHERE (Status__c='Requested' OR Status__c='Rejected' OR (Status__c='Pending' AND Cloufi__URL__c=null)) AND Cloufi__Type__c!='Control Sheet' AND Cloufi__Type__c!='Control Sheet Completed' AND Stip_Name__c!='ESC Reports') FROM Opportunity WHERE id=:oppId];
            
            if(objOpp.Cloufi__Dropbox_Attachments__r.size()>0){
                Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                List<String> emailIds = new List<String>();
                if(objOpp.Cloufi__Email_Address__c !=null){
                    emailIds.add(objOpp.Cloufi__Email_Address__c);
                }
                emailMsg.setToAddresses(emailIds);
                emailMsg.setTargetObjectId(UserInfo.getUserId());
                emailMsg.setWhatId(objOpp.id);   
                emailMsg.SaveAsActivity = false;  
                emailMsg.setTemplateId([select id from EmailTemplate where DeveloperName = 'Request_Missing_Stips'].id);
                emailMsg.setTreatTargetObjectAsRecipient(false);
                if(emailIds.size()>0){
                    List<Messaging.SendEmailResult> results =  Messaging.sendEmail(new Messaging.Email[] {emailMsg});
                    system.debug('results=>'+results);
                    if (results.get(0).isSuccess()) {
                        msg.put('Success','Missing Document mail has been sent to '+objOpp.Cloufi__Email_Address__c);
                    }
                }else{
                    msg.put('Warning','Merchant email id is blank.');
                }
            }else{
                msg.put('Warning','There are no Stips to request');
            }
        }catch(Exception ex){
            System.debug('Exception '+ex.getMessage());
            System.debug('Exception '+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            return null;            
        }
        return msg;
    }

    // Aditya - Send an email to sales support from Under Writting email to request stip
    @AuraEnabled
    public static Map<String,String> RequestStipAlertToSupport(Id oppId){
        Map<String,String> msg = new Map<String,String>();
        try{
            Opportunity objOpp = [SELECT id,Owner.Email,Lead__c,Cloufi__Email_Address__c,Owner.CompanyName,(SELECT id,Cloufi__URL__c,Status__c, Stip_Name__c FROM Cloufi__Dropbox_Attachments__r WHERE (Status__c='Requested' OR Status__c='Rejected' OR (Status__c='Pending' AND Cloufi__URL__c=null)) AND Stip_Name__c!='ESC Reports') FROM Opportunity WHERE id=:oppId];
            String supportCompanyName = objOpp.Owner.CompanyName+' '+'Sales Support';
            system.debug('supportCompanyName=>'+supportCompanyName);
            if(String.isBlank(objOpp.Owner.CompanyName) || String.isEmpty(objOpp.Owner.CompanyName)){
                msg.put('Warning','Please update Deal Owner Company name');
                return msg;
            }
            
            if(objOpp.Cloufi__Dropbox_Attachments__r.size()>0){
                Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                List<String> supportEmailIds = new List<String>();
                List<String> lenderEmailIds = new List<String>();
                
                OrgWideEmailAddress[] objOrgLender = [SELECT Id, Address,DisplayName FROM OrgWideEmailAddress WHERE DisplayName='Internal Lender'];
                //OrgWideEmailAddress objOrgSpport = [SELECT Id, Address,DisplayName FROM OrgWideEmailAddress WHERE DisplayName='Maple Sales Support'];
                OrgWideEmailAddress[] objOrgSpport = [SELECT Id, Address,DisplayName FROM OrgWideEmailAddress WHERE DisplayName=:supportCompanyName];
                system.debug('objOrgSpport=>'+objOrgSpport);
                if(objOrgSpport.size() > 0){
                    supportEmailIds.add(objOrgSpport.get(0).Address);
                }else{
                    string warMsg = 'Org Wide Email Address is not Created for Sales support, Please create Org email address with name '+supportCompanyName;
                    msg.put('Warning',warMsg);
                    return msg;
                }
                system.debug('objOrgLender=>'+objOrgLender);
                system.debug('objOrgSpport=>'+objOrgSpport);
                emailMsg.setToAddresses(supportEmailIds);
                if (objOrgLender.size() > 0 ) {
                    emailMsg.setOrgWideEmailAddressId(objOrgLender.get(0).Id);
                }
                emailMsg.setTargetObjectId(UserInfo.getUserId());
                emailMsg.setWhatId(objOpp.id); 
                emailMsg.SaveAsActivity = false;  
                emailMsg.setTemplateId([select id from EmailTemplate where DeveloperName = 'Request_Missing_Stips_From_UW'].id);
                emailMsg.setTreatTargetObjectAsRecipient(false);
                system.debug('emailMsg=>'+emailMsg);
                if(objOrgLender.size()>0 && objOrgSpport.size()>0){
                    List<Messaging.SendEmailResult> results =  Messaging.sendEmail(new Messaging.Email[] {emailMsg});
                    system.debug('results=>'+results);
                    if (results.get(0).isSuccess()) {
                        msg.put('Success','Missing Document mail has been sent');
                    }
                }else{
                    msg.put('Warning','Org Wide Email Address is not available.');
                }
            }else{
                msg.put('Warning','There are no Stips to request');
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
            Opportunity objOpp = [SELECT id,Owner.Sales_Support_Email__c,OwnerId,Lead__c, Owner.ManagerId, Owner.Manager.Email FROM Opportunity WHERE id=:oppId];
            EmailTemplate emailTemp = [select id from EmailTemplate where DeveloperName = 'Requested_Docs_uploaded'];
            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            List<String> ToEmailIds=new List<String>();
            if(objOpp.Owner.Sales_Support_Email__c!=null){
                ToEmailIds.add(objOpp.Owner.Sales_Support_Email__c);
            }
            //Copy Owner's Manager in all communications
            if(objOpp.Owner.ManagerId!=null){
                ToEmailIds.add(objOpp.Owner.Manager.Email);
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
            return message;
        }catch(Exception ex){
            System.debug('Exception '+ex.getMessage());
            System.debug('Exception '+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            return null;
        }
    }
    
    // Aditya - Send mail to Sales Agent
    @AuraEnabled
    public static Map<String,String> sendemailToOppOwner(Id oppId){
        Map<String,String> msg = new Map<String,String>();
        try{
            List<Cloufi__UW_Document__c> lstUw = [select id,Stip_Name__c,Cloufi__Type__c,Cloufi__URL__c,Cloufi__Opportunity__c,Status__c,Cloufi__Opportunity__r.Owner.Email,Cloufi__Opportunity__r.Owner_1_Email__c,Cloufi__Opportunity__r.Owner.Name, Cloufi__Opportunity__r.Owner.ManagerId, Cloufi__Opportunity__r.Owner.Manager.Email from Cloufi__UW_Document__c where Cloufi__Opportunity__c =: oppId AND Cloufi__Type__c!='Control Sheet' AND Cloufi__Type__c!='Control Sheet Completed' AND Stip_Name__c!='ESC Reports' AND (Status__c='Requested' OR Status__c='Rejected' OR (Status__c='Pending' AND Cloufi__URL__c=null))];
            
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
                List<Messaging.SendEmailResult> results =  Messaging.sendEmail(new Messaging.Email[] {emailMsg});
                if (results.get(0).isSuccess()) {
                    msg.put('Success','Email send successfully');
                }else{
                    msg.put('Warning','Something went wrong');
                }
            }else{
                msg.put('Warning','No Pending Stips to Send.');
            }
        }catch(Exception ex){
            System.debug('Exception '+ex.getMessage());
            System.debug('Exception '+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            return null;            
        }
        return msg;
    }
    
    // Aditya -  Get UW documents those are completed
    @AuraEnabled
    public static List<Cloufi__UW_Document__c> getUWDocumentList(Id oppId){
        system.debug('Inside getUWDocumentList');
        //return [select id,Stip_Name__c,Cloufi__URL__c,Cloufi__Opportunity__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c= : oppId AND Cloufi__URL__c!=null AND Stip_Name__c !='Signed Application' AND Stip_Name__c!='Contract' AND Stip_Name__c!='ESC Reports'];
        Opportunity objOpportunity = [SELECT Id, Name, Cloufi__Funder__c FROM Opportunity WHERE Id =:oppId LIMIT 1];
        List<Cloufi__UW_Document__c> returnDocList = new List<Cloufi__UW_Document__c>();
        if(objOpportunity.Cloufi__Funder__c !=null){
            set<Id> lenderDocsIds = new set<Id>();
            for(UW_Document_Share__c objShare: [select Name,Account__c,Opportunity__c,UW_Documents__c from UW_Document_Share__c where Opportunity__c = : oppId AND Account__c =: objOpportunity.Cloufi__Funder__c ORDER BY UW_Documents__r.Stip_Name__c ASC]){
                lenderDocsIds.add(objShare.UW_Documents__c);
            }
            returnDocList = [select id,Stip_Name__c,Cloufi__URL__c,Cloufi__Opportunity__c from Cloufi__UW_Document__c where Id IN: lenderDocsIds AND Cloufi__Opportunity__c= : oppId AND Cloufi__URL__c!=null AND Stip_Name__c !='Signed Application' AND Stip_Name__c!='Contract' AND Stip_Name__c!='ESC Reports'];// AND Cloufi__Type__c!='Control Sheet Completed'
        }
        return returnDocList;
    }

    // Aditya -  Get other UW documents
    @AuraEnabled
    public static List<Cloufi__UW_Document__c> getOtherUWDocumentList(Id oppId){
        system.debug('Inside Other getUWDocumentList');
        Opportunity objOpportunity = [SELECT Id, Name, Cloufi__Funder__c FROM Opportunity WHERE Id =:oppId LIMIT 1];
        List<Cloufi__UW_Document__c> returnDocList = new List<Cloufi__UW_Document__c>();
        if(objOpportunity.Cloufi__Funder__c !=null){
            set<Id> lenderDocsIds = new set<Id>();
            for(UW_Document_Share__c objShare: [select Name,Account__c,Opportunity__c,UW_Documents__c from UW_Document_Share__c where Opportunity__c = : oppId AND Account__c =: objOpportunity.Cloufi__Funder__c ORDER BY UW_Documents__r.Stip_Name__c ASC]){
                lenderDocsIds.add(objShare.UW_Documents__c);
            }
            returnDocList = [select id,Stip_Name__c,Cloufi__URL__c,Cloufi__Opportunity__c,Status__c from Cloufi__UW_Document__c where Id NOT IN: lenderDocsIds AND Cloufi__Opportunity__c= : oppId AND Cloufi__URL__c!=null AND Stip_Name__c !='Signed Application' AND Stip_Name__c!='Contract' AND Stip_Name__c!='ESC Reports' AND Cloufi__URL__c!=null];// AND Cloufi__Type__c!='Control Sheet Completed' AND Status__c='Completed'
        }
        return returnDocList;
    }



    // Aditya -  Get UW documents those are completed
    @AuraEnabled
    public static List<Cloufi__UW_Document__c> getSharedUWDocumentList(Id oppId,Id lenderId){
        system.debug('Inside getUWDocumentList');
        List<Cloufi__UW_Document__c> returnDocList = new List<Cloufi__UW_Document__c>();
        if(oppId !=null && lenderId !=null){
            set<Id> lenderDocsIds = new set<Id>();
            for(UW_Document_Share__c objShare: [select Name,Account__c,Opportunity__c,UW_Documents__c from UW_Document_Share__c where Opportunity__c = : oppId AND Account__c =: lenderId ORDER BY UW_Documents__r.Stip_Name__c ASC]){
                lenderDocsIds.add(objShare.UW_Documents__c);
            }
            returnDocList = [select id,Stip_Name__c,Cloufi__URL__c,Cloufi__Opportunity__c from Cloufi__UW_Document__c where Id IN: lenderDocsIds AND Cloufi__Opportunity__c= : oppId AND Stip_Name__c !='Signed Application' AND Stip_Name__c!='Contract'  AND Status__c='Completed' AND Cloufi__URL__c!=null ORDER BY Stip_Name__c ASC];//AND Stip_Name__c!='ESC Reports' AND Cloufi__Type__c!='Control Sheet Completed'
        }
        return returnDocList;
    }

    // Aditya -  Get other UW documents
    @AuraEnabled
    public static List<Cloufi__UW_Document__c> getUnsharedUWDocumentList(Id oppId,Id lenderId){
        system.debug('Inside Other getUWDocumentList');
        List<Cloufi__UW_Document__c> returnDocList = new List<Cloufi__UW_Document__c>();
        if(oppId !=null && lenderId !=null){
            set<Id> lenderDocsIds = new set<Id>();
            for(UW_Document_Share__c objShare: [select Name,Account__c,Opportunity__c,UW_Documents__c from UW_Document_Share__c where Opportunity__c = : oppId AND Account__c =: lenderId ORDER BY UW_Documents__r.Stip_Name__c ASC]){
                lenderDocsIds.add(objShare.UW_Documents__c);
            }
            returnDocList = [select id,Stip_Name__c,Cloufi__URL__c,Cloufi__Opportunity__c,Status__c from Cloufi__UW_Document__c where Id NOT IN: lenderDocsIds AND Cloufi__Opportunity__c= : oppId AND Stip_Name__c !='Signed Application' AND Stip_Name__c!='Contract' AND Stip_Name__c!='ESC Reports' AND Status__c='Completed' AND Cloufi__URL__c!=null ORDER BY Stip_Name__c ASC ];//AND Cloufi__Type__c!='Control Sheet Completed'
        }
        return returnDocList;
    }



    // Aditya - To check Submission coutry
    @AuraEnabled
    public static List<Cloufi__Submission__c> dealSubmissionList(Id oppId){
        Map<Id,Cloufi__Submission__c> mapSubmission = new Map<Id,Cloufi__Submission__c>();
        List<Cloufi__Submission__c> submissionList = [SELECT Id, Name,Cloufi__Lender__c,Cloufi__Lender__r.Name FROM Cloufi__Submission__c Where Cloufi__Opportunity__c =: oppId];
        for(Cloufi__Submission__c objSub: submissionList){
            mapSubmission.put(objSub.Cloufi__Lender__c,objSub);
        }
        system.debug('mapSubmission=>'+mapSubmission);
        return mapSubmission.values();
    }

    // Aditya - Send mail to Lender
    @AuraEnabled
    public static Map<String,String> createShareForLender(Id oppId,List<string> createShareStipIds,Id lenderId){
        Map<String,String> msg = new Map<String,String>();
        try{
            Opportunity objOpp = [SELECT id,stageName,Cloufi__Funder__c,Cloufi__Funder__r.Name FROM Opportunity WHERE id=:oppId];
            List<UW_Document_Share__c> lenderUWShare = new List<UW_Document_Share__c>();
            for(Id objUWId:createShareStipIds){
                UW_Document_Share__c objShare = new UW_Document_Share__c();
                objShare.Account__c = lenderId;//objOpp.Cloufi__Funder__c;
                objShare.Opportunity__c = oppId;
                objShare.UW_Documents__c = objUWId;
                lenderUWShare.add(objShare);
            }
            if(lenderUWShare.size()>0){
                insert lenderUWShare;
                msg.put('Success','Document has been shared');
            }else{
                msg.put('Warning','No stip has been selected.');
            }
        }catch(Exception ex){
            System.debug('Exception '+ex.getMessage());
            System.debug('Exception '+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            return null;
        }
        return msg;
    }
    
     // Aditya - Send mail to Lender
    @AuraEnabled
    public static Map<String,String> sendEmailToLender(List<string> stipIds,Id oppId,String inputNote,List<string> otherStipIds){
        Map<String,String> msg = new Map<String,String>();
        String formatUWDoc = '';
        try{
            if(stipIds.size()==0 && otherStipIds.size()==0){
                msg.put('Warning','Please select atleast one Document');
            }else{
                List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
                List<Cloufi__UW_Document__c> lstUw = [select id,Sent_to_Lender__c,Stip_Name__c,Cloufi__URL__c,Cloufi__Opportunity__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c =: oppId AND Status__c ='Completed'];
                
                Opportunity objOpp = [SELECT id,stageName,Cloufi__Funder__c,(SELECT id,Cloufi__Offer_Status__c,Cloufi__Funder__c FROM Cloufi__Offers__r WHERE Cloufi__Offer_Status__c='Chosen') FROM Opportunity WHERE id=:oppId];
                

                // Update the Send to Lender field on UW Document those are selected
                if(objOpp.Cloufi__Offers__r.size()>0 && lstUw.size()>0){
                    //Create Share Docs for Lender
                    if(otherStipIds.size()>0){
                        stipIds.addAll(otherStipIds);
                        List<UW_Document_Share__c> lenderUWShare = new List<UW_Document_Share__c>();
                        for(Id objUWId:otherStipIds){
                            UW_Document_Share__c objShare = new UW_Document_Share__c();
                            objShare.Account__c = objOpp.Cloufi__Funder__c;
                            objShare.Opportunity__c = oppId;
                            objShare.UW_Documents__c = objUWId;
                            lenderUWShare.add(objShare);
                        }
                        if(lenderUWShare.size()>0){
                            insert lenderUWShare;
                        }
                    }

                    List<Cloufi__UW_Document__c> lstToUpdateUw = new List<Cloufi__UW_Document__c>();
                    List<String> uwDocList = new List<String>();
                    for(Cloufi__UW_Document__c objUW:lstUw){
                        if(stipIds.contains(String.valueOf(objUW.Id))){
                            objUW.Sent_to_Lender__c = true;
                            lstToUpdateUw.add(objUW);
                        }else{
                            objUW.Sent_to_Lender__c = false;
                            lstToUpdateUw.add(objUW);
                        }
                    }
                    system.debug('lstUw >>'+lstUw);
                    system.debug('lstToUpdateUw >>'+lstToUpdateUw);
                    
                    if(lstToUpdateUw.size()>0){
                        update lstToUpdateUw;
                        List<EmailTemplate> emailTemp = [select id from EmailTemplate where DeveloperName = 'Send_for_Final_UW'];
                        Account objAcc = [SELECt id,(SELECT id,Email,Submission__c FROM Contacts WHERE Submission__c=true) FROM Account WHERE id=:objOpp.Cloufi__Offers__r[0].Cloufi__Funder__c];
                        system.debug('objAcc=>'+objAcc);
                        
                        //Instance of Email to be sent
                        string body = '';
                        Messaging.SingleEmailMessage mesg = Messaging.renderStoredEmailTemplate(emailTemp[0].Id,userInfo.getUserId(),oppId);
                        system.debug('mesg=>'+mesg);
                        body = mesg.HtmlBody;
                        if(!String.isBlank(inputNote)){
                            String note = '<b>Note: </b>'+inputNote+'<br/><br/>';
                            body = body.replace('InputNoteBySalesSupport',note);
                        }else{
                            body = body.replace('InputNoteBySalesSupport','');
                        }
                        
                        if(!lstToUpdateUw.isEmpty()){
                            for(Cloufi__UW_Document__c uwDoc : lstToUpdateUw){
                                if(stipIds.contains(String.valueOf(uwDoc.Id))){
                                    uwDocList.add(uwDoc.Stip_Name__c);
                                    formatUWDoc+= '<li>'+uwDoc.Stip_Name__c+'</li>';
                                }
                            }
                            
                            body = body.replace('StipulationList',''+formatUWDoc);
                        }
                        
                        List<Cloufi__LendingXL_Settings__c> sett= [select Cloufi__Value__c from Cloufi__LendingXL_Settings__c where Name = 'Site_URL' AND Cloufi__Value__c !=null LIMIT 1];
                        String Site_URL = sett[0].Cloufi__Value__c;
                        if(oppid != null){
                            body = body.replace('MerchantStipPageLink',Site_URL+'MerchantStips?Id='+oppid);
                        }
                        
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
                        emailMsg.setSubject(mesg.Subject);
                        emailMsg.setWhatId(oppId);
                        emailMsg.setHtmlBody(body);
                        emailMsg.setPlainTextBody(mesg.PlainTextBody);
                        //emailMsg.setSaveAsActivity(true);
                        if(ToEmailIds.size()>0){
                            List<Messaging.SendEmailResult> results =  Messaging.sendEmail(new Messaging.Email[] {emailMsg});
                            if (results.get(0).isSuccess()) {
                                msg.put('Success','Email send successfully.');
                                objOpp.stageName = 'Final UW';
                                update objOpp;
                            }
                        }else{
                            msg.put('Warning','Lender not available');
                        }
                    }
                }else{
                    msg.put('Warning','Offer is not chosen for this Opportunity');
                }
            }
        }catch(Exception ex){
            System.debug('Exception '+ex.getMessage());
            System.debug('Exception '+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            return null;
        }
        return msg;
    }
    
    // Get Lenders
     @AuraEnabled
    Public static Map<id, List<Account>> getReqLenders(Id oppId){ 
        Map<id,List<Account>> lenderNameMap = new Map<id,List<Account>>();
        List<id> docIds = new List<id>();
        Map<Id,Account> mapIdAccount = new Map<Id,Account>();
        Opportunity objOpp=[SELECT id,(SELECT id,Name FROM Cloufi__Dropbox_Attachments__r) FROM Opportunity WHERE id=:oppId];
        for(Cloufi__UW_Document__c objUW:objOpp.Cloufi__Dropbox_Attachments__r){
            docIds.add(objUW.id);
        }
        for(Account objAcc:[SELECT id,Name FROM Account]){
            mapIdAccount.put(objAcc.id,objAcc);
        }
        if(docIds.size()>0){
            for(UW_Document_Share__c objShare:[SELECT id,account__c,Account__r.name,UW_Documents__c FROM UW_Document_Share__c WHERE UW_Documents__c in:docIds]){
                if(!lenderNameMap.containsKey(objShare.UW_Documents__c)){
                    lenderNameMap.put(objShare.UW_Documents__c,new List<Account>());
                }
                lenderNameMap.get(objShare.UW_Documents__c).add(mapIdAccount.get(objShare.account__c));
            }
        }
        return lenderNameMap;
    }

    /*public class documentWrapper{
        @auraEnabled
        public Id docId{get;set;}
        
        @auraEnabled
        public List<String> docName{get;set;}

         @auraEnabled
        public List<Cloufi__UW_Document__c> docList{get;set;}
        
        public documentWrapper(String docId, List<String> docName,List<Cloufi__UW_Document__c> docList){
            this.docId = docId;
            this.docName = docName;
            this.docList = docList;
        }
    }

    @AuraEnabled
    Public static List<documentWrapper> getDocumentWrapper(Id oppId){ 
        List<documentWrapper> lenderNameMap = new List<documentWrapper>();
        List<id> docIds = new List<id>();
        Map<Id,Account> mapIdAccount = new Map<Id,Account>();
        Opportunity objOpp=[SELECT id,(SELECT id,Name FROM Cloufi__Dropbox_Attachments__r) FROM Opportunity WHERE id=:oppId];
        for(Cloufi__UW_Document__c objUW:objOpp.Cloufi__Dropbox_Attachments__r){
            docIds.add(objUW.id);
        }
        for(Account objAcc:[SELECT id,Name FROM Account]){
            mapIdAccount.put(objAcc.id,objAcc);
        }
        if(docIds.size()>0){
            for(UW_Document_Share__c objShare:[SELECT id,account__c,Account__r.name,UW_Documents__c FROM UW_Document_Share__c WHERE UW_Documents__c in:docIds]){
                lenderNameMap.add(new documentWrapper(objShare.UW_Documents__c, objShare.Account__r.name,mapIdAccount.get(objShare.account__c)));
            }
        }
        system.debug('lenderNameMap==>>'+lenderNameMap);
        return lenderNameMap;
    }*/

    @AuraEnabled
    Public static Map<id,List<String>> getReqLendersName(Id oppId){ 
        Map<id,List<String>> lenderNameMap = new Map<id,List<String>>();
        List<id> docIds = new List<id>();
        Opportunity objOpp=[SELECT id,(SELECT id,Name FROM Cloufi__Dropbox_Attachments__r) FROM Opportunity WHERE id=:oppId];
        for(Cloufi__UW_Document__c objUW:objOpp.Cloufi__Dropbox_Attachments__r){
            docIds.add(objUW.id);
        }
        if(docIds.size()>0){
            for(UW_Document_Share__c objShare:[SELECT id,account__c,Account__r.name,UW_Documents__c FROM UW_Document_Share__c WHERE UW_Documents__c in:docIds]){
                if(!lenderNameMap.containsKey(objShare.UW_Documents__c))
                    lenderNameMap.put(objShare.UW_Documents__c,new List<String>());
                lenderNameMap.get(objShare.UW_Documents__c).add(objShare.Account__r.name);
            }
        }
        system.debug('lenderNameMap==>>'+lenderNameMap);
        return lenderNameMap;
    }

    @AuraEnabled
    public static List<Cloufi__UW_Document__c> deleteUWDocument(String uwId){
        System.debug('uwId=>'+uwId);
        System.debug('In controller deleteUWDocument method..');
        List<Cloufi__UW_Document__c> lstDocument = new List<Cloufi__UW_Document__c>();
        Cloufi__UW_Document__c delUW=[Select Id,Cloufi__Opportunity__c from Cloufi__UW_Document__c where id=:uwId];
        Id oppId = delUW.Cloufi__Opportunity__c;
        delete delUW;
        /*DescribeSObjectResult describeResultDocument = Cloufi__UW_Document__c.getSObjectType().getDescribe();
        List<String> documentfieldNames = new List<String>(describeResultDocument.fields.getMap().keySet());
        String query = ' SELECT ' + String.join( documentfieldNames, ',' ) + ' FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c = '+'\''+oppId+'\' ORDER BY Cloufi__Type__c, Status__c';
        lstDocument = Database.query(query); 
        return lstDocument;*/
        return fetchDocument(oppId);
    }

     @AuraEnabled
    public static string getUWNameCtrl(String uwId){
        return [Select id,Stip_Name__c FROM Cloufi__UW_Document__c Where id=:uwId].Stip_Name__c;
    }

    /*@AuraEnabled
    Public static lenderWrapper getReqLenders(Id oppId){ 
        lenderWrapper lenderWrapperR = new  lenderWrapper ();  
        List<id> docIds = new List<id>();
        Opportunity objOpp=[SELECT id,(SELECT id,Name FROM Cloufi__Dropbox_Attachments__r) FROM Opportunity WHERE id=:oppId];
        for(Cloufi__UW_Document__c objUW:objOpp.Cloufi__Dropbox_Attachments__r){
            docIds.add(objUW.id);
        }
        if(docIds.size()>0){
            for(UW_Document_Share__c objShare:[SELECT id,account__c,Account__r.name,UW_Documents__c FROM UW_Document_Share__c WHERE UW_Documents__c in:docIds]){
                lenderWrapperR(objShare.UW_Documents__c,objShare.Account__r.name);
            }
        }
        system.debug('lenderNameMap==>>'+lenderNameMap);
        return lenderWrapperR;
    }
    
    public class lenderWrapper{
        @AuraEnabled public id uwId {get;set;}
        @AuraEnabled public List<string> lstLennders{get;set;}        
    }*/
  
   @AuraEnabled //- Download ALl
    public static String getAllUWDocuments(Id oppId){
        System.debug('oppId -> '+oppId);
        Opportunity objOpportunity = new Opportunity();
        if(oppId != null){
          objOpportunity = [SELECT ID,Name,Cloufi__Dropbox_Folder_Path__c FROM Opportunity WHERE ID =: oppID];  
        }
      return objOpportunity.Cloufi__Dropbox_Folder_Path__c;
    }
    @AuraEnabled
    public static Boolean checkUWURL(Id oppId){
        Boolean urlExist = false;
        Opportunity objOpp=[SELECT id,(SELECT id,Name,cloufi__URL__c FROM Cloufi__Dropbox_Attachments__r) FROM Opportunity WHERE id=:oppId];
        for(Cloufi__UW_Document__c objUW:objOpp.Cloufi__Dropbox_Attachments__r){
            if(objUW.cloufi__URL__c !=null){
                urlExist = true;
                break;
            }
        }
      return urlExist;
    }
    
    @AuraEnabled
    public static List<Opportunity> getUWDocuments(Id oppId){
        system.debug('Inside getUWDocuments');
        return [SELECT ID,Name,Cloufi__Dropbox_Folder_Path__c FROM Opportunity WHERE ID =: oppID];
    }
    
    @AuraEnabled
    public static Cloufi__Dropbox_Settings__c getHiearchySettings(){
        return Cloufi__Dropbox_Settings__c.getInstance();
    }
}