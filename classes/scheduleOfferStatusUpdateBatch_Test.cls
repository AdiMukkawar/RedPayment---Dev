/*Author | Date       | Description
Neha     | 08/22/2018 | Test class for scheduleOfferStatusUpdateBatch
*/

@isTest
public class scheduleOfferStatusUpdateBatch_Test {    
        @istest        
        public static void  testschedule() {            
            Test.StartTest();
            scheduleOfferStatusUpdateBatch objSchedule = new scheduleOfferStatusUpdateBatch();      
            String sch = '0 0 23 * * ?';
            system.schedule('Test check', sch, objSchedule);
            Test.stopTest();            
        }
}