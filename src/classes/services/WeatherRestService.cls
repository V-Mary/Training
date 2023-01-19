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
            logger.logSuccess('API', 'WeatherRestService');
        } catch (Exception e) {
            logger.logError('API', 'WeatherRestService', e);
            res.statusCode = 500;
        } finally {
            logger.flush();
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
            logger.logSuccess('API', 'WeatherRestService');
        } catch (Exception e) {
            logger.logError('API', 'WeatherRestService', e);
            res.statusCode = 500;
        } finally {
            logger.flush();
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
            logger.logSuccess('API', 'WeatherRestService');
        } catch (Exception e) {
            logger.logError('API', 'WeatherRestService', e);
            res.statusCode = 500;
        } finally {
            logger.flush();
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
            logger.logSuccess('API', 'WeatherRestService');
        } catch (Exception e) {
            logger.logError('API', 'WeatherRestService', e);
            res.statusCode = 500;
        } finally {
            logger.flush();
        }
    }
}