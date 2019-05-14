({
	getUWDocumentListHelper:function(component,helper) {
        var action = component.get("c.getUWDocumentList");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(data){
           var state = data.getState();
            if(state == "SUCCESS"){
                component.set("v.CompletedStips",data.getReturnValue());
            }else if(state = "ERROR"){
                alert('Unknow error');
            }
        });
        $A.enqueueAction(action);
    }
})