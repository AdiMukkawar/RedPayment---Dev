/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: OpportunityDocumentsController
* Created Date: 18-September-2018
* Description: Controller to Upload Opportunity documents
*******************************************************************/
public class OpportunityDocumentsController{
    public id opportunityId{get;set;}
    public Opportunity objOpportunity{get;set;}        
    public List<StipAttachment> listStipAttachment{get;set;}
    public List<Cloufi__UW_Document__c> lstStips{get;set;}
    public Boolean extraDocs{get;set;}
    public Boolean bankStmtDocs{get;set;}
    
    public OpportunityDocumentsController(ApexPages.StandardController controller) {
        opportunityId = ApexPages.currentPage().getParameters().get('id');        
        listStipAttachment = new List<StipAttachment>();
        lstStips = new List<Cloufi__UW_Document__c>();
        extraDocs = false;
        bankStmtDocs = false;
        if(opportunityId != null){
            init();                               
        }
    }
    
    public void init(){
        
        List<Opportunity> OpportunityList = [SELECT id,Name,Owner.Email,Sales_Support_Email__c FROM Opportunity WHERE id =:opportunityId];
        //Get the documents list
        lstStips = [select id,stip_Name__c,Cloufi__Opportunity__c,Name,Cloufi__Display_Size__c,Cloufi__View__c,Cloufi__Type__c,Cloufi__URL__c, Comment__c, Status__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c=:opportunityId AND Stip_Name__c!='ESC Reports' AND Cloufi__Type__c!='Control Sheet' AND Cloufi__Type__c!='Control Sheet Completed' AND Cloufi__Type__c != 'Processing Statement' AND stip_Name__c!='Signed Application' Order By Status__c ASC];
        if(OpportunityList.size()>0){
            objOpportunity = OpportunityList[0];
        }
        system.debug('lstStips=>'+lstStips);
        for(Cloufi__UW_Document__c uw: lstStips){
            listStipAttachment.add(new StipAttachment(uw));
            if(uw.Stip_Name__c != null && uw.Cloufi__Type__c !='Bank Statement'){//&& !uw.Stip_Name__c.tolowercase().contains('processing statement') 
                extraDocs = true;
                system.debug('Inside If=>'+extraDocs );
            }
            if(uw.Stip_Name__c != null && uw.Cloufi__Type__c =='Bank Statement' && (uw.Status__c == 'Requested' || uw.Status__c == 'Rejected')){//&& uw.Stip_Name__c.tolowercase().contains('bank statement')
                bankStmtDocs = true;
            }
        }
        system.debug('listStipAttachment >>'+listStipAttachment);
    }
    
