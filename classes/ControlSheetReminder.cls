/*********************************************************
Author          | Date       | Description 
Aditya Mukkawar | 03/29/2019 | Send Control sheet Reminder to control sheet departmenent
**********************************************************/
global class ControlSheetReminder implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('Hello=>');
        DateTime twoHoursAgo = System.now().addHours(-2);
        system.debug('twoHoursAgo=>'+twoHoursAgo);
        String query = 'SELECT Id,Control_Sheet_Recipients__c,Control_Sheet_requested_Date_Time__c,Status__c ,Cloufi__Opportunity__c,Cloufi__Opportunity__r.name,Stip_name__c,Cloufi__Type__c FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c!=null AND Control_Sheet_Recipients__c!=NULL AND Status__c = \'Requested\' AND Cloufi__Type__c=\'Control Sheet\' AND Control_Sheet_requested_Date_Time__c <=:twoHoursAgo';
        system.debug('query=>'+Database.Query(query));
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Cloufi__UW_Document__c> scope){
        System.debug('scope-->'+scope);
        if(scope.size()>0){
            Boolean sendEmailAlert = true;
            Date todayDate = System.today();
            Map<Date, Set<String>> holidayMap = new Map<Date, Set<String>>();
            //Loop through the bank holidays between yesterday's date and a month ahead and populate map
            for(Cloufi__Bank_Holiday__c objBankHoliday : [SELECT Cloufi__Holiday_Date__c, Cloufi__Payment_Processor__c FROM Cloufi__Bank_Holiday__c WHERE Cloufi__Holiday_Date__c > :System.today().addDays(-1) AND Cloufi__Holiday_Date__c <: System.today().addMonths(2)]){
                Set<String> paymentProSet = new Set<String>();
                for(String paymentPro : objBankHoliday.Cloufi__Payment_Processor__c.split(';')){
                    paymentProSet.add(paymentPro.trim());        
                }
                holidayMap.put(objBankHoliday.Cloufi__Holiday_Date__c, paymentProSet);
            }

            Date tempDate = Date.newInstance(todayDate.year(),todayDate.month(),todayDate.day());
            Datetime dt = DateTime.newInstance(tempDate, Time.newInstance(0, 0, 0, 0));
            String dayOfWeek = dt.format('EEEE');
            dayOfWeek = dayOfWeek.toUpperCase();

            if((holidayMap.get(todayDate) != null && holidayMap.get(todayDate).contains('MAC TD')) || dayOfWeek == 'SATURDAY' || dayOfWeek == 'SUNDAY'){
                sendEmailAlert = false;
            }
            system.debug('sendEmailAlert=>'+sendEmailAlert);
            if(sendEmailAlert){
                List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
                List<EmailTemplate> emailTemp = [select id from EmailTemplate where DeveloperName = 'ControlSheetReminder'];
                List<OrgWideEmailAddress> orgEmails = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Maple Sales Support'];//CPS Sales Support
                Set<String> emailIds = new Set<String>();
                List<String> ccEmailIds = new List<String>();
                List<String> emailIdList = new List<String>();
                for(Cloufi__UW_Document__c objUW:scope){
                    objUW.Control_Sheet_Recipients__c = objUW.Control_Sheet_Recipients__c.removeStart('(').removeEnd(')');
                    if(objUW.Control_Sheet_Recipients__c != null){
                        emailIds.addAll(objUW.Control_Sheet_Recipients__c.split(','));
                        emailIdList.addAll(emailIds);
                    }
                }
                Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                if(orgEmails.size()>0){
                    ccEmailIds.add(orgEmails[0].Address);
                }
                
                system.debug('emailIdList=>'+emailIdList);
                system.debug('ccEmailIds=>'+ccEmailIds);
                emailMsg.setToAddresses(emailIdList);
                if(ccEmailIds.size()>0){
                    emailMsg.setCCAddresses(ccEmailIds);
                }
                emailMsg.setTargetObjectId(UserInfo.getUserId());
                emailMsg.setWhatId(scope[0].Cloufi__Opportunity__c);
                emailMsg.SaveAsActivity = false;
                emailMsg.setTreatTargetObjectAsRecipient(false);
                emailMsg.setTemplateId(emailTemp[0].id);
                system.debug('emailMsg=>'+emailMsg);
                if(emailIdList.size() > 0){
                    lstEmailMsg.add(emailMsg);
                }
                if(lstEmailMsg.size() > 0){
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmailMsg);
                }
            }
        }
    }

    global void finish(Database.BatchableContext BC) {
    }
}