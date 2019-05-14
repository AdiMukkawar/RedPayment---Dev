global class RenewalPayoffPercentageCalculationBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = '';
        query += ' SELECT ' + String.join(DevUtil.getFieldsOfsObject('Opportunity'), ',' );
        query += ' FROM Opportunity WHERE (StageName = \'Funded\' OR (StageName = \'Completed\' AND Payoff_Percentage_Time__c < 100)) AND CloufiServicing__Funding_Date__c != null';
        query += ' AND Cloufi__Payback_Amount__c != null AND CloufiServicing__Payment_Installment__c != null';
        query += ' AND CloufiServicing__Active_Repayment_Schedule__c = null';
        //query += ' AND Id = \'00618000009CgXt\'';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        for(Opportunity objOpportunity : scope){
            Decimal payoffPercentage = 0.0, installments = 0.0;
            Integer days = objOpportunity.CloufiServicing__Funding_Date__c.daysBetween(Date.today());
            if(objOpportunity.Cloufi__Payback_Amount__c > 0 && objOpportunity.CloufiServicing__Payment_Installment__c > 0){
                installments = objOpportunity.Cloufi__Payback_Amount__c/objOpportunity.CloufiServicing__Payment_Installment__c;
            }

            if(installments > 0.0){
                if(objOpportunity.Cloufi__Frequency__c == 'Daily'){
                    Integer workingDays = DevUtil.getWorkingDays(objOpportunity.CloufiServicing__Funding_Date__c);
                    payoffPercentage = (workingDays/installments)*100;
                }else if(objOpportunity.Cloufi__Frequency__c == 'Weekly'){
                    payoffPercentage = ((days/7.0)/installments)*100;
                }else if(objOpportunity.Cloufi__Frequency__c == 'Monthly'){
                    payoffPercentage = ((days/30.4)/installments)*100;
                }
                objOpportunity.Payoff_Percentage_Time__c = payoffPercentage;
            }
        }
        update scope;
    }
    
    global void finish(Database.BatchableContext BC){}
}