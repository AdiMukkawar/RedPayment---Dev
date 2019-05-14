/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: SalesRepCompController (SalesRepSupportCompController_Test - Test class)
* Created Date: 21-September-2018
* Description: Controller for SalesRepComp visulaforce component
*******************************************************************/
public class SalesRepCompController{
    
    public Id oppId {get;set;}
    
    public string getOppLink(){
        if(oppId !=null){
            string base_URL = Label.Base_URL;
            return base_URL+'/'+oppId;
        }else{
            return null;
        }
        
    }
    
    //  To get Task which is assign to sales Rep
    public List<Task> getMessageFroSupport(){
        if(oppId !=null){
            List<Task> taskListForSupport= new List<Task>();
            taskListForSupport= [SELECT id,whatId,Description,Subject FROM Task WHERE WhatId=:oppId and subject='Task Assign to Sales Rep' Order by CreatedDate Desc LIMIT 1];
            if(taskListForSupport[0].Description !=null && taskListForSupport.size()>0){
                return taskListForSupport;
            }else{
                return null;
            }
        }else{
            return null;
        }
    }
    
}