global class RenewalPayoffPercCalcSchedular implements Schedulable {
   global void execute(SchedulableContext sc) {
      RenewalPayoffPercentageCalculationBatch b = new RenewalPayoffPercentageCalculationBatch(); 
      database.executebatch(b);
   }
}