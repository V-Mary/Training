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
}