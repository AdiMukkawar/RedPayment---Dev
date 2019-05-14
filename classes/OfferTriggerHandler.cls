/**
Author  | Date       | Description
Neha    | 08/09/2018 | Trigger to update submission status on approving offer
Aditya  | 08/24/2018 | Send an email to the "Revision" contacts under the Offers Submission Lender
Neha    | 08/30/2018 | Updated to send email to sales support on approving offer
Neha    | 09/11/2018 | Updated submission status to decline when all offers are rejected for the respective submission
Aditya  | 09/14/2018 | Whenever New Offer gets created, an email should go out to Sales Support of Opportunity Owner's Sales Support group email
Aditya  | 09/28/2018 | For custom offer send alert to sales support
Aditya  | 10/03/2018 | Removed Opportunity stage update from Approved to Contract Requested
Neha    | 10/10/2018 | Restructured trigger and handler
Aditya  | 12/05/2018 | Update submission status if some offers status are Rejected and other are Expired
Aditya  | 12/06/2018 | 1. If rejected offer update as New and all other related offers are Rejected / Expired then update submission status as Received
                       2. If chosen offer update then update submission status
**/

public class OfferTriggerHandler {    
    
    //Aditya - Send an Email to Sales Support of Opportunity Owner's Sales Support group email when offer get created
    public static void sendMailToSupportGroup(List<Cloufi__Offers__c> newOffers){
        system.debug('Inside Offer trigger, sendMailToSupportGroup, newOffers>>'+newOffers);
        try{
            Set<Id> offerId = new Set<id>();
            Set<Id> opportunityId = new Set<Id>();
            map<Id,Id> mapOfferIdOppId = new map<Id,Id>();
            map<Id,Opportunity> mapOfferIdOpp = new map<Id,Opportunity>();
            Map<ID,Schema.RecordTypeInfo> rt_Map = Cloufi__Offers__c.sObjectType.getDescribe().getRecordTypeInfosById();
            
            String templateId ;
            String userId ;
            String whatId;
            
            //get opportunity of offer
            for(Cloufi__Offers__c objOffer : newOffers){
                offerId.add(objOffer.id);
                opportunityId.add(objOffer.Cloufi__Opportunity__c);
                mapOfferIdOppId.put(objOffer.id,objOffer.Cloufi__Opportunity__c);
            }
            
            for(Opportunity objOpportunity:[SELECT id,OwnerId,Owner.Sales_Support_Email__c,(SELECT id,createdDate FROM Cloufi__Offers__r order by createdDate DESC limit 1) FROM Opportunity WHERE id in:opportunityId]){
                for(Cloufi__Offers__c objO:objOpportunity.Cloufi__Offers__r){
                    if(mapOfferIdOppId.containsKey(objO.id)){
                        mapOfferIdOpp.put(objO.id,objOpportunity);
                    }
                }
            }
            system.debug('mapOfferIdOpp >>'+mapOfferIdOpp);
            List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
            if(mapOfferIdOpp.size()>0){
                EmailTemplate standardEmailTemp = [select id from EmailTemplate where DeveloperName = 'Support_Group_offer_email_Rep'];
                EmailTemplate customEmailTemp = [select id from EmailTemplate where DeveloperName = 'Support_Group_Custom_offer_email'];
                for(Cloufi__Offers__c objOffer : newOffers){
                    if(mapOfferIdOpp.get(objOffer.id) != null){
                        Opportunity objOpp = mapOfferIdOpp.get(objOffer.id);
                        List<String> ToEmailIds=new List<String>();
                        if(objOpp.Owner.Sales_Support_Email__c !=null){
                            ToEmailIds.add(objOpp.Owner.Sales_Support_Email__c);
                        }
                        if(rt_map.get(objOffer.recordTypeID).getName().containsIgnoreCase('Standard')){
                            templateId = standardEmailTemp.id;
                        }else if(rt_map.get(objOffer.recordTypeID).getName().containsIgnoreCase('Custom')){
                            templateId = customEmailTemp.id;
                        }
                        userId = objOpp.OwnerId;
                        whatId = objOffer.Id;
                        
                        Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(templateId, userId, whatId);
                        //Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                        email.setToAddresses(ToEmailIds);
                        email.setTargetObjectId(userId);
                        //email.setWhatId(objOffer.Id);
                        //emailMsg.setTemplateId(standardEmailTemp.id);
                        /*if(rt_map.get(objOffer.recordTypeID).getName().containsIgnoreCase('Standard')){
                            emailMsg.setTemplateId(standardEmailTemp.id);
                        }else if(rt_map.get(objOffer.recordTypeID).getName().containsIgnoreCase('Custom')){
                            emailMsg.setTemplateId(customEmailTemp.id);
                            if(mapOfferIdAttachment.size()>0){
                                Attachment att = mapOfferIdAttachment.get(objOffer.id);
                                if(mapOfferIdAttachment.get(objOffer.id) !=null){
                                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                                    efa.setFileName(att.Name);
                                    efa.setBody(att.body);
                                    efa.setContentType(att.ContentType);
                                    efa.setInline(false);
                                    emailMsg.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                                }
                            }                            
                        }
                        emailMsg.SaveAsActivity = False;
                        emailMsg.setTreatTargetObjectAsRecipient(false);*/
                        email.SaveAsActivity = False;
                        email.setTreatTargetObjectAsRecipient(false);
                        system.debug('email=>'+email);
                        if(ToEmailIds.size()>0){
                            lstEmailMsg.add(email);                      
                        }                       
                    }
                }
            }
            if(lstEmailMsg.size()>0){
                Messaging.sendEmail(lstEmailMsg);
            }
        }catch(exception ex){
            System.debug('error -->'+ex.getMessage()+' on line --> '+ex.getLineNumber());
            System.debug('*****error*****'+ex.getStackTraceString());
        }
    }
    
