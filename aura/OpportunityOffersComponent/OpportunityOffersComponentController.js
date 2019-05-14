({
      doInit: function(component, event, helper) {
        // Fetch the account list from the Apex controller
        helper.getsObjectRecs(component);
      },     
        createRecord : function (component, event, helper) {
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                "entityApiName": "Cloufi__Offers__c"
            });
            createRecordEvent.fire();
        },	
    })