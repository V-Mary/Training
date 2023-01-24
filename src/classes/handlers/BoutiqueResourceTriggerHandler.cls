/**
 * Created by Mariya on 24.01.2023.
 */

public with sharing class BoutiqueResourceTriggerHandler {

    public static void handler(List<Boutique_Resource__c> newTrigger, System.TriggerOperation triggerOperation) {

        switch on TriggerOperation {
            when BEFORE_INSERT, BEFORE_UPDATE {
                BoutiqueResourceService.formatWorkPhone(newTrigger);
            }
        }
    }
}