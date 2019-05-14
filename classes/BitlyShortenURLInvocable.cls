/*****************************************************************
 * Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
 * Class Name: BitlyShortenURLInvocable
 * Created Date: 01-14-2019
 * Description: Invocable class used in process builder to create short url's

 *******************************************************************/
public class BitlyShortenURLInvocable {
    
    @InvocableMethod(
        label = 'shorten'
        description = 'Given Application IDs then generates a bitly short url for them'
    )
    public static List<String> shorten(List<ID> appIds) {
        if(!test.isRunningTest()){
            shortenAsync( appIds );
        }
    	return new List<String>();
    }
    
    @Future( callout = true )
    public static void shortenAsync( List<ID> appIds ) {
        // Fetch your data and a field where you want to store the generated short url
        List<Cloufi__Application__c> apps = new List<Cloufi__Application__c>([ SELECT id, Short_URL__c FROM Cloufi__Application__c WHERE id IN :appIds ]);
        // Service to actually call out to bitly and get a shortened url
    	BitlyService service = new BitlyService();        
        for ( Cloufi__Application__c ObjApp : apps ) {
            // we're just creating short urls to the record itself with added site url
            system.debug('{!$Label.Site_URL}=>'+Label.Site_URL);
            //ObjApp.Short_URL__c = service.shorten('https://dev-merchantservices.cs23.force.com/CompleteApplicationForm?id='+ObjApp.id);
            ObjApp.Short_URL__c = service.shorten( Label.Site_URL+'/CompleteApplicationForm?id=' + ObjApp.id );
        }
        
        // update the records with their short urls
        if (apps.size() > 0) {
            update apps;
        }
        
    }
}