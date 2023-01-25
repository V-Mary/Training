/**
 * Created by Mariya on 24.01.2023.
 */

trigger BoutiqueResourceTrigger on Boutique_Resource__c (before insert, before update) {

    BoutiqueResourceTriggerHandler.handler(Trigger.new, Trigger.operationType);
}