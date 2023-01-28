/**
 * Created by Mariya on 27.01.2023.
 */

public with sharing class AppointmentResourceTriggerHandler {

    public static void handler(Map<Id, Appointment_Resource__c> newTrigger, System.TriggerOperation triggerOperation) {

        switch on TriggerOperation {
            when AFTER_INSERT {
                AppointmentResourceService.sendEmailAfterAssignment(newTrigger);
            }
        }
    }
}