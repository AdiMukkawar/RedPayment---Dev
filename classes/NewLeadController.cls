/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Prashant Mahajan)
* Class Name: NewLeadController
* Created Date: 26-July-2018
* Description: Controller Extension for new lead create component
*******************************************************************/
global class NewLeadController{
    
    public NewLeadController() {}
    
    // Create New Lead Records	
    @AuraEnabled
    global static Lead saveLeadCtrl(Lead objLead){
        if(objLead != null){
            insert objLead;        
        }
        
        return objLead;
    }
}