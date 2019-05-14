/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
* Class Name: LenderToSalesSupportCompCtrl (SalesSupportLenderCommComponent_Test - Test class)
* Created Date: 01/23/2019
* Description: Controller for LenderToSalesSupportComp visulaforce component
*******************************************************************/
public class LenderToSalesSupportCompCtrl{
    
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
    public List<Task> getMessageFormSalesRep(){
        if(oppId !=null){
            List<Task> taskListForSalesRep = new List<Task>();
            taskListForSalesRep = [SELECT id,whatId,Description,Subject FROM Task WHERE WhatId=:oppId and subject='Message from Lender to Sales Support' Order by CreatedDate Desc LIMIT 1];
            if(taskListForSalesRep [0].Description !=null && taskListForSalesRep.size()>0){
                return taskListForSalesRep;
            }else{
                return null;
            }
        }else{
            return null;
        }
    }
}