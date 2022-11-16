/**
 * Created by Mariya on 14.11.2022.
 */

public inherited sharing class BoutiqueResourceSelector {

    public static List<Boutique_Resource__c> getBoutiqueResourceByContactIds(Set<Id> contactIds){
        return [SELECT Name, Boutique__c, Contact__c FROM Boutique_Resource__c WHERE Contact__c IN : contactIds];
    }
}