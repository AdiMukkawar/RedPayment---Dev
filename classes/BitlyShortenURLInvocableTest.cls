/*****************************************************************
 * Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
 * Class Name: BitlyShortenURLInvocableTest
 * Created Date: 01-14-2019
 * Description: Test Class for BitlyShortenURLInvocable
 *******************************************************************/
@isTest
public class BitlyShortenURLInvocableTest {

    
    public static testMethod void test_shorten() {
        
        Test.startTest();        
        // Set Mock Class
        Test.setMock( HttpCalloutMock.class, new BitlyHttpCalloutMock() );
        List<ID> appIds = new List<Id>();     
        
        // Insert Application Record to generate Short URL
        Cloufi__Application__c objApp = new Cloufi__Application__c (Cloufi__Business_DBA_Name__c='TestCompany',Legal_Corporate_Name__c='TestCompany');
        insert objApp;
        appIds.add(objApp.Id);
        BitlyShortenURLInvocable.shortenAsync(appIds);
        
        Test.stopTest(); 
        
    }
}