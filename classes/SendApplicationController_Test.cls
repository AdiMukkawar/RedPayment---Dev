@isTest
public class SendApplicationController_Test {
    
    public static testMethod void testApplicationSend(){
        Lead objLead = new Lead(AnnualRevenue=1562,Fax ='sdvasd',Description='Desc',Email='test@gmail.com',FirstName='name',Website ='www.w3schools.com',Industry = 'Agriculture',MobilePhone = '45455',Phone='6546546',Title='Title',LastName='Name',Company='Company',Status='Open - Not Contacted',NumberOfEmployees = 52,Rating ='Hot',Average_Monthly_Revenue__c='$5,000 - $9,999',Time_in_Business__c='4 months – 1 year',Are_you_in_Bankruptcy_Consumer_Proposal__c=false,Cloufi__Amount_Requested__c=123,Purpose_of_Funding__c='Test',Interested_within_2_4_weeks__c=true);
        insert ObjLead;
        
        Cloufi__Application__c objApplication = new Cloufi__Application__c(Cloufi__First_Name__c='First Name',Cloufi__Last_Name__c='Last Name',Cloufi__Business_Legal_Name__c ='Legal Name',Cloufi__Business_DBA_Name__c='DBA Name',Cloufi__Lead__c=objLead.id);
        insert objApplication;
        
        Adobe_Templates__c objAdobeTemp = new Adobe_Templates__c(name='Adobe Template Id');
        insert objAdobeTemp;
        
        Test.startTest();           
            ApexPages.StandardController sc = new ApexPages.StandardController(objLead);
            apexpages.currentpage().getparameters().put('id',objLead.id);
            SendApplicationController objController = new SendApplicationController(sc);
            objController.adobePDF = true;
            objController.sendAppLink = true;
            objController.sendPDF = false;
            objController.SendApplication();
        
            
        Test.stopTest();
    }
    
    public static testMethod void testSendPDF(){
        Lead objLead = new Lead(AnnualRevenue=1562,Fax ='sdvasd',Description='Desc',Email='test@gmail.com',FirstName='name',Website ='www.w3schools.com',Industry = 'Agriculture',MobilePhone = '45455',Phone='6546546',Title='Title',LastName='Name',Company='Company',Status='Open - Not Contacted',NumberOfEmployees = 52,Rating ='Hot',Average_Monthly_Revenue__c='$5,000 - $9,999',Time_in_Business__c='4 months – 1 year',Are_you_in_Bankruptcy_Consumer_Proposal__c=false,Cloufi__Amount_Requested__c=123,Purpose_of_Funding__c='Test',Interested_within_2_4_weeks__c=true);
        insert ObjLead;
        
        Cloufi__Application__c objApplication = new Cloufi__Application__c(Cloufi__First_Name__c='First Name',Cloufi__Last_Name__c='Last Name',Cloufi__Business_Legal_Name__c ='Legal Name',Cloufi__Business_DBA_Name__c='DBA Name',Cloufi__Lead__c=objLead.id);
        insert objApplication;
        
         Adobe_Templates__c objAdobeTemp = new Adobe_Templates__c(name='Adobe Template Id');
        insert objAdobeTemp;
        
        Test.startTest();
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objLead);
            apexpages.currentpage().getparameters().put('id',objLead.id);
            SendApplicationController objController = new SendApplicationController(sc);
            objController.adobePDF = true;
            objController.objApp = objApplication;
            objController.sendAppLink = false;
            objController.sendPDF = true;
            objController.sendPDFAttach();
        
