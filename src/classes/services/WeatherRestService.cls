/**
 * Created by Mariya on 12.12.2022.
 */
@RestResource(urlMapping='/Weather/*')
global with sharing class WeatherRestService {

    @HttpGet
    global static void getWeather() {
        Logger logger = new Logger();
        RestResponse res = RestContext.response;
        try {
            String body = WeatherService.handleRequest(RestContext.request);
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(body);
        } catch (Exception e) {
            logger.createErrorLog('API', 'WeatherRestService', e);
        }
    }

    @HttpDelete
    global static void deleteWeather() {
        Logger logger = new Logger();
        RestResponse res = RestContext.response;
        try {
            String body = WeatherService.handleRequest(RestContext.request);
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(body);
        } catch (Exception e) {
            logger.createErrorLog('API', 'WeatherRestService', e);
        }
    }

    @HttpPost
    global static void createWeather() {
        Logger logger = new Logger();
        RestResponse res = RestContext.response;
        try {
            String body = WeatherService.handleRequest(RestContext.request);
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(body);
        } catch (Exception e) {
            logger.createErrorLog('API', 'WeatherRestService', e);
        }
    }

    @HttpPatch
    global static void updateWeather() {
        Logger logger = new Logger();
        RestResponse res = RestContext.response;
        try {
            String body = WeatherService.handleRequest(RestContext.request);
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(body);
        } catch (Exception e) {
            logger.createErrorLog('API', 'WeatherRestService', e);
        }
    }
}