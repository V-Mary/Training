/**
 * Created by Mariya on 14.11.2022.
 */

public with sharing class ContactService {
    public static void createTeamMember(List<Contact> newContacts){

        List<Contact> contactList = new List<Contact>();

        List<Boutique_Resource__c> boutiqueList = new List<Boutique_Resource__c>();

        for (Contact item: newContacts){
            if (item.AccountId != null) {
                contactList.add(item);
            }
        }

        for (Contact item: contactList){
            Boutique_Resource__c newTeamMember = new Boutique_Resource__c(Boutique__c = item.AccountId, Contact__c = item.Id, Name = item.LastName);
            newTeamMember.RecordTypeId = '0127S000000c4WtQAI';
            boutiqueList.add(newTeamMember);
        }

        insert boutiqueList;

    }

    public static void updateTeamMember(List<Contact> newContacts, Map<Id,Contact> oldMapContacts, Map<Id,Contact> newMapContacts){

        Set<Id> contactIds = new Set<Id>();

        for (Contact item: newContacts){
            if (item.Name != oldMapContacts.get(item.Id).Name) {
                contactIds.add(item.Id);
            }
        }

        List<Boutique_Resource__c> boutiqueList = BoutiqueResourceSelector.getBoutiqueResourceByContactId(contactIds);

        for (Boutique_Resource__c item: boutiqueList){
            //item.Boutique__c = newMapContacts.get(item.Contact__c).AccountId;
            item.Name = newMapContacts.get(item.Contact__c).LastName;
        }

        update boutiqueList;

    }
}