    //Upload documents
    public PageReference uploadDocuments(){
        Pattern nonWordChar = Pattern.compile('[^\\w]');
        String extension;
        String documentName;
        List <Cloufi__UW_Document__c> updateUWList = new List <Cloufi__UW_Document__c>();
        try{
            system.debug('listStipAttachment >>'+listStipAttachment);
            List<Attachment> listAttachment = new List<Attachment>();
            List<String> docNameList = new List<String>();
            for(StipAttachment s : listStipAttachment){
                if(s.fileNameStr!=null){
                    documentName = s.fileNameStr.replaceAll( '\\s+', '');
                    docNameList = documentName.split('\\.');
                    if(docNameList.size() > 0){
                        extension = docNameList[docNameList.size()-1];
                    }
                    
                    if(s.attachmentBlob != null){
                        Attachment objAttachment = new Attachment();
                        
                        if(documentName.length()>70){
                            docNameList = documentName.split('\\.');
                            if(docNameList.size() > 0){
                                extension = docNameList[docNameList.size()-1];
                                if(docNameList[0].length()>=70){
                                    documentName = nonWordChar.matcher(s.stip.Stip_Name__c).replaceAll('_');
                                    documentName = documentName.subString(0,69)+'.'+extension;
                                    system.debug('Inside if documentName>>'+documentName);
                                    
                                }else{
                                    documentName = nonWordChar.matcher(s.stip.Stip_Name__c).replaceAll('_');
                                    documentName = documentName+'.'+extension;
                                    system.debug('Inside else documentName>>'+documentName);
                                }
                            }
                            objAttachment.Name = documentName;
                        }else{
                            documentName = nonWordChar.matcher(s.stip.Stip_Name__c).replaceAll('_');
                            documentName = documentName+'.'+extension;
                            
                            system.debug('Inside else parent documentName>>'+documentName);
                            objAttachment.Name = documentName;
                        }
                        system.debug('objAttachment.Name>>'+objAttachment.Name);
                        objAttachment.Body = s.attachmentBlob;
                        objAttachment.ParentId = s.stip.Id;                   
                        listAttachment.add(objAttachment);
                    }
                }
                if(s.stip.Stip_Name__c =='Online Bank Login information' && s.stip.Comment__c!=null){
                    updateUWList.add(s.stip);
                }
            }
            system.debug('updateUWList >>'+updateUWList);
            if(!updateUWList.isEmpty()){
                update updateUWList;
            }
            System.debug('listAttachment ->'+listAttachment+' size ->'+listAttachment.size());
            
            /*
            Map<String, Cloufi__UW_Document__c> mapDocs = new Map<String,Cloufi__UW_Document__c>();
            for(StipAttachment s: listStipAttachment){
                s.stip.Cloufi__Opportunity__c = objOpportunity.Id;
                if(s.attachment.Name !=null){
                    s.stip.Name = s.attachment.Name;
                    mapDocs.put(s.stip.stip_Name__c,s.stip);
                }
                
            }
            if(mapDocs.size()>0){
                upsert mapDocs.values();
            }
            //Add attachments
            for(StipAttachment s: listStipAttachment){
                if(mapDocs.containsKey(s.stip.stip_Name__c)){
                    s.attachment.parentId = mapDocs.get(s.stip.stip_Name__c).Id;
                    if(s.attachment.Body != null && s.attachment.Name != null){
                        listAttachment.add(s.attachment);
                    }
                }
            }*/            
            
            if(listAttachment.size()>0){
                upsert listAttachment;
                system.debug('listAttachment after upsert>>'+listAttachment);
                List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                List<String> emailIds = new List<String>();
                if(objOpportunity.Owner.Email != null){
                    emailIds.add(objOpportunity.Owner.Email);
                }
                if(objOpportunity.Sales_Support_Email__c != null){
                    emailIds.add(objOpportunity.Sales_Support_Email__c);
                }
                //Email Message
                string sub = 'New documents uploaded by merchant for '+objOpportunity.Name;
                emailMsg.setToAddresses(emailIds);
                emailMsg.setsubject(sub);
                String mailBody = '';
                String baseURL = System.Label.Base_URL;
                mailBody += 'Hello,<br/><br/>';
                mailBody += 'Documents are uploaded by '+objOpportunity.Name+',<br/><br/>';
                mailBody += 'Opportunity: <b><a style="color:#999999;" target="_blank" href = "'+baseURL+'/'+objOpportunity.Id+'">'+objOpportunity.Name+'</a></b><br/><br/>';
                mailBody += 'Best Regrads,';
                emailMsg.sethtmlBody(mailBody);
                if(objOpportunity.Id != null){
                    emailMsg.setWhatId(objOpportunity.Id);
                }
                
                emailMsg.SaveAsActivity = False;            
                lstEmailMsg.add(emailMsg);
                if(lstEmailMsg.size()>0){
                    Messaging.sendEmail(lstEmailMsg);
                }
            }

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Documents Uploaded Successfully.'));
            //return null;
            PageReference cmpPage = new PageReference('/apex/ApplicationThankYou');
            cmpPage.setRedirect(true);
            return cmpPage;
        }catch(Exception ex){
            System.debug('Exception>> '+ex.getMessage());
            System.debug('Exception >>'+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            return null;
        }
        
    }
    
    public class StipAttachment{
        public Cloufi__UW_Document__c stip{get;set;}
        public Blob attachmentBlob{get;set;}
        public String fileNameStr{get;set;}

        public StipAttachment(Cloufi__UW_Document__c s){
            stip=s;
        }
    }
   
}