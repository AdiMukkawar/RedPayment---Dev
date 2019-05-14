/*****************************************************************
Mock Class For  : AddUWDocumentsControllerX 
-------------------------------------------------------------------------------------------
Author           | Project       |    Date       | Description
-------------------------------------------------------------------------------------------
Aditya Mukkawar  | Red Payment   |   01/30/2019  | Mock callout class to create response
********************************************************************/
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    
   //class with the code of HttpCalloutMock
    public HTTPResponse respond(HTTPRequest req){
        String Body;
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/octet-stream');
        if(req.getEndpoint().contains('https://content.dropboxapi.com/2/files/upload')){
            res.setBody('{"name": "Test Image GMEg1WU6r6.png", "path_lower": "/salesforce%20documents/test image gmeg1wu6r6.png", "path_display": "/Salesforce%20Documents/Test Image GMEg1WU6r6.png", "id": "id:ZjFvMRv6-XAAAAAAAAApwA", "client_modified": "2019-01-30T11:11:09Z", "server_modified": "2019-01-30T11:11:09Z", "rev": "38b74b6d9665", "size": 30548, "content_hash": "3169da6d6cc31a8f04ce2f9316b7177d969ba650f86ca1bbe242a4ea766c1b69"}');
            res.setStatusCode(200);
        }else if(req.getEndpoint().contains('https://api.dropboxapi.com/2/sharing/create_shared_link_with_settings')){
            res.setBody('{".tag": "file", "url": "https://www.dropbox.com/s/c85zff08k22ah0y/Test%20Image%20GMEg1WU6r6.png?dl=0", "id": "id:ZjFvMRv6-XAAAAAAAAApwA", "name": "Test Image GMEg1WU6r6.png", "path_lower": "/salesforce%20documents/test image gmeg1wu6r6.png", "link_permissions": {"resolved_visibility": {".tag": "public"}, "requested_visibility": {".tag": "public"}, "can_revoke": true, "visibility_policies": [{"policy": {".tag": "public"}, "resolved_policy": {".tag": "public"}, "allowed": true}, {"policy": {".tag": "team_only"}, "resolved_policy": {".tag": "team_only"}, "allowed": false, "disallowed_reason": {".tag": "user_not_on_team"}}, {"policy": {".tag": "password"}, "resolved_policy": {".tag": "password"}, "allowed": false, "disallowed_reason": {".tag": "user_account_type"}}], "can_set_expiry": false, "can_remove_expiry": true, "allow_download": true, "can_allow_download": true, "can_disallow_download": false, "allow_comments": true, "team_restricts_comments": false}, "preview_type": "photo", "client_modified": "2019-01-30T11:11:09Z", "server_modified": "2019-01-30T11:11:09Z", "rev": "38b74b6d9665", "size": 30548}');
        	res.setStatusCode(200);
        }
        return res;
    }
}