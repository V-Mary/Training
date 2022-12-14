/**
 * Created by Mariya on 13.12.2022.
 */

public with sharing class WeatherService {

    static Map<String, WeatherRestCall> methods = new Map<String, WeatherRestCall>{
            'getDetailsByDate' => new GetWeatherByDate(),
            'getDetailsById' => new GetWeatherById(),
            'createNewRecord' => new PostWeather(),
            'updateRecord' => new PatchWeather(),
            'deleteRecord' => new DeleteWeather()
    };

    public static String handleRequest(RestRequest request) {
        return methods.get(request.params.get('method')).handle(request);
    }

    class GetWeatherByDate implements WeatherRestCall {
        public String handle(RestRequest request) {
            String weatherYear = request.params.get('year');
            return JSON.serialize(WeatherSelector.getByYear(weatherYear));
        }
    }

    class GetWeatherById implements WeatherRestCall {
        public String handle(RestRequest request) {
            String weatherId = request.params.get('id');
            return JSON.serialize(WeatherSelector.getById(weatherId));
        }
    }

    class PostWeather implements WeatherRestCall {
        public String handle(RestRequest request) {
            String weatherName = request.params.get('name');
            String weatherTemp = request.params.get('temp');
            String weatherWindSpeed = request.params.get('speed');
            Weather__c newWeather = new Weather__c(Name = weatherName, Temp__c = Integer.valueOf(weatherTemp), Wind_Speed__c = Integer.valueOf(weatherWindSpeed));
            insert newWeather;
            return JSON.serialize(newWeather);
        }
    }

    class PatchWeather implements WeatherRestCall {
        public String handle(RestRequest request) {
            String weatherId = request.params.get('id');
            String weatherTemp = request.params.get('temp');
            List<Weather__c> weathers = WeatherSelector.getById(weatherId);
            weathers.get(0).Temp__c = Integer.valueOf(weatherTemp);
            update weathers;
            return JSON.serialize(weathers);
        }
    }

    class DeleteWeather implements WeatherRestCall {
        public String handle(RestRequest request) {
            String weatherId = request.params.get('id');
            List<Weather__c> weatherToDelete = WeatherSelector.getById(weatherId);
            delete weatherToDelete;
            return JSON.serialize('Weather deleted successfully');
        }
    }
}