    //restrict offer insertion on approved submission
    /*public static void restrictOffers(List<Cloufi__Offers__c> newOffers){
        Set<Id> submissionId = new Set<Id>();
        for(Cloufi__Offers__c objOffer : newOffers){
            submissionId.add(objOffer.Cloufi__Submission__c);
        }
        
        Map<id,Cloufi__Submission__c> submissionMap = new Map<id,Cloufi__Submission__c>([select id ,name ,Cloufi__Status__c from Cloufi__Submission__c where ID IN: submissionId]);
        for(Cloufi__Offers__c parentOffer : newOffers){
            if(submissionMap.containsKey(parentOffer.Cloufi__Submission__c) && submissionMap.get(parentOffer.Cloufi__Submission__c).Cloufi__Status__c == 'Approved'){
                parentOffer.addError('Can not insert offer on approved submission');
            }
        }
    }*/
    //Aditya -12/07/2018 If rejected offer update then update submission status
    public static void oldRejectedToReceivedSubmission(List<Cloufi__Offers__c> oldRejectedOffers){
        //To update status on submission on changing offer status 
        Set<Id> offerId = new Set<id>();
        Set<Id> opportunityIdSet = new Set<Id>();
        Set<Id> submissionIdSet = new Set<Id>();
        
        for(Cloufi__Offers__c objOffer: oldRejectedOffers){
            offerId.add(objOffer.Id);
            opportunityIdSet.add(objOffer.Cloufi__Opportunity__c);
            if(objOffer.Cloufi__Submission__c != null){
                submissionIdSet.add(objOffer.Cloufi__Submission__c);
            }
        }
        //Fetched submission along with related offers
        Map<id,Cloufi__Submission__c> submissionMap = new Map<id,Cloufi__Submission__c>([select id ,name ,Cloufi__Status__c from Cloufi__Submission__c where Cloufi__Opportunity__c IN: opportunityIdSet ]);
        Map<id,List<Cloufi__Offers__c>> submissionIdOffersMap = new Map<id,List<Cloufi__Offers__c>>();
        List<Cloufi__Offers__c> allOffers = [select id,name,Cloufi__Submission__c,Cloufi__Opportunity__c, Cloufi__Opportunity__r.Name ,Cloufi__Offer_Status__c from Cloufi__Offers__c where Cloufi__Submission__c IN: submissionIdSet];// AND Id not in :offerId
        for(Cloufi__Offers__c objOff:allOffers){
            if(!submissionIdOffersMap.containsKey(objOff.Cloufi__Submission__c))
                submissionIdOffersMap.put(objOff.Cloufi__Submission__c,new List<Cloufi__Offers__c>());
            submissionIdOffersMap.get(objOff.Cloufi__Submission__c).add(objOff);
        }
        if(submissionIdSet.size()>0){
            for(Id subId:submissionIdSet){
                Integer rejExpOffers = 0;
                Boolean updateStatus = false;
                if(submissionIdOffersMap.get(subId) != null){
                    for(Cloufi__Offers__c objOffer:submissionIdOffersMap.get(subId)){
                        System.debug('objOffer.Cloufi__Offer_Status__c-->'+objOffer.Cloufi__Offer_Status__c);
                        if(objOffer.Cloufi__Offer_Status__c == 'Rejected' || objOffer.Cloufi__Offer_Status__c == 'Expired' || objOffer.Cloufi__Offer_Status__c != 'Chosen'){
                            rejExpOffers = rejExpOffers + 1;
                            updateStatus = true;
                            System.debug('rejExpOffers Inside-->'+rejExpOffers);
                        }else if(objOffer.Cloufi__Offer_Status__c != 'Rejected' && objOffer.Cloufi__Offer_Status__c != 'Chosen'){
                            updateStatus = true;
                            rejExpOffers = rejExpOffers + 1;
                            System.debug('rejExpOffers else-->'+rejExpOffers);
                        }else{
                            updateStatus = false;
                            break;
                        }
                        System.debug('rejExpOffers Inside-->'+rejExpOffers);
                        if(rejExpOffers == submissionIdOffersMap.get(subId).size() && updateStatus){
                            System.debug('Inside Reject to app-->');
                            submissionMap.get(objOffer.Cloufi__Submission__c).Cloufi__Status__c = 'Received';
                        }
                    }
                }
            }
            //Update submission
            if(submissionMap.values().size()>0){
                update submissionMap.values();
            }
        }
    }
    
