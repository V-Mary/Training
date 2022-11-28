@IsTest
private class ContactTriggerTest {

    @TestSetup
    private static void makeData() {
        Account acc1 = new Account(Name = 'Acc');
        insert acc1;

        Contact con1 = new Contact(LastName = 'cont1', AccountId = acc1.Id);
        Contact con2 = new Contact(LastName = 'cont2', AccountId = acc1.Id);
        insert new List<Contact>{
                con1, con2
        };

        insert new List<Boutique_Resource__c>{
                new Boutique_Resource__c(Name = 'teamMember1', Boutique__c = acc1.Id, Contact__c = con1.Id),
                new Boutique_Resource__c(Name = 'teamMember2', Boutique__c = acc1.Id, Contact__c = con2.Id)
        };
    }

    @IsTest
    private static void createTeamMemberTest() {
        Account acc = [SELECT Name FROM Account WHERE Name = 'Acc'];

        Contact cont = new Contact(LastName = 'cont', AccountId = acc.Id);

        Test.startTest();

        insert cont;

        Test.stopTest();

        List<Boutique_Resource__c> teamMembers = [SELECT id from Boutique_Resource__c WHERE Contact__c = :cont.Id];

        Assert.areEqual(1, teamMembers.size(), 'Do not create new team member');
    }

    @IsTest
    private static void updateTeamMemberTest() {
        List<Contact> contacts = [SELECT LastName, Id FROM Contact];

        for (Contact item : contacts) {
            item.LastName = 'new name';
        }

        Test.startTest();

        update contacts;

        Test.stopTest();

        List<Boutique_Resource__c> teamMembers = new List<Boutique_Resource__c>();

        for (Boutique_Resource__c item : [SELECT Name FROM Boutique_Resource__c WHERE Contact__c IN :contacts]) {
            if (item.Name == 'new name') {
                teamMembers.add(item);
            }
        }

        Assert.areEqual(4, teamMembers.size(), 'Do not update name in Boutique Resource');
    }
}