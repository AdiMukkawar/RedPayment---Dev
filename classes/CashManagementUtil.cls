/*********************************************************************************
* Author: Techila Global Services Pvt Ltd. (Gaurav Agrawal)
* Class Name: CashManagementUtil
* Created Date: 27-March-2018
* Description: Utility class for Cash Management
**********************************************************************************
* Updates
* Author            | Date          | Description
*                   |               | 
**********************************************************************************/

public class CashManagementUtil{

    //Method to get all the fields of sObject named passed 
    public static List<String> getFieldsOfsObject(String sObjectName){
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sObjType = gd.get(sObjectName);
        Schema.DescribeSObjectResult describeResult = sObjType.getDescribe();
        List<String> fields;
        System.debug('sObjectName -> '+sObjectName);
        
        if(sObjectName.toLowerCase() == 'opportunity'){
            Set<String> fieldNameSet = new Set<String>();
            fieldNameSet = describeResult.fields.getMap().keySet();
            if(fieldNameSet.contains('iqscore')){
                fieldNameSet.remove('iqscore');
            }            
            if(fieldNameSet.contains('cloufi__total_syndication_percentage__c')){
                fieldNameSet.remove('cloufi__total_syndication_percentage__c');
            }  
            if(fieldNameSet.contains('cloufi__iso__c')){
                fieldNameSet.remove('cloufi__iso__c');
            }
            fields = new List<String>(fieldNameSet); 
            
            System.debug('fields -> '+fields);
            
            return fields;         
        }else if(sObjectName.toLowerCase() == 'cloufi__payments__c'){
            Set<String> fieldNameSet = new Set<String>();
            fieldNameSet = describeResult.fields.getMap().keySet();
            if(fieldNameSet.contains('lastvieweddate')){
                fieldNameSet.remove('lastvieweddate');
            }            
            if(fieldNameSet.contains('lastreferenceddate')){
                fieldNameSet.remove('lastreferenceddate');
            }  
            if(fieldNameSet.contains('merchant_id__c')){
                fieldNameSet.remove('merchant_id__c');
            }
            fields = new List<String>(fieldNameSet);
            System.debug('fields -> '+fields);
            return fields;         
        }else{
            fields = new List<String>(describeResult.fields.getMap().keySet());
            System.debug('fields -> '+fields);
            return fields;
        }
    }

    //Method to get Holidays from yesterday to next two months
    public static Map<Date, Set<String>> getHolidayMap(){

        Map<Date, Set<String>> holidayMap = new Map<Date, Set<String>>();

        //Loop through the bank holidays between yesterday's date and a month ahead and populate map
        for(Cloufi__Bank_Holiday__c objBankHoliday : [SELECT Cloufi__Holiday_Date__c, Cloufi__Payment_Processor__c FROM Cloufi__Bank_Holiday__c WHERE Cloufi__Holiday_Date__c > :System.today().addDays(-1) AND Cloufi__Holiday_Date__c <: System.today().addMonths(2)]){
            Set<String> paymentProSet = new Set<String>();
            for(String paymentPro : objBankHoliday.Cloufi__Payment_Processor__c.split(';')){
                paymentProSet.add(paymentPro.trim());        
            }
            holidayMap.put(objBankHoliday.Cloufi__Holiday_Date__c, paymentProSet);
        }
        return holidayMap;
    }

    //Method to get Holidays from yesterday to next two months
    public static Map<Date, Set<String>> getHolidayMapForAllDays(){

        Map<Date, Set<String>> holidayMap = new Map<Date, Set<String>>();

        //Loop through the bank holidays between yesterday's date and a month ahead and populate map
        for(Cloufi__Bank_Holiday__c objBankHoliday : [SELECT Cloufi__Holiday_Date__c, Cloufi__Payment_Processor__c FROM Cloufi__Bank_Holiday__c WHERE Cloufi__Holiday_Date__c > :System.today().addDays(-1)]){
            Set<String> paymentProSet = new Set<String>();
            for(String paymentPro : objBankHoliday.Cloufi__Payment_Processor__c.split(';')){
                paymentProSet.add(paymentPro.trim());        
            }
            holidayMap.put(objBankHoliday.Cloufi__Holiday_Date__c, paymentProSet);
        }
        return holidayMap;
    }

