/**
 * Created by Mariya on 25.01.2023.
 */

public inherited sharing class CaseService {

    public static Boolean isOwnerChanged(Case newCase, Case oldCase) {
        return newCase.OwnerId != oldCase.OwnerId;
    }

    public static Boolean isCaseStatusAssigned(Case caseRecord) {
        return caseRecord.Status == CaseUtility.ASSIGNED_STATUS;
    }

    public static Boolean isAppointmentRequestRT(Case caseRecord) {
        return caseRecord.RecordTypeId == CaseUtility.getAppointmentRequestRTId();
    }

    private static Map<Id, Case> getCasesWithNewOwnerByOwnerIds(List<Case> newCases, Map<Id, Case> oldCasesByIds) {

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

        List<Case> casesToUpdate = new List<Case>();

        for (Boutique_Resource__c boutiqueResource : BoutiqueResourceSelector.getBoutiqueResourceByUserIds(filteredCasesByOwnerIds.keySet())) {
            if (BoutiqueResourceService.isTeamMemberRT(boutiqueResource)) {
                boutiqueResourcesByUserIds.put(boutiqueResource.User__c, boutiqueResource);
            }
        }

        for (Id caseOwnerId : filteredCasesByOwnerIds.keySet()) {
            appointmentResources.add(new Appointment_Resource__c(
                    Boutique_Resource__c = boutiqueResourcesByUserIds.get(caseOwnerId).Id,
                    Appointment__c = filteredCasesByOwnerIds.get(caseOwnerId).Id));

            if (!isCaseStatusAssigned(filteredCasesByOwnerIds.get(caseOwnerId))) {
                Case caseToUpdate = [SELECT Id, Status FROM Case WHERE Id = :filteredCasesByOwnerIds.get(caseOwnerId).Id];
                caseToUpdate.Status = CaseUtility.ASSIGNED_STATUS;
                casesToUpdate.add(caseToUpdate);
            }
        }

        insert appointmentResources;
        update casesToUpdate;
    }
}