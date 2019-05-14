/*****************************************************************
* Author: Techila Global Services Pvt Ltd.(Aditya Mukkawar)
* Class Name: SubmissionOfferCompController
* Created Date: 02-October-2018
* Description: Class to display Submission related offers
-------------------------------------------------------------------
*******************************************************************/
public class SubmissionOfferCompController {
	
	// To get current user information 
	@AuraEnabled 
    public static user fetchUser(){
        User oUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
	
	// Get all offers under submission
    @AuraEnabled
    public static List<Cloufi__Offers__c> fetchOffer(Id subId) {
        List<Cloufi__Offers__c> lstOffer = new List<Cloufi__Offers__c>();
        system.debug('subId'+subId);
		User oUser = [select id,Name,Profile.Name,UserRole.Name FROM User Where id =: userInfo.getUserId()];
		system.debug('oUser=>'+oUser);
        DescribeSObjectResult describeResultOffer = Cloufi__Offers__c.getSObjectType().getDescribe();
        List<String> OfferfieldNames = new List<String>(describeResultOffer.fields.getMap().keySet());
        String query = '';
		if(oUser.Profile.Name =='Cash Advance Sales Agent'){
			query = ' SELECT ' + String.join( OfferfieldNames, ',' ) + ', recordType.name FROM Cloufi__Offers__c WHERE Cloufi__Offer_Status__c!= \'New\' and Cloufi__Submission__c = '+'\''+subId+'\'';
		}else{
			query = ' SELECT ' + String.join( OfferfieldNames, ',' ) + ', recordType.name FROM Cloufi__Offers__c WHERE Cloufi__Submission__c = '+'\''+subId+'\'';
		}
        system.debug('query'+query);
        lstOffer = Database.query(query); 
        system.debug('lstOffer'+lstOffer);
        return lstOffer;
    }
	
	// To cancel the offer
	@AuraEnabled
    public static List <Cloufi__Offers__c> cancelOffer(List<Cloufi__Offers__c> lstOffer) {
        String oppId = lstOffer[0].Cloufi__Opportunity__c;
        DescribeSObjectResult describeResultOffer = Cloufi__Offers__c.getSObjectType().getDescribe();
        List<String> OfferfieldNames = new List<String>(describeResultOffer.fields.getMap().keySet());     
        String query = ' SELECT ' + String.join( OfferfieldNames, ',' ) + ', recordType.name FROM Cloufi__Offers__c WHERE Cloufi__Opportunity__c = '+'\''+oppId+'\'';
        lstOffer = Database.query(query); 
        return lstOffer;
    }
	
	// Update the offers those status change
	@AuraEnabled
	public static Map<String,String> saveOffer(List<Cloufi__Offers__c> lstOffer) {
        Map<String,String> msg = new Map<String,String>();
        system.debug('lstOffer'+lstOffer);
        try{
            List<Cloufi__Offers__c> lstOffer1 = new List<Cloufi__Offers__c>();
			Map<Id,Cloufi__Offers__c> mapOldOffers = new Map<Id,Cloufi__Offers__c>();
			for(Cloufi__Offers__c objOldOffer:[SELECT id,Cloufi__Offer_Status__c,Cloufi__Opportunity__c FROM Cloufi__Offers__c WHERE Cloufi__Opportunity__c=:lstOffer[0].Cloufi__Opportunity__c]){
				mapOldOffers.put(objOldOffer.id,objOldOffer);
			}
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
    public static List < String > getselectOptions(sObject objObject, string fld) {
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
        allOpts.sort();
        return allOpts;
    }
}