    public static String fetchPaymentMethodFromPaymentProcessor(String paymentProcessor){
        CloufiServicing__Payment_Processor_Settings__c objPaymentProcessorSetting = CloufiServicing__Payment_Processor_Settings__c.getValues(paymentProcessor);
        if(objPaymentProcessorSetting != null && objPaymentProcessorSetting.CloufiServicing__Payment_Method__c != null){
            return objPaymentProcessorSetting.CloufiServicing__Payment_Method__c;
        }else{
            return null;
        }
    }

    //Method for getting next settlement date for particular payment processor
    public static Date getNextSettlementDate(String paymentProcessor, Map<Date, Set<String>> holidayMap){
        String paymentMethod = fetchPaymentMethodFromPaymentProcessor(paymentProcessor);
        //Define settlement date
        Date settlementDate;
        //Map for Payment processor and their window of days in that pending payment will settle
        Map<String, Integer> paymenProcessorMap = new Map<String, Integer>{'ACH.Com' => 3, 'TD Bank' => 6, 'EFT Canada' => 4};

        if(paymenProcessorMap.get(paymentMethod) != null){
            Integer count=0, i=1;
            //loop until count is less then the defined days window for payment processor 
            while(count<paymenProcessorMap.get(paymentMethod)){
                //Calculate the day of week
                Date d = System.today().addDays(i);
                String dayOfWeek = CashManagementUtil.getDayOfWeek(d);

                //If the day for which the loop is running listed in the holidays for the payment processor OR the day is a weeked
                //Dont increase the count just increase the date
                if((holidayMap.get(d) != null && holidayMap.get(d).contains(paymentMethod)) || dayOfWeek == 'Saturday' || dayOfWeek == 'Sunday'){
                    i++;
                }
                //otherwise increment the counter and date
                else{
                    i++;
                    count++;
                    settlementDate = d;
                }                                   
            }
            System.debug('settlementDate ->'+settlementDate);
        }
        return settlementDate;
    }

    //Method for getting next settlement date for particular payment processor
    public static Date getNextSettlementDateForSyndicationPayments(String paymentProcessor, Map<Date, Set<String>> holidayMap){
        String paymentMethod = fetchPaymentMethodFromPaymentProcessor(paymentProcessor);
        //Define settlement date
        Date settlementDate;
        //Map for Payment processor and their window of days in that pending payment will settle
        Map<String, Integer> paymenProcessorMap = new Map<String, Integer>{'ACH.Com' => 4, 'TD Bank' => 7, 'EFT Canada' => 5};

        if(paymenProcessorMap.get(paymentMethod) != null){
            Integer count=0, i=1;
            //loop until count is less then the defined days window for payment processor 
            while(count<paymenProcessorMap.get(paymentMethod)){
                //Calculate the day of week
                Date d = System.today().addDays(i);
                String dayOfWeek = CashManagementUtil.getDayOfWeek(d);

                //If the day for which the loop is running listed in the holidays for the payment processor OR the day is a weeked
                //Dont increase the count just increase the date
                if((holidayMap.get(d) != null && holidayMap.get(d).contains(paymentMethod)) || dayOfWeek == 'Saturday' || dayOfWeek == 'Sunday'){
                    i++;
                }
                //otherwise increment the counter and date
                else{
                    i++;
                    count++;
                    settlementDate = d;
                }                                   
            }
            System.debug('settlementDate ->'+settlementDate);
        }
        return settlementDate;
    }

