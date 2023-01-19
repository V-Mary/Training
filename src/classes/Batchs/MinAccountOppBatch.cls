/**
 * Created by Mariya on 17.01.2023.
 */

public with sharing class MinAccountOppBatch implements Database.Batchable<sObject>, Schedulable, Database.Stateful {

    private Decimal sumOfOpp;
    private Logger logger;
    private List<Opportunity> opportunitiesToSum = new List<Opportunity>();

    public Iterable<sObject> start(Database.BatchableContext param1) {
        return Database.getQueryLocator('SELECT Id, Name, (SELECT Amount FROM Opportunities) FROM Account WHERE Id in (SELECT AccountId FROM Opportunity)');
    }


    public void execute(Database.BatchableContext param1, List<Account> accounts) {

        try {
            this.logger = new Logger();

            for (Account acc : accounts) {
                System.debug(acc);
                Opportunity minOpp = acc.Opportunities[0];

                for (Opportunity opp : acc.Opportunities) {
                    if (opp.Amount < minOpp.Amount) {
                        minOpp = opp;
                    }
                }

                this.opportunitiesToSum.add(minOpp);
            }

        } catch (Exception e) {
            logger.logError('BATCH', 'MinAccountOppBatch', e);
            logger.flush();
        }
    }

    public void finish(Database.BatchableContext param1) {
        this.sumOfOpp = 0;

        try {
            for (Opportunity opp : this.opportunitiesToSum) {
                sumOfOpp += opp.Amount;
            }

            OrgConfiguration__c orgConfiguration = OrgConfiguration__c.getOrgDefaults();
            orgConfiguration.Lesser_Amounts__c = sumOfOpp;
            upsert orgConfiguration;

            logger.logSuccess('BATCH', 'MinAccountOppBatch');
        } catch (Exception e) {
            logger.logError('BATCH', 'MinAccountOppBatch', e);
        } finally {
            logger.flush();
        }
    }

    public void execute(SchedulableContext param1) {
        MinAccountOppBatch minAccountOppBatch = new MinAccountOppBatch();
        Id batchId = Database.executeBatch(minAccountOppBatch);
    }
}