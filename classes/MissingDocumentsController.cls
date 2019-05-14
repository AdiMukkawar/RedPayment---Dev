/*
-------------------------------------------------------------------------------------------
Author           | Project       |Date           | Description
-------------------------------------------------------------------------------------------
Aditya           | Red Payment   | 08/13/2018    | Controller for Upload documents
-------------------------------------------------------------------------------------------
*/
public class MissingDocumentsController{
    public id applicationId{get;set;}
    public Cloufi__Application__c objApplication{get;set;}        
    public List<StipAttachment> listStipAttachment{get;set;}
    public List<Cloufi__UW_Document__c> lstStips{get;set;}
    public List<UW_Documents_Settings__c> lstCustomSet{get;set;}
    
    public MissingDocumentsController(ApexPages.StandardController controller) {
        applicationId = ApexPages.currentPage().getParameters().get('id');        
        listStipAttachment = new List<StipAttachment>();
        lstStips = new List<Cloufi__UW_Document__c>();
        lstCustomSet = new List<UW_Documents_Settings__c>();
        if(applicationId != null){
            init();                               
        }
    }
    
    public void init(){
        
        List<Cloufi__Application__c> ApplicationList = new List<Cloufi__Application__c>();
        DescribeSobjectResult decribeResult= Cloufi__Application__c.getSobjectType().getDescribe();
        List<String> fieldNames=new List<String>(decribeResult.fields.getMap().KeySet());
        String Query = 'SELECT ' + String.join( fieldNames, ',' );
        Query+=' FROM '+decribeResult.getName()+' WHERE Id='+'\''+applicationId+'\'' ;
        ApplicationList = Database.query(Query);
        
        //Get the documents list
        lstStips = [select id,stip_Name__c,Cloufi__Application__c,Name,Cloufi__Display_Size__c,Cloufi__View__c,Cloufi__Type__c,Cloufi__URL__c from Cloufi__UW_Document__c where Cloufi__Application__c=:applicationId  Order By Cloufi__URL__c ASC];
        
        if(ApplicationList.size()>0){
            objApplication = ApplicationList[0];
        }
        for(Cloufi__UW_Document__c uw: lstStips){
            listStipAttachment.add(new StipAttachment(uw,new Attachment()));
        }
        lstCustomSet = [select Name,Stage__c,Type__c from UW_Documents_Settings__c where Type__c = 'Document' AND Stage__c= 'Application']; 
    }
    
    //Upload documents
    public PageReference uploadDocuments(){    
        Map<String, Cloufi__UW_Document__c> mapDocs = new Map<String,Cloufi__UW_Document__c>();
        List<Attachment> listAttachment = new List<Attachment>();     
        for(StipAttachment s: listStipAttachment){
            s.stip.Cloufi__Application__c = objApplication.Id;
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
        }            
        System.debug('listAttachment ->'+listAttachment.size()); 
        if(listAttachment.size()>0){
            upsert listAttachment;
        }  
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Documents Uploaded Successfully.'));
        //return null;
        PageReference cmpPage = new PageReference('/apex/ApplicationThankYou');
        cmpPage.setRedirect(true);
        return cmpPage;
       
    }
    
    public class StipAttachment{
        public Cloufi__UW_Document__c stip{get;set;}
        public Attachment attachment{get;set;}
        
        public StipAttachment(Cloufi__UW_Document__c s,Attachment att){
            stip=s;
            attachment=att;
        }
    }
   
   
}