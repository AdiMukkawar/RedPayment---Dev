({
    fetchPickListVal: function(component, fieldName, picklistOptsAttributeName) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfoForPicklistValues"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();

                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v." + picklistOptsAttributeName, opts);
            }
        });
        $A.enqueueAction(action);
    },
    fetchUserHelper : function(component,helper,event) {
        var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
               // set current user information on userInfo attribute
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },

    getUWNameHelper : function(component,helper,event,uwId) {
        var action = component.get("c.getUWNameCtrl");
        action.setParams({uwId:uwId});
        action.setCallback(this, function(response) {
            component.set("v.uwName",response.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    deleteUWHelper : function(component, event) {
        console.log('in delete account helper method.');
        var action = component.get("c.deleteUWDocument");
        console.log('component.get("v.uwIDToDelete")=>'+component.get("v.uwIDToDelete"));
        action.setParams({uwId:component.get("v.uwIDToDelete")});
        action.setCallback(this, function(response) {
            component.set("v.documentList",response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    getLendersHelper : function(component, event, helper) {
        //console.log('Inside getLendersHelper=>');
        //console.log('opportunityId=>'+component.get("v.opportunityId"));        
        var action = component.get("c.getReqLenders");
        action.setParams({
            'oppId': component.get("v.opportunityId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var arrayMapKeys = [];
                for(var key in result){
                    //console.log('key : '+ key+ 'Map value: ', result[key]);
                    arrayMapKeys.push({key: key, value: result[key]});
                }
                //console.log('arrayMapKeys=>'+arrayMapKeys);
                component.set("v.mapValues", arrayMapKeys);
            }
        });
        $A.enqueueAction(action);
    },
    getLendersNameHelper : function(component, event, helper) {
        //console.log('Inside getLendersNameHelper=>');
        //console.log('opportunityId=>'+component.get("v.opportunityId"));        
        var action = component.get("c.getReqLendersName");
        action.setParams({
            'oppId': component.get("v.opportunityId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var arrayMapKeys1 = [];
                for(var key in result){
                    //console.log('key : '+ key+ 'Map value: ', result[key]);
                    arrayMapKeys1.push({key: key, value: result[key]});
                }
                console.log('getLendersNameHelper=>'+arrayMapKeys1);
                component.set("v.mapNameValues", arrayMapKeys1);
            }
        });
        $A.enqueueAction(action);
    },
    
})