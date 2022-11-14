/**
 * Created by Mariya on 14.11.2022.
 */

public with sharing class BoutiqueResourceSelector {

    public static List<Boutique_Resource__c> getBoutiqueResourceByContactId(Set<Id> contactId){

        return [SELECT Name, Boutique__c FROM Boutique_Resource__c WHERE Contact__c IN :contactId];

    }

}