    //Aditya -12/06/2018- If chosen offer update then update submission status
    public static void oldChosenToReceivedSubmission(List<Cloufi__Offers__c> oldChosenOffers){
        Set<Id> submissionIdSet = new Set<Id>();
        
        for(Cloufi__Offers__c objOffer : oldChosenOffers){
            if(objOffer.Cloufi__Submission__c != null){
                submissionIdSet.add(objOffer.Cloufi__Submission__c);
            }
        }
        if(submissionIdSet.size()>0){
            Map<id,Cloufi__Submission__c> submissionMap = new Map<id,Cloufi__Submission__c>([select id ,name ,Cloufi__Status__c from Cloufi__Submission__c where Id IN: submissionIdSet]);
            for(Cloufi__Offers__c objOffer : oldChosenOffers){
                if(objOffer.Cloufi__Offer_Status__c == 'New' || objOffer.Cloufi__Offer_Status__c == 'Presented' || objOffer.Cloufi__Offer_Status__c == 'Reviewed' || objOffer.Cloufi__Offer_Status__c == 'Revision'){
                    submissionMap.get(objOffer.Cloufi__Submission__c).Cloufi__Status__c = 'Received';
                }/*else if(objOffer.Cloufi__Offer_Status__c == 'New'){
                    submissionMap.get(objOffer.Cloufi__Submission__c).Cloufi__Status__c = 'Received';
                }*/
                
            }
            
            //Update submission
            if(submissionMap.values().size()>0){
                update submissionMap.values();
            }
        }
    }
    