        Test.stopTest();
    }
    
    public static testMethod void testSendAllAndPDF(){
        Lead objLead = new Lead(AnnualRevenue=1562,Fax ='sdvasd',Description='Desc',Email='test@gmail.com',FirstName='name',Website ='www.w3schools.com',Industry = 'Agriculture',MobilePhone = '45455',Phone='6546546',Title='Title',LastName='Name',Company='Company',Status='Open - Not Contacted',NumberOfEmployees = 52,Rating ='Hot',Average_Monthly_Revenue__c='$5,000 - $9,999',Time_in_Business__c='4 months – 1 year',Are_you_in_Bankruptcy_Consumer_Proposal__c=false,Cloufi__Amount_Requested__c=123,Purpose_of_Funding__c='Test',Interested_within_2_4_weeks__c=true);
        insert ObjLead;
        
        Cloufi__Application__c objApplication = new Cloufi__Application__c(Cloufi__First_Name__c='First Name',Cloufi__Last_Name__c='Last Name',Cloufi__Business_Legal_Name__c ='Legal Name',Cloufi__Business_DBA_Name__c='DBA Name',Cloufi__Lead__c=objLead.id);
        insert objApplication;
        
         Adobe_Templates__c objAdobeTemp = new Adobe_Templates__c(name='Adobe Template Id');
        insert objAdobeTemp;
        
        Test.startTest();
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objLead);
            apexpages.currentpage().getparameters().put('id',objLead.id);
            SendApplicationController objController = new SendApplicationController(sc);
            objController.adobePDF = true;
            objController.sendAppLink = true;
            objController.sendPDF = true;
            objController.SendApplication();
            //objController.sendEmail();
            //objController.sendPDFAttach();
            
        Test.stopTest();
    }
    
    public static testMethod void testWithoutApp(){
        Lead objLead = new Lead(AnnualRevenue=1562,Fax ='sdvasd',Description='Desc',Email='test@gmail.com',FirstName='name',Website ='www.w3schools.com',Industry = 'Agriculture',MobilePhone = '45455',Phone='6546546',Title='Title',LastName='Name',Company='Company',Status='Open - Not Contacted',NumberOfEmployees = 52,Rating ='Hot',Average_Monthly_Revenue__c='$5,000 - $9,999',Time_in_Business__c='4 months – 1 year',Are_you_in_Bankruptcy_Consumer_Proposal__c=false,Cloufi__Amount_Requested__c=123,Purpose_of_Funding__c='Test',Interested_within_2_4_weeks__c=true);
        insert ObjLead;
        
         Adobe_Templates__c objAdobeTemp = new Adobe_Templates__c(name='Adobe Template Id');
        insert objAdobeTemp;
        
        Test.startTest();
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objLead);
            apexpages.currentpage().getparameters().put('id',objLead.id);
            SendApplicationController objController = new SendApplicationController(sc);
            objController.adobePDF = true;
            objController.sendAppLink = true;
            objController.sendPDF = false;
            objController.SendApplication();
        
            objController = new SendApplicationController(sc);
            objController.sendAppLink = false;
            objController.sendPDF = true;
            objController.sendMobile = true;            
            objController.SendApplication();
            /*objController.sendPhone = true;
            objController.SendApplication();*/
        Test.stopTest();
    }
    
    public static testMethod void testWithoutAppForPDF(){
        Lead objLead = new Lead(AnnualRevenue=1562,Fax ='sdvasd',Description='Desc',Email='test@gmail.com',FirstName='name',Website ='www.w3schools.com',Industry = 'Agriculture',MobilePhone = '45455',Phone='6546546',Title='Title',LastName='Name',Company='Company',Status='Open - Not Contacted',NumberOfEmployees = 52,Rating ='Hot',Average_Monthly_Revenue__c='$5,000 - $9,999',Time_in_Business__c='4 months – 1 year',Are_you_in_Bankruptcy_Consumer_Proposal__c=false,Cloufi__Amount_Requested__c=123,Purpose_of_Funding__c='Test',Interested_within_2_4_weeks__c=true);
        insert ObjLead;
        
         Adobe_Templates__c objAdobeTemp = new Adobe_Templates__c(name='Adobe Template Id');
        insert objAdobeTemp;
        
        Test.startTest();
            
            ApexPages.StandardController sc = new ApexPages.StandardController(objLead);
            apexpages.currentpage().getparameters().put('id',objLead.id);            
            SendApplicationController objController = new SendApplicationController(sc);            
            objController = new SendApplicationController(sc);
            objController.adobePDF = true;
            objController.sendAppLink = false;
            objController.sendPDF = true;
            objController.SendApplication();
        Test.stopTest();
    }
    
    public static testMethod void testWithoutAppAndPDF(){
        Lead objLead = new Lead(AnnualRevenue=1562,Fax ='sdvasd',Description='Desc',Email='test@gmail.com',FirstName='name',Website ='www.w3schools.com',Industry = 'Agriculture',MobilePhone = '45455',Phone='6546546',Title='Title',LastName='Name',Company='Company',Status='Open - Not Contacted',NumberOfEmployees = 52,Rating ='Hot',Average_Monthly_Revenue__c='$5,000 - $9,999',Time_in_Business__c='4 months – 1 year',Are_you_in_Bankruptcy_Consumer_Proposal__c=false,Cloufi__Amount_Requested__c=123,Purpose_of_Funding__c='Test',Interested_within_2_4_weeks__c=true);
        insert ObjLead;
        
         Adobe_Templates__c objAdobeTemp = new Adobe_Templates__c(name='Adobe Template Id');
        insert objAdobeTemp;
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new SendApplicationMock());
            ApexPages.StandardController sc = new ApexPages.StandardController(objLead);
            apexpages.currentpage().getparameters().put('id',objLead.id);
            SendApplicationController objController = new SendApplicationController(sc);            
            objController = new SendApplicationController(sc);
            objController.adobePDF = true;
            objController.sendAppLink = true;
            objController.sendPDF = true;
            objController.sendMobile = false;   
            //objController.sendPhone = false;
            objController.SendApplication();            
        Test.stopTest();
    }
}