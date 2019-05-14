/*****************************************************************
 * Author: Techila Global Services Pvt Ltd. (Aditya Mukkawar)
 * Class Name: BitlyService
 * Created Date: 01-14-2019
 * Description: Class to get access token using callouts

 *******************************************************************/
public class BitlyService {
        
    private String accessToken;
    
    public BitlyService() {
        this.accessToken = getAccessToken();
    }
    
    public String shorten( String url ) {

        HttpRequest req = new HttpRequest();
        req.setEndpoint(
            'callout:Bitly/v3/shorten' +
            '?access_token=' + this.accessToken +
            '&longUrl=' + EncodingUtil.urlEncode( url, 'UTF-8' ) +
            '&format=txt'
        );
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);
        return res.getBody();
    }    
    
    private String getAccessToken() {

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Bitly/oauth/access_token');
        req.setMethod('POST');

        Http http = new Http();
        HttpResponse res = http.send(req);
        return res.getBody();
    }    
}