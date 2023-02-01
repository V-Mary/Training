/**
 * Created by Mariya on 01.02.2023.
 */

public with sharing class CaseController {

    @AuraEnabled(Cacheable=true)
    public static List<Appointment_Resource__c> getAppointmentResourcesByBoutiqueId(Id boutiqueId) {
        return [
                SELECT Appointment__r.Boutique__c,
                        Appointment__r.Start_Time__c,
                        Appointment__r.Additional_Comments__c,
                        Appointment__r.Appointment_Date__c,
                        Appointment__r.Customer__c,
                        Boutique_Resource__r.Work_Phone__c,
                        Appointment__r.Purpose_of_Visit__c,
                        Appointment__r.ContactEmail
                FROM Appointment_Resource__c
                WHERE Boutique_Resource__c = :boutiqueId
                AND Appointment__r.RecordTypeId = :CaseUtility.getAppointmentRequestRTId()
        ];
    }
}