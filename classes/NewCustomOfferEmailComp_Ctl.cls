/*
 * Test class Name - NewOfferEmailComp_Ctl_Test
 * */
public class NewCustomOfferEmailComp_Ctl {
    public Id offid{get;set;}
    public string getOfferLink(){
        string base_URL = Label.Base_URL;
        return base_URL+'/'+offid;
    }
}