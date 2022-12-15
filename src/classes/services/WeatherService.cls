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
            return JSON.serialize(WeatherSelector.getWeatherByCityId(weatherId));
        }
    }

    class PostWeather implements WeatherRestCall {
        public String handle(RestRequest request) {
            WeatherDto weather = (WeatherDto) JSON.deserialize(request.requestBody.toString(), WeatherDto.class);
            Weather__c newWeather = weather.createWeather();
            insert newWeather;
            return JSON.serialize(newWeather);
        }
    }

    class PatchWeather implements WeatherRestCall {
        public String handle(RestRequest request) {
            WeatherDto weatherDto = (WeatherDto) JSON.deserialize(request.requestBody.toString(), WeatherDto.class);
            Weather__c weather = weatherDto.updateWeather();
            upsert weather CityId__c;
            return JSON.serialize(weather);

        }
    }

    class DeleteWeather implements WeatherRestCall {
        public String handle(RestRequest request) {
            String weatherId = request.params.get('id');
            List<Weather__c> weatherToDelete = WeatherSelector.getWeatherByCityId(weatherId);
            delete weatherToDelete;
            return JSON.serialize('Weather deleted successfully');
        }
    }
}