/*****************************************************************
* Author: Techila Global Services Pvt Ltd. 
* Class Name: OpportunityDocumentsController
* Created Date: 
* Description: Controller to Upload Opportunity Offer
*******************************************************************/
/*Author            | Date       | Description
Neha               | 26-Jan-2019| Updated saveNewOffer Method
**/
public class CloneOpportunityofferController {
    
    @AuraEnabled
    public static Map<String,String> saveOffer(List<Cloufi__Offers__c> lstOffer) {
        Map<String,String> msg = new Map<String,String>();
        system.debug('lstOffer>>'+lstOffer);
        try{
            List<Cloufi__Offers__c> lstOffer1 = new List<Cloufi__Offers__c>();
            Map<Id,Cloufi__Offers__c> mapOldOffers = new Map<Id,Cloufi__Offers__c>();
            //String oppId = lstOffer[0].Cloufi__Opportunity__c;
            for(Cloufi__Offers__c objOldOffer:[SELECT id,Cloufi__Offer_Status__c,Cloufi__Opportunity__c FROM Cloufi__Offers__c WHERE Cloufi__Opportunity__c=:lstOffer[0].Cloufi__Opportunity__c]){
                mapOldOffers.put(objOldOffer.id,objOldOffer);
            }
            system.debug('mapOldOffers >>'+mapOldOffers);
            for(integer i=0;i<lstOffer.size();i++){
                if(lstOffer[i].Cloufi__Offer_Status__c != 'Expired'){
                    lstOffer1.add(lstOffer[i]);
                }else{
                    Cloufi__Offers__c oldOffer = mapOldOffers.get(lstOffer[i].id);
                    if(oldOffer.id == lstOffer[i].id && lstOffer[i].Cloufi__Offer_Status__c == 'Expired' && oldOffer.Cloufi__Offer_Status__c != 'Expired'){
                        lstOffer1.add(lstOffer[i]);
                    }
                }
            }
            system.debug('lstOffer1 >>'+lstOffer1);
            update lstOffer1;
            msg.put('Success','Offer Updated');
        }catch(Exception ex){
            string strMessageToDisplay='';
            System.debug('Exception '+ex.getMessage());
            System.debug('Exception '+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            //msg.put('Error',ex.getMessage().substringAfter(':'));
            strMessageToDisplay = ex.getMessage().substringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION,');  
            strMessageToDisplay = strMessageToDisplay.substring(0,strMessageToDisplay.length()-4);
            System.debug('strMessageToDisplay=>'+strMessageToDisplay);
            msg.put('Error',strMessageToDisplay);
        }
        return msg;
    }
    
    @AuraEnabled
    public static Cloufi__Offers__c initNewOffer(){
        Cloufi__Offers__c objOffer = new Cloufi__Offers__c();
        objOffer.Program__c = null;
        return objOffer;
    }
    
    @AuraEnabled
    public static List<Cloufi__Offers__c> fetchOffer(Id oppId) {
        List<Cloufi__Offers__c> lstOffer = new List<Cloufi__Offers__c>();
        system.debug('oppId'+oppId);
        User oUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
        system.debug('oUser=>'+oUser);
        DescribeSObjectResult describeResultOffer = Cloufi__Offers__c.getSObjectType().getDescribe();
        List<String> OfferfieldNames = new List<String>(describeResultOffer.fields.getMap().keySet());
        String query = '';
        if(oUser.Profile.Name =='Cash Advance Sales Agent'){
            query = ' SELECT ' + String.join( OfferfieldNames, ',' ) + ', recordType.name FROM Cloufi__Offers__c WHERE Cloufi__Offer_Status__c!= \'New\' and Cloufi__Opportunity__c = '+'\''+oppId+'\'';
        }else{
            query = ' SELECT ' + String.join( OfferfieldNames, ',' ) + ', recordType.name FROM Cloufi__Offers__c WHERE Cloufi__Opportunity__c = '+'\''+oppId+'\'';
        }
        system.debug('query'+query);
        lstOffer = Database.query(query); 
        system.debug('lstOffer'+lstOffer);
        return lstOffer;
    }
    
    @AuraEnabled
    public static List <Cloufi__Offers__c> cancelOffer(List<Cloufi__Offers__c> lstOffer) {
        String oppId = lstOffer[0].Cloufi__Opportunity__c;
        DescribeSObjectResult describeResultOffer = Cloufi__Offers__c.getSObjectType().getDescribe();
        List<String> OfferfieldNames = new List<String>(describeResultOffer.fields.getMap().keySet());     
        String query = ' SELECT ' + String.join( OfferfieldNames, ',' ) + ', recordType.name FROM Cloufi__Offers__c WHERE Cloufi__Opportunity__c = '+'\''+oppId+'\'';
        lstOffer = Database.query(query); 
        return lstOffer;
    }
    
    @AuraEnabled 
    public static user fetchUser(){
        // query current user information  
        User oUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
    
    @AuraEnabled
    public static List <String> getselectOptions(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getlabel());
        }
        return allOpts;
    }
    
