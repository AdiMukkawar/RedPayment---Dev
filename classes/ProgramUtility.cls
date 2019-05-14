/**
Author  | Date | Description
Sneha   | 12/6/2017 | Utility Class for Program matching funcitonality
Sneha   | 12/7/2017 | Add Matching functionality for Application
**/
public class ProgramUtility {
    public Sobject objRecord;
    Set<String> setProgramFieldApi;
    Set<String> setLoanFieldApi;
    Set<String> setApplicationFieldApi;
    List<Cloufi__Program_Matching_Criteria__c> listProgramCriteria;
    String sobjectName;

    public ProgramUtility(List<Cloufi__Program_Matching_Criteria__c> listCriteria){
        listProgramCriteria = listCriteria;

        //get all program field api mentioned in program matching criteria
        //use set to avoid duplication
        setProgramFieldApi = new Set<String>();
        setLoanFieldApi = new Set<String>();
        setApplicationFieldApi = new Set<String>();
        for(Cloufi__Program_Matching_Criteria__c criteria: listProgramCriteria){
            setProgramFieldApi.add(criteria.Cloufi__Program_Field__c.trim().toLowerCase());

            if(criteria.Cloufi__Opportunity__c!=null){//Schema.sObjectType.Cloufi__Program_Matching_Criteria__c.isAccessible() && Schema.sObjectType.Cloufi__Program_Matching_Criteria__c.fields.Cloufi__Opportunity__c.isAccessible() && 
                setLoanFieldApi.add(criteria.Cloufi__Opportunity__c.trim().toLowerCase());
            }
            if(criteria.Cloufi__Application_Field__c!=null){//Schema.sObjectType.Cloufi__Program_Matching_Criteria__c.isAccessible() && Schema.sObjectType.Cloufi__Program_Matching_Criteria__c.fields.Cloufi__Application_Field__c.isAccessible() && 
                setApplicationFieldApi.add(criteria.Cloufi__Application_Field__c.trim().toLowerCase());
            }

        }     
    }

    //Method to query the opportunity with required fields
    public Opportunity getOpportunity(Id loanId){
        sobjectName = 'Opportunity';
        Opportunity opp = new Opportunity();
        
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType obj = schemaMap.get('Opportunity');
        
        if(Schema.sObjectType.Opportunity.isAccessible())
        {
            //Query only those opportunity fields which are mentioned in criteria
            String queryOpp = 'select StageName,Business_Start_Date__c,Do_you_Process_Credit_card__c,';
            for(String loanapi: setLoanFieldApi){
                
                SObjectField currentField = obj.getDescribe().fields.getMap().get(loanapi);
                /*if(currentField.getDescribe().isAccessible())
                {*/
                    queryOpp+=loanapi+',';
               // }
            }
            queryOpp+= '(select name,Cloufi__URL__c,Cloufi__Type__c,Stip_Name__c, Status__c from Cloufi__Dropbox_Attachments__r where (Stip_Name__c LIKE \'%Bank Statement%\' OR Stip_Name__c=\'Signed Application\' OR Stip_Name__c LIKE \'%Processing Statement%\') AND Cloufi__URL__c != null)';
            queryOpp = queryOpp.removeEnd(',');
            queryOpp+=' from Opportunity where Id=\''+loanId+'\' limit 1';
                        
            if(setLoanFieldApi.size()>0){
                objRecord = Database.query(queryOpp);
                opp = (Opportunity)objRecord;
            }
        }
        return opp;
    }