    //Aditya -12/06/2018- If rejected offer update as New and all other related offers are Rejected/Expired then update submission status as Received
    public static void rejectToNewSubmission(List<Cloufi__Offers__c> newOffers){
        Set<Id> submissionIdSet = new Set<Id>();
        
        for(Cloufi__Offers__c objOffer : newOffers){
            if(objOffer.Cloufi__Submission__c != null){
                submissionIdSet.add(objOffer.Cloufi__Submission__c);
            }
        }
        if(submissionIdSet.size()>0){
            //Map<id,Cloufi__Submission__c> submissionMap = new Map<id,Cloufi__Submission__c>([select id ,name ,Cloufi__Status__c,Decline_Reason__c from Cloufi__Submission__c where Id IN: submissionIdSet]);
            Map<id,Cloufi__Submission__c> submissionMap = new Map<id,Cloufi__Submission__c>([select id ,name ,Cloufi__Status__c from Cloufi__Submission__c where Id IN: submissionIdSet]);
            
            Map<id,List<Cloufi__Offers__c>> submissionIdOffersMap = new Map<id,List<Cloufi__Offers__c>>();
            List<Cloufi__Offers__c> allOffers = [select id,name,Cloufi__Submission__c,Cloufi__Opportunity__c, Cloufi__Opportunity__r.Name ,Cloufi__Offer_Status__c from Cloufi__Offers__c where Cloufi__Submission__c IN: submissionIdSet];
            for(Cloufi__Offers__c objOff:allOffers){
                if(!submissionIdOffersMap.containsKey(objOff.Cloufi__Submission__c))
                    submissionIdOffersMap.put(objOff.Cloufi__Submission__c,new List<Cloufi__Offers__c>());
                submissionIdOffersMap.get(objOff.Cloufi__Submission__c).add(objOff);
            }
            for(Id objSubId: submissionIdSet){
                if(submissionIdOffersMap.get(objSubId) != null){
                    for(Cloufi__Offers__c objOff:submissionIdOffersMap.get(objSubId)){
                        Boolean updateStatus = false;
                        Integer newStatus = 0;
                        if(objOff.Cloufi__Offer_Status__c == 'Rejected' || objOff.Cloufi__Offer_Status__c == 'Expired' || objOff.Cloufi__Offer_Status__c == 'New'){
                            updateStatus = true;
                            if(objOff.Cloufi__Offer_Status__c == 'New'){
                                newStatus =newStatus+1;
                            }
                        }else{
                            updateStatus = false;
                            break;
                        }
                        if(updateStatus && newStatus==1){
                            submissionMap.get(objOff.Cloufi__Submission__c).Cloufi__Status__c = 'Received';
                        }
                    }
                }
            }
            
            //Update submission
            if(submissionMap.values().size()>0){
                update submissionMap.values();
            }
            
        }
    }
    //reject submission when all offers get rejected
    public static void rejectExpireSubmission(List<Cloufi__Offers__c> rejectedExpiredOffers){
        try{
            Set<Id> submissionIdSet = new Set<Id>();
            integer rejectCount = 0; 
            integer expiredCount = 0;
            
            for(Cloufi__Offers__c objOffer : rejectedExpiredOffers){
                submissionIdSet.add(objOffer.Cloufi__Submission__c);
            }
            
            //Map<id,Cloufi__Submission__c> submissionMap = new Map<id,Cloufi__Submission__c>([select id ,name ,Cloufi__Status__c,Decline_Reason__c from Cloufi__Submission__c where Id IN: submissionIdSet ]); 
            Map<id,Cloufi__Submission__c> submissionMap = new Map<id,Cloufi__Submission__c>([select id ,name ,Cloufi__Status__c from Cloufi__Submission__c where Id IN: submissionIdSet ]); 
            List<Cloufi__Offers__c> allOffers = [select id,name,Cloufi__Submission__c,Cloufi__Opportunity__c, Cloufi__Opportunity__r.Name ,Cloufi__Offer_Status__c from Cloufi__Offers__c where Cloufi__Submission__c IN: submissionIdSet ];        
            
            for(Cloufi__Offers__c objOffer : allOffers){                
                if(objOffer.Cloufi__Offer_Status__c == 'Rejected'){
                    rejectCount +=1;
                }else if(objOffer.Cloufi__Offer_Status__c == 'Expired'){
                    expiredCount +=1;
                }             
            }
            
            if(rejectCount == allOffers.size()){
                for(Cloufi__Offers__c objOffer : rejectedExpiredOffers){
                    if(submissionMap.containsKey(objOffer.Cloufi__Submission__c)){
                        submissionMap.get(objOffer.Cloufi__Submission__c).Cloufi__Status__c = 'Rejected';
                    }
                }            
            }if(expiredCount == allOffers.size()){
                for(Cloufi__Offers__c objOffer : rejectedExpiredOffers){
                    if(submissionMap.containsKey(objOffer.Cloufi__Submission__c)){
                        submissionMap.get(objOffer.Cloufi__Submission__c).Cloufi__Status__c = 'Expired';
                    }
                }            
            }
            // Aditya - Update submission status if some offers status are Rejected and other are Expired
            integer rejExpCount = rejectCount + expiredCount;
            system.debug('rejExpCount=>'+rejExpCount);
            if(rejExpCount == allOffers.size()){
                for(Cloufi__Offers__c objOffer : rejectedExpiredOffers){
                    if(submissionMap.containsKey(objOffer.Cloufi__Submission__c)){
                        if(rejectCount == expiredCount){
                            submissionMap.get(objOffer.Cloufi__Submission__c).Cloufi__Status__c = 'Rejected';
                        }
                        if(rejectCount > expiredCount){
                            submissionMap.get(objOffer.Cloufi__Submission__c).Cloufi__Status__c = 'Rejected';
                        }
                        if(rejectCount < expiredCount){
                            submissionMap.get(objOffer.Cloufi__Submission__c).Cloufi__Status__c = 'Expired';
                        }
                    }
                }
            }
            
            //Update submission
            if(submissionMap.values().size()>0){
                update submissionMap.values();
            }
        }catch(exception ex){
            System.debug('error -->'+ex.getMessage()+' on line --> '+ex.getLineNumber());
            System.debug('*****error*****'+ex.getStackTraceString());
        }
    }
    
