/**
 * Created by Mariya on 27.01.2023.
 */

@IsTest public with sharing class CaseTriggerTest {

    @TestSetup private static void makeData() {
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';

        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User user1 = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = p.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = uniqueUserName, External_Id__c = 'standt');
        insert user1;

        Account acc = new Account(Name = 'acc');
        insert acc;

        insert new Operating_Hours__c(Account__c = acc.Id,
                Date__c = Date.newInstance(2023, 02, 02),
                Start_Time__c = Time.newInstance(1, 2, 3, 4),
                End_Time__c = Time.newInstance(5, 2, 3, 4));

        Contact con = new Contact(LastName = 'con', External_Id__c = 'con');
        insert con;

        insert new List<Boutique_Resource__c>{
                new Boutique_Resource__c(Name = 'teamMember1', Boutique__c = acc.Id, Contact__c = con.Id,
                        RecordTypeId = ContactUtility.getTeamMemberRTId(), Work_Phone__c = '1234567890', User__c = user1.Id),
                new Boutique_Resource__c(Name = 'default', Work_Phone__c = '1234567890', Boutique__c = acc.Id, Contact__c = con.Id)
        };

        insert new Case(RecordTypeId = CaseUtility.getAppointmentRequestRTId(), AccountId = acc.Id,
                Appointment_Date__c = Date.newInstance(2023, 02, 02),
                Start_Time__c = Time.newInstance(2, 2, 3, 4), Status = 'New', Origin = 'Web');

    }

    @IsTest private static void createAppointmentResourcesAfterOwnerUpdateTest() {

        Case case1 = [SELECT Id, OwnerId, Status FROM Case LIMIT 1];

        User user1 = [SELECT Id FROM User WHERE Email = 'standarduser@testorg.com' LIMIT 1];

        Boutique_Resource__c boutiqueResource = [SELECT Id, User__c FROM Boutique_Resource__c LIMIT 1];

        case1.OwnerId = user1.Id;

        List<Appointment_Resource__c> appointmentResourcesBeforeUpdate = [
                SELECT Id, Appointment__c, Boutique_Resource__c
                FROM Appointment_Resource__c
        ];

        Test.startTest();

        update case1;

        Test.stopTest();

        Case case2 = [SELECT Status FROM Case LIMIT 1];

        List<Appointment_Resource__c> appointmentResourcesAfterUpdate = [
                SELECT Id, Appointment__c, Boutique_Resource__c
                FROM Appointment_Resource__c
        ];

        Assert.areEqual(appointmentResourcesBeforeUpdate.size() + 1, appointmentResourcesAfterUpdate.size());
        Assert.areEqual('Assigned', case2.Status);
    }

    @IsTest private static void createTimeSlotTest() {

        Contact con = [SELECT Id FROM Contact LIMIT 1];

        Account acc = [SELECT Id FROM Account LIMIT 1];

        Case caseRecord = new Case(RecordTypeId = CaseUtility.getAppointmentRequestRTId(),
                ContactId = con.Id, AccountId = acc.Id,
                Appointment_Date__c = Date.newInstance(2023, 02, 02),
                Start_Time__c = Time.newInstance(1, 2, 3, 4), Status = 'New');

        List<Time_Slot__c> timeSlotsBeforeInsert = [SELECT Id, Date__c, Start__c FROM Time_Slot__c];

        List<Appointment_Resource__c> appointmentResourcesBeforeInsert = [SELECT id FROM Appointment_Resource__c];


        Test.startTest();

        insert caseRecord;

        Test.stopTest();

        List<Time_Slot__c> timeSlotsAfterInsert = [SELECT Id, Date__c, Start__c FROM Time_Slot__c];

        List<Appointment_Resource__c> appointmentResourcesAfterInsert = [SELECT id FROM Appointment_Resource__c];

        Assert.areEqual(appointmentResourcesBeforeInsert.size() + 1, appointmentResourcesAfterInsert.size());

        Assert.areEqual(timeSlotsBeforeInsert.size() + 1, timeSlotsAfterInsert.size());
    }
}