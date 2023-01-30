/**
 * Created by Mariya on 27.01.2023.
 */

trigger AppointmentResourceTrigger on Appointment_Resource__c (after insert) {

    AppointmentResourceTriggerHandler.handler(Trigger.newMap, Trigger.operationType);

}