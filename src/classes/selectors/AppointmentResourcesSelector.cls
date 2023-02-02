/**
 * Created by Mariya on 29.01.2023.
 */

public inherited sharing class AppointmentResourcesSelector {

    public static List<Appointment_Resource__c> getAppointmentResourcesByIdsWithAssignedStatus(Set<Id> ids) {
        return [
                SELECT Id, Appointment__r.Status, Appointment__r.OwnerId
                FROM Appointment_Resource__c
                WHERE Id IN :ids
                AND Appointment__r.Status = :CaseUtility.ASSIGNED_STATUS
        ];
    }

    @AuraEnabled(Cacheable=true)
    public static List<Appointment_Resource__c> getAppointmentResourcesByBoutiqueId(Id boutiqueId) {
        return [
                SELECT Appointment__r.Boutique__c,
                        Appointment__r.Start_Time__c,
                        Appointment__r.Additional_Comments__c,
                        Appointment__r.Appointment_Date__c,
                        Appointment__r.Customer__c,
                        Boutique_Resource__r.Work_Phone__c,
                        Appointment__r.Boutique__r.Name,
                        Appointment__r.Customer__r.Name,
                        Appointment__r.Purpose_of_Visit__c,
                        Appointment__r.ContactEmail,
                        Appointment__c
                FROM Appointment_Resource__c
                WHERE Boutique_Resource__c = :boutiqueId
                AND Appointment__r.RecordTypeId = :CaseUtility.getAppointmentRequestRTId()
                LIMIT 10
        ];
    }
}