({
	doInit : function(component, event, helper) {
		helper.fetchUserHelper(component, event, helper);
		helper.getSalesRepNoteList(component, event, helper);
	},

	saveSalesRepNote : function(component, event, helper) {
        component.set('v.SaveRepresentativeNote', false);
        helper.saveSalesRepNoteHelper(component, event, helper);       
    },
})