    //Method for getting next business day for payment processor 
    public static Date getNextBusinessDate(String paymentProcessor, Map<Date, Set<String>> holidayMap){
        String paymentMethod = fetchPaymentMethodFromPaymentProcessor(paymentProcessor);
        //Define business date
        Date nextBusinessDate;

        Integer count=0, i=1;

        //Loop through for 1 increment in count
        while(count<1){
            //Calculate the day of week
            Date d = System.today().addDays(i);
            String dayOfWeek = CashManagementUtil.getDayOfWeek(d);

            //If the day for which the loop is running listed in the holidays for the payment processor OR the day is a weeked
            //Dont increase the count just increase the date
            if((holidayMap.get(d) != null && holidayMap.get(d).contains(paymentMethod)) || dayOfWeek == 'Saturday' || dayOfWeek == 'Sunday'){
                i++;
            }
            //otherwise increment the counter and date
            else{
                i++;
                count++;
                nextBusinessDate = d;
            }                                        
        }
        return nextBusinessDate;
    }

    //Method for getting next business day for payment processor 
    public static Date getSecondNextBusinessDate(String paymentProcessor, Map<Date, Set<String>> holidayMap){
        String paymentMethod = fetchPaymentMethodFromPaymentProcessor(paymentProcessor);
        //Define business date
        Date nextBusinessDate;

        Integer count=0, i=1;

        //Loop through for 1 increment in count
        while(count<2){
            //Calculate the day of week
            Date d = System.today().addDays(i);
            String dayOfWeek = CashManagementUtil.getDayOfWeek(d);
            System.debug('dayOfWeek=>'+dayOfWeek);
            //If the day for which the loop is running listed in the holidays for the payment processor OR the day is a weeked
            //Dont increase the count just increase the date
            if((holidayMap.get(d) != null && holidayMap.get(d).contains(paymentMethod)) || dayOfWeek == 'Saturday' || dayOfWeek == 'Sunday'){
                i++;
            }
            //otherwise increment the counter and date
            else{
                i++;
                count++;
                nextBusinessDate = d;
            }                                        
        }
        return nextBusinessDate;
    }

    //Method for getting next week's business day for payment processor 
    public static Date getNextWeekBusinessDate(String paymentProcessor, Map<Date, Set<String>> holidayMap){
        String paymentMethod = fetchPaymentMethodFromPaymentProcessor(paymentProcessor);
        //Define business date
        Date nextBusinessDate;

        Integer count=0, i=0;

        //Loop through for 1 increment in count
        while(count<5){
            //Calculate the day of week
            Date d = System.today().addDays(i);
            String dayOfWeek = CashManagementUtil.getDayOfWeek(d);

            //If the day for which the loop is running listed in the holidays for the payment processor OR the day is a weeked
            //Dont increase the count just increase the date
            if((holidayMap.get(d) != null && holidayMap.get(d).contains(paymentMethod)) || dayOfWeek == 'Saturday' || dayOfWeek == 'Sunday'){
                i++;
            }
            //otherwise increment the counter and date
            else{
                i++;
                count++;
                nextBusinessDate = d;
            }                                        
        }
        return nextBusinessDate;
    }

    //Method for getting next week's business day for payment processor 
    public static Date getNextWeekBusinessDate(String paymentProcessor, Map<Date, Set<String>> holidayMap, String weekDay){
        String paymentMethod = fetchPaymentMethodFromPaymentProcessor(paymentProcessor);
        Date nextWeekDate;
        for(Integer i=1; i<8; i++){
            Date d = System.today().addDays(i);
            String dayOfWeek = CashManagementUtil.getDayOfWeek(d);
            if(dayOfWeek == weekDay){
                nextWeekDate = d;
                break;
            }            
        }

        if(holidayMap != null && holidayMap.size() > 0){
            Date d = nextWeekDate;
            String dayOfWeek = CashManagementUtil.getDayOfWeek(d);
            if(holidayMap.get(d) == null && dayOfWeek != 'saturday' && dayOfWeek != 'sunday'){
                return d;
            }else{
                if(holidayMap.get(d) != null && !holidayMap.get(d).contains(paymentMethod) && dayOfWeek != 'saturday' && dayOfWeek != 'sunday'){
                    return d;
                }else{                
                    do{
                        d = d.addDays(1);
                        dayOfWeek = CashManagementUtil.getDayOfWeek(d);                            
                    }while((holidayMap.get(d) != null && holidayMap.get(d).contains(paymentMethod)) || dayOfWeek == 'saturday' || dayOfWeek == 'sunday');
                    return d;
                }
            }
        }else{
            return nextWeekDate;
        }
    }    

