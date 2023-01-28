/**
 * Created by Mariya on 28.01.2023.
 */

public with sharing class EmailTemplateSelector {

    public static final String APPOINTMENT_ASSIGNED_DEV_NAME = 'Appointment_Assigned';

    public static EmailTemplate getSelectorByDevName(String devName) {
        return [SELECT Id FROM EmailTemplate WHERE DeveloperName = :devName];
    }
}