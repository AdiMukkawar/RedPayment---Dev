@isTest
public class NoteTrigger_Test 
{
    @isTest
    public static void testNoteTrigger()
    {
        HelperClass.firstRun = false;
        //insert opportunity
        Opportunity objOpp = new Opportunity(); 
        objOpp.Name = 'Test Opp';
        objOpp.ForecastCategoryName = 'Pipeline';
        objOpp.CloseDate = System.today();
        objOpp.StageName = 'Qualified';
        insert objOpp;
        
        // Insert Note
        Note objNote = new Note(Title = 'Test', ParentId = objOpp.Id);
		insert objNote;
    }
}