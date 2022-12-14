/**
 * Created by Mariya on 12.12.2022.
 */
@RestResource(urlMapping='/Weather/*')
global with sharing class WeatherRestService {

    @HttpGet
    global static void getWeather() {
        RestResponse res = RestContext.response;
        String body = WeatherService.handleRequest(RestContext.request);
        res.statusCode = 200;
        res.responseBody = Blob.valueOf(body);
    }

    @HttpDelete
    global static void deleteById() {
        RestResponse res = RestContext.response;
        String body = WeatherService.handleRequest(RestContext.request);
        res.statusCode = 200;
        res.responseBody = Blob.valueOf(body);
    }

    @HttpPost
    global static void postById() {
        RestResponse res = RestContext.response;
        String body = WeatherService.handleRequest(RestContext.request);
        res.statusCode = 200;
        res.responseBody = Blob.valueOf(body);
    }

    @HttpPatch
    global static void patchById() {
        RestResponse res = RestContext.response;
        String body = WeatherService.handleRequest(RestContext.request);
        res.statusCode = 200;
        res.responseBody = Blob.valueOf(body);
    }
}