    // Aditya - Method to fetch Opportunity is in Approved stage or not
    @AuraEnabled
    public static Boolean isOppInApprovedStage(Id oppId){
        Boolean appStage = false;
        opportunity objOpp = [SELECT id,StageName FROM Opportunity WHERE id=:oppId];
        if(objOpp.StageName =='Approved'){
            appStage = true;
        }
        return appStage;
    }

    // Aditya - To check Submission coutry
    @AuraEnabled
    public static Boolean checkSubmissionCountry(Id oppId,Id accId){
        Boolean validFunder = false;
        opportunity objOpp = [SELECT id,CloufiServicing__Submission_Country__c FROM Opportunity WHERE id=:oppId];
        Account objAcc = [SELECT id,Country__c FROM Account WHERE id=:accId];

        if(objOpp.CloufiServicing__Submission_Country__c == objAcc.Country__c){
            validFunder = true;
        }
        return validFunder;
    }
    
    @AuraEnabled
    public static List<Cloufi__UW_Document__c> getCompletedUWDocumentList(Id oppId){
        return [select id,Stip_Name__c,Cloufi__URL__c,Cloufi__Opportunity__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c= : oppId and Cloufi__URL__c!=null AND Status__c='Completed'];
    }
    
    @AuraEnabled
    public static opportunity getCurrentOpp(Id oppId){
        system.debug('oppId=>'+oppId);
        opportunity objOpp = [select id,Cloufi__Gross_Profit__c,Name,Amount,Amount_Requested__c from opportunity Where id =: oppId];
        return objOpp;
        //return [select id,Cloufi__Gross_Profit__c,Name from opportunity where id= : oppId];
    }
    
