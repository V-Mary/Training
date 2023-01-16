/**
 * Created by Mariya on 14.12.2022.
 */

public with sharing class WeatherDto {

    private String name;
    private Integer temp;
    private Integer temp_min;
    private Integer temp_max;
    private Integer humidity;
    private Integer pressure;
    private Integer speed;
    private Datetime dt;
    private String cityId;

    public WeatherDto(String name, Integer temp, Integer temp_min, Integer temp_max, Integer humidity, Integer pressure, Integer speed, Datetime dt) {
        this.name = name;
        this.temp = temp;
        this.temp_min = temp_min;
        this.temp_max = temp_max;
        this.humidity = humidity;
        this.pressure = pressure;
        this.speed = speed;
        this.dt = dt;
    }

    public WeatherDto(String name, Integer temp, Integer speed) {
        this.name = name;
        this.temp = temp;
        this.speed = speed;
    }

    public Weather__c createWeather() {
        return new Weather__c(Name = this.name, Temp__c = this.temp, Wind_Speed__c = this.speed);
    }

    public Weather__c updateWeather() {
        return new Weather__c(CityId__c = this.cityId, Temp__c = this.temp, Wind_Speed__c = this.speed);
    }
}