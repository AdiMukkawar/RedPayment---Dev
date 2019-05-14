/*****************************************************************
 * Author: Techila Global Services Pvt Ltd. (Prashant Mahajan)
 * Class Name: NewLeadController_Test
 * Created Date: 26-July-2018
 * Description: Test Class for NewLeadController
 *******************************************************************/
@isTest
public class NewLeadController_Test {
    public static testMethod void validateNewLeadCreation(){   
        // Insert Lead
        Lead  ObjLead = new Lead();
        objLead.LastName = 'Test Last Name';
        ObjLead.Company = 'Test Company';
        NewLeadController obj = new NewLeadController();        
        NewLeadController.saveLeadCtrl(ObjLead);
    }
}