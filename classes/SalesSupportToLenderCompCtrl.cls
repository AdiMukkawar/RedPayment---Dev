/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: SalesSupportToLenderCompCtrl (SalesSupportLenderCommComponent_Test - Test class)
* Created Date: 01/23/2019
* Description: Controller for SalesSupportToLenderComp visulaforce component
*******************************************************************/
public class SalesSupportToLenderCompCtrl{
    
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
            taskListForSupport= [SELECT id,whatId,Description,Subject FROM Task WHERE WhatId=:oppId and subject='Message from Sales Support to Lender' Order by CreatedDate Desc LIMIT 1];
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