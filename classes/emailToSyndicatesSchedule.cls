global class emailToSyndicatesSchedule implements Schedulable {
        global void execute(SchedulableContext sc) {
            emailToSyndicates opb = new emailToSyndicates(1);
            Database.executeBatch(opb,100);
        }
}