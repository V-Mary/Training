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

    public static Boolean isTimeSuitable(Case caseRecord, Operating_Hours__c operatingHours) {
        return caseRecord.Start_Time__c >= operatingHours.Start_Time__c
                && caseRecord.Start_Time__c <= operatingHours.End_Time__c;
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

    public static void createAppointmentResourcesAfterOwnerUpdate(List<Case> newCases, Map<Id, Case> oldCasesByIds) {

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

        update casesToUpdate;
        insert appointmentResources;
    }

    public static void createTimeSlot(Map<Id, Case> newCasesByIds) {

        List<Time_Slot__c> timeSlots = new List<Time_Slot__c>();

        List<Appointment_Resource__c> appointmentResources = new List<Appointment_Resource__c>();

        Set<Id> accIds = new Set<Id>();

        for (Case caseRecord : newCasesByIds.values()) {
            accIds.add(caseRecord.AccountId);
        }

        Map<Id, Map<Date, Operating_Hours__c>> operatingHoursByIdsByAccountIds = new Map<Id, Map<Date, Operating_Hours__c>>();

        for (Account account : AccountSelector.getAccountByIds(accIds)) {
            for (Operating_Hours__c oh : account.Operating_Hours__r) {
                operatingHoursByIdsByAccountIds.put(account.Id,
                        new Map<Date, Operating_Hours__c>{
                                oh.Date__c => oh
                        });
            }
        }

        Boutique_Resource__c defaultBoutiqueResource = BoutiqueResourceSelector.getDefaultBoutiqueResource();

        for (Case caseRecord : newCasesByIds.values()) {
            Operating_Hours__c operatingHours =
                    operatingHoursByIdsByAccountIds.get(caseRecord.AccountId).get(caseRecord.Appointment_Date__c);

            if (isTimeSuitable(caseRecord, operatingHours)) {
                Time_Slot__c timeSlot = new Time_Slot__c(Start__c = caseRecord.Start_Time__c, Operating_Hours__c = operatingHours.Id);
                timeSlots.add(timeSlot);

                appointmentResources.add(new Appointment_Resource__c(Time_Slot__c = timeSlot.Id,
                        Appointment__c = caseRecord.Id, Boutique_Resource__c = defaultBoutiqueResource.Id));
            } else {
                caseRecord.addError('Proposed time is outside of boutique`s working hours. Please provide time within '
                        + operatingHours.Start_Time__c.hour() + ':' + operatingHours.Start_Time__c.minute() +
                        '-' + operatingHours.End_Time__c.hour() + ':' + operatingHours.End_Time__c.minute());
            }
        }

        insert timeSlots;
        insert appointmentResources;
    }
}