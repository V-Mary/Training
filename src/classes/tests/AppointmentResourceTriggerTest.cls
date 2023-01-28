/**
 * Created by Mariya on 27.01.2023.
 */

@IsTest public with sharing class AppointmentResourceTriggerTest {

    @TestSetup private static void makeDake() {

        Account acc = new Account(Name = 'acc');
        insert acc;

        Contact con = new Contact(LastName = 'con', External_Id__c = 'con');
        insert con;

        insert new Boutique_Resource__c(Name = 'teamMember1', Boutique__c = acc.Id, Contact__c = con.Id,
                RecordTypeId = ContactUtility.getTeamMemberRTId(), Work_Phone__c = '1234567890');


        insert new Case(RecordTypeId = CaseUtility.getAppointmentRequestRTId(),
                Appointment_Date__c = Date.newInstance(2023, 02, 02),
                Start_Time__c = Time.newInstance(1, 2, 3, 4), Status = CaseUtility.ASSIGNED_STATUS);
    }

    @IsTest private static void sendEmailAfterAssignmentTest() {
        Case caseRecord = [SELECT Id FROM Case WHERE Status = :CaseUtility.ASSIGNED_STATUS LIMIT 1];

        Boutique_Resource__c boutiqueResource = [SELECT Id FROM Boutique_Resource__c LIMIT 1];

        Appointment_Resource__c appointmentResource = new Appointment_Resource__c(Boutique_Resource__c = boutiqueResource.Id,
                Appointment__c = caseRecord.Id);

        Test.startTest();

        insert appointmentResource;

        Integer invocations = Limits.getEmailInvocations();

        Test.stopTest();

        Assert.areEqual(1, invocations);
    }
}