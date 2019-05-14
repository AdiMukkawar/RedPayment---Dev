/*********************************************************
Author  		| Date       | Description 
Aditya Mukkawar | 03/29/2019 | Send Control sheet Reminder to control sheet departmenent
**********************************************************/

global class ScheduleControlSheetReminder implements Schedulable{
    global void execute(SchedulableContext sc) {
    	ControlSheetReminder controlSheetBatch = new ControlSheetReminder(); 
        database.executebatch(controlSheetBatch);
    }
}