/*********************************************************************************
* Author: Techila Global Services Pvt Ltd. (Gaurav Agrawal)
* Class Name: LeadTriggerHandler
* Created Date: 30-August-2018
* Description: Helper class for LeadTrigger 
**********************************************************************************
* Updates
* Author            | Date          | Description
* Aditya            | 12-Sep-2018   | Insert Application under lead if manually created
**********************************************************************************/

public class LeadTriggerHandler{
    //Helper method for mapping timezone based on first 3 digits of Phone number
    public static void mapTimeZone(List<Lead> leadList){
        for(Lead objLead : leadList){
            String phoneString = objLead.Phone;         
            phoneString = phoneString.trim();           
            phoneString = phoneString.replace('+1','');         
            phoneString = phoneString.replaceAll('\\D',''); 
            if(phoneString.length()>3){     
                phoneString = phoneString.subString(0,3);
                if(TimeZone_Mapping__c.getAll().get(phoneString) != null && TimeZone_Mapping__c.getAll().get(phoneString).TimeZone__c != null){             
                    objLead.Time_Zone__c = TimeZone_Mapping__c.getAll().get(phoneString).TimeZone__c;           
                }
            }
        }
    }
    
    // Aditya - Insert Application under lead if Application is not created
    public static void afterInsert(set<Id> leadIds){
        List<Lead> lstLead = [SELECT id,LastName,FirstName,Email,Company,Phone,(SELECT id FROM Cloufi__Applications__r LIMIT 1) FROM Lead WHERE id in:leadIds];
        system.debug('lstLead=>'+lstLead);
        List<Lead> leadsToCreateApp = new List<Lead>();
        for(Lead objLead : lstLead){
            system.debug('objLead.Cloufi__Applications__r=>'+objLead.Cloufi__Applications__r);
            if(objLead.Cloufi__Applications__r.size()==0){
                leadsToCreateApp.add(objLead);
            }
        }
        system.debug('leadsToCreateApp=>'+leadsToCreateApp);
        List<Cloufi__Application__c> lstApp = new List<Cloufi__Application__c>();
        if(leadsToCreateApp.size()>0){
            for(Lead objLd : leadsToCreateApp){
                Cloufi__Application__c objApplication = new Cloufi__Application__c();
                objApplication.Cloufi__Last_Name__c = objLd.LastName;
                objApplication.Cloufi__First_Name__c = objLd.FirstName;
                objApplication.Cloufi__Email__c = objLd.Email;
                objApplication.Cloufi__Business_Legal_Name__c = objLd.Company;
                objApplication.Cloufi__Phone_Bank_Info__c = objLd.Phone;
                objApplication.Cloufi__Lead__c = objLd.id;
                lstApp.add(objApplication);
            }
        }
        system.debug('lstApp=>'+lstApp);
        if(lstApp.size()>0){
            insert lstApp;
        }
    }
    
    //Anuradha - Application Checklist Verification
    public static void verifyAppCheckList(Map <Id, Lead> applicationCheckListMap){
        system.debug('applicationCheckListMap >>'+applicationCheckListMap);
        for(Lead leadRecord : applicationCheckListMap.values()){
            /* if(leadRecord.LastName!=null && (leadRecord.Phone!=null || leadRecord.MobilePhone!=null)   && leadRecord.Company!=null && leadRecord.Email!=null && (leadRecord.Time_in_Business__c!=null && leadRecord.Time_in_Business__c!='0-3 Months') && (leadRecord.Average_Monthly_Revenue__c!=null && leadRecord.Average_Monthly_Revenue__c!='$0 - $4,999') && leadRecord.Type_Of_Business__c!=null && leadRecord.Cloufi__Amount_Requested__c!=null && leadRecord.Purpose_of_Funding__c!=null && ((leadRecord.Are_you_in_Bankruptcy_Consumer_Proposal__c && leadRecord.Current_Payment_Plan__c!='No')  || leadRecord.Are_you_in_Bankruptcy_Consumer_Proposal__c==false) && leadRecord.Interested_within_2_4_weeks__c!=false){
                leadRecord.OwnerId = Label.Default_Lead_Owner_for_OffShore;
            }else{
                leadRecord.addError('Please verify all the fields under Qualifying Question section, in order to complete the Check-list');
            } */
            if(leadRecord.LastName==''){
                leadRecord.LastName.addError('This field is required.');
            }
            if(leadRecord.Phone==null && leadRecord.MobilePhone==null){
                leadRecord.Phone.addError('Either add a Business Phone or Cell Phone number');
            }
            if(leadRecord.Company==null){
                leadRecord.Company.addError('This field is required.');
            }
            if(leadRecord.Email==null){
                leadRecord.Email.addError('This field is required.');
            }
            if(leadRecord.Are_you_in_Bankruptcy_Consumer_Proposal__c==true && leadRecord.Current_Payment_Plan__c!='Yes'){
                leadRecord.Current_Payment_Plan__c.addError('Current Payment plan is required in case of Bankcruptcy');
            }
            if(leadRecord.Time_in_Business__c==null || leadRecord.Time_in_Business__c=='0-3 Months'){
                leadRecord.Time_in_Business__c.addError('Time in Business should be a minimum over 3 months');
            }
            if(leadRecord.Average_Monthly_Revenue__c==null || leadRecord.Average_Monthly_Revenue__c=='$0 - $4,999'){
                leadRecord.Average_Monthly_Revenue__c.addError('Minimum Average Monthly Revenue should be over 5K');
            }
            if(leadRecord.Type_Of_Business__c==null){
                leadRecord.Type_Of_Business__c.addError('This field is required.');
            }
            if(leadRecord.Cloufi__Amount_Requested__c==null){
                leadRecord.Cloufi__Amount_Requested__c.addError('This field is required.');
            }
            if(leadRecord.Purpose_of_Funding__c==null){
                leadRecord.Purpose_of_Funding__c.addError('This field is required.');
            }
            if(leadRecord.Interested_within_2_4_weeks__c==false){
                leadRecord.Interested_within_2_4_weeks__c.addError('This field is required.');
            }           
        }
    }

    // Aditya - Manual access to lead owner manager
    public static void createLeadShare(set<Id> leadIds){
        system.debug('leadIds=>'+leadIds);
        List<Lead> leadList = [SELECT id,OwnerId FROM Lead WHERE Id IN:leadIds];
        List<LeadShare> leadShareList = new List<LeadShare>();
        Set<Id> leadOwnerIdSet = new Set<Id>();
        Map<Id,Id> ownerManagerIdMap = new Map<Id, Id>();
        
        for(Lead objLead : leadList){
            leadOwnerIdSet.add(objLead.OwnerId);
        }
        if(leadOwnerIdSet.size()>0){
            for(User objUser : [SELECT Id, ManagerId FROM User WHERE Id IN : leadOwnerIdSet]){
                if(objUser.ManagerId !=null){
                    ownerManagerIdMap.put(objUser.Id, objUser.ManagerId);
                }
            }
            for(Lead objLd : leadList){
                if(objLd.OwnerId != null && ownerManagerIdMap.get(objLd.OwnerId) != null){
                    LeadShare objLeadShare = new LeadShare();
                    objLeadShare.LeadId = objLd.Id;
                    objLeadShare.LeadAccessLevel = 'Edit';
                    objLeadShare.RowCause = 'Manual';
                    objLeadShare.UserOrGroupId = ownerManagerIdMap.get(objLd.OwnerId);
                    leadShareList.add(objLeadShare);                
                }
            }
            if(leadShareList.size()>0){
                if(!test.isRunningTest()){
                    insert leadShareList;
                }
            }
        }
    }
}