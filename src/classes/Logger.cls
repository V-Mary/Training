/**
 * Created by Mariya on 14.12.2022.
 */

public with sharing class Logger {
    public List<Log__c> logs = new List<Log__c>();

    public void logError(String summary, String className, Exception e) {
        this.logs.add(
                new Log__c(
                        Name = className,
                        MethodName__c = e.getStackTraceString().substringBefore(':').substringAfterLast('.'),
                        LineNumber__c = e.getLineNumber(),
                        Severity__c = ApexPages.Severity.ERROR.name(),
                        Summary__c = summary,
                        Message__c = e.getMessage(),
                        StackTrace__c = e.getStackTraceString()
                )
        );
    }

    public void logSuccess(String summary, String className) {
        this.logs.add(
                new Log__c(
                        Name = className,
                        Severity__c = ApexPages.Severity.INFO.name(),
                        Summary__c = summary,
                        Message__c = 'Success'
                )
        );
    }

    public void flush() {
        insert this.logs;
    }
}