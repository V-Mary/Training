/**
 * Created by Mariya on 12.12.2022.
 */

public inherited sharing class WeatherSelector {

    public static List<Weather__c> getById(String id) {
        return [
                SELECT Name, Date_and_Time__c, Pressure__c, Humidity__c, Temp__c, Min_Temperature__c, Max_Temperature__c
                FROM Weather__c
                WHERE Id = :id
        ];
    }

    public static List<Weather__c> getByYear(String year) {

        List<Weather__c> weathers = new List<Weather__c>();

        for (Weather__c item : [SELECT Date_and_Time__c from Weather__c WHERE Date_and_Time__c != NULL]) {
            if (item.Date_and_Time__c.year() == Integer.valueOf(year)) {
                weathers.add(item);
            }
        }

        return weathers;
    }
}