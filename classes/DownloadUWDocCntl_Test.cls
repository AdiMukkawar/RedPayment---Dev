@isTest
public class DownloadUWDocCntl_Test 
{
    @isTest
    public static void testDownloadAllUWDocumentsControllerX()
    {
        // Fetch folder
        Folder lstFolder = [Select Id From Folder Where Name = 'Sales Tools'];
        
        //insert opportunity
        Opportunity objOpp = new Opportunity(); 
        objOpp.Name = 'Test Opp';
        objOpp.ForecastCategoryName = 'Pipeline';
        objOpp.CloseDate = System.today();
        objOpp.StageName = 'Qualified';
        objOpp.Cloufi__Dropbox_Folder_Path__c = lstFolder.Id;
        insert objOpp;
        
        // Insert UW Document'
        Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c(Cloufi__URL__c='www.sfdc.com',Name='Test',Stip_Name__c='Signed Application',Cloufi__Opportunity__c=objOpp.Id,Cloufi__Type__c='Bank Statement', Status__c='Pending');
        insert objUW;
        
        //Insert UW_Document_Share__c
        UW_Document_Share__c objUWDOC = new UW_Document_Share__c(UW_Documents__c = objUW.id, Opportunity__c = objOpp.id);
        insert objUWDOC;
        
        PageReference pageRef = Page.Download_UW_Documents;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(objOpp.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpp);
        DownloadUWDocCntl objUWDocument = new DownloadUWDocCntl(sc);
    }
}