    //Update submission on chosing offer and reject other offers
    public static void updateStatus(List<Cloufi__Offers__c> chosenOffers){ 
        try{
            List<Cloufi__Offers__c> listSiblingOffer = new List<Cloufi__Offers__c>();
         
            System.debug('chosenOffers-->'+chosenOffers);
            
            //To update status on submission on changing offer status 
            Set<Id> offerId = new Set<id>();
            Set<Id> opportunityIdSet = new Set<Id>();
            
            for(Cloufi__Offers__c objOffer: chosenOffers){
                offerId.add(objOffer.Id);
                opportunityIdSet.add(objOffer.Cloufi__Opportunity__c);
            }
            
            //Fetched submission along with related offers
           // Map<id,Cloufi__Submission__c> submissionMap = new Map<id,Cloufi__Submission__c>([select id ,name ,Cloufi__Status__c,Decline_Reason__c,(select id,Cloufi__Offer_Status__c,Cloufi__Opportunity__c from Cloufi__Offers__r where Id not in :offerId) from Cloufi__Submission__c where Cloufi__Opportunity__c IN: opportunityIdSet ]);                
            Map<id,Cloufi__Submission__c> submissionMap = new Map<id,Cloufi__Submission__c>([select id ,name ,Cloufi__Status__c,(select id,Cloufi__Offer_Status__c,Cloufi__Opportunity__c from Cloufi__Offers__r where Id not in :offerId) from Cloufi__Submission__c where Cloufi__Opportunity__c IN: opportunityIdSet ]);                
            System.debug('submissionMap-->'+submissionMap);
            //Loop through the chosen offers
            for(Cloufi__Offers__c parentOffer: chosenOffers){
                if(submissionMap.containsKey(parentOffer.Cloufi__Submission__c) && parentOffer.Cloufi__Offer_Status__c=='Chosen' /*|| (objOffer.Cloufi__Offer_Status__c == 'Rejected' && parentOffer.Cloufi__Offer_Status__c=='Chosen')*/){
                    Cloufi__Submission__c objSubmission = submissionMap.get(parentOffer.Cloufi__Submission__c);
                    System.debug('objSubmission-->'+objSubmission);
                    System.debug('sibling offers-->'+objSubmission.Cloufi__Offers__r);
                    for(Cloufi__Offers__c siblingOffer : objSubmission.Cloufi__Offers__r){
                        //Checked more than one offer is not approved
                        if(siblingOffer.Cloufi__Offer_Status__c=='Chosen'){
                            parentOffer.addError('One offer is already Chosen for this Loan');
                        }
                        
                        //Reject offers under same submission
                        if(siblingOffer.Cloufi__Offer_Status__c != 'Expired'){
                            siblingOffer.Cloufi__Offer_Status__c = 'Rejected';
                            listSiblingOffer.add(siblingOffer);
                        }
                    }
                }   
                    
                System.debug('other offers-->'+listSiblingOffer);

                //Iterate all the submissions under opportunity
                for(Cloufi__Submission__c objSubmission : submissionMap.values()){
                    if(parentOffer.Cloufi__Offer_Status__c=='Chosen'){
                        //Reject other submission
                        if(objSubmission.Id != parentOffer.Cloufi__Submission__c){
                            if(objSubmission.Cloufi__Status__c != 'Declined'){
                                objSubmission.Cloufi__Status__c = 'Rejected';
                            }
                            
                            //Reject other offers
                            for(Cloufi__Offers__c siblingOffer : objSubmission.Cloufi__Offers__r){
                                if(siblingOffer.Cloufi__Offer_Status__c != 'Expired'){
                                    siblingOffer.Cloufi__Offer_Status__c = 'Rejected';
                                    listSiblingOffer.add(siblingOffer);
                                }
                            }
                        }else{
                            //Approve related submission
                            objSubmission.Cloufi__Status__c = 'Approved'; 
                        }                                                
                    }
                }
            }

            System.debug('other offers after-->'+listSiblingOffer);
            
            //Update submission status
            if(Schema.sObjectType.Cloufi__Submission__c.isUpdateable() && submissionMap.size()>0){
                update submissionMap.values();
            }
            
            //Update sibling offer
            if(listSiblingOffer.size()>0){
                update listSiblingOffer;
            }
        }catch(exception ex){
            System.debug('error -->'+ex.getMessage()+' on line --> '+ex.getLineNumber());
            System.debug('*****error*****'+ex.getStackTraceString());
        }
    }
    
