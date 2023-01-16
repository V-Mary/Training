/**
 * Created by Mariya on 13.01.2023.
 */

@isTest
private class OpenWeatherControllerTest {

    @isTest static void testGetWeatherByCityName() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        MockHttpResponseGenerator.indicatorVar = 'byName';

        HttpResponse res = OpenWeatherController.getWeatherByCityName('London');

        String actualValue = res.getBody();
        String expectedValue = '{"coord":{"lon":-0.1257,"lat":51.5085},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03d"}],"base":"stations","main":{"temp":283.13,"feels_like":279.38,"temp_min":282.06,"temp_max":283.91,"pressure":1008,"humidity":69},"visibility":10000,"wind":{"speed":9.77,"deg":260,"gust":17.49},"clouds":{"all":40},"dt":1673612701,"sys":{"type":2,"id":2075535,"country":"GB","sunrise":1673596874,"sunset":1673626584},"timezone":0,"id":2643743,"name":"London","cod":200}';
        Assert.areEqual(actualValue, expectedValue);
        Assert.areEqual(200, res.getStatusCode());
    }

    @isTest static void testGetWeatherByCityId() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        MockHttpResponseGenerator.indicatorVar = 'byId';

        HttpResponse res = OpenWeatherController.getWeatherByCityId('2643743');

        String actualValue = res.getBody();
        String expectedValue = '{"coord":{"lon":-0.1257,"lat":51.5085},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03d"}],"base":"stations","main":{"temp":283.13,"feels_like":279.38,"temp_min":282.06,"temp_max":283.91,"pressure":1008,"humidity":69},"visibility":10000,"wind":{"speed":9.77,"deg":260,"gust":17.49},"clouds":{"all":40},"dt":1673612701,"sys":{"type":2,"id":2075535,"country":"GB","sunrise":1673596874,"sunset":1673626584},"timezone":0,"id":2643743,"name":"London","cod":200}';
        Assert.areEqual(actualValue, expectedValue);
        Assert.areEqual(200, res.getStatusCode());
    }


    @isTest static void testGetWeatherByCityIdNegative() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        MockHttpResponseGenerator.indicatorVar = 'wrong';

        HttpResponse res = OpenWeatherController.getWeatherByCityId('wrongId');

        System.debug(res.getStatusCode());

        String actualValue = res.getBody();
        String expectedValue = '{"cod":"404","message":"city not found"}';
        Assert.areEqual(expectedValue, actualValue);
        Assert.areEqual(404, res.getStatusCode());
    }

    @isTest static void testSaveWeather() {

        String res = '{"coord":{"lon":-0.1257,"lat":51.5085},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"base":"stations","main":{"temp":280.07,"feels_like":276.42,"temp_min":278.47,"temp_max":281.07,"pressure":1014,"humidity":80},"visibility":10000,"wind":{"speed":6.17,"deg":250},"clouds":{"all":99},"dt":1673641507,"sys":{"type":2,"id":2075535,"country":"GB","sunrise":1673596874,"sunset":1673626584},"timezone":0,"id":2643743,"name":"London","cod":200}';

        OpenWeatherController.saveWeather(res);

        List<Weather__c> weathers = [SELECT Id FROM Weather__c];

        Assert.areEqual(1, weathers.size(), 'Do not save new record!');
    }
}