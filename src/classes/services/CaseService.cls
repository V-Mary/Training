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

    public static void createAppointmentResources(List<Case> newCases, Map<Id, Case> oldCasesByIds) {

        List<Case> casesWithNewOwnerId = new List<Case>();

        Set<Id> caseOwnerIds = new Set<Id>();

        for (Case updatedCase : newCases) {
            if (isOwnerChanged(updatedCase, oldCasesByIds.get(updatedCase.Id)) && isAppointmentRequestRT(updatedCase)) {
                casesWithNewOwnerId.add(updatedCase);
                caseOwnerIds.add(updatedCase.OwnerId);
            }
        }

        List<Appointment_Resource__c> appointmentResources = new List<Appointment_Resource__c>();

        List<Boutique_Resource__c> boutiqueResources = BoutiqueResourceSelector.getBoutiqueResourceByContactOwnerIds(caseOwnerIds);

        for (Case caseToUpdate : casesWithNewOwnerId) {
            for (Boutique_Resource__c boutiqueResource : boutiqueResources) {
                if (boutiqueResource.User__c == caseToUpdate.OwnerId) {
                    appointmentResources.add(new Appointment_Resource__c(Boutique_Resource__c = boutiqueResource.Id, Appointment__c = caseToUpdate.Id));
                }
            }

            if (caseToUpdate.Status != CaseUtility.ASSIGNED_STATUS) {
                caseToUpdate.Status = CaseUtility.ASSIGNED_STATUS;
            }
        }

        insert appointmentResources;
    }
}