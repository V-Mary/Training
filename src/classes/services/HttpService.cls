/**
 * Created by Mariya on 30.11.2022.
 */

public class HttpService {

    public static String makeHttpRequest(String callout, String urlData, String method, Map<String, String> apiKeyMap){
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setEndpoint(callout+'/'+urlData);

        for(String keyMap: apiKeyMap.keySet()){
            req.setHeader(keyMap, apiKeyMap.get(keyMap));
        }

        Http http = new Http();
        HttpResponse res = http.send(req);

        return res.getBody();
    }

}