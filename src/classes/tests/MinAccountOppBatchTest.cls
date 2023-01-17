/**
 * Created by Mariya on 17.01.2023.
 */

@IsTest
private class MinAccountOppBatchTest {

    @TestSetup
    private static void makeData() {
        Account acc1 = new Account(Name = 'acc1');
        Account acc2 = new Account(Name = 'acc1');

        insert new List<Account>{
                acc1, acc2
        };

        insert new List<Opportunity>{
                new Opportunity(Name = 'opp1', Amount = 200, AccountId = acc1.Id, CloseDate = Date.newInstance(2023, 11, 11), StageName = 'Closed Won'),
                new Opportunity(Name = 'opp2', Amount = 300, AccountId = acc1.Id, CloseDate = Date.newInstance(2023, 11, 11), StageName = 'Closed Won'),
                new Opportunity(Name = 'opp3', Amount = 400, AccountId = acc2.Id, CloseDate = Date.newInstance(2023, 11, 11), StageName = 'Closed Won'),
                new Opportunity(Name = 'opp4', Amount = 500, AccountId = acc2.Id, CloseDate = Date.newInstance(2023, 11, 11), StageName = 'Closed Won'),
                new Opportunity(Name = 'opp5', Amount = 600, AccountId = acc2.Id, CloseDate = Date.newInstance(2023, 11, 11), StageName = 'Closed Won')
        };
    }

    @IsTest
    private static void MinAccountOppTest() {

        Test.startTest();
        MinAccountOppBatch batch = new MinAccountOppBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        List<OrgConfiguration__c> orgConfigurations = [SELECT Lesser_Amounts__c FROM OrgConfiguration__c];

        Assert.areEqual(600, orgConfigurations[0].Lesser_Amounts__c);
    }

}