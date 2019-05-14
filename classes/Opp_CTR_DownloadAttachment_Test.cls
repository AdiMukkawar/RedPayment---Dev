@isTest
public class Opp_CTR_DownloadAttachment_Test 
{
    @isTest
    public static void testOpp_CTR_DownloadAttachment()
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DownloadUWMockHttpResponseGenerator());
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
        
         // Insert UW Document
        Cloufi__UW_Document__c objUW = new Cloufi__UW_Document__c(Cloufi__URL__c='www.sfdc.com',Name='Test',Stip_Name__c='Signed Application',Cloufi__Opportunity__c=objOpp.Id,Cloufi__Type__c='Bank Statement', Status__c='Pending');
        insert objUW;
        
        String filepath = 'http://www.axmag.com/download/pdfurl-guide.pdf';
        Opp_CTR_DownloadAttachment.callout(filepath);
        
        Opp_CTR_DownloadAttachment.downloadFiles(objOpp.Id);
        Test.stopTest();
    }
}