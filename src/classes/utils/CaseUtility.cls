/**
 * Created by Mariya on 26.01.2023.
 */

public without sharing class CaseUtility {

    public static final String ASSIGNED_STATUS = 'Assigned';

    public static final String APPOINTMENT_REQUEST = 'Appointment_Request';
    public static final String QUEUED_APPOINTMENT = 'Queued_Appointment';

    public static final Map<String, Schema.RecordTypeInfo> CASE_RTS_BY_NAMES =
            Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName();

    public static Id getCaseRTId(String developerName){
        return CASE_RTS_BY_NAMES.get(developerName).getRecordTypeId();
    }

    public static Id getAppointmentRequestRTId(){
        return CASE_RTS_BY_NAMES.get(APPOINTMENT_REQUEST).getRecordTypeId();
    }
}