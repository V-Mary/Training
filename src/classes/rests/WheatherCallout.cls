/**
 * Created by Mariya on 29.11.2022.
 */

public with sharing class WheatherCallout {

    public static String makeCallout() {
        HttpRequest req = new HttpRequest();
        String APIKey = 'c840127ab41a64ffc77361a9d11b3ab3';
        req.setEndpoint('http://api.openweathermap.org/data/2.5/forecast?id=524901&appid=' + APIKey);
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);

        return res.getBody();
    }
}