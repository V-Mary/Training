/**
 * Created by Mariya on 25.01.2023.
 */

public with sharing class CaseTriggerHandler {

    public static void handler(List<Case> newCases, Map<Id, Case> oldCasesByIds, System.TriggerOperation triggerOperation) {
        switch on triggerOperation {
            when BEFORE_UPDATE {
                CaseService.createAppointmentResources(newCases, oldCasesByIds);
            }
        }
    }
}