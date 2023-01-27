/**
 * Created by Mariya on 25.01.2023.
 */

public inherited sharing class CaseService {

    private static Boolean isOwnerChanged(Case newCase, Case oldCase) {
        return newCase.OwnerId != oldCase.OwnerId;
    }

    private static Boolean isAppointmentRequestRT(Case caseRecord) {
        return caseRecord.RecordTypeId == CaseUtility.getAppointmentRequestRTId();
    }

    private static Boolean isTeamMemberRT(Boutique_Resource__c boutiqueResource) {
        return boutiqueResource.RecordTypeId == ContactUtility.getTeamMemberRTId();
    }

    public static Map<Id, Case> getCasesWithNewOwnerByOwnerIds(List<Case> newCases, Map<Id, Case> oldCasesByIds) {

        Map<Id, Case> filteredCasesByOwnerIds = new Map<Id, Case>();

        for (Case updatedCase : newCases) {
            if (isOwnerChanged(updatedCase, oldCasesByIds.get(updatedCase.Id)) && isAppointmentRequestRT(updatedCase)) {
                filteredCasesByOwnerIds.put(updatedCase.OwnerId, updatedCase);
            }
        }

        return filteredCasesByOwnerIds;
    }

    public static void createAppointmentResources(List<Case> newCases, Map<Id, Case> oldCasesByIds) {

        Map<Id, Case> filteredCasesByOwnerIds = getCasesWithNewOwnerByOwnerIds(newCases, oldCasesByIds);

        List<Appointment_Resource__c> appointmentResources = new List<Appointment_Resource__c>();

        Map<Id, Boutique_Resource__c> boutiqueResourcesByUserIds = new Map<Id, Boutique_Resource__c>();

        for (Boutique_Resource__c boutiqueResource : BoutiqueResourceSelector.getBoutiqueResourceByUserIds(filteredCasesByOwnerIds.keySet())) {
            if (isTeamMemberRT(boutiqueResource)) {
                boutiqueResourcesByUserIds.put(boutiqueResource.User__c, boutiqueResource);
            }
        }

        for (Id caseOwnerId : filteredCasesByOwnerIds.keySet()) {
            if (boutiqueResourcesByUserIds.containsKey(caseOwnerId)) {
                appointmentResources.add(new Appointment_Resource__c(
                        Boutique_Resource__c = boutiqueResourcesByUserIds.get(caseOwnerId).Id,
                        Appointment__c = filteredCasesByOwnerIds.get(caseOwnerId).Id));

                if (filteredCasesByOwnerIds.get(caseOwnerId).Status != CaseUtility.ASSIGNED_STATUS) {
                    filteredCasesByOwnerIds.get(caseOwnerId).Status = CaseUtility.ASSIGNED_STATUS;
                }
            }
        }

        insert appointmentResources;
    }
}