    //Populate chosen offer value on opportunity
    public static void updateOpportunity(List<Cloufi__Offers__c> chosenOffers){
        try{
            Set<String> offerFieldSet = new Set<String>();
            Set<String> opportunityFieldSet = new Set<String>(); 
            Set<Id> offerIds = new Set<Id>();
            
            // get opportunity for current offer
            for(Cloufi__Offers__c offerObj: chosenOffers){
                offerIds.add(offerObj.Cloufi__Opportunity__c);
            }
            
            system.debug('offerIds >>'+offerIds);
            
            Map <Id, Opportunity> opportunityUpdateMap = new Map <Id, Opportunity>();
            List<Opportunity> opportunityList = [Select Id,Name,StageName from Opportunity Where Id =: offerIds];
            system.debug('opportunityList initial >>'+opportunityList);
            Map<String,String> mapOfferToOpportunityFieldMapping = new Map<String,String>();
            for(Opportunity objOpp : opportunityList){
                
                if(Schema.sObjectType.Cloufi__Offers__c.isAccessible() && Schema.sObjectType.Cloufi__Offers__c.fields.Cloufi__Offer_Status__c.isAccessible()){
                    opportunityFieldSet = Schema.SObjectType.Opportunity.fields.getMap().keySet();      
                    offerFieldSet = Schema.SObjectType.Cloufi__Offers__c.fields.getMap().keySet();    
                    for(Cloufi__Offer_Opportunity_Field_Mapping__c offerOpportunityMapping : Cloufi__Offer_Opportunity_Field_Mapping__c.getAll().values()){             
                        String opportunityField = (offerOpportunityMapping.Cloufi__Opportunity_Field_API__c).toLowerCase();             
                        String offerField = (offerOpportunityMapping.Cloufi__Offer_Field_API__c).toLowerCase();
                        if(opportunityFieldSet.contains(opportunityField.toLowerCase()) && offerFieldSet.contains(offerField.toLowerCase())){
                            mapOfferToOpportunityFieldMapping.put(opportunityField,offerField);
                        }
                    }
                    system.debug('mapOfferToOpportunityFieldMapping >>'+mapOfferToOpportunityFieldMapping);
                    for(Cloufi__Offers__c objOffer : chosenOffers){
                        system.debug('objOffer >>'+objOffer);
                        if(objOffer.Cloufi__Offer_Status__c =='Chosen'){
                            for(String strKey : mapOfferToOpportunityFieldMapping.keySet()){
                                system.debug('strKey >>'+strKey);
                                objOpp.put(strKey,objOffer.get(mapOfferToOpportunityFieldMapping.get(strKey)));
                                system.debug('objOpp >>'+objOpp);
                                if(!opportunityUpdateMap.containsKey(objOpp.Id)){
                                    opportunityUpdateMap.put(objOpp.Id, objOpp);
                                }
                            } 
                        }
                            
                    }
                    
                    system.debug('opportunityUpdateMap >>'+opportunityUpdateMap);
                }
                
                /* if(Schema.sObjectType.Opportunity.isUpdateable() && opportunityList.size() > 0){
                    system.debug('opportunityList final >>'+opportunityList);
                    update opportunityList;
                } */
            }
            system.debug('opportunityUpdateMap >>'+opportunityUpdateMap);
            if(Schema.sObjectType.Opportunity.isUpdateable() && opportunityUpdateMap.size() > 0){
                update opportunityUpdateMap.values();
            }
            
            
            
        }catch(exception ex){
            System.debug('error -->'+ex.getMessage()+' on line --> '+ex.getLineNumber());
            System.debug('*****error*****'+ex.getStackTraceString());
        }
    }   
    
