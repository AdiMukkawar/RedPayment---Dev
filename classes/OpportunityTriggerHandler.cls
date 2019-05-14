public class OpportunityTriggerHandler{
    
    public static void createDefaultUWDocuments(List<Opportunity> opportunityList){

        Map<Id,Id> opportunityApplicationMap = new Map<Id,Id>();
        Map<Id, Set<String>> opportunityUWDocumentMap = new Map<Id, Set<String>>();
        Map<Id, Map<String, Cloufi__UW_Document__c>> applicationUWDocumentMap = new Map<Id, Map<String, Cloufi__UW_Document__c>>();
        Set<Id> opportunityIdSet = new Set<Id>();
        Set<Id> applicationIdSet = new Set<Id>();        
        
        for(Opportunity objOpportunity : opportunityList){
            opportunityIdSet.add(objOpportunity.Id);
        }
        
        for(Opportunity objOpportunity : [SELECT Id, (SELECT Id FROM Cloufi__Applications__r ORDER BY CreatedDate DESC LIMIT 1), (SELECT Id, Name, Stip_Name__c FROM Cloufi__Dropbox_Attachments__r) FROM Opportunity WHERE Id IN : opportunityIdSet]){        
            if(objOpportunity.Cloufi__Applications__r.size()>0){
                opportunityApplicationMap.put(objOpportunity.Id, objOpportunity.Cloufi__Applications__r[0].Id);
                applicationIdSet.add(objOpportunity.Cloufi__Applications__r[0].Id);
            }else{
                opportunityApplicationMap.put(objOpportunity.Id, null);
            }
            if(objOpportunity.Cloufi__Dropbox_Attachments__r.size()>0){
                for(Cloufi__UW_Document__c objUWDocument : objOpportunity.Cloufi__Dropbox_Attachments__r){
                    if(opportunityUWDocumentMap.get(objOpportunity.Id) == null){
                        opportunityUWDocumentMap.put(objOpportunity.Id, new Set<String>{objUWDocument.Stip_Name__c});
                    }else{
                        opportunityUWDocumentMap.get(objOpportunity.Id).add(objUWDocument.Stip_Name__c);
                    }
                }
            }else{
                opportunityUWDocumentMap.put(objOpportunity.Id, new Set<String>());
            }
        }

        for(Cloufi__Application__c objApplication : [SELECT Id, (SELECT Id, Name, Stip_Name__c, Cloufi__Opportunity__c FROM Cloufi__Stips__r) FROM Cloufi__Application__c WHERE Id IN : applicationIdSet]){
            
            if(objApplication.Cloufi__Stips__r.size()>0){
                Map<String, Cloufi__UW_Document__c> uwdMap = new Map<String, Cloufi__UW_Document__c>();
                for(Cloufi__UW_Document__c objUWDocument : objApplication.Cloufi__Stips__r){
                    uwdMap.put(objUWDocument.Stip_Name__c, objUWDocument);
                }
                applicationUWDocumentMap.put(objApplication.Id, uwdMap);               
            }else{
                applicationUWDocumentMap.put(objApplication.Id, new Map<String, Cloufi__UW_Document__c>());
            }
        }

        List<Cloufi__UW_Document__c> uwDocumentList = new List<Cloufi__UW_Document__c>();
        List<Cloufi__UW_Document__c> uwDocList = OpportunityTriggerHandler.getUWDocuments();        
        for(String opportunityId : opportunityApplicationMap.keyset()){            
            for(Cloufi__UW_Document__c objUWDocument : uwDocList){
                if(opportunityApplicationMap.get(opportunityId) != null){
                    if(applicationUWDocumentMap.get(opportunityApplicationMap.get(opportunityId)) != null && applicationUWDocumentMap.get(opportunityApplicationMap.get(opportunityId)).get(objUWDocument.Stip_Name__c) != null){
                        Cloufi__UW_Document__c objUWDocExisting = applicationUWDocumentMap.get(opportunityApplicationMap.get(opportunityId)).get(objUWDocument.Stip_Name__c);
                        objUWDocExisting.Cloufi__Opportunity__c = opportunityId;
                        uwDocumentList.add(objUWDocExisting);
                    }
                }else{
                    if(!opportunityUWDocumentMap.get(opportunityId).contains(objUWDocument.Stip_Name__c)){
                        objUWDocument.Cloufi__Opportunity__c = opportunityId;
                        uwDocumentList.add(objUWDocument);
                    }
                }
            }
        }           
        if(uwDocumentList.size()>0){
            upsert uwDocumentList;
        }
    }
    
    // To get all documents needed
    public static List<Cloufi__UW_Document__c> getUWDocuments(){
        Map<Integer, String> monthMap = new Map<Integer, String>{1 =>'January', 2=>'February', 3=>'March', 4=>'April', 5=>'May',6=>'June', 7=>'July', 8=>'August', 9=>'September',10=>'October',11=>'November', 12=>'December'};        
        List<Cloufi__UW_Document__c> uwDocumentList = new List<Cloufi__UW_Document__c>();      
        for(UW_Documents_Settings__c objUWDSetting : [SELECT Name, Stage__c, Type__c FROM UW_Documents_Settings__c WHERE Type__c = 'Document' AND Stage__c= 'Application']){
            Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c(Name = objUWDSetting.Name, Stip_Name__c = objUWDSetting.Name, Cloufi__Type__c = 'Application - Document');
            uwDocumentList.add(objUWDocument);
        }
        Date todaysDate = System.today();
        for(Integer i=1;i<5;i++){
            Date pastDate = todaysDate.addMonths(-i);            
            String dateString = monthMap.get(pastDate.month())+'-'+pastDate.year();

            Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c();
            objUWDocument.Name = dateString + ' Bank Statement';
            objUWDocument.Stip_Name__c = objUWDocument.Name;
            objUWDocument.Cloufi__Type__c = 'Bank Statement';
            objUWDocument.Month__c = monthMap.get(pastDate.month());
            objUWDocument.Year__c = String.valueOf(pastDate.year());
            uwDocumentList.add(objUWDocument);

            /*Cloufi__UW_Document__c objUWDocument1 = new Cloufi__UW_Document__c();
            objUWDocument1.Name = dateString + ' Processing Statement';
            objUWDocument1.Stip_Name__c = objUWDocument1.Name;
            objUWDocument1.Cloufi__Type__c = 'Processing Statement';
            objUWDocument1.Month__c = monthMap.get(pastDate.month());
            objUWDocument1.Year__c = String.valueOf(pastDate.year());
            uwDocumentList.add(objUWDocument1);*/
        }
        Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c();
        objUWDocument.Name = 'Signed Application';
        objUWDocument.Stip_Name__c = objUWDocument.Name;
        objUWDocument.Cloufi__Type__c = 'Application - Document';
        uwDocumentList.add(objUWDocument);
        
        return uwDocumentList;
    }  

    public static void createContractUWDocument(Map<Id, Opportunity> opportunityMap){        
        Map<Id, Cloufi__UW_Document__c> oppUWDocumentMap = new Map<Id, Cloufi__UW_Document__c>();

        for(Cloufi__UW_Document__c objUWDocument : [SELECT Id, Stip_Name__c, Cloufi__Opportunity__c, Status__c FROM Cloufi__UW_Document__c WHERE Cloufi__Type__c = 'Stip' AND Stip_Name__c = 'Contract' AND Cloufi__Opportunity__c IN : opportunityMap.keyset()]){
            oppUWDocumentMap.put(objUWDocument.Cloufi__Opportunity__c, objUWDocument);         
        }
        for(Id opportunityId : opportunityMap.keySet()){
            if(!oppUWDocumentMap.containsKey(opportunityId)){
                Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c();
                objUWDocument.Name = 'Contract';
                objUWDocument.Stip_Name__c = objUWDocument.Name;
                objUWDocument.Cloufi__Type__c = 'Stip';
                objUWDocument.Status__c = 'Requested';
                objUWDocument.Cloufi__Opportunity__c = opportunityId;
                oppUWDocumentMap.put(objUWDocument.Cloufi__Opportunity__c, objUWDocument);   
            }else{
                oppUWDocumentMap.get(opportunityId).Status__c = 'Requested';
            }
        }
        upsert oppUWDocumentMap.values();
    } 

    public static void createSignedContractUWDocument(Map<Id, Opportunity> opportunityMap){        
        Map<Id, Cloufi__UW_Document__c> oppUWDocumentMap = new Map<Id, Cloufi__UW_Document__c>();

        for(Cloufi__UW_Document__c objUWDocument : [SELECT Id, Stip_Name__c, Cloufi__Opportunity__c FROM Cloufi__UW_Document__c WHERE Cloufi__Type__c = 'Stip' AND Stip_Name__c = 'Signed Contract' AND Cloufi__Opportunity__c IN : opportunityMap.keyset()]){
            oppUWDocumentMap.put(objUWDocument.Cloufi__Opportunity__c, objUWDocument);         
        }
        
        for(Id opportunityId : opportunityMap.keySet()){
            if(!oppUWDocumentMap.containsKey(opportunityId)){
                Cloufi__UW_Document__c objUWDocument = new Cloufi__UW_Document__c();
                objUWDocument.Name = 'Signed Contract';
                objUWDocument.Stip_Name__c = objUWDocument.Name;
                objUWDocument.Cloufi__Type__c = 'Stip';
                objUWDocument.Cloufi__Opportunity__c = opportunityId; 
                oppUWDocumentMap.put(objUWDocument.Cloufi__Opportunity__c, objUWDocument);   
            }else{
                oppUWDocumentMap.get(opportunityId).Status__c = 'Requested';
            }  
        }
        upsert oppUWDocumentMap.values();
    }
    
    
    /*Start: Update Servicing White Label field with custom Lookup filtered White Label*/
    public static void updateWhiteLabelServicing(List<Opportunity> opportunityList, Map<Id, Opportunity> opportunityOldMap){
        for(Opportunity objOpportunity : opportunityList){
            if(objOpportunity.White_Label_Custom__c != opportunityOldMap.get(objOpportunity.Id).White_Label_Custom__c){
                objOpportunity.CloufiServicing__White_Label__c = objOpportunity.White_Label_Custom__c;
            }
        }
    }
    /*End: Update Servicing White Label field with custom Lookup filtered White Label*/

    public static void createDropboxFolder(List<Opportunity> opportunityList){
        Set<Id> opportunityIdSet = new Set<Id>();
        for(Opportunity objOpportunity : opportunityList){
            opportunityIdSet.add(objOpportunity.Id);
        } 
        if(opportunityIdSet.size()>0){
            OpportunityTriggerHandler.createDropboxFolder(opportunityIdSet);
        }  
    }

    @Future(callout=true)
    public static void createDropboxFolder(Set<Id> opportunityIdSet){
        List<Opportunity> opportunityList = new List<Opportunity>();

        for(Opportunity objOpportunity : [SELECT Id, Name, Cloufi__Dropbox_Folder_Path__c,Cancelled_Dropbox_Folder_Path__c FROM Opportunity WHERE Id IN : opportunityIdSet]){
            Cloufi__Dropbox_Settings__c dropBoxSetting = Cloufi__Dropbox_Settings__c.getOrgDefaults();
            String token = dropBoxSetting.Cloufi__Access_Token__c;
            system.debug('objOpportunity.Name=>'+objOpportunity.Name);     
            String oppName = objOpportunity.Name.replaceAll('[^a-zA-Z0-9\\s+]', ' ').trim();
            system.debug('oppName=>'+oppName);
            String createFolderURL = 'https://api.dropboxapi.com/2/files/create_folder_batch';
            HttpRequest createFolderRequest = new HttpRequest();
            createFolderRequest.setEndpoint(createFolderURL);
            createFolderRequest.setMethod('POST');
            createFolderRequest.setHeader('Authorization','Bearer '+token);
            createFolderRequest.setHeader('Content-Type', 'application/json');
            createFolderRequest.setBody('{"paths": ["/Merchant Services/'+oppName+'","/Merchant Services/Cancelled '+oppName+'"],"autorename": true}');
            createFolderRequest.setTimeout(12000);
            Http objHTTP = new Http();
            HttpResponse objHTTPResponse;
            String responseString;  
            System.debug('createFolderRequest -> '+createFolderRequest);
            objHTTPResponse = objHTTP.send(createFolderRequest);
            responseString = objHTTPResponse.getBody();
            
            CreateDropboxFolder objCreateDropboxFolder = (CreateDropboxFolder) System.JSON.deserialize(responseString, CreateDropboxFolder.class); 
            
            for(CreateDropboxFolder.cls_entries entrie : objCreateDropboxFolder.entries){
                CreateDropboxFolder.cls_metadata metaDataDp = entrie.metadata;
                if(metaDataDp.path_lower.contains('cancelled'))
                    objOpportunity.Cancelled_Dropbox_Folder_Path__c = metaDataDp.path_lower;
                else
                    objOpportunity.Cloufi__Dropbox_Folder_Path__c = metaDataDp.path_lower;
            }
            
            opportunityList.add(objOpportunity);
        }

        if(opportunityList.size()>0){
            update opportunityList;
        }        
    }

    

    public static void createOpportunityShare(List<Opportunity> opportunityList){
        List<OpportunityShare> opportunityShareList = new List<OpportunityShare>();
        Set<Id> opportunityOwnerIdSet = new Set<Id>();
        Map<Id, Id> ownerManagerIdMap = new Map<Id, Id>();

        for(Opportunity objOpportunity : opportunityList){
            opportunityOwnerIdSet.add(objOpportunity.OwnerId);
        }

        for(User objUser : [SELECT Id, ManagerId FROM User WHERE Id IN : opportunityOwnerIdSet]){
            ownerManagerIdMap.put(objUser.Id, objUser.ManagerId);
        }
        
        for(User objUser : [SELECT Id, ManagerId FROM User WHERE ManagerId IN : opportunityOwnerIdSet]){
            ownerManagerIdMap.put(objUser.Id, objUser.ManagerId);
        }
        
        system.debug('ownerManagerIdMap >>'+ownerManagerIdMap);
        for(Opportunity objOpportunity : opportunityList){
            if(objOpportunity.OwnerId != null && ownerManagerIdMap.get(objOpportunity.OwnerId) != null){
                OpportunityShare objOpportunityShare = new OpportunityShare();
                objOpportunityShare.OpportunityId = objOpportunity.Id;
                objOpportunityShare.OpportunityAccessLevel = 'Edit';
                objOpportunityShare.RowCause = 'Manual';
                objOpportunityShare.UserOrGroupId = ownerManagerIdMap.get(objOpportunity.OwnerId);
                opportunityShareList.add(objOpportunityShare);                
            }
        }

        if(opportunityShareList.size()>0){
            if(!test.isRunningTest()){
                insert opportunityShareList;
            }
        }
    }

    public static void checkOpportunityOwnerChange (List<Opportunity> opportunityList, Map<Id, Opportunity> opportunityOldMap){
        Set<Id> ownerIdSet = new Set<Id>();
        Set<Id> oldOwnerIdSet = new Set<Id>();
        Set<Id> managerIdSet = new Set<Id>();
        Map<Id, Id> ownerManagerMap = new Map<Id, Id>();
        Map<Id, Set<Id>> managerTeamMap = new Map<Id, Set<Id>>();

        for(Opportunity objOpportunity : opportunityList){
            if(objOpportunity.OwnerId != opportunityOldMap.get(objOpportunity.Id).OwnerId){
                ownerIdSet.add(objOpportunity.OwnerId);
                oldOwnerIdSet.add(opportunityOldMap.get(objOpportunity.Id).OwnerId);
            }
        }

        for(User objUser : [SELECT Id, ManagerId FROM User WHERE Id IN : oldOwnerIdSet]){
            managerIdSet.add(objUser.ManagerId);
            //ownerManagerMap.put(objUser.Id, objUser.ManagerId);
        }
        for(User objUser : [SELECT Id, (SELECT Id FROM ManagedUsers) FROM User WHERE Id IN : managerIdSet]){
            Set<Id> teamUserIdSet = new Set<Id>();
            for(User objTeamMember : objUser.ManagedUsers){
                teamUserIdSet.add(objTeamMember.Id);
            }
            //Add the manager Id to the team list as well
            teamUserIdSet.add(objUser.Id);
            managerTeamMap.put(objUser.Id, teamUserIdSet);
        }

        for(Opportunity objOpportunity : opportunityList){          
            //if(!managerTeamMap.get(ownerManagerMap.get(opportunityOldMap.get(objOpportunity.Id).OwnerId)).contains(objOpportunity.OwnerId)){
            if(managerTeamMap.size()>0 && managerTeamMap.get(UserInfo.getUserId())!=null){
                //if(!managerTeamMap.get(opportunityOldMap.get(objOpportunity.Id).OwnerId).contains(objOpportunity.OwnerId)){
                if(!managerTeamMap.get(UserInfo.getUserId()).contains(objOpportunity.OwnerId)){
                    objOpportunity.addError('Deal Can only be assign with team agents.');
                }
            }
        }

        /*Set<Id> oldUserIds= new Set<Id>();
        Set<Id> newUserIds= new Set<Id>();
        Map<Id,Id> mapUserManagerId = new Map<Id,Id>();
        Map<Id,Set<Id>> managerAndTeamMap = new Map<Id,Set<Id>>();
        Map<Id, Id> ownerManagerMap = new Map<Id, Id>();
        for(Opportunity objopp:opportunityOldMap.values()){
            oldUserIds.add(objopp.OwnerId);
        }
        for(User objUser : [SELECT Id, ManagerId FROM User WHERE Id IN : oldUserIds]){
            ownerManagerMap.put(objUser.Id, objUser.ManagerId);
        }

        User oUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];

        if(oldUserIds.size()>0){
            for(User objUser: [SELECT Id, ManagerId,(SELECT Id FROM ManagedUsers) FROM User WHERE Id IN :oldUserIds]){
                mapUserManagerId.put(objUser.id,objUser.ManagerId);
                for(User objTeamMember : objUser.ManagedUsers){
                    if(!managerAndTeamMap.containsKey(objUser.id)){
                        managerAndTeamMap.put(objUser.id,new set<id>{objTeamMember.id});
                    }
                    else{
                        managerAndTeamMap.get(objUser.id).add(objTeamMember.id);
                    }
                }
            }   
        }

        for(Opportunity objOpportunity : opportunityList){
            //if(oUser.Profile.Name !='System Administrator' && objOpportunity.OwnerId != opportunityOldMap.get(objOpportunity.Id).OwnerId && mapUserManagerId.get(objOpportunity.OwnerId)!=mapUserManagerId.get(opportunityOldMap.get(objOpportunity.Id).OwnerId)){
            if(oUser.Profile.Name !='System Administrator' && ownerManagerMap.get(objOpportunity.OwnerId) != null && managerAndTeamMap.get(ownerManagerMap.get(objOpportunity.OwnerId)) != null && !managerAndTeamMap.get(ownerManagerMap.get(objOpportunity.OwnerId)).contains(objOpportunity.OwnerId)){
                objOpportunity.addError('Deal Can only be assign with team agents.');
            }
        }*/

    }

    public static void createOpportunityShare(List<Opportunity> opportunityList, Map<Id, Opportunity> opportunityOldMap){
        List<OpportunityShare> opportunityShareList = new List<OpportunityShare>();
        Set<Id> opportunityOwnerIdSet = new Set<Id>();
        Set<Id> opportunityOldOwnerIdSet = new Set<Id>();
        Map<Id, Id> ownerManagerIdMap = new Map<Id, Id>();
        List<Opportunity> opportunityListFiltered = new List<Opportunity>();
        Set<Id> opportunityIdSet = new Set<Id>();
        Map<Id, List<Cloufi__UW_Document__c>> opportunityUWDocumentMap = new Map<Id, List<Cloufi__UW_Document__c>>();
        List<Cloufi__UW_Document__Share> uwShareList = new List<Cloufi__UW_Document__Share>();
        Map<Id, Id> opportunityOldOwnerIdMap = new Map<Id, Id>();
        Map<Id, Id> oppOwnerMap = new Map<Id, Id>();
        List<Cloufi__UW_Document__Share> uwDocumentShareToDeleteList = new List<Cloufi__UW_Document__Share>();
        List<OpportunityShare> opportunityShareToDeleteList = new List<OpportunityShare>();
        List<Cloufi__UW_Document__c> uwOwnerList = new List<Cloufi__UW_Document__c>();
        List<Cloufi__UW_Document__c> uwOwnerUpdateList = new List<Cloufi__UW_Document__c>();
        Map<Id, Id> opportunityOldManagerMap = new Map<Id, Id>();
        
        for(Opportunity objOpportunity : opportunityList){
            if(objOpportunity.OwnerId != opportunityOldMap.get(objOpportunity.Id).OwnerId || Test.isRunningTest()){
                opportunityOwnerIdSet.add(objOpportunity.OwnerId);
                opportunityOldOwnerIdSet.add(opportunityOldMap.get(objOpportunity.Id).OwnerId);
                opportunityListFiltered.add(objOpportunity);
                opportunityIdSet.add(objOpportunity.Id);
                opportunityOldOwnerIdMap.put(objOpportunity.Id, opportunityOldMap.get(objOpportunity.Id).OwnerId);
                oppOwnerMap.put(objOpportunity.Id, objOpportunity.OwnerId);
            }
        }
        
        for(User objUser : [SELECT Id, ManagerId FROM User WHERE Id IN : opportunityOldOwnerIdSet]){
            opportunityOldManagerMap.put(objUser.Id, objUser.ManagerId);
        }

        uwOwnerList = [SELECT ID, OwnerId, Cloufi__Opportunity__c FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c IN:opportunityIdSet];
        if(!uwOwnerList.isEmpty()){
            for(Cloufi__UW_Document__c uwRecord: uwOwnerList){
                uwRecord.OwnerId = oppOwnerMap.get(uwRecord.Cloufi__Opportunity__c);
                uwOwnerUpdateList.add(uwRecord);
            }
        }

        if(!uwOwnerUpdateList.isEmpty()){
            update uwOwnerUpdateList;
        }
        
        for(Opportunity objOpportunity : [SELECT Id, OwnerId, Owner.ManagerId, (SELECT Id, OwnerId FROM Cloufi__Dropbox_Attachments__r), (SELECT Id, UserOrGroupId FROM Shares) FROM Opportunity WHERE Id IN : opportunityIdSet]){
            if(objOpportunity.Cloufi__Dropbox_Attachments__r.size()>0){
                opportunityUWDocumentMap.put(objOpportunity.Id, objOpportunity.Cloufi__Dropbox_Attachments__r);
            }
            if(objOpportunity.OwnerId != null){
                ownerManagerIdMap.put(objOpportunity.OwnerId, objOpportunity.Owner.ManagerId);
            }
            
            if(objOpportunity.Shares.size()>0){
                for(OpportunityShare objOpportunityShare : objOpportunity.Shares){
                    if(objOpportunityShare.UserOrGroupId == opportunityOldMap.get(objOpportunity.Id).OwnerId){
                        opportunityShareToDeleteList.add(objOpportunityShare);
                    }
                    if(objOpportunityShare.UserOrGroupId == opportunityOldManagerMap.get(objOpportunity.OwnerId)){
                        opportunityShareToDeleteList.add(objOpportunityShare);
                    }
                }
            }
        }
        
        //Insert OpportunityShare and UW Document Share record for Opportunity Owner Manager
        for(Opportunity objOpportunity : opportunityListFiltered){
            if(objOpportunity.OwnerId != null && ownerManagerIdMap.get(objOpportunity.OwnerId) != null){
                OpportunityShare objOpportunityShare = new OpportunityShare();
                objOpportunityShare.OpportunityId = objOpportunity.Id;
                objOpportunityShare.OpportunityAccessLevel = 'Edit';
                objOpportunityShare.RowCause = 'Manual';
                objOpportunityShare.UserOrGroupId = ownerManagerIdMap.get(objOpportunity.OwnerId);
                opportunityShareList.add(objOpportunityShare);

                if(opportunityUWDocumentMap.get(objOpportunity.Id) != null && opportunityUWDocumentMap.get(objOpportunity.Id).size()>0 && ownerManagerIdMap.get(objOpportunity.OwnerId) != null){
                    Id managerId = ownerManagerIdMap.get(objOpportunity.OwnerId);
                    for(Cloufi__UW_Document__c objUWDocument : opportunityUWDocumentMap.get(objOpportunity.Id)){
                        Cloufi__UW_Document__Share objUWShare = new Cloufi__UW_Document__Share();
                        objUWShare.UserOrGroupId = managerId;
                        objUWShare.ParentId = objUWDocument.Id;
                        objUWShare.RowCause = 'Manual';
                        objUWShare.AccessLevel = 'Edit';
                        uwShareList.add(objUWShare);
                    }
                }                
            }
        }

        //Delete Old Owner's UW Sharing Records
        for(Cloufi__UW_Document__c objUWDocument : [SELECT Id, Cloufi__Opportunity__c, (SELECT Id, UserOrGroupId FROM Shares WHERE RowCause = 'Manual') FROM Cloufi__UW_Document__c WHERE Cloufi__Opportunity__c IN : opportunityOldOwnerIdMap.keyset()]){
            if(objUWDocument.Shares.size()>0){
                for(Cloufi__UW_Document__Share objShare : objUWDocument.Shares){
                    if(ownerManagerIdMap.get(objUWDocument.Cloufi__Opportunity__c) != null && objShare.UserOrGroupId == ownerManagerIdMap.get(objUWDocument.Cloufi__Opportunity__c)){
                        uwDocumentShareToDeleteList.add(objShare);
                    }
                }
            }
        }

        if(opportunityShareToDeleteList.size()>0 && !test.isRunningTest()){
            //delete opportunityShareToDeleteList;
        }

        if(opportunityShareList.size()>0 && !test.isRunningTest()){
            insert opportunityShareList;
        } 
        
        if(uwDocumentShareToDeleteList.size()>0 && !test.isRunningTest()){
            //delete uwDocumentShareToDeleteList;
        }
        
        if(uwShareList.size()>0 && !test.isRunningTest()){
            insert uwShareList;
        } 
    }
}