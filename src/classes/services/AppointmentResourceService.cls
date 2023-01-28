/**
 * Created by Mariya on 27.01.2023.
 */

public with sharing class AppointmentResourceService {

    public static Messaging.SingleEmailMessage getSingleEmailMessageForCase(String devName, Case caseRecord) {

        EmailTemplate template = EmailTemplateSelector.getSelectorByDevName(devName);

        Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(template.Id, caseRecord.OwnerId, caseRecord.Id);

        message.setReplyTo(UserInfo.getUserEmail());
        message.setSaveAsActivity(false);
        message.setTreatTargetObjectAsRecipient(true);
        message.setToAddresses(new List<String>{
                caseRecord.OwnerId
        });

        return message;
    }

    public static void sendEmailAfterAssignment(Map<Id, Appointment_Resource__c> appointmentResourcesByIds) {

        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();

        List<Appointment_Resource__c> appointmentResources = [
                SELECT Id, Appointment__r.Status, Appointment__r.OwnerId
                FROM Appointment_Resource__c
                WHERE Id IN :appointmentResourcesByIds.keySet()
                AND Appointment__r.Status = :CaseUtility.ASSIGNED_STATUS
        ];

        for (Appointment_Resource__c appointmentResource : appointmentResources) {
            Messaging.SingleEmailMessage message = getSingleEmailMessageForCase(
                    EmailTemplateSelector.APPOINTMENT_ASSIGNED_DEV_NAME, appointmentResource.Appointment__r);
            messages.add(message);
        }

        if (!messages.isEmpty()) {
            Messaging.sendEmail(messages);
        }
    }
}