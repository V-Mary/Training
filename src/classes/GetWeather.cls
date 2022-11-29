/**
 * Created by Mariya on 29.11.2022.
 */

public with sharing class GetWeather {

    public Datetime dateAndTime {get;set;}
    public Integer visibility  {get;set;}
    public MainItem mainItem  {get;set;}
    public WeatherItem weatherItem {get;set;}
    public WindItem windItem {get;set;}

    public class MainItem {
        public Integer temp;
        public Integer maxTemp;
        public Integer minTemp;
        public Integer pressure;
        public Integer humidity;
    }

    public class WeatherItem {
        public String descriotion;
    }

    public class WindItem {
        public Integer windSpeed;
    }

    public static List<GetWeather> pasrseWeatherData() {
        String inputData = WheatherCallout.makeCallout();

        JSONParser parser = JSON.createParser(inputData);

        List<GetWeather> weathers = new List<GetWeather>();

        while (parser.nextToken() != JSONToken.END_ARRAY) {

            GetWeather newWeatherRecord = new GetWeather();

            while (parser.nextToken() != JSONToken.END_OBJECT) {

                if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {

                    String attr = parser.getText();
                    parser.nextToken();

                    if(attr == 'dt_txt') {

                        newWeatherRecord.dateAndTime = DateTime.parse(parser.getText());

                    } else if(attr == 'visibility') {
                        newWeatherRecord.visibility = Integer.valueOf(parser.getText());
                    }else if(attr == 'main') {

                        GetWeather.MainItem main = new GetWeather.MainItem();

                        while(parser.nextToken() != JSONToken.END_OBJECT) {
                            if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                                String mainAttr = parser.getText();
                                parser.nextToken();
                                if(mainAttr == 'temp') {
                                    main.temp = Integer.valueOf(parser.getText());
                                } else if(mainAttr == 'temp_min') {
                                    main.maxTemp = Integer.valueOf(parser.getText());
                                } else if(mainAttr == 'temp_max') {
                                    main.minTemp = Integer.valueOf(parser.getText());
                                } else if(mainAttr == 'pressure') {
                                    main.pressure = Integer.valueOf(parser.getText());
                                } else if(mainAttr == 'humidity') {
                                    main.humidity = Integer.valueOf(parser.getText());
                                }
                                newWeatherRecord.mainItem = main;
                            }
                        }
                    }else if(attr == 'weather') {

                        GetWeather.WeatherItem weather = new WeatherItem();
                        while(parser.nextToken() != JSONToken.END_OBJECT) {
                            if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                                String mainAttr = parser.getText();
                                parser.nextToken();
                                if(mainAttr == 'description') {
                                    weather.descriotion = parser.getText();
                                }
                                newWeatherRecord.weatherItem = weather;
                            }
                        }
                    }else if(attr == 'wind') {

                        GetWeather.WindItem wind = new WindItem();
                        while(parser.nextToken() != JSONToken.END_OBJECT) {
                            if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                                String mainAttr = parser.getText();
                                parser.nextToken();
                                if(mainAttr == 'speed') {
                                    wind.windSpeed = Integer.valueOf(parser.getText());
                                }
                                newWeatherRecord.windItem = wind;
                            }
                        }
                    }
                }
                weathers.add(newWeatherRecord);
            }
        }
        return weathers;
    }
}