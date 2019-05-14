@isTest
public class RequestContractController_Test 
{
    @isTest
    public static void tesRequestContractController()
    {
        //Insert opportunity
        Opportunity objOpp = new Opportunity(); 
        objOpp.Name = 'Test Opp';
        objOpp.ForecastCategoryName = 'Pipeline';
        objOpp.CloseDate = System.today();
        objOpp.StageName = 'Qualified';
        insert objOpp;
        RequestContractController.getUWDocumentList(objOpp.Id);
    }
}