    //Add offer documents when an offer inserted
    public static void AddUWDocuments(List<Cloufi__Offers__c> newOffers){
        try{
            Set<Id> opportunityId = new Set<Id>();
            Set<Id> lenderId = new Set<Id>();
            Map<String,UW_Documents_Settings__c> UWDocSettingsMap = new Map<String,UW_Documents_Settings__c>();                 
            Map<String,Cloufi__UW_Document__c> UWDocMap = new Map<String,Cloufi__UW_Document__c>();  
            Map<String,UW_Document_Share__c> UWShareMap = new Map<String,UW_Document_Share__c>();
            List<UW_Document_Share__c> lstSharedStipToInsert = new List<UW_Document_Share__c>();
            
            //get lenders of offers
            for(Cloufi__Offers__c objOffer : newOffers){
                opportunityId.add(objOffer.Cloufi__Opportunity__c);
                lenderId.add(objOffer.Cloufi__Funder__c);          
            } 
            
            //get offer document from custom settings
            for(UW_Documents_Settings__c UWDocSettings : [select name,Stage__c,Type__c from UW_Documents_Settings__c where Stage__c='Offer' AND Type__c='Document' ORDER BY Name ASC]){
                UWDocSettingsMap.put(UWDocSettings.Name,UWDocSettings);
            }
            
            //get all documents from opportunity
            for(Cloufi__UW_Document__c objUW : [Select Stip_Name__c,Name,Cloufi__URL__c, Cloufi__Type__c, Cloufi__Display_Size__c from Cloufi__UW_Document__c where Cloufi__Opportunity__c IN: opportunityId AND Stip_Name__c IN:UWDocSettingsMap.keySet()]){
                UWDocMap.put(objUW.Stip_Name__c,objUW);
            }
            
            //create share documents for the offer docs
            for(UW_Document_Share__c objUW : [select Name,Account__c,Opportunity__c,UW_Documents__c,UW_Documents__r.Cloufi__URL__c,UW_Documents__r.Stip_Name__c from UW_Document_Share__c where Opportunity__c IN: opportunityId AND Account__c IN: lenderId ORDER BY UW_Documents__r.Stip_Name__c ASC]){
                if(UWDocSettingsMap.containsKey(objUW.UW_Documents__r.Stip_Name__c) && objUW.UW_Documents__r.Stip_Name__c == UWDocSettingsMap.get(objUW.UW_Documents__r.Stip_Name__c).Name){
                    UWShareMap.put(objUW.UW_Documents__r.Stip_Name__c,objUW);
                }
            }
            
            //create Offer documents
            for(Cloufi__Offers__c objOffer : newOffers){
                for(UW_Documents_Settings__c UWDocSettings : UWDocSettingsMap.values()){
                    Cloufi__UW_Document__c objUWDoc = new Cloufi__UW_Document__c();
                    objUWDoc.Name = UWDocSettings.Name;
                    objUWDoc.Stip_Name__c = UWDocSettings.Name;
                    objUWDoc.Cloufi__Opportunity__c = objOffer.Cloufi__Opportunity__c;
                    objUWDoc.Cloufi__Type__c = 'Offer - Document';
                    if(!UWDocMap.containsKey(objUWDoc.Stip_Name__c)){
                        UWDocMap.put(objUWDoc.Stip_Name__c,objUWDoc);
                    }else{
                        UWDocMap.get(objUWDoc.Stip_Name__c);
                    }  
                }
            }
            
            if(UWDocMap.size()>0){
                upsert UWDocMap.values();
            }
            
            //create UW share for the related offer docs
            for(Cloufi__Offers__c objOffer : newOffers){
                for(Cloufi__UW_Document__c objUWDoc : UWDocMap.values()){
                    if(!UWShareMap.containsKey(objUWDoc.Stip_Name__c) && objOffer.Cloufi__Funder__c != null ){
                        UW_Document_Share__c objShare = new UW_Document_Share__c();
                        objShare.Opportunity__c = objOffer.Cloufi__Opportunity__c;               
                        objShare.UW_Documents__c = objUWDoc.Id;
                        objShare.Account__c = objOffer.Cloufi__Funder__c;
                        lstSharedStipToInsert.add(objShare);                  
                    }
                }
            }
            if(lstSharedStipToInsert.size()>0){
                insert lstSharedStipToInsert;
            }
        }catch(exception ex){
            System.debug('error -->'+ex.getMessage()+' on line --> '+ex.getLineNumber());
            System.debug('*****error*****'+ex.getStackTraceString());
        }
    }
    
