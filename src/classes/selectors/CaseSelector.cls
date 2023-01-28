/**
 * Created by Mariya on 27.01.2023.
 */

public inherited sharing class CaseSelector {

    public static List<Case> getCasesByIds(Set<Id> ids) {
        return [SELECT Id, ContactEmail, OwnerId, Status, ContactId FROM Case WHERE Id IN :ids];
    }
}