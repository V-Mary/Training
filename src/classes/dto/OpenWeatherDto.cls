/**
 * Created by Mariya on 06.12.2022.
 */

public with sharing class OpenWeatherDto {

    public class fromJSON{
        public cls_coord coord;
        public cls_weather[] weather;
        public String base;
        public cls_main main;
        public Integer visibility;
        public cls_wind wind;
        public cls_clouds clouds;
        public Integer dt;
        public cls_sys sys;
        public Integer timezone;
        public Integer id;
        public String name;
        public Integer cod;
    }
    public class cls_coord {
        public Double lon;
        public Double lat;
    }
    public class cls_weather {
        public Integer id;
        public String main;
        public String description;
        public String icon;
    }
    public class cls_main {
        public Double temp;
        public Double feels_like;
        public Double temp_min;
        public Double temp_max;
        public Integer pressure;
        public Integer humidity;
    }
    public class cls_wind {
        public Double speed;
        public Integer deg;
        public Double gust;
    }
    public class cls_clouds {
        public Integer all;
    }
    public class cls_sys {
        public Integer type;
        public Integer id;
        public String country;
        public Integer sunrise;
        public Integer sunset;
    }

    public class wrapperData{
        public String name;
        public Double temp;
        public Double temp_min;
        public Double temp_max;
        public Double speed;
        public Integer humidity;
        public Integer pressure;
        public Integer dt;
        public wrapperData(fromJSON parseData){
            cls_main te = parseData.main;
            cls_wind w = parseData.wind;
            this.name = parseData.name;
            this.temp = te.temp;
            this.temp_min = te.temp_min;
            this.temp_max = te.temp_max;
            this.humidity = te.humidity;
            this.pressure = te.pressure;
            this.speed = w.speed;
            this.dt = parseData.dt;
        }
    }

    public static fromJSON parse(String body) {
        return (fromJSON) JSON.deserialize(body, fromJSON.class);
    }
}