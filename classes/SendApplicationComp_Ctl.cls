public class SendApplicationComp_Ctl {
    
    public String Site_URL { get; set; }
    
    public Id leadId {get;set;}
    public Id appid {get;set;}
    
    public string getLead(){
        //Map<string,Site_Url__c> MCASettings = Site_Url__c.getAll();
        List<Cloufi__LendingXL_Settings__c> sett= [select Cloufi__Value__c from Cloufi__LendingXL_Settings__c where Name = 'Site_URL' AND Cloufi__Value__c !=null LIMIT 1];
        Site_URL = sett[0].Cloufi__Value__c;
        return Site_URL+'CompleteApplicationForm?Id='+appid;
    }
}