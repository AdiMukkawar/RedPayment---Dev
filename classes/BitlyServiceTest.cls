/*****************************************************************
 * Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
 * Class Name: BitlyServiceTest
 * Created Date: 01-14-2019
 * Description: Test Class for BitleyService
 *******************************************************************/
@isTest
public class BitlyServiceTest {
    
   public static testMethod void test_shorten() {
        
       	Test.startTest();
       	// Set mock class
        Test.setMock( HttpCalloutMock.class, new BitlyHttpCalloutMock() );
        BitlyService service = new BitlyService();
        String shortURL = service.shorten( URL.getSalesforceBaseUrl().toExternalForm() ) ;
        Test.stopTest();
    }
}