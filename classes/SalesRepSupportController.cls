/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: SalesRepSupportController (SalesRepSupportCompController_Test - Test class)
* Created Date: 21-September-2018
* Description: Controller for SalesRepSupport visulaforce component
*******************************************************************/
public class SalesRepSupportController{
    
    public Id oppId {get;set;}
    
    public string getOppLink(){
        if(oppId !=null){
            string base_URL = Label.Base_URL;
            return base_URL+'/'+oppId;
        }else{
            return null;
        }
        
    }
    
	//  To get Task which is assign to sales support
    public List<Chat__c> getMessageFormSalesRep(){
        if(oppId !=null){
            /*List<Task> taskListForSalesRep = new List<Task>();
            taskListForSalesRep = [SELECT id,whatId,Description,Subject FROM Task WHERE WhatId=:oppId and subject='Task Assign to Sales Support' Order by CreatedDate Desc LIMIT 1];
            if(taskListForSalesRep [0].Description !=null && taskListForSalesRep.size()>0){
                return taskListForSalesRep;
            }else{
                return null;
            }*/
            List<Chat__c> taskListForSalesRep = new List<Chat__c>();
            taskListForSalesRep = [SELECT id,Opportunity__c,Message__c,Subject__c FROM Chat__c WHERE Opportunity__c=:oppId and Subject__c='Task Assign to Sales Support' Order by CreatedDate Desc LIMIT 1];
            if(taskListForSalesRep [0].Message__c !=null && taskListForSalesRep.size()>0){
                return taskListForSalesRep;
            }else{
                return null;
            }
        }else{
            return null;
        }
    }
}