    //Method to query the application with required fields
    /*public Cloufi__Application__c getApplication(Id appId){
        sobjectName = 'Cloufi__Application__c';
        
        Cloufi__Application__c app= new Cloufi__Application__c();
    
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType obj = schemaMap.get('Cloufi__Application__c');
        
        if(Schema.sObjectType.Cloufi__Application__c.isAccessible())
        {
            //Query only those opportunity fields which are mentioned in criteria
            String queryOpp = 'select ';
            for(String loanapi: setApplicationFieldApi){
                
                SObjectField currentField = obj.getDescribe().fields.getMap().get(loanapi);
                if(currentField.getDescribe().isAccessible())
                {
                    queryOpp+=loanapi+',';
                }    
            }

            queryOpp = queryOpp.removeEnd(',');
            queryOpp+=' from Cloufi__Application__c where Id=\''+appId+'\' limit 1';
    
            if(setApplicationFieldApi.size()>0){
                objRecord = Database.query(queryOpp);
                app = (Cloufi__Application__c)objRecord;
            }  
        }    
                  
        return app;
    }*/

    public List<ProgramCustom> getPrograms(Id loanId){
        List<Cloufi__Product__c> listProgram = new List<Cloufi__Product__c>();
        List<ProgramCustom> listProgramCustom = new List<ProgramCustom>();
        Opportunity loan = new Opportunity();
        loan = [select name,CloufiServicing__Submission_Country__c from Opportunity where id=: loanId]; //(select name,Cloufi__URL__c from Cloufi__Dropbox_Attachments__r where Name IN ('Bank Statements','Signed Application') AND Cloufi__URL__c != null)
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType obj = schemaMap.get('Cloufi__Product__c');
        
        String queryProgram = 'select ';
        
        if(Schema.sObjectType.Cloufi__Product__c.isAccessible())
        {
            //Query only those Program fields which are mentioned in criteria
            for(String loanapi: setProgramFieldApi){
                SObjectField currentField = obj.getDescribe().fields.getMap().get(loanapi);
                if(currentField.getDescribe().isAccessible())
                {
                    queryProgram+=loanapi+',';
                }
            }
            //Add Account and Name field
            if(!setProgramFieldApi.contains('Cloufi__Account__c') && Schema.sObjectType.Cloufi__Product__c.fields.Cloufi__Account__c.isAccessible()){
                queryProgram+='Cloufi__Account__c,';
            }
            if(!setProgramFieldApi.contains('name') && Schema.sObjectType.Cloufi__Product__c.fields.name.isAccessible()){
                queryProgram+='name,';
            }
            //account name
            if(!setProgramFieldApi.contains('Cloufi__Account__r.name') && Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.name.isAccessible()){
                queryProgram+='Cloufi__Account__r.name,';
            }

            if(!setProgramFieldApi.contains('Cloufi__Account__r.Country__c')){
                queryProgram+='Cloufi__Account__r.Country__c,';
            }

            queryProgram = queryProgram.removeEnd(',');
            queryProgram+=' from Cloufi__Product__c where Cloufi__Account__c != null and Cloufi__Account__r.Country__c =\''+loan.CloufiServicing__Submission_Country__c+'\' AND Cloufi__Account__r.recordtype.DeveloperName IN (\'Lender\') order by Cloufi__Account__r.name';
            
            listProgram = Database.query(queryProgram);
        }
            
        //Get Program Account Contact email address
        Set<Id> setAccountId = new Set<Id>();
        if(Schema.sObjectType.Cloufi__Product__c.isAccessible() && Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Cloufi__Product__c.fields.Cloufi__Account__c.isAccessible())
        {
            for(Cloufi__Product__c program: listProgram){ 
                setAccountId.add(program.Cloufi__Account__c);
            }
        }
        
        //Map<Id,Contact> mapAccountEmail = new Map<Id,Contact>();
        Map<Id,List<Contact>> mapAccountEmail = new Map<Id,List<Contact>>();
        if(Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Contact.fields.email.isAccessible())
        {
            for(Account objAccount: [select id,(select id,email from Contacts where Submission__c = true AND email != null) /* remove limit*/ from Account where id in:setAccountId]){
                if(objAccount.Contacts.size()>0){                   
                    mapAccountEmail.put(objAccount.Id,objAccount.Contacts);
                    //add list of contacts in value
                }
            }
        }
        //Get Field describe for opportunity fields mentioned in program criteria
        List<Schema.DescribeSObjectResult> describeSobjectsResult = Schema.describeSObjects(new List<String>{sobjectName}); 
        Map<String, Schema.SObjectField> allOppFields = describeSobjectsResult[0].fields.getMap();

        //Find matching programs using criteria
        for(Cloufi__Product__c program: listProgram){
            Map<String,Boolean> mapCriteriaMatch = new Map<String,Boolean>();

            //for each criteria check if it satisfies
            for(Cloufi__Program_Matching_Criteria__c criteria: listProgramCriteria){
                String fieldApi;
                if(sobjectName=='Opportunity'){
                    fieldApi = criteria.Cloufi__Opportunity__c.trim().toLowerCase();
                }
                else if(sobjectName=='Cloufi__Application__c'){//Schema.sObjectType.Cloufi__Program_Matching_Criteria__c.isAccessible() && Schema.sObjectType.Cloufi__Program_Matching_Criteria__c.fields.Cloufi__Application_Field__c.isAccessible() && 
                    fieldApi = criteria.Cloufi__Application_Field__c.trim().toLowerCase();
                }
                String programApi = criteria.Cloufi__Program_Field__c.trim().toLowerCase();

                //Check if the type of Opportunity field is Boolean
                if(allOppFields.get(fieldApi).getDescribe().getType() == Schema.DisplayType.BOOLEAN){
                    //Get objRecord and program field boolean value 
                                       
                    Boolean loanFieldValue = (Boolean)objRecord.get(fieldApi);
                    Boolean programFieldValue = (Boolean)program.get(programApi);
                    if(criteria.Cloufi__Criteria__c=='equals to' && loanFieldValue==programFieldValue){//Schema.sObjectType.Cloufi__Program_Matching_Criteria__c.isAccessible() && Schema.sObjectType.Cloufi__Program_Matching_Criteria__c.fields.Cloufi__Criteria__c.isAccessible() && 
                        mapCriteriaMatch.put(programApi,true);
                    }
                }

                //Check if the type of Opportunity field is Picklist
                else if(allOppFields.get(fieldApi).getDescribe().getType() == Schema.DisplayType.PICKLIST 
                    || allOppFields.get(fieldApi).getDescribe().getType() == Schema.DisplayType.STRING){
                    
                    //Get objRecord and program field boolean value 
                    String loanFieldValue = (String)objRecord.get(fieldApi);
                    String programFieldValue = (String)program.get(programApi);
                    if(loanFieldValue!=null){
                        loanFieldValue = loanFieldValue.trim().toLowerCase();
                    }
                    if(programFieldValue!=null){
                        programFieldValue = programFieldValue.trim().toLowerCase();
                    }
                    if(loanFieldValue!=null && programFieldValue!=null && programFieldValue.contains(loanFieldValue)){
                        mapCriteriaMatch.put(programApi,true);
                    }
                }
                //If not boolean then assume it will be numeric
                else{
                    //Get objRecord and program field value - assuming it will be numeric
                    Double loanFieldValue = (Double)objRecord.get(fieldApi);
                    Double programFieldValue = (Double)program.get(programApi);
					System.debug('loanFieldValue-->>'+loanFieldValue);
                    System.debug('loan field-->>'+objRecord.get(fieldApi));
                    if(criteria.Cloufi__Criteria__c=='greater than' && loanFieldValue>programFieldValue){//Schema.sObjectType.Cloufi__Program_Matching_Criteria__c.isAccessible() && Schema.sObjectType.Cloufi__Program_Matching_Criteria__c.fields.Cloufi__Criteria__c.isAccessible() && 
                        mapCriteriaMatch.put(programApi,true);
                    }
                    if(criteria.Cloufi__Criteria__c=='less than' && loanFieldValue<programFieldValue){
                        mapCriteriaMatch.put(programApi,true);
                    }
                    if(criteria.Cloufi__Criteria__c=='equals to' && loanFieldValue==programFieldValue){
                        mapCriteriaMatch.put(programApi,true);
                    }
                }

                if(!mapCriteriaMatch.keyset().contains(programApi)){
                    mapCriteriaMatch.put(programApi,false);
                }
            }  
            
            List<String> emailSet = new List<String>();
            Set<Id> conId = new Set<Id>();
            
            if(mapAccountEmail.containsKey(program.Cloufi__Account__c) && mapAccountEmail.get(program.Cloufi__Account__c).size()>0){ //&& it contains contacts 
                
                for(contact objContact : mapAccountEmail.get(program.Cloufi__Account__c)){
                    if(objContact.Email != null)
                    emailSet.add(objContact.Email);
                    conId.add(objContact.Id);
                }
                
                listProgramCustom.add(new ProgramCustom(program,mapCriteriaMatch,emailSet,conId,objRecord.Id));
                //listProgramCustom.add(new ProgramCustom(program,mapCriteriaMatch,emailSet.addAll(mapAccountEmail.get(program.Cloufi__Account__c).Email),conId.addAll(mapAccountEmail.get(program.Cloufi__Account__c).Id),objRecord.Id));
            }
            /*else{
                listProgramCustom.add(new ProgramCustom(program,mapCriteriaMatch,null,null,objRecord.Id));
            }*/
            
        }

        //Sort the list by percent
        listProgramCustom.sort();

        return listProgramCustom;
    }

