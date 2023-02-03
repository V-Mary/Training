/**
 * Created by Mariya on 02.02.2023.
 */

public with sharing class AppointmentResourceController {

    @AuraEnabled(Cacheable=true)
    public static List<Appointment_Resource__c> getAppointmentResourcesByBoutiqueId(Id boutiqueId) {
        return AppointmentResourcesSelector.getAppointmentResourcesByBoutiqueId(boutiqueId);
    }
}