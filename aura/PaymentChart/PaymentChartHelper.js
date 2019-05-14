({
	getAccountIDNameList : function(component, event, helper) {
        console.log('in get program method');
        //component.set("v.Spinner", true);
        var action = component.get("c.getAccountList");
		
        action.setParams({
            oppId : component.get("v.recordId")
        });
        //var program = component.get("v.selectedProgram");
        action.setCallback(this,function(response){
	        var val = response.getReturnValue();
	        var tempList = [];
	        tempList = val;
	        console.log('299 State>>'+response.getState());
            if(response.getState()==='SUCCESS'){
                if(! $A.util.isEmpty(tempList)){
                    component.set("v.accList",tempList);
                    console.log('accList'+component.get("v.accList"));
                    console.log('List==>'+tempList[0].Id);
                }
            }
        });
        
        $A.enqueueAction(action); 
    },
})