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
                UserName = uniqueUserName);


        Account acc = new Account(Name = 'acc');
        insert acc;

        Contact con = new Contact(LastName = 'con', AccountId = acc.Id);

        insert new Case(RecordTypeId = CaseUtility.getAppointmentRequestRTId(),
                Appointment_Date__c = Date.newInstance(2023, 02, 02),
                Start_Time__c = Time.newInstance(1, 2, 3, 4), Status = 'New');

        System.runAs(user1) {
            insert new Boutique_Resource__c(Name = 'teamMember1', Boutique__c = acc.Id, Contact__c = con.Id,
                    RecordTypeId = ContactUtility.getTeamMemberRTId(), Work_Phone__c = '1234567890', User__c = user1.Id);
        }
    }

    @IsTest private static void createAppointmentResourcesTest() {

        Case case1 = [SELECT Id, OwnerId, Status FROM Case LIMIT 1];

        User user1 = [SELECT Id FROM User WHERE Email = 'standarduser@testorg.com' LIMIT 1];

        Boutique_Resource__c boutiqueResource = [SELECT Id, User__c FROM Boutique_Resource__c LIMIT 1];

        case1.OwnerId = user1.Id;

        Test.startTest();

        update case1;

        Test.stopTest();

        Case case2 = [SELECT Status FROM Case LIMIT 1];

        List<Appointment_Resource__c> appointmentResources = [SELECT Id, Appointment__c, Boutique_Resource__c FROM Appointment_Resource__c];

        Assert.areEqual(1, appointmentResources.size());
        Assert.areEqual(case1.Id, appointmentResources.get(0).Appointment__c);
        Assert.areEqual('Assigned', case2.Status);
        Assert.areEqual(boutiqueResource.Id, appointmentResources.get(0).Boutique_Resource__c);
    }
}