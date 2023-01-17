/**
 * Created by Mariya on 17.01.2023.
 */

public with sharing class MinAccountOppBatch implements Database.Batchable<sObject>, Schedulable, Database.Stateful {

    public Iterable<sObject> start(Database.BatchableContext param1) {
        return Database.getQueryLocator('SELECT Id FROM Account');
    }

    public void execute(Database.BatchableContext param1, List<Account> accounts) {

        Logger logger = new Logger();

        try {
            List<Opportunity> opportunitiesToSum = new List<Opportunity>();

            for (Account acc : accounts) {
                List<Opportunity> opportunities = [SELECT Id, Amount FROM Opportunity WHERE AccountId = :acc.Id];

                if (opportunities.isEmpty()) {
                    continue;
                }

                Opportunity minOpp = opportunities[0];

                for (Opportunity opp : opportunities) {
                    if (opp.Amount < minOpp.Amount) {
                        minOpp = opp;
                    }
                }

                opportunitiesToSum.add(minOpp);
            }

            Decimal sum = 0;

            for (Opportunity opp : opportunitiesToSum) {
                sum = sum + opp.Amount;
            }

            OrgConfiguration__c orgConfiguration = new OrgConfiguration__c();

            orgConfiguration.Lesser_Amounts__c = sum;

            insert orgConfiguration;

            logger.logSuccess('BATCH', 'MinAccountOppBatch');

        } catch (Exception e) {
            logger.logError('BATCH', 'MinAccountOppBatch', e);
        } finally {
            logger.flush();
        }
    }

    public void finish(Database.BatchableContext param1) {
    }

    public void execute(SchedulableContext param1) {
        MinAccountOppBatch minAccountOppBatch = new MinAccountOppBatch();
        Id batchId = Database.executeBatch(minAccountOppBatch);
    }
}