({
	doInit: function(component, event, helper) {
		helper.getUWDocumentListHelper(component,helper);
	},
    closePopup : function(component, event, helper) {
    	component.set("v.showPopup",false);
	}

})