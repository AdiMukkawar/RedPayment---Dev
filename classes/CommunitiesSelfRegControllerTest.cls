/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
@IsTest public with sharing class CommunitiesSelfRegControllerTest {
    @IsTest 
    public static void testCommunitiesSelfRegController() {
        /*Account objAcc = new Account(Name = 'Test');
        insert objAcc;
        PageReference pageRef = Page.communitiesSelfReg;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(objAcc.Id));
        //SyndicationPortalController sc = new SyndicationPortalController();*/
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        controller.registerUser();
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);    
        
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null);  
    }    
}