@IsTest
public class ContactTriggerTest {

    @TestSetup
    static void makeData(){

        Account acc1 = new Account(Name = 'Acc');
        insert acc1;

        Contact cont1 = new Contact(LastName = 'cont1', AccountId = acc1.Id);
        Contact cont2 = new Contact(LastName = 'cont2', AccountId = acc1.Id);
        insert cont1;
        insert cont2;

        Boutique_Resource__c teamMember1 = new Boutique_Resource__c(Name = 'teamMember1', Boutique__c = acc1.Id, Contact__c = cont1.Id);
        Boutique_Resource__c teamMember2 = new Boutique_Resource__c(Name = 'teamMember2', Boutique__c = acc1.Id, Contact__c = cont2.Id);
        insert teamMember1;
        insert teamMember2;
    }

    @IsTest
    static void createTeamMemberTest(){
        Account acc = [SELECT Name FROM Account WHERE  Name = 'Acc'];

        Contact cont = new Contact(LastName = 'cont', AccountId = acc.Id);

        Test.startTest();

        insert cont;

        Test.stopTest();

        List<Boutique_Resource__c> teamMembers = [SELECT id from Boutique_Resource__c WHERE Contact__c =:cont.Id];

        System.assertEquals(1, teamMembers.size(), 'Do not create new team member');
    }

    @IsTest
    static void updateTeamMemberTest(){

        List<Contact> contacts = [SELECT LastName, Id FROM Contact];

        for (Contact item: contacts){
            item.LastName = 'new name';
        }

        Test.startTest();

        update contacts;

        Test.stopTest();

        List<Boutique_Resource__c> teamMembers = new List<Boutique_Resource__c>();

        for (Boutique_Resource__c item : [SELECT Name FROM Boutique_Resource__c WHERE Contact__c IN : contacts]){

            if (item.Name == 'new name') {

                teamMembers.add(item);

            }

        }

        System.assertEquals(4, teamMembers.size(), 'Do not update name in Boutique Resource');

    }
}