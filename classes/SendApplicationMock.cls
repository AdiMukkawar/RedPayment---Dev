/*
Author      | Date        | Description
Prashant    | 13-08-2018  | Mock class for SendApplicationController
*/
@isTest
global class SendApplicationMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
           
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if(req.getEndpoint()=='https://lookups.twilio.com/v1/PhoneNumbers/+917972947140'){
            res.setBody('{"caller_name": null, "country_code": "IN", "phone_number": "+917972947140", "national_format": "079729 47140", "carrier": {"mobile_country_code": "405", "mobile_network_code": "864", "name": "Reliance (JIO) - Maharashtra & Goa", "type": "mobile", "error_code": null}, "add_ons": null, "url": "https://lookups.twilio.com/v1/PhoneNumbers/+917972947140?Type=carrier"}');                           
        }else if(req.getEndpoint()=='https://api.twilio.com/2010-04-01/Accounts/'){
            res.setBody('{"from": "+14154847489","to": "+918149060864", "body": "Test", "status": "queued", "sid": "asdsf514554fdhgd"}');                           
        }
        res.setStatusCode(200);
        return res;	
            
    }
}