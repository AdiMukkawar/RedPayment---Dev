public without sharing class ApplicationDocumentController{
    public Cloufi__Application__c objApplication{get;set;}
    public List<StipAttachment> listStipAttachment{get;set;}
    public boolean isProcessingStatement{get;set;}

    public ApplicationDocumentController(){
        objApplication = new Cloufi__Application__c();
        listStipAttachment = new List<StipAttachment>();
        isProcessingStatement = false;
        System.debug('Envelope Id ->'+ApexPages.currentPage().getParameters().get('envelopeId'));
        if(ApexPages.currentPage().getParameters().get('envelopeId') != null){
            List<dsfs__DocuSign_Status__c> docusignStatusList = new List<dsfs__DocuSign_Status__c>();
            docusignStatusList = [SELECT Id, dsfs__Opportunity__c FROM dsfs__DocuSign_Status__c WHERE dsfs__DocuSign_Envelope_ID__c =: ApexPages.currentPage().getParameters().get('envelopeId')];
            system.debug('docusignStatusList=>'+docusignStatusList);
            if(docusignStatusList.size()>0){
                String oppId = docusignStatusList[0].dsfs__Opportunity__c;
                Opportunity objOpp = [SELECT Id, (SELECT Id, Name, Stip_Name__c, Cloufi__URL__c,Cloufi__Type__c  FROM Cloufi__Dropbox_Attachments__r WHERE Cloufi__Type__c = 'Bank Statement' OR Cloufi__Type__c = 'Processing Statement') FROM Opportunity WHERE Id =: oppId];
                System.debug('objOpp.Cloufi__Dropbox_Attachments__r ->'+objOpp.Cloufi__Dropbox_Attachments__r);
                if(objOpp.Cloufi__Dropbox_Attachments__r.size()>0){
                    for(Cloufi__UW_Document__c objUWDocument : objOpp.Cloufi__Dropbox_Attachments__r){
                        listStipAttachment.add(new StipAttachment(objUWDocument));
                        System.debug('objUWDocument.Cloufi__Type__c -> '+objUWDocument.Cloufi__Type__c);
                        if(objUWDocument.Cloufi__Type__c == 'Processing Statement'){
                            isProcessingStatement = true;
                        }
                    }               
                }
            }
        }else{
            Opportunity objOpp = [SELECT Id, (SELECT Id, Name, Stip_Name__c, Cloufi__URL__c,Cloufi__Type__c  FROM Cloufi__Dropbox_Attachments__r WHERE Cloufi__Type__c = 'Bank Statement' OR Cloufi__Type__c = 'Processing Statement') FROM Opportunity WHERE Id =: ApexPages.currentPage().getParameters().get('opportunityId')];
            if(objOpp.Cloufi__Dropbox_Attachments__r.size()>0){
                for(Cloufi__UW_Document__c objUWDocument : objOpp.Cloufi__Dropbox_Attachments__r){
                    listStipAttachment.add(new StipAttachment(objUWDocument));
                    if(objUWDocument.Cloufi__Type__c == 'Processing Statement'){
                        isProcessingStatement = true;
                    }
                }               
            }            
        } 
        
        System.debug('listStipAttachment -> '+listStipAttachment);
    }

    public PageReference uploadDocuments(){
        try{            
            List<Attachment> listAttachment = new List<Attachment>();     
            //Add attachments
            system.debug('listStipAttachment >>'+listStipAttachment);
            for(StipAttachment s : listStipAttachment){
                system.debug('s >>'+s);
                if(s.attachmentBlob != null){
                    Attachment objAttachment = new Attachment();
                    system.debug('s.fileNameStr=>'+s.fileNameStr);
                    String documentName = s.fileNameStr.replaceAll( '\\s+', '');
                    system.debug('documentName=>'+documentName);
                    if(documentName.length()>70){
                        List<String> docNameList = documentName.split('\\.');
                        if(docNameList.size() > 0){
                            String extension = docNameList[docNameList.size()-1];
                            if(docNameList[0].length()>=70){
                                documentName = docNameList[0].subString(0,69)+'.'+extension;
                            }else{
                                documentName = docNameList[0]+'.'+extension;
                            }
                        }
                        objAttachment.Name = documentName;
                    }else{
                        objAttachment.Name = documentName;
                    }
                    system.debug('documentName >>'+documentName);
                    objAttachment.Body = s.attachmentBlob;
                    objAttachment.ParentId = s.stip.Id;                   
                    listAttachment.add(objAttachment);
                }
            }            
            System.debug('listAttachment ->'+listAttachment+' size ->'+listAttachment.size());
            if(listAttachment.size()>0){
                upsert listAttachment;
            }
            PageReference cmpPage = new PageReference('/apex/ApplicationThankYou');
            cmpPage.setRedirect(true);
            return cmpPage;
        }catch(Exception e){
            System.debug('Msg '+e.getMessage());
            System.debug('Msg '+e.getStackTraceString());
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