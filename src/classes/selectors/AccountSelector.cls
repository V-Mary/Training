/**
 * Created by Mariya on 31.01.2023.
 */

public inherited sharing class AccountSelector {

    public static List<Account> getAccountByIds(Set<Id> accIds) {
        return [
                SELECT Id, (SELECT Date__c, Start_Time__c, End_Time__c FROM Operating_Hours__r)
                FROM Account
                WHERE Id IN :accIds
        ];
    }

}