    @AuraEnabled
    public static Map<String,string> requestContract(List<string> stipIds,Id oppId){
        Map<String,string> msg = new Map<String,string>();
        List<Cloufi__UW_Document__c> updateLstUw = new List<Cloufi__UW_Document__c>();
        List<Cloufi__UW_Document__c> lstUw = new List<Cloufi__UW_Document__c>();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: Label.CPS_Sales_Support_Email];
        List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
        Opportunity objOpportunity = [SELECT Id, Name, Cloufi__Funder__c, Cloufi__Funder__r.Name, Company_Logo__c, StageName FROM Opportunity WHERE Id =:oppId LIMIT 1];
        if(objOpportunity.Cloufi__Funder__c !=null){
            Account objAccount = [SELECT Id, Name, (SELECT Id, Name, Email FROM Contacts WHERE Email != null AND Contract__c = true) FROM Account WHERE ID =: objOpportunity.Cloufi__Funder__c];
            if(stipIds.size()>0){
                lstUw = [select id,Sent_for_Contract__c,Stip_Name__c,Cloufi__URL__c,Cloufi__Opportunity__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c=:oppId];  
                system.debug('lstUw=>'+lstUw);
            }
            
            List<EmailTemplate> templateList = [SELECT Id, Body FROM EmailTemplate WHERE DeveloperName = 'Request_Contract'];
            if(objAccount.Contacts.size()>0 && templateList.size()>0){
                List<String> emailIds = new List<String>();
                for(Contact objContact : objAccount.Contacts){
                    emailIds.add(objContact.Email);
                }
                Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                emailMsg.setTargetObjectId(objAccount.Contacts[0].id);
                emailMsg.setWhatId(objOpportunity.id);
                emailMsg.setTemplateId(templateList[0].id);
                emailMsg.SaveAsActivity = False;
                emailMsg.setTreatTargetObjectAsRecipient(false);
                emailMsg.setToAddresses(emailIds);
                if ( owea.size() > 0 ) {
                    emailMsg.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                system.debug('emailMsg=>'+emailMsg);
                lstEmailMsg.add(emailMsg);
            }else{
                msg.put('WARNING','Please select Contract checkbox under desired Contact to get Email notification');
            }
            if(lstEmailMsg.size()>0){
                Messaging.sendEmail(lstEmailMsg);
                if(objOpportunity.StageName == 'Approved'){
                    objOpportunity.StageName = 'Contract Requested';
                    update objOpportunity;
                    if(lstUw.size()>0){
                        for(Cloufi__UW_Document__c objUW:lstUw){
                            if(stipIds.contains(objUW.id)){
                                objUW.Sent_for_Contract__c = true;
                            }else{
                                objUW.Sent_for_Contract__c = false;
                            }
                            
                            updateLstUw.add(objUW);
                        }
                        system.debug('updateLstUw=>'+updateLstUw);
                        if(updateLstUw.size()>0){
                            update updateLstUw;
                        }
                    }
                }
                msg.put('Success','Email send successfully');
            }
        }
        return msg;
        // msg.put('Warning','Somthing went wrong');
    }
    
    // Aditya - Method to check offer is choosen 
    @AuraEnabled
    public static Boolean isOfferChosen(Id oppId){
        Boolean funder = false;
        opportunity objOpp = [SELECT id,Cloufi__Funder__c,(SELECT id,Cloufi__Offer_Status__c FROM cloufi__Offers__r WHERE Cloufi__Offer_Status__c='Chosen') FROM Opportunity WHERE id=:oppId];
        if(objOpp.cloufi__Offers__r.size()>0){
            funder = true;
        }
        return funder;
    }
    
    // Aditya - Method to check offer is choosen 
    @AuraEnabled
    public static Boolean isReqDocsAvailable(Id oppId){
        Boolean docsAvailable = false;
        opportunity objOpp = [SELECT id,Cloufi__Funder__c,(SELECT id,Name,Status__c FROM cloufi__Dropbox_Attachments__r WHERE (Name='Drivers License' OR Name='Voided Check') AND Status__c='Completed') FROM Opportunity WHERE id=:oppId];
        if(objOpp.cloufi__Dropbox_Attachments__r.size()==2 ){
            docsAvailable = true;
        }
        return docsAvailable;
    }
    
    /* @AuraEnabled
            public static Cloufi__Offers__c saveNewOfferController(Cloufi__Offers__c objOffer,Id oppId,String programId){
            System.debug('objOffer>>'+objOffer);
            if(objOffer != null){
            objOffer.Cloufi__Opportunity__c = oppId;
            objOffer.Cloufi__Offer_Status__c = 'Reviewed';
            if(programId!=null && programId!=''){
            objOffer.Program__c = programId;
            }
            if(objOffer.Program_Type__c =='MCA'){
            objOffer.Cloufi__Daily_PB_Amount__c = 0;
            objOffer.Cloufi__Percentage_Of_Gross__c = 0;
            }else{
            objOffer.Holdback_Per__c = 0;
            }
            
            if(objOffer.Cloufi__Terms_In_Months__c != null && objOffer.Cloufi__Funding_Amount__c != null && objOffer.Cloufi__Payback_Amount__c != null && objOffer.Factor_Rate__c != null && objOffer.Cloufi__Daily_PB_Amount__c != null && objOffer.Cloufi__Percentage_Of_Gross__c != null) {
            insert objOffer;
            }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Blank Offer can not be Saved'));
            return null;
            }
            
            system.debug('objOffer=>'+objOffer);       
            }
            
            return objOffer;
            }*/
    
