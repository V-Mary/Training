/**
 * Created by Mariya on 15.01.2023.
 */

@IsTest private class WeatherRestServiceTest {

    @TestSetup
    private static void makeData() {
        Weather__c weather = new Weather__c(Name = 'test', CityId__c = 'test', Temp__c = 23, Wind_Speed__c = 22, Date_and_Time__c = DateTime.newInstance(2023, 12, 17, 13, 6, 6));
        insert weather;
    }

    @IsTest private static void createWeatherTest() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Weather?';

        req.httpMethod = 'POST';

        req.addParameter('method', 'createNewRecord');

        String postData = '{\n' +
                '    "name":"test",\n' +
                '    "temp":"12",\n' +
                '    "speed":"421"\n' +
                '}';

        req.requestBody = Blob.valueof(postData);

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        WeatherRestService.createWeather();
        Test.stopTest();

        List<Weather__c> weathers = [SELECT Id, Name, Temp__c, Wind_Speed__c FROM Weather__c];

        String responceExpected = '{"attributes":{"type":"Weather__c","url":"/services/data/v56.0/sobjects/Weather__c/' + weathers.get(1).Id + '"},"Name":"' + weathers.get(1).Name + '","Temp__c":' + weathers.get(1).Temp__c + ',"Wind_Speed__c":' + weathers.get(1).Wind_Speed__c + ',"Id":"' + weathers.get(1).Id + '"}';

        Assert.areEqual(2, weathers.size());
        Assert.areEqual(200, res.statusCode);
        Assert.areEqual(responceExpected, res.responseBody.toString());
    }

    @IsTest private static void getWeatherByDateTest() {
        Weather__c weather = [SELECT Id, Date_and_Time__c FROM Weather__c WHERE Name = 'test'];

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Weather?';

        req.httpMethod = 'GET';

        req.addParameter('method', 'getDetailsByDate');
        req.addParameter('year', '2023');

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        WeatherRestService.getWeather();
        Test.stopTest();

        String responceExpected = '[{"attributes":{"type":"Weather__c","url":"/services/data/v56.0/sobjects/Weather__c/' + weather.Id + '"},"Date_and_Time__c":"' + weather.Date_and_Time__c.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ') + '","Id":"' + weather.Id + '"}]';

        Assert.areEqual(200, res.statusCode);
        Assert.areEqual(responceExpected, res.responseBody.toString());
    }

    @IsTest private static void getWeatherByDateNegativeTest() {

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Weather?';

        req.httpMethod = 'GET';

        req.addParameter('method', 'getDetailsByDate');
        req.addParameter('year', '2021');

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        WeatherRestService.getWeather();
        Test.stopTest();

        Assert.areEqual(200, res.statusCode);
        Assert.areEqual('[]', res.responseBody.toString());
    }

    @IsTest private static void getWeatherByIdTest() {
        Weather__c weather = [SELECT CityId__c FROM Weather__c WHERE Name = 'test'];

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Weather?';

        req.httpMethod = 'GET';

        req.addParameter('method', 'getDetailsById');
        req.addParameter('id', weather.CityId__c);

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        WeatherRestService.getWeather();
        Test.stopTest();

        Assert.areEqual(200, res.statusCode);
    }

    @IsTest private static void getWeatherByIdNegativeTest() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Weather?';

        req.httpMethod = 'GET';

        req.addParameter('method', 'getDetailsById');
        req.addParameter('id', 'xxxx');

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        WeatherRestService.getWeather();
        Test.stopTest();

        Assert.areEqual(200, res.statusCode);
        Assert.areEqual('[]', res.responseBody.toString());
    }

    @IsTest private static void deleteWeatherTest() {
        Weather__c weather = [SELECT CityId__c FROM Weather__c WHERE Name = 'test'];

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Weather?';

        req.httpMethod = 'DELETE';

        req.addParameter('method', 'deleteRecord');
        req.addParameter('id', weather.CityId__c);

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        WeatherRestService.deleteWeather();
        Test.stopTest();

        List<Weather__c> weathers = [SELECT Id FROM Weather__c];

        Assert.areEqual(200, res.statusCode);
        Assert.areEqual(0, weathers.size());
        Assert.areEqual('"Weather deleted successfully"', res.responseBody.toString());
    }

    @IsTest private static void deleteWeatherNegativeTest() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Weather?';

        req.httpMethod = 'DELETE';

        req.addParameter('method', 'deleteRecord');
        req.addParameter('id', 'xxx');

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        WeatherRestService.deleteWeather();
        Test.stopTest();

        List<Weather__c> weathers = [SELECT Id FROM Weather__c];

        Assert.areEqual(200, res.statusCode);
        Assert.areEqual(1, weathers.size());
        Assert.areEqual('"Wrong id"', res.responseBody.toString());
    }

    @IsTest private static void updateWeatherTest() {
        Weather__c weather = [SELECT Id FROM Weather__c WHERE Name = 'test'];

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Weather?';

        req.httpMethod = 'PATCH';

        String postData = '{\n' +
                '    "CityId": "test",\n' +
                '    "temp":"532",\n' +
                '    "speed":"22"\n' +
                '}';

        req.requestBody = Blob.valueof(postData);

        req.addParameter('method', 'updateRecord');

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        WeatherRestService.updateWeather();
        Test.stopTest();

        List<Weather__c> weathers = [SELECT Id FROM Weather__c];

        String responceExpected = '{"attributes":{"type":"Weather__c","url":"/services/data/v56.0/sobjects/Weather__c/' + weather.Id + '"},"CityId__c":"test","Temp__c":532,"Wind_Speed__c":22,"Id":"' + weather.Id + '"}';

        Assert.areEqual(1, weathers.size());
        Assert.areEqual(200, res.statusCode);
        Assert.areEqual(responceExpected, res.responseBody.toString());
    }

    @IsTest private static void updateWeatherNewRecordTest() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Weather?';

        req.httpMethod = 'PATCH';

        String postData = '{\n' +
                '    "CityId": "newrecord",\n' +
                '    "temp":"28",\n' +
                '    "speed":"22"\n' +
                '}';

        req.requestBody = Blob.valueof(postData);

        req.addParameter('method', 'updateRecord');

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        WeatherRestService.updateWeather();
        Test.stopTest();

        List<Weather__c> weathers = [SELECT Id FROM Weather__c];

        Weather__c newRecord = [SELECT Id FROM Weather__c WHERE CityId__c = 'newrecord'];

        String responceExpected = '{"attributes":{"type":"Weather__c","url":"/services/data/v56.0/sobjects/Weather__c/' + newRecord.Id + '"},"CityId__c":"newrecord","Temp__c":28,"Wind_Speed__c":22,"Id":"' + newRecord.Id + '"}';

        Assert.areEqual(2, weathers.size());
        Assert.areEqual(200, res.statusCode);
        Assert.areEqual(responceExpected, res.responseBody.toString());
    }

}