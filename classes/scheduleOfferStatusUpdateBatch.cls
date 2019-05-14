/*********************************************************
Author  | Date       | Description 
Neha   | 08/21/2018 | Controller for submitToSalesSupport VF Page
**********************************************************/

global class scheduleOfferStatusUpdateBatch implements Schedulable{
    global void execute(SchedulableContext sc) {
        UpdateOfferStatusBatch offerBatch = new UpdateOfferStatusBatch(); 
        database.executebatch(offerBatch);
    }
}