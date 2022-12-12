@RestResource(urlMapping='/Weather/*')
global with sharing class WeatherRestService {

    @HttpGet
    global static Weather__c getById() {
        RestRequest req = RestContext.request;
        String weatherId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Weather__c result = WeatherSelector.getById(weatherId);
        return result;
    }

    @HttpGet
    global static List<Weather__c> getByDateTime() {
        RestRequest req = RestContext.request;
        String weatherDateTime = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        List<Weather__c> result = WeatherSelector.getByYear(weatherDateTime);
        return result;
    }

    @HttpDelete
    global static void deleteById() {
        RestRequest req = RestContext.request;
        String weatherId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Weather__c result = WeatherSelector.getById(weatherId);
        delete result;
    }

    @HttpPost
    global static String postById(String name, Integer temp, Integer windSpeed) {
        Weather__c newWeather = new Weather__c( Name  = name, Temp__c = temp, Wind_Speed__c  = windSpeed);
        insert newWeather;
        return newWeather.Id;
    }

    @HttpPatch
    global static String patchById(Integer temp) {
        RestRequest req = RestContext.request;
        String weatherId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Weather__c result = WeatherSelector.getById(weatherId);
        result.Temp__c = temp;
        update result;
        return result.Id;
    }
}