/**
 * Created by Mariya on 25.01.2023.
 */

public inherited sharing class CaseService {

    public static List<Case> getCasesWithNewOwnerId(List<Case> newCases, Map<Id, Case> oldCasesByIds) {

        List<Case> casesWithNewOwnerId = new List<Case>();

        for (Case updatedCase : newCases) {
            if (updatedCase.OwnerId != oldCasesByIds.get(updatedCase.Id).OwnerId) {
                casesWithNewOwnerId.add(updatedCase);
            }
        }

        return casesWithNewOwnerId;
    }

    public static void createAppointmentResources(List<Case> newCases, Map<Id, Case> oldCasesByIds) {

        List<Case> casesWithNewOwnerId = getCasesWithNewOwnerId(newCases, oldCasesByIds);

        Set<Id> caseOwnerIds = new Set<Id>();

        List<Appointment_Resource__c> appointmentResources = new List<Appointment_Resource__c>();

        for (Case updatedCase : casesWithNewOwnerId) {
            caseOwnerIds.add(updatedCase.OwnerId);
        }

        List<Boutique_Resource__c> boutiqueResources = [SELECT Id, User__c FROM Boutique_Resource__c WHERE User__c IN :caseOwnerIds];

        for (Case caseToUpdate : casesWithNewOwnerId) {
            for (Boutique_Resource__c boutiqueResource : boutiqueResources) {
                if (boutiqueResource.User__c == caseToUpdate.OwnerId) {
                    appointmentResources.add(new Appointment_Resource__c(Boutique_Resource__c = boutiqueResource.Id, Appointment__c = caseToUpdate.Id));
                }
            }

            if (caseToUpdate.Status != 'Assigned') {
                caseToUpdate.Status = 'Assigned';
            }
        }

        insert appointmentResources;
    }
}