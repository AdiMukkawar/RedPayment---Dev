public class ApplicationUtil {
    
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
    
    //Method for getting next settlement date for particular payment processor
    public static Date getNextSettlementDate(String paymentProcessor, Map<Date, Set<String>> holidayMap){
        String paymentMethod = fetchPaymentMethodFromPaymentProcessor(paymentProcessor);
        //String paymentMethod = paymentProcessor;
        //Define settlement date
        Date settlementDate;
        //Map for Payment processor and their window of days in that pending payment will settle
        Map<String, Integer> paymenProcessorMap = new Map<String, Integer>{'ACH.Com' => 2, 'TD Bank' => 6, 'EFT Canada' => 4};

        if(paymenProcessorMap.get(paymentMethod) != null){
            Integer count=0, i=1;
            //loop until count is less then the defined days window for payment processor 
            while(count<paymenProcessorMap.get(paymentMethod)){
                //Calculate the day of week
                Date d = System.today().addDays(i);
                String dayOfWeek = getDayOfWeek(d);

                //If the day for which the loop is running listed in the holidays for the payment processor OR the day is a weeked
                //Dont increase the count just increase the date
                if((holidayMap.get(d) != null && holidayMap.get(d).contains(paymentMethod)) || dayOfWeek == 'SATURDAY' || dayOfWeek == 'SUNDAY'){
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
    
     public static String getDayOfWeek(Date d){
        Date tempDate = Date.newInstance(d.year(),d.month(),d.day());
        Datetime dt = DateTime.newInstance(tempDate, Time.newInstance(0, 0, 0, 0));
        String dayOfWeek = dt.format('EEEE');
        return dayOfWeek.toUpperCase();
    }
    
    public static String fetchPaymentMethodFromPaymentProcessor(String paymentProcessor){
        CloufiServicing__Payment_Processor_Settings__c objPaymentProcessorSetting = CloufiServicing__Payment_Processor_Settings__c.getValues(paymentProcessor);
        if(objPaymentProcessorSetting != null && objPaymentProcessorSetting.CloufiServicing__Payment_Method__c != null){
            return objPaymentProcessorSetting.CloufiServicing__Payment_Method__c;
        }else{
            return paymentProcessor;
        }
    }
}