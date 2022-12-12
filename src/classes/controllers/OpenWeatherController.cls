/**
 * Created by Mariya on 30.11.2022.
 */

public with sharing class OpenWeatherController {
    public static String getWeatherByCityName (String cityName) {
        String urlData = 'data/2.5/weather?q='+cityName;
        Map<String, String> apiKeyMap = new Map<String, String>{'x-api-key' => '{!$Credential.Password}'};

        return HttpService.makeHttpRequest(
                'callout:OpenWeatherNamedCredential', urlData, 'GET', apiKeyMap);

    }

    public static String getWeatherByCityId (String cityId) {
        String urlData = 'data/2.5/weather?id='+cityId;
        Map<String, String> apiKeyMap = new Map<String, String>{'x-api-key' => '{!$Credential.Password}'};

        return HttpService.makeHttpRequest(
                'callout:OpenWeatherNamedCredential', urlData, 'GET', apiKeyMap);

    }

    public static void saveWeather(String responseData){
        OpenWeatherDto.fromJSON data = OpenWeatherDto.parse(responseData);

        Weather__c weatherRecord = new Weather__c();
        weatherRecord.Name = data.name ;
        weatherRecord.Humidity__c = data.main.humidity ;
        weatherRecord.Max_Temperature__c = data.main.temp_max ;
        weatherRecord.Min_Temperature__c = data.main.temp_min ;
        weatherRecord.Pressure__c = data.main.pressure ;
        weatherRecord.Temp__c = data.main.temp ;
        weatherRecord.Wind_Speed__c = data.wind.speed ;
        weatherRecord.Date_and_Time__c = DateTime.newInstance(data.dt);

        insert weatherRecord;
    }
}