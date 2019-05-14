global with sharing class DevUtil {
    global static List<Cloufi__UW_Document__c> fetchDocument(Id oppId) {
        List<Cloufi__UW_Document__c> lstDocument = new List<Cloufi__UW_Document__c>();
        system.debug('oppId'+oppId);
        DescribeSObjectResult describeResultDocument = Cloufi__UW_Document__c.getSObjectType().getDescribe();
        List<String> documentfieldNames = new List<String>(describeResultDocument.fields.getMap().keySet());
        
        String query = ' SELECT ' + String.join( documentfieldNames, ',' ) + ' FROM Cloufi__UW_Document__c WHERE Cloufi__Type__c != \'Processing Statement\' AND (NOT Stip_Name__c LIKE \'ESC Reports%\') AND (NOT Stip_Name__c LIKE \'Control Sheet%\') AND Cloufi__Opportunity__c = '+'\''+oppId+'\' AND Status__c = \'Completed\' ORDER BY Cloufi__Type__c, Status__c';
        lstDocument = Database.query(query); 

        query = ' SELECT ' + String.join( documentfieldNames, ',' ) + ' FROM Cloufi__UW_Document__c WHERE Cloufi__Type__c = \'Processing Statement\' AND Cloufi__Opportunity__c = '+'\''+oppId+'\' AND Status__c = \'Completed\' ORDER BY Cloufi__Type__c, Status__c';
        
        List<Cloufi__UW_Document__c> lstProcessingStmtDocument = new List<Cloufi__UW_Document__c>();
        lstProcessingStmtDocument = Database.query(query); 
        lstDocument.addAll(lstProcessingStmtDocument);
        return lstDocument;
    }	

    public static List<String> getFieldsOfsObject(String sObjectName){
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sObjType = gd.get(sObjectName);
        Schema.DescribeSObjectResult describeResult = sObjType.getDescribe();
        List<String> fields;
        if(sObjectName.toLowerCase() == 'opportunity'){
            Set<String> fieldNameSet = new Set<String>();
            fieldNameSet = describeResult.fields.getMap().keySet();
            if(fieldNameSet.contains('iqscore')){
                fieldNameSet.remove('iqscore');
            }            
            if(fieldNameSet.contains('cloufi__total_syndication_percentage__c')){
                fieldNameSet.remove('cloufi__total_syndication_percentage__c');
            }  
            if(fieldNameSet.contains('cloufi__iso__c')){
                fieldNameSet.remove('cloufi__iso__c');
            }
            /*if(fieldNameSet.contains('holdback_per__c')){
                fieldNameSet.remove('holdback_per__c');
            }
            if(fieldNameSet.contains('percentage_of_gross__c')){
                fieldNameSet.remove('percentage_of_gross__c');
            }*/
            fields = new List<String>(fieldNameSet); 
            return fields;         
        }else if(sObjectName.toLowerCase() == 'cloufi__payments__c'){
            Set<String> fieldNameSet = new Set<String>();
            fieldNameSet = describeResult.fields.getMap().keySet();
            if(fieldNameSet.contains('lastvieweddate')){
                fieldNameSet.remove('lastvieweddate');
            }            
            if(fieldNameSet.contains('lastreferenceddate')){
                fieldNameSet.remove('lastreferenceddate');
            }  
            if(fieldNameSet.contains('merchant_id__c')){
                fieldNameSet.remove('merchant_id__c');
            }
            fields = new List<String>(fieldNameSet); 
            return fields;         
        }else{
            fields = new List<String>(describeResult.fields.getMap().keySet());
            return fields;
        }
    }

    public static Integer getWorkingDays(Date fundingDate){
        Integer days = 0, workingDays = 0;
        days = fundingDate.daysBetween(Date.today());
        for(Integer i=0; i<days; i++){
            String dayOfWeek = getDayOfWeek(fundingDate);
            if(dayOfWeek != 'saturday' && dayOfWeek != 'sunday'){
                workingDays += 1;
            }
            fundingDate = fundingDate.addDays(1);
        }
        return workingDays+1;
    } 

    public static String getDayOfWeek(Date d){
        Date tempDate = Date.newInstance(d.year(),d.month(),d.day());
        Datetime dt = DateTime.newInstance(tempDate, Time.newInstance(0, 0, 0, 0));
        String dayOfWeek = dt.format('EEEE');
        return dayOfWeek.toLowerCase();
    }   
}