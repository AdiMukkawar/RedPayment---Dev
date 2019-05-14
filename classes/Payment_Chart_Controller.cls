/*****************************************************************
* Author: Techila Global Services Pvt Ltd. 
* Class Name: Payment_Chart_Controller
* Created Date: 26 - 02 - 2019
* Description: Controller to Fetch payment records
*******************************************************************/
/*Author            | Date       | Description
Sheema Dhanraj      | 27-Feb-2019| Filter Payment records
**/
public class Payment_Chart_Controller 
{
    // Method to fetch payment records related to opportunity
    @AuraEnabled
    public static List<Cloufi__Payments__c> getPaymentRecords(Id oppId)
    {
        List<Cloufi__Payments__c> payments = new List<Cloufi__Payments__c>();
        String q = 'SELECT ' + String.join(DevUtil.getFieldsOfsObject('Cloufi__Payments__c'),',');
        q += ' FROM Cloufi__Payments__c WHERE Cloufi__Opportunity__r.Id = \''+ oppId +'\'';
        system.debug('Database.Query(q)-->'+Database.Query(q));
        if(Database.Query(q).size() > 0)
        {
            return Database.Query(q);
        }
        return null;
    }
    
    // Method to fetch syndication records
    @AuraEnabled
    public static List < CloufiServicing__Syndication__c > getSyndication(Id oppId)
    {
        List<CloufiServicing__Syndication__c> syndicationList = [Select Name,CloufiServicing__Syndicating_Account__r.Name
                                                                 from CloufiServicing__Syndication__c 
                                                                 where CloufiServicing__Opportunity__r.Id =: oppId];
        system.debug('syndicationList--->'+syndicationList);
        if(syndicationList.size() > 0)
        {
            return syndicationList;
        }
        return null;
    }
    
    // Method to fetch picklist values
    @AuraEnabled
    public static List < String > getPicklistValues(string fld) {
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Cloufi__Payments__c.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        allOpts.sort();
        return allOpts;
    }
    
    // Method to fetch filtered payment records
    @AuraEnabled
    public static List<Cloufi__Payments__c> getFilteredRecords(Id oppId, String syndication, String PaymentType, Boolean PaymentRecordType1, 
                                                               Boolean PaymentRecordType2, String EffectiveDateFrom, String EffectiveDateTo,
                                                               String SettlementDateFrom, String SettlementDateTo, String PaymentStatus)
    {
        String q;
        if(oppId != null)
        {
            q = 'SELECT ' + String.join(DevUtil.getFieldsOfsObject('Cloufi__Payments__c'),',');
            q += ' FROM Cloufi__Payments__c WHERE Cloufi__Opportunity__r.Id = \''+ oppId +'\'';
        }
        if(PaymentRecordType1 == true && PaymentRecordType2 == true)
        {
            List<String> recordTypeList = new List<String>{'Payment In', 'Payment Out'};
            system.debug('recordTypeList--->'+recordTypeList);
            q +='  AND RecordType.Name IN: recordTypeList';
            system.debug('q--->'+q);
        }
        else if(PaymentRecordType1 == true)
        {
            String PaymentIn = 'Payment In';
            q +='  AND RecordType.Name =: PaymentIn';
        }
        else if(PaymentRecordType2 == true)
        {
            String PaymentOut = 'Payment Out';
            q +='  AND RecordType.Name =: PaymentOut';
        }
        
        if(syndication != null && syndication !='')
        {
            q +='  AND CloufiServicing__Syndication__r.Name=:syndication';
        }
        
        if(PaymentType != null && PaymentType !='')
        {
            q +='  AND Cloufi__Payment_Type__c=:PaymentType';
        }
        
        if(EffectiveDateFrom != null && EffectiveDateFrom != '')
        {
            Date effDate = date.valueof(EffectiveDateFrom);
            q +='  AND Cloufi__Effective_Date__c >=: effDate';
        }
        if(EffectiveDateTo != null && EffectiveDateTo != '')
        {
            Date effDateTo = date.valueof(EffectiveDateTo);
            q += '  AND Cloufi__Effective_Date__c <=: effDateTo';
        }
        if(SettlementDateFrom != null && SettlementDateFrom != '')
        {
            Date settDate = date.valueof(SettlementDateFrom);
            q += '  AND CloufiServicing__Expected_Settlement_Date__c >=: settDate';
        }
        if(SettlementDateTo != null && SettlementDateTo !='')
        {
            Date settDateTo = date.valueof(SettlementDateTo);
            q += '  AND CloufiServicing__Expected_Settlement_Date__c <=: settDateTo';
        }
        if(PaymentStatus != null && PaymentStatus !='')
        {
            q += '  AND Cloufi__Status__c=:PaymentStatus';
        }
        if(Database.Query(q).size() > 0)
        {
            return Database.Query(q);
        }
        return null;
    }
}