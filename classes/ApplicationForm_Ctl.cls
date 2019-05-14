/*
Initial Application Form Controller
Test Class: 
------------------------------------------------------------------------------------
Author           | Project       |Date           | Description
------------------------------------------------------------------------------------
Aditya           | Red Payment   | 06/14/2018    | Initial creation
---------------------------------------------------------------------------------------------------------------------
*/
public class ApplicationForm_Ctl {
    public Cloufi__Application__c objApplication{get;set;}
    public Cloufi__Application__c objLeadApp{get;set;}
    public Lead objLead{get;set;}
    public Boolean renderOffers{get;set;}
    public Boolean isSubmit{get;set;}
    public Decimal offerValue{get;set;}
    public String formattedOfferValue{get;set;}
    public Boolean isInvalid{get;set;}
    public String settlementDay{get;set;}
    public String meetingDate{get;set;}
    public time meetingTime{get;set;}
    public String meetingType{get;set;}
    
    public ApplicationForm_Ctl(ApexPages.StandardController controller){
        objApplication = new Cloufi__Application__c();
        objLeadApp = new Cloufi__Application__c();
        objLead = new Lead();
        renderOffers = false;
        isSubmit = false;
        offerValue = 0;
        isInvalid = false;
        settlementDay = '';
    }
    
