/*****************************************************************
 * Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
 * Class Name: BitlyHttpCalloutMock
 * Created Date: 01-14-2019
 * Description: Mock class for Bitly Service
 *******************************************************************/
@isTest
public class BitlyHttpCalloutMock implements HttpCalloutMock {

    public HttpResponse respond( HttpRequest req ) {
		HttpResponse res = new HttpResponse();
        String endpoint = req.getEndpoint();
        system.debug('Inside Mock');
        if ( endpoint.contains('/oauth/access_token') ) {
            res.setBody('123');
        } else if ( endpoint.contains('/v3/shorten') ) {
            res.setBody('https://www.salesforce.com');
        }

        res.setStatusCode(200);
        system.debug('res=>'+res);
        return res;
    }
}