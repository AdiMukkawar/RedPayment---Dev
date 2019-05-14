@isTest
global class MockHttpResponseGenerator1 implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        System.debug('In Mock Class');
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"name": "Test Image GMEg1WU6r6.png", "path_lower": "/salesforce%20documents/test image gmeg1wu6r6.png", "path_display": "/Salesforce%20Documents/Test Image GMEg1WU6r6.png", "id": "id:ZjFvMRv6-XAAAAAAAAApwA", "client_modified": "2019-01-30T11:11:09Z", "server_modified": "2019-01-30T11:11:09Z", "rev": "38b74b6d9665", "size": 30548, "content_hash": "3169da6d6cc31a8f04ce2f9316b7177d969ba650f86ca1bbe242a4ea766c1b69"}');
        res.setStatusCode(200);
        return res; 
    }
}