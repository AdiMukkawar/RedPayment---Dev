global with sharing class AcceptLenderLink
{
    
    public String Site_URL { get; set; }
    
    public Id synId {get;set;}
    public Id AccountID {get;set;}
    public id oId {get;set;}
    public id sId {get;set;}
    
    public string getSyndicators() 
    {        
        Map<string,Cloufi__LendingXL_Settings__c> LendingXLSettings = Cloufi__LendingXL_Settings__c.getAll();
        Site_URL = LendingXLSettings.get('Site_URL')!=null?LendingXLSettings.get('Site_URL').Cloufi__value__c:'';
        return Site_URL+'PriceCalculatorFunder?Id='+synId+'&accId='+AccountID+'&submissionId='+sId;
    }
    
}