    //Wrapper class to save matching programs for respective loan
    public class ProgramCustom implements Comparable{
        public Cloufi__Product__c program{get;set;}
        public Integer percent{get;set;}
        public Map<String,Boolean> mapCriteriaMatch{get;set;}
        
        //Variables used for InviteLenders Page
        public boolean isSelected{get;set;}
         public boolean showFunder{get;set;}
        //public String contactEmail{get;set;}
        public List<String> contactEmail{get;set;}
        public Cloufi__Submission__c submission{get;set;}
        public Set<Id> contactId{get;set;}
        //public Id contactId{get;set;}

        //Constructor for InviteLendersCtrl Page
        public ProgramCustom(Cloufi__Product__c prod,Map<String,Boolean> mapMatch,List<String> cemail,Set<Id> cid,Id loanId){
            /*if(Schema.sObjectType.Cloufi__Submission__c.isCreateable() && Schema.sObjectType.Cloufi__Submission__c.fields.Cloufi__Opportunity__c.isCreateable()
                && Schema.sObjectType.Cloufi__Submission__c.fields.Cloufi__Lender__c.isCreateable() && Schema.sObjectType.Cloufi__Submission__c.fields.Cloufi__Program__c.isCreateable())
            {*/
                submission = new Cloufi__Submission__c();
                submission.Cloufi__Opportunity__c=loanId;
                submission.Cloufi__Lender__c = prod.Cloufi__Account__c;
                submission.Cloufi__Program__c = prod.Id;              
                contactEmail = cemail;
                contactId = cid;
                isSelected=false;
                program =prod;
                percent = 0;
                mapCriteriaMatch = mapMatch;
                showFunder=false;
            //}
            //Get the count to criterias satisfied
            Integer isTrue =0;
            for(string key: mapCriteriaMatch.keyset()){
                if(mapCriteriaMatch.get(key)){
                    isTrue +=1; 
                }
            }

            //Calculate the criteria satisfied %
            percent = (100*isTrue)/mapCriteriaMatch.size();
        }

        //Constructor for LoanProgramsCtrl Page
        public ProgramCustom(Cloufi__Product__c prod,Map<String,Boolean> mapMatch){
            program =prod;
            percent = 0;
            mapCriteriaMatch = mapMatch;
            Integer isTrue =0;
            for(string key: mapCriteriaMatch.keyset()){
                if(mapCriteriaMatch.get(key)){
                    isTrue +=1; 
                }
            }

            //Calculate the criteria satisfied %
            percent = (100*isTrue)/mapCriteriaMatch.size();
        }

        public Integer compareTo(Object ObjToCompare) {
            return Integer.valueOf(((ProgramCustom)objToCompare).percent- percent);

        }
    } 

}