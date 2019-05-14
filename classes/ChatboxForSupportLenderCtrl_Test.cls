@isTest
public class ChatboxForSupportLenderCtrl_Test 
{
    @isTest
    public static void testChatboxForSupportLenderCtrl_Test()
    {
        // Insert opportunity
        Opportunity objOpp = new Opportunity(); 
        objOpp.Name = 'Test Opp';
        objOpp.ForecastCategoryName = 'Pipeline';
        objOpp.CloseDate = System.today();
        objOpp.StageName = 'Qualified';
        insert objOpp;
        
        ChatboxForSupportLenderCtrl.showLabelCtrl(objOpp.Id);
        
        // Insert User
        Profile objProfile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User objUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = objProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='redpaymenttestuser632@gmail.com');

        System.runAs(objUser) {
            // The following code runs as user 'objUser' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        }
        ChatboxForSupportLenderCtrl.fetchUser();
        // Set Input msg value
        String inputmsg = 'Test input message';
        ChatboxForSupportLenderCtrl.SendMessageCtrl(objOpp.Id, inputmsg);
        ChatboxForSupportLenderCtrl.taskListCtrl(objOpp.Id);
    }
}