    public void Proceed(){
        renderOffers = true;
        if(ObjApplication.Average_Monthly_Revenue__c == '$0 - $4,999' || ObjApplication.Time_in_Business__c == '0-3 Months'){
            isInvalid = true;               
        }else{
            // Create Lead and Application
            system.debug('Cloufi__Business_DBA_Name__c=='+objApplication.Cloufi__Business_DBA_Name__c);
            objLead.LastName = objApplication.Cloufi__Business_DBA_Name__c;
            objLead.Company = objApplication.Cloufi__Business_DBA_Name__c;
            objLead.Average_Monthly_Revenue__c = objApplication.Average_Monthly_Revenue__c;
            objLead.Time_in_Business__c = objApplication.Time_in_Business__c;
            objLead.Phone = objApplication.Business_Cell_Phone_Number__c;
            objLead.Country = 'Canada';
            objLead.Country__c = 'Canada';
            objLead.Campaign__c = 'MapleAdvance.com Form';
            objLead.LeadSource = 'Maple Advance';
            objLead.Unconverted_Lead_ByPass__c = true;
            insert objLead;
            
            /*objApplication.Cloufi__Lead__c = objLead.id;
            insert objApplication;*/
            system.debug('objApplication.Cloufi__Lead__c=>'+objApplication.Cloufi__Lead__c);
            
            if(objApplication.Average_Monthly_Revenue__c == '$0 - $4,999'){
                offerValue = 7500;//4999*1.5;
                formattedOfferValue = String.valueOf(offerValue.format());
            }else if(objApplication.Average_Monthly_Revenue__c == '$5,000 - $9,999'){
                offerValue = 15000;//9999*1.5;
                formattedOfferValue = String.valueOf(offerValue.format());
            }else if(objApplication.Average_Monthly_Revenue__c == '$10,000 - $24,999'){
                offerValue = 37500;//24999*1.5;
                formattedOfferValue = String.valueOf(offerValue.format());
            }else if(objApplication.Average_Monthly_Revenue__c == '$25,000 - $49,999'){
                offerValue = 75000;//49999*1.5;
                formattedOfferValue = String.valueOf(offerValue.format());
            }else if(objApplication.Average_Monthly_Revenue__c == '$50,000 - $99,999'){
                offerValue = 150000;//99999*1.5;
                formattedOfferValue = String.valueOf(offerValue.format());
            }else if(objApplication.Average_Monthly_Revenue__c == '$100,000 - $249,999'){
                offerValue = 375000;//249999*1.5;
                formattedOfferValue = String.valueOf(offerValue.format());
            }else if(objApplication.Average_Monthly_Revenue__c == '$250,000+'){
                offerValue = 375000;//250000*1.5;
                formattedOfferValue = String.valueOf(offerValue.format());
            }
        }
        Map<Date, Set<String>> holidayMap;
        holidayMap = ApplicationUtil.getHolidayMap();
        date settlementDate = ApplicationUtil.getNextSettlementDate('ACH.Com',holidayMap);
        settlementDay = ApplicationUtil.getDayOfWeek(settlementDate);        
    }
    
    
    public PageReference createApplication(){        
        try{
            objLeadApp = [SELECT id,cloufi__Lead__c FROM cloufi__Application__c WHERE cloufi__Lead__c=:objLead.id];
            system.debug('objLeadApp=>'+objLeadApp);
            //Validation on credit score and average monthly revenue
            if(ObjApplication.Average_Monthly_Revenue__c == '$0 - $4,999' ||  ObjApplication.Time_in_Business__c == '0-4 Months'){
                isInvalid = true;               
            }else{
                system.debug('objApplication.Cloufi__Amount_Requested__c=>'+objApplication.Cloufi__Amount_Requested__c);
                objLead = [SELECT id,LastName,Company,Average_Monthly_Revenue__c,Legal_Corporate_Name__c,Time_in_Business__c,Cloufi__Monthly_Gross_Sale__c,Cloufi__Business_DBA_Name__c,Cloufi__Years_In_Business__c,FirstName,Website,CreditScore__c,Industry,MobilePhone,Street,State,City,PostalCode,Phone,Fax,Email, Type_Of_Business__c FROM Lead WHERE id=:objLeadApp.Cloufi__Lead__c LIMIT 1];
                system.debug('objLead=>'+objLead);
                objLead.LastName = objApplication.Cloufi__Last_Name__c;
                objLead.Company = objApplication.Cloufi__Business_DBA_Name__c;
                objLead.Average_Monthly_Revenue__c = objApplication.Average_Monthly_Revenue__c;
                objLead.Time_in_Business__c = objApplication.Time_in_Business__c;
                objLead.Phone = objApplication.Business_Cell_Phone_Number__c;
                
                objLead.FirstName = objApplication.Cloufi__First_Name__c;
                objLead.Email = objApplication.Cloufi__Email__c;
                objLead.Cloufi__Years_In_Business__c = objApplication.Cloufi__Yrs_In_Business__c;            
                objLead.Cloufi__Monthly_Gross_Sale__c = objApplication.Cloufi__Monthly_Gross_Sale__c;
                objLead.CreditScore__c = objApplication.CreditScore__c;
                objLead.Industry = objApplication.Cloufi__Industry_Type__c;
                objLead.MobilePhone = objApplication.Telephone_Number__c;
                //objLead.Cloufi__Amount_Requested__c = objApplication.Cloufi__Amount_Requested__c;
                objLead.Purpose_of_Funding__c = objApplication.How_will_you_use_the_loan__c;
                objLead.Type_Of_Business__c = objApplication.Cloufi__Type_Of_Business__c;
                objLead.Cloufi__Amount_Requested__c = Decimal.ValueOf(string.valueOf(objApplication.Cloufi__Amount_Requested__c).replace('$', ''));
                update objLead;
                
                Cloufi__Application__c objApp = [SELECT id,Cloufi__Type_Of_Business__c,Cloufi__First_Name__c,Cloufi__Last_Name__c,Cloufi__Email__c,Telephone_Number__c,Cloufi__Phone_Bank_Info__c,Cloufi__Amount_Requested__c,How_will_you_use_the_loan__c,Cloufi__Industry_Type__c FROM Cloufi__Application__c WHERE id=:objLeadApp.id];
                system.debug('objApp=>'+objApp);
                objApp.Cloufi__First_Name__c = objApplication.Cloufi__First_Name__c;
                objApp.Cloufi__Last_Name__c = objApplication.Cloufi__Last_Name__c;
                objApp.Cloufi__Email__c = objApplication.Cloufi__Email__c;
                objApp.Telephone_Number__c = objApplication.Telephone_Number__c;
                objApp.Cloufi__Amount_Requested__c = Decimal.ValueOf(string.valueOf(objApplication.Cloufi__Amount_Requested__c).replace('$', ''));
                //objApp.Cloufi__Amount_Requested__c= objApplication.Cloufi__Amount_Requested__c;
                objApp.How_will_you_use_the_loan__c= objApplication.How_will_you_use_the_loan__c;
                objApp.Cloufi__Type_Of_Business__c = objApplication.Cloufi__Type_Of_Business__c;
                update objApp;
                isSubmit = true;           
            }
            //submitApplication();
            PageReference objPR = new PageReference('/apex/completeApplicationForm?id='+objLeadApp.Id);
            objPR.setRedirect(true);
            return objPR;       
       }catch(Exception ex){            
            System.debug('Exception '+ex.getMessage());
            System.debug('Exception '+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            return null;
        }
        //return null;
    }
    
    public PageReference submitApplication(){
        PageReference objPR = new PageReference('/apex/completeApplicationForm?id='+objLeadApp.Id);
        objPR.setRedirect(true);
        return objPR;
    }
    
    public  PageReference goBack(){
        isInvalid = false;
        renderOffers = false;
        return null;
    }
    
    /*public PageReference seeOffers(){
        PageReference objPR = new PageReference('/apex/AvailableOffers?applicationId='+objApplication.Id);
        objPR.setRedirect(true);
        return objPR;        
    }*/
    
    public List<SelectOption> getContactWay(){
        List<SelectOption> ContactWayName = new List<SelectOption>();
            ContactWayName.add(new SelectOption('--None--','--None--'));
            ContactWayName.add(new SelectOption('Call','Call'));
            ContactWayName.add(new SelectOption('Email','Email'));
            ContactWayName.add(new SelectOption('Text','Text'));
        return ContactWayName;
    }
}