/**
 * Created by Mariya on 29.01.2023.
 */

public with sharing class CaseController {

    @AuraEnabled public static List<Case> getCasesByAccountId(Id accountId) {
        return [SELECT CaseNumber, Status, Start_Time__c, Appointment_Date__c FROM Case
            WHERE AccountId = :accountId AND RecordTypeId = :CaseUtility.getAppointmentRequestRTId()];
    }
}