    @AuraEnabled
    public static boolean checkForSignedApp(Id oppId){
        String query = 'select name,Cloufi__URL__c,Cloufi__Type__c,Stip_Name__c, Status__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c= : oppId AND (Stip_Name__c LIKE \'%Bank Statement%\' OR Stip_Name__c=\'Signed Application\' OR Stip_Name__c LIKE \'%Processing Statement%\') AND Cloufi__URL__c != null AND Status__c = \'Completed\'';        
        List<Cloufi__UW_Document__c> docList = database.query(query);
        integer appCount = 0;
        integer bankStmtCount = 0;
        boolean isAvailable = false;
        
        //iterate through the document list
        for(Cloufi__UW_Document__c objUW : docList){
            if(objUW.Stip_Name__c.tolowercase() == 'signed application'){
                if(objUW.Status__c == 'Completed'){
                    appCount += 1;
                }
            }
            if(objUW.Cloufi__Type__c == 'Bank Statement'){
                if(objUW.Status__c == 'Completed'){
                    bankStmtCount +=1;
                }
            }
        }
        
        System.debug('appCount>>'+appCount+'  bankStmtCount>>'+bankStmtCount);
        
        if(appCount==1 && bankStmtCount>=3){
            isAvailable = true;
        }else if(appCount==0 && bankStmtCount<3){
            isAvailable = false;
        }
        
        System.debug('isAvailable>>'+isAvailable);
        //List<Cloufi__UW_Document__c> objUWDoc = [select id,Stip_Name__c,Cloufi__URL__c,Cloufi__Opportunity__c,Status__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c= : oppId AND Cloufi__URL__c!=null AND (Stip_Name__c ='Signed Application' || )AND Status__c = 'Completed'];
        //system.debug('objUWDoc>>'+objUWDoc +'  size>>'+objUWDoc.size());
        /*if(objUWDoc.size() > 0){
            isAvailable = true;
        }else{
            isAvailable = false;
        }*/
        return isAvailable;
    }
    @AuraEnabled
    public static Map<String,String> saveNewOfferController(Cloufi__Offers__c objOffer,Id oppId,String programId){
        Map<String,String> msg = new Map<String,String>();
        List<Cloufi__Submission__c> submissionList = new List<Cloufi__Submission__c>();
        List<Cloufi__Product__c> objProgram  = new List<Cloufi__Product__c>();
        
        
        System.debug('objOffer>>'+objOffer);
        try{
            if(objOffer.Cloufi__Terms_In_Months__c != null && objOffer.Cloufi__Funding_Amount__c != null && objOffer.Cloufi__Payback_Amount__c != null && objOffer.Factor_Rate__c != null && objOffer.Cloufi__Daily_PB_Amount__c != null && objOffer.Cloufi__Percentage_Of_Gross__c != null) {
                if(programId != null){
                    objProgram =[select id,Cloufi__Account__c from Cloufi__Product__c where Id =: programId];
                    if(objProgram.size() > 0 && objProgram[0].Cloufi__Account__c != null){
                        submissionList = [select id,Cloufi__Status__c from Cloufi__Submission__c where Cloufi__Program__c =: programId AND Cloufi__Lender__c =: objProgram[0].Cloufi__Account__c AND Cloufi__Opportunity__c =: oppId];
                    }
                }
                
                Opportunity Loan = [select id,StageName from Opportunity where Id=: oppId];
                List<Cloufi__Offers__c> offerList = [select id from Cloufi__Offers__c where Cloufi__Opportunity__c =: oppId];
                
                if(objOffer != null){
                    objOffer.Cloufi__Funder__c = objOffer.Funder_Dev__c;
                    objOffer.Cloufi__Opportunity__c = oppId;
                    objOffer.Cloufi__Offer_Status__c = 'Reviewed';
                    if(programId!=null && programId!=''){
                        objOffer.Program__c = programId;
                    }
                    
                    //if(objSubmission.Id != null){
                    if(submissionList.size() > 0){
                        Cloufi__Submission__c objSubmission = submissionList[0];
                        if(objSubmission.Cloufi__Status__c == 'Expired' || objSubmission.Cloufi__Status__c == 'Rejected' || objSubmission.Cloufi__Status__c == 'Requested'){
                            objSubmission.Cloufi__Status__c = 'Received';
                        }
                        update objSubmission;
                        objOffer.Cloufi__Submission__c = objSubmission.Id;  
                    }else{
                        Cloufi__Submission__c objSubmission = new Cloufi__Submission__c();
                        objSubmission.Cloufi__Status__c = 'Received';
                        objSubmission.Cloufi__Program__c = programId;
                        objSubmission.Cloufi__Opportunity__c = oppId;
                        objSubmission.Cloufi__Lender__c = objProgram[0].Cloufi__Account__c;
                        objSubmission.Cloufi__Submission_Type__c = 'Manual';
                        insert objSubmission;
                        objOffer.Cloufi__Submission__c = objSubmission.Id;  
                    }
                    
                    if(objOffer.Program_Type__c =='MCA'){
                        objOffer.Cloufi__Daily_PB_Amount__c = 0;
                        objOffer.Cloufi__Percentage_Of_Gross__c = 0;
                    }else{
                        objOffer.Holdback_Per__c = 0;
                    }
                    
                    if(objOffer.Holdback_Per__c > 100){
                        msg.put('WARNING','Holdback % can not be greater than 100');
                    }else if(objOffer.Cloufi__Percentage_Of_Gross__c > 100){
                        msg.put('WARNING','Percentage of gross can not be greater than 100');
                    }else{
                        if(loan.StageName == 'UW' && offerList.size()<=0){
                            loan.StageName = 'Approved';
                        }else if(loan.StageName == 'App In Missing Info'){
                            loan.StageName = 'Approved';
                        }
                            
                        insert objOffer;
                        update loan;
                        msg.put('Success','Record saved succesfully');
                    }
                }else{
                    msg.put('WARNING','Blank offer cannot be saved');
                }
            }else{
                msg.put('WARNING','Blank offer cannot be saved');
            }
            
            system.debug('objOffer=>'+objOffer);       
        }catch(Exception ex){
            string strMessageToDisplay='';
            System.debug('Exception '+ex.getMessage());
            System.debug('Exception '+ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            //msg.put('Error',ex.getMessage().substringAfter(':'));
            strMessageToDisplay = ex.getMessage().substringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION,');  
            strMessageToDisplay = strMessageToDisplay.substring(0,strMessageToDisplay.length()-4);
            System.debug('strMessageToDisplay=>'+strMessageToDisplay);
            msg.put('Error',strMessageToDisplay);
        }
        return msg;
    }
    
    @auraEnabled
    public static List<programInformation> getProgramDetails(Id accId){
        System.debug('accId>>'+accId);
        //String networkPlatform;
        List<programInformation> listProg = new List<programInformation>();
        List<Cloufi__Product__c> programList = new List<Cloufi__Product__c>([SELECT Id,Name FROM Cloufi__Product__c WHERE Cloufi__Account__c =:accId]);
        for(Cloufi__Product__c objProg:[SELECT Id,Name FROM Cloufi__Product__c WHERE Cloufi__Account__c =:accId]){
            listProg.add(new programInformation(objProg.Id, objProg.Name));
        }
        
        System.debug('listProg==>'+listProg);
        return listProg;
    }
    
    
    public class programInformation{
        @auraEnabled
        public String programId{get;set;}
        
        @auraEnabled
        public String programName{get;set;}
        
        public programInformation(String programId, String programName){
            this.programId = programId;
            this.programName = programName;
        }
    }
    
    
}