    //Mail to sales support when all offers get rejected or expired
    public static void notifySalesSupport(set<Id> OpportunityIdSet){   
        try{
            integer rejectCount = 0;
            Integer expiredOfferCount = 0;
            boolean isRecursive = false;
            String opportunityName = '';
            Id oppId;
            
            List<Cloufi__Offers__c> AllOffers = [select id,name,Cloufi__Opportunity__c, Cloufi__Opportunity__r.Name ,Cloufi__Offer_Status__c from Cloufi__Offers__c where Cloufi__Opportunity__c IN: OpportunityIdSet ];
            if(AllOffers.size()>0){
                opportunityName = AllOffers[0].Cloufi__Opportunity__r.Name;
                oppId = AllOffers[0].Cloufi__Opportunity__c;
            }
            
            for(Cloufi__Offers__c objOffer : AllOffers){
                if(objOffer.Cloufi__Offer_Status__c == 'Rejected'){
                    rejectCount += 1;
                }else if(objOffer.Cloufi__Offer_Status__c == 'Expired'){
                    expiredOfferCount += 1;
                }
            }
            
            if(rejectCount == AllOffers.size()){
                notifySalesSupport('Rejected' , oppId);
            }else if(expiredOfferCount == AllOffers.size()){
                notifySalesSupport('Expired', oppId);
            }
        }catch(exception ex){
            System.debug('error -->'+ex.getMessage()+' on line --> '+ex.getLineNumber());
            System.debug('*****error*****'+ex.getStackTraceString());
        }
    }
    
    //Mail to sales support when all offers get rejected or expired
    public static void notifySalesSupport(String offersStatus, Id offerOpportunityId){
        try{
            List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();
            List<Task> tasklist=new List<Task>();               
            Set<Id> lenderId = new Set<id>();
            List<String> ToEmailIds=new List<String>();            
            EmailTemplate emailTemp;
            
            List<EmailTemplate> templateList = new List<EmailTemplate>();
            if(offersStatus == 'Rejected'){
                templateList = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'All_Offer_Rejection'];
            }else if(offersStatus == 'Expired'){
                templateList = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'All_Offer_Expired'];
            }
            
            Opportunity objOpportunity = [select id,Sales_Support_Email__c,OwnerId,Name,Company_Logo__c,Owner.Company_Logo__c from Opportunity where Id=:offerOpportunityId];
            
            if(templateList!=null && templateList.size()>0){
                emailTemp = templateList[0];
                String htmlBody = emailTemp.HtmlValue;
                String subject = emailTemp.Subject;
                htmlBody = htmlBody.replace('opportunityName', '<a href="'+System.URL.getSalesforceBaseURL().toExternalForm()+'/'+ offerOpportunityId + '" target="_blank">'+objOpportunity.Name+'</a>');
                htmlBody = htmlBody.replace('companyLogo','<img src="'+objOpportunity.Owner.Company_Logo__c+'"/>');
                htmlBody = htmlBody.replace('dealName', objOpportunity.Name);
                subject = subject.replace('dealName', objOpportunity.Name);
                /*User objUser = [SELECT Sales_Support_Email__c FROM User WHERE Id =: UserInfo.getUserId()];
                Id targetObject;*/
                
                if(objOpportunity.Sales_Support_Email__c != null){
                    ToEmailIds.add(objOpportunity.Sales_Support_Email__c);
                    Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                    //Email Message
                    emailMsg.setToAddresses(ToEmailIds);
                    emailMsg.setWhatId(objOpportunity.Id);
                    emailMsg.setHtmlBody(htmlBody);
                    emailMsg.setSubject(subject);
                    emailMsg.setTemplateId(emailTemp.Id);
                    emailMsg.SaveAsActivity = False;
                    lstEmailMsg.add(emailMsg);
                    
                    if(lstEmailMsg.size()>0){
                        Messaging.sendEmail(lstEmailMsg);
                    }
                }
            }
        }catch(exception ex){
            System.debug('error -->'+ex.getMessage()+' on line --> '+ex.getLineNumber());
            System.debug('*****error*****'+ex.getStackTraceString());
        }
    }
}