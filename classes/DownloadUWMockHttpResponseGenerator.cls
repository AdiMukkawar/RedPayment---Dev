global class DownloadUWMockHttpResponseGenerator implements HttpCalloutMock
{
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"probability_1":0.00321}');
        response.setStatusCode(200);
        return response;
    }
}