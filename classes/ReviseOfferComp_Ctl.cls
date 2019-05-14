public class ReviseOfferComp_Ctl{
    
    public String Site_URL { get; set; }
    public Id offrId {get;set;}
    
    public string getOfferR(){
        List<Cloufi__LendingXL_Settings__c> sett= [select Cloufi__Value__c from Cloufi__LendingXL_Settings__c where Name = 'Site_URL' AND Cloufi__Value__c !=null LIMIT 1];
        Site_URL = sett[0].Cloufi__Value__c;
        return Site_URL+'ReviseOffer?Id='+offrId;
    }

}