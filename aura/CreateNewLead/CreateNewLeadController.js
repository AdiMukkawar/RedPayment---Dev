({		
    handleSaveLead: function(component, event, helper) {
        if(helper.validateRepaymentForm(component)){
            component.set('v.Spinner', true);
            helper.saveLead(component, event, helper);
        }else if(component.get('v.Lead.Email') == null || component.get('v.Lead.Email') == ""){
            component.set("v.displayEmailError",  false);
        }
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        component.set("v.Spinner", false);
    }, 
    
    // this function validate email address
    validateEmail : function(component, event, helper) {
        var isValidEmail = true;
        var emailFieldValue = component.get('v.Lead.Email');
        console.log('emailFieldValue=>'+emailFieldValue);
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        if(emailFieldValue != null)
        {
            var trimName = emailFieldValue.trim();
            component.set("v.Lead.Email", trimName);
        }
        if(emailFieldValue != "")
        {
            if(!$A.util.isEmpty(emailFieldValue)){   
                if(emailFieldValue.match(regExpEmailformat)){
                    $A.util.removeClass(emailFieldValue, 'slds-has-error');
                    isValidEmail = false;
                    component.set("v.displayEmailError",isValidEmail); 
                }else{
                    $A.util.addClass(emailFieldValue, 'slds-has-error');
                    isValidEmail = true;
                    component.set("v.displayEmailError",isValidEmail);
                }
            }
        }
        else{
            isValidEmail = false;
            component.set("v.displayEmailError",isValidEmail);
        }
    },
    
    validateFirstName : function(component, event, helper){
        var firstNameValue = component.get('v.Lead.FirstName');
        if(firstNameValue != null)
        {
            var trimName = firstNameValue.trim();
            component.set("v.Lead.FirstName", trimName);
        }
    },
    
    validateLastName : function(component, event, helper){
        var lastNameValue = component.get('v.Lead.LastName');
        if(lastNameValue != null)
        {
            var trimName = lastNameValue.trim();
            component.set("v.Lead.LastName",trimName);
        }
    },
    
    validateCompany : function(component, event, helper){
        var companyValue = component.get('v.Lead.Company');
        if(companyValue != null)
        {
            var trimName = companyValue.trim();
            component.set("v.Lead.Company",trimName);
        }
    }
})