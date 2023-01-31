/**
 * Created by Mariya on 25.01.2023.
 */

public with sharing class CaseTriggerHandler {

    public static void handler(List<Case> newCases, Map<Id, Case> oldCasesByIds, Map<Id, Case> newCasesByIds, System.TriggerOperation triggerOperation) {
        switch on triggerOperation {
            when AFTER_UPDATE {
                CaseService.createAppointmentResourcesAfterOwnerUpdate(newCases, oldCasesByIds);
            }
            when BEFORE_INSERT {
                CaseService.createTimeSlot(newCases);
            }
            when AFTER_INSERT {
                CaseService.createAppointmentResource(newCasesByIds);
            }
        }
    }
}