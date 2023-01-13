/**
 * Created by Mariya on 13.01.2023.
 */

@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    public static String indicatorVar;

    HttpResponse res = new HttpResponse();

    global HTTPResponse respond(HTTPRequest req) {

        if (indicatorVar == 'byName') {
            System.assertEquals('callout:OpenWeatherNamedCredential' + '/data/2.5/weather?q=London',
                    req.getEndpoint());
        } else if (indicatorVar == 'byId') {
            System.assertEquals('callout:OpenWeatherNamedCredential' + '/data/2.5/weather?id=2643743',
                    req.getEndpoint());
        } else if (indicatorVar == 'wrong') {
            System.assertEquals('callout:OpenWeatherNamedCredential' + '/data/2.5/weather?id=wrongId',
                    req.getEndpoint());
            res.setBody('{"cod":"404","message":"city not found"}');
            res.setStatusCode(404);
            return res;
        }

        System.assertEquals('GET', req.getMethod());

        res.setBody('{"coord":{"lon":-0.1257,"lat":51.5085},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03d"}],"base":"stations","main":{"temp":283.13,"feels_like":279.38,"temp_min":282.06,"temp_max":283.91,"pressure":1008,"humidity":69},"visibility":10000,"wind":{"speed":9.77,"deg":260,"gust":17.49},"clouds":{"all":40},"dt":1673612701,"sys":{"type":2,"id":2075535,"country":"GB","sunrise":1673596874,"sunset":1673626584},"timezone":0,"id":2643743,"name":"London","cod":200}');
        res.setStatusCode(200);
        return res;
    }
}