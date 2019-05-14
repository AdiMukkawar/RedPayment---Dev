public with sharing class SendOfferToMerchantControllerX {

	public Cloufi__Offers__c objOffers{get;set;}

    public SendOfferToMerchantControllerX(ApexPages.StandardController controller) {
    	if(Apexpages.currentPage().getParameters().get('id') != null){
    		objOffers = [SELECT Id, Name, Cloufi__Offer_Status__c FROM Cloufi__Offers__c WHERE Id =: Apexpages.currentPage().getParameters().get('id') LIMIT 1];
    	}else{
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Page must be invoked from Offer'));
    	}
    }

    public PageReference presentOffer(){
    	if(objOffers != null){            
    		if(objOffers.Cloufi__Offer_Status__c == 'New' || objOffers.Cloufi__Offer_Status__c == 'Reviewed'){                
    			objOffers.Cloufi__Offer_Status__c = 'Presented';
    			update objOffers;
		    	PageReference objPR = new PageReference('/'+objOffers.Id);
		    	return objPR;    			
    		}else{
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Only New Offers can be presented'));
    			return null;
    		}
    	}else{
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Page must be invoked from Offer'));
    	}
    	return null;
    }
}