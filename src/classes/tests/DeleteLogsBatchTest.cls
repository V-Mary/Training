/**
 * Created by Mariya on 19.01.2023.
 */
//CreatedDate = Datetime.newInstance(2022, 01, 01, 01, 01, 01)
@IsTest
private class DeleteLogsBatchTest {

    @TestSetup private static void makeData() {
        insert new List<Log__c>{
                new Log__c(Name = 'test1'),
                new Log__c(Name = 'test2'),
                new Log__c(Name = 'test3')
        };
    }

    @IsTest private static void DeleteLogsTest() {
        Log__c log = [SELECT Id, CreatedDate FROM Log__c LIMIT 1];

        Test.setCreatedDate(log.Id, System.now().addDays(-10));

        Test.startTest();
        DeleteLogsBatch batch = new DeleteLogsBatch(7);
        Database.executeBatch(batch);
        Test.stopTest();

        List<Log__c> logs = [SELECT Name FROM Log__c];

        Assert.areEqual(3, logs.size());
    }
}