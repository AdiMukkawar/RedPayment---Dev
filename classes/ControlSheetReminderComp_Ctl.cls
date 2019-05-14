public class ControlSheetReminderComp_Ctl{

    public List<Cloufi__UW_Document__c> getUWList(){
        datetime myDateTime = datetime.now().addHours(-2);
        system.debug('### DateTime>>>'+myDateTime);
        List<Cloufi__UW_Document__c> lstUW = new List<Cloufi__UW_Document__c>();
        lstUW = [Select Id,Name,Control_Sheet_Recipients__c,Control_Sheet_requested_Date_Time__c,Status__c,Cloufi__Opportunity__c,Cloufi__Opportunity__r.name,Stip_name__c,Cloufi__Type__c From Cloufi__UW_Document__c Where Status__c = 'Requested' AND Control_Sheet_requested_Date_Time__c <=:myDateTime AND Cloufi__Opportunity__c!=null AND Cloufi__Type__c='Control Sheet' AND Control_Sheet_Recipients__c!=NULL];
        if(lstUW.size()>0){
             return lstUW; 
        }else{
            return lstUW;
        }
    }
   
}