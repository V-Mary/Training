/**
 * Created by Mariya on 24.01.2023.
 */

public with sharing class BoutiqueResourceService {

    public static final String phonePattern = '[0-9]{10}';

    public static Boolean isPhoneNumberValid(String phoneNumber) {
        return String.isNotBlank(phoneNumber) && Pattern.matches(phonePattern, phoneNumber);
    }

    public static void formatWorkPhone(List<Boutique_Resource__c> newBoutiques) {

        for (Boutique_Resource__c item : newBoutiques) {

            if (item.RecordTypeId == ContactUtility.getTeamMemberRTId()) {

                if (!isPhoneNumberValid(item.Work_Phone__c)) {
                    item.addError('Phone number is not valid.');
                } else {
                    item.Work_Phone__c = String.format('({0}) {1}-{2}', new List<String>{
                            item.Work_Phone__c.substring(0, 3), item.Work_Phone__c.substring(3, 6), item.Work_Phone__c.substring(6, 10)
                    });
                }
            }
        }
    }
}