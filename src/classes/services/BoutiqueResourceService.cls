/**
 * Created by Mariya on 24.01.2023.
 */

public with sharing class BoutiqueResourceService {

    public static void formatWorkPhone(List<Boutique_Resource__c> newBoutiques) {

        for (Boutique_Resource__c item : newBoutiques) {

            if (String.isNotBlank(item.Work_Phone__c)) {

                if (item.Work_Phone__c.length() < 1 || item.Work_Phone__c.length() > 10 || !item.Work_Phone__c.isNumeric()) {
                    item.addError('Please, enter 10 numbers!');
                }

                String formatedPhone = '(' + item.Work_Phone__c.substring(0, 3) + ') ' + item.Work_Phone__c.substring(3, 6) + '-' + item.Work_Phone__c.substring(6, 10);

                item.Work_Phone__c = formatedPhone;
            }
        }
    }
}