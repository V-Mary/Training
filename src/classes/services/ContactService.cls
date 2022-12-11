/**
 * Created by Mariya on 14.11.2022.
 */

public inherited sharing class ContactService {
    public static void createTeamMember(List<Contact> newContacts){

        List<Contact> contacts = new List<Contact>();

        List<Boutique_Resource__c> boutiques = new List<Boutique_Resource__c>();

        for (Contact item : newContacts){
            System.debug('1');
            System.debug(item.AccountId);
            if ( String.isNotBlank(item.AccountId)) {
                System.debug('2');
                contacts.add(item);
            }
        }

        System.debug('list contact '+contacts);

        for (Contact item : contacts){
            System.debug('create new ream member');
            Boutique_Resource__c newTeamMember = new Boutique_Resource__c(Boutique__c = item.AccountId, Contact__c = item.Id, Name = item.LastName, RecordTypeId = ContactUtility.getTeamMemberRTId());
            boutiques.add(newTeamMember);
        }

        System.debug('insert new team member');
        insert boutiques;

    }

    public static void updateTeamMember(Map<Id,Contact> oldContactById, Map<Id,Contact> newContactById){

        List<Contact> contactsToCreateNewTeamMember = new List<Contact>();

        Set<Id> contactIds = new Set<Id>();

        for (Contact item : oldContactById.values()){

            if (String.isNotBlank(item.AccountId)) {

                if (newContactById.get(item.Id).LastName != item.LastName || newContactById.get(item.Id).AccountId != item.AccountId) {

                    contactIds.add(item.Id);
                }

            }else if (String.isBlank(item.AccountId))  {

                contactsToCreateNewTeamMember.add(newContactById.get(item.Id));

            }
        }

        System.debug(contactsToCreateNewTeamMember);


        if (contactsToCreateNewTeamMember.size() > 0) {

            System.debug('not null list to create');
            createTeamMember(contactsToCreateNewTeamMember);

        }

        List<Boutique_Resource__c> boutiques = BoutiqueResourceSelector.getBoutiqueResourceByContactIds(contactIds);

        for (Boutique_Resource__c item : boutiques){

            item.Boutique__c = newContactById.get(item.Contact__c).AccountId;

            item.Name = newContactById.get(item.Contact__c).LastName;

        }

        if (boutiques.size() > 0) {

            System.debug('list to update');
            update boutiques;

        }

    }
}