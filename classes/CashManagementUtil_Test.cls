@isTest
public class CashManagementUtil_Test 
{
    @isTest
    public static void testMethod1()
    {
        // Insert Bank Holiday
        Cloufi__Bank_Holiday__c objBank = new Cloufi__Bank_Holiday__c();
        objBank.Name = 'Test';
        objBank.Cloufi__Holiday_Date__c = Date.newInstance(2020, 01, 01);
        objBank.Cloufi__Payment_Processor__c = 'ACH.com';
        insert objBank;
        //Profile objProfile =[SELECT Id FROM Profile WHERE Name='Sales Support'];
        CloufiServicing__Payment_Processor_Settings__c objSetting = new CloufiServicing__Payment_Processor_Settings__c(Name='ACH.Com',
                                                                                                                      CloufiServicing__Payment_Method__c = 'Test method');
        insert objSetting;
        CashManagementUtil.getFieldsOfsObject('opportunity');
        CashManagementUtil.getHolidayMap();
        CashManagementUtil.getHolidayMapForAllDays();
        //CashManagementUtil.fetchPaymentMethodFromPaymentProcessor('Process');
        CashManagementUtil.generateRandomString(10);
        Set<String> objStr = new Set<String>{'Test', 'Test1'};
        Map<Date, Set<String>> objMap = new Map<Date, Set<String>>{Date.newInstance(2000,10,10)=>objStr};
        CashManagementUtil.getNextBusinessDate('Processing', objMap);
        CashManagementUtil.getSecondNextBusinessDate('paymentProcessor', objMap);
        CashManagementUtil.getNextSettlementDate('String paymentProcessor', objMap);
        CashManagementUtil.getNextWeekBusinessDate('payment', objMap, 'saturday');
        CashManagementUtil.getNextSettlementDateForSyndicationPayments('Test', objMap);
        CashManagementUtil.getNextBusinessDate('String paymentProcessor', objMap);
        CashManagementUtil.getNextMonthBusinessDate('String paymentProcessor', objMap);
        CashManagementUtil.getNextWeekBusinessDate('paymentProcessor', objMap, 'Tuesday');
        CashManagementUtil.getHolidayForDate(Date.newInstance(2000,10,10), 'paymentProcessor', objMap);
        CashManagementUtil.getDayOfWeek(Date.newInstance(2000,10,10));
        CashManagementUtil.getNextWeekBusinessDate('Test Payment', objMap);
        CashManagementUtil.getNextMonthBusinessDate('String paymentProcessor', objMap, 2.5);
    }
    @isTest
    public static void testMethod2()
    {
        CashManagementUtil.getFieldsOfsObject('cloufi__payments__c');
        CashManagementUtil.getHolidayMap();
        CashManagementUtil.getHolidayMapForAllDays();
        //CashManagementUtil.fetchPaymentMethodFromPaymentProcessor('Process');
        CashManagementUtil.generateRandomString(10);
        Set<String> objStr = new Set<String>{'Test', 'Test1'};
        Map<Date, Set<String>> objMap = new Map<Date, Set<String>>{Date.newInstance(2000,10,10)=>objStr};
        CashManagementUtil.getNextBusinessDate('Processing', objMap);
        CashManagementUtil.getSecondNextBusinessDate('paymentProcessor', objMap);
        CashManagementUtil.getNextSettlementDate('String paymentProcessor', objMap);
        CashManagementUtil.getNextWeekBusinessDate('Test', objMap, 'Monday');
        CashManagementUtil.getNextSettlementDateForSyndicationPayments('TD Bank', objMap);
        CashManagementUtil.getNextBusinessDate('String paymentProcessor', objMap);
        CashManagementUtil.getNextMonthBusinessDate('String paymentProcessor', objMap);
        CashManagementUtil.getNextWeekBusinessDate('paymentProcessor', objMap, 'Tuesday');
        CashManagementUtil.getHolidayForDate(Date.newInstance(2000,10,10), 'Test', objMap);
        CashManagementUtil.getDayOfWeek(Date.newInstance(2000,10,10));
        CashManagementUtil.getNextWeekBusinessDate('Test Payment', objMap);
        CashManagementUtil.getNextMonthBusinessDate('String paymentProcessor', objMap, 2.5);
    }
}