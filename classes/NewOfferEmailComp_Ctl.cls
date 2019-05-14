public class NewOfferEmailComp_Ctl {
    public Id offid {get; set;}
    public Cloufi__Offers__c objOffer{get;set;}
    
    public List<Cloufi__Offers__c> getOffer(){
        if(offid!= null)
        {
            List<Cloufi__Offers__c> lstOffer = new List<Cloufi__Offers__c>();
            
            String query = 'SELECT ';
            for(Schema.FieldSetMember f : this.getFields()) {
                query += f.getFieldPath() + ', ';
            }
            query += 'Id FROM Cloufi__Offers__c where Id=: offid';
            objOffer = (Cloufi__Offers__c)Database.query(query);
            lstOffer.add(objOffer);
            return lstOffer;
        }
        return null;
    }
    
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Cloufi__Offers__c.FieldSets.New_Offer_for_Support_Group.getFields();
    }
    
    public string getOfferLink(){
        string base_URL = Label.Base_URL;
        return base_URL+'/'+offid;
    }
}