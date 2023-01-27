/**
 * Created by Mariya on 14.11.2022.
 */

public inherited sharing class BoutiqueResourceSelector {

    public static Boutique_Resource__c getBoutiqueResourceById(Id boutiqueId) {
        return [SELECT Id FROM Boutique_Resource__c WHERE Id = :boutiqueId];
    }

    public static List<Boutique_Resource__c> getBoutiqueResourceByContactIds(Set<Id> contactIds) {
        return [SELECT Name, Boutique__c, Contact__c FROM Boutique_Resource__c WHERE Contact__c IN :contactIds];
    }

    public static List<Boutique_Resource__c> getBoutiqueResourceByUserIds(Set<Id> userIds) {
        return [SELECT User__c, Id, RecordTypeId FROM Boutique_Resource__c WHERE User__c IN :userIds];
    }
}