    //Method for getting next month's business day for payment processor 
    public static Date getNextMonthBusinessDate(String paymentProcessor, Map<Date, Set<String>> holidayMap){
        String paymentMethod = fetchPaymentMethodFromPaymentProcessor(paymentProcessor);
        //Define business date
        Date nextBusinessDate;

        Integer count=0, i=0;

        //Loop through for 1 increment in count
        while(count<1){
            //Calculate the day of week
            Date tempDate = System.today().addMonths(1);
            Date d = tempDate.addDays(i);
            String dayOfWeek = CashManagementUtil.getDayOfWeek(d);

            //If the day for which the loop is running listed in the holidays for the payment processor OR the day is a weeked
            //Dont increase the count just increase the date
            if((holidayMap.get(d) != null && holidayMap.get(d).contains(paymentMethod)) || dayOfWeek == 'Saturday' || dayOfWeek == 'Sunday'){
                i++;
            }
            //otherwise increment the counter and date
            else{
                i++;
                count++;
                nextBusinessDate = d;
            }                                        
        }
        return nextBusinessDate;
    }

    //Method for getting next month's business day for payment processor 
    public static Date getNextMonthBusinessDate(String paymentProcessor, Map<Date, Set<String>> holidayMap, Decimal mDay){
        String paymentMethod = fetchPaymentMethodFromPaymentProcessor(paymentProcessor);
        Date nextMonthDate;
        Integer monthDay = Integer.valueOf(mDay);

        for(Integer i=1; i<32; i++){
            Date d = System.today().addDays(i);
            Integer day = d.day();
            if(monthDay == day){
                nextMonthDate = d;
                break;
            }            
        }

        if(holidayMap != null && holidayMap.size() > 0){
            Date d = nextMonthDate;
            String dayOfWeek = CashManagementUtil.getDayOfWeek(d);
            if(holidayMap.get(d) == null && dayOfWeek != 'saturday' && dayOfWeek != 'sunday'){
                return d;
            }else{
                if(holidayMap.get(d) != null && !holidayMap.get(d).contains(paymentMethod) && dayOfWeek != 'saturday' && dayOfWeek != 'sunday'){
                    return d;
                }else{
                    do{
                        d = d.addDays(1);
                        dayOfWeek = CashManagementUtil.getDayOfWeek(d);                            
                    }while((holidayMap.get(d) != null && holidayMap.get(d).contains(paymentMethod)) || dayOfWeek == 'saturday' || dayOfWeek == 'sunday');
                    return d;
                }
            }
        }else{
            return nextMonthDate;
        }
    }    

    //Method to find for a given date and payment processor is there any holiday or not
    public static Boolean getHolidayForDate(Date d, String paymentProcessor, Map<Date, Set<String>> holidayMap){
        String dayOfWeek = CashManagementUtil.getDayOfWeek(d);
        if(holidayMap.get(d) != null && holidayMap.get(d).contains(paymentProcessor) && dayOfWeek != 'saturday' && dayOfWeek != 'sunday'){
            return true;
        }else{
            return false;
        }
    }   

    //Method to get day of the week from date passed in
    public static String getDayOfWeek(Date d){
        Date tempDate = Date.newInstance(d.year(),d.month(),d.day());
        Datetime dt = DateTime.newInstance(tempDate, Time.newInstance(0, 0, 0, 0));
        String dayOfWeek = dt.format('EEEE');
        return dayOfWeek.toLowerCase();
    }

    //Method to generate random alphanumeric string of the passed length
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr.toUpperCase(); 
    }
}