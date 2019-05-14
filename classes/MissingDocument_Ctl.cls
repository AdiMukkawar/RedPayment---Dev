public class MissingDocument_Ctl{
    
    public String Site_URL { get; set; }
    public Id appid {get;set;}
    
    public string getLead(){
        List<Cloufi__LendingXL_Settings__c> sett= [select Cloufi__Value__c from Cloufi__LendingXL_Settings__c where Name = 'Site_URL' AND Cloufi__Value__c !=null LIMIT 1];
        Site_URL = sett[0].Cloufi__Value__c;
        return Site_URL+'MissingDocuments?Id='+appid;
    }
    
    public List<String> getMissingDocs(){
        if(appid != null){
            List<String> lstUW = new List<String>();
            cloufi__Application__c objApp = [SELECT id,Missing_Documents_Types__c FROM cloufi__Application__c WHERE id=:appid LIMIT 1];
            lstUW = objApp.Missing_Documents_Types__c.split(',');
            return lstUW;
        }
        return null;
    }
}