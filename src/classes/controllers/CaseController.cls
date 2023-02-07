/**
 * Created by Mariya on 06.02.2023.
 */

public with sharing class CaseController {

    @AuraEnabled(Cacheable=true)
    public static String getAppointmentRequestRTId() {
        return String.valueOf(CaseUtility.getAppointmentRequestRTId());
    }
}