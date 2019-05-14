@isTest
public class DownloadAllUWDocumentsControllerX_Test 
{
    @isTest
    public static void testDownloadAllUWDocumentsControllerX()
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DownloadUWMockHttpResponseGenerator());
        //insert opportunity
        Opportunity objOpp = new Opportunity(); 
        objOpp.Name = 'Test Opp';
        objOpp.ForecastCategoryName = 'Pipeline';
        objOpp.CloseDate = System.today();
        objOpp.StageName = 'Qualified';
        insert objOpp;
        
        PageReference pageRef = Page.DownloadAllUWDocuments;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(objOpp.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpp);
        DownloadAllUWDocumentsControllerX objUWDocument = new DownloadAllUWDocumentsControllerX(sc);
        objUWDocument.downloadAllUWDocs();
        objUWDocument.downloadOneUWDoc();
        Test.stopTest();
    }
}