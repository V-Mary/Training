/**
 * Created by Mariya on 19.01.2023.
 */

public with sharing class DeleteLogsBatch implements Database.Batchable<sObject>, Schedulable, Database.Stateful {

    private Logger logger;

    public Iterable<sObject> start(Database.BatchableContext param1) {
        return Database.getQueryLocator('SELECT CreatedDate FROM Log__c WHERE CreatedDate < N_DAYS_AGO:7');
    }

    public void execute(Database.BatchableContext param1, List<Log__c> logs) {

        this.logger = new Logger();

        try {
            delete logs;
            logger.logSuccess('BATCH', 'DeleteLogsBatch');
        } catch (Exception e) {
            logger.logError('BATCH', 'DeleteLogsBatch', e);
        } finally {
            logger.flush();
        }
    }

    public void finish(Database.BatchableContext param1) {
    }

    public void execute(SchedulableContext param1) {
        DeleteLogsBatch deleteLogsBatch = new DeleteLogsBatch();
        Id batchId = Database.executeBatch(deleteLogsBatch);
    }
}