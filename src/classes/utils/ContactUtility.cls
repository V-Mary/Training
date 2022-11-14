/**
 * Created by Mariya on 14.11.2022.
 */

public with sharing class ContactUtility {

    public static final String TEAM_MEMBER = 'Team_Member';
    public static final String LOCATION = 'Location';
    public static final String PURPOSEOFVISIT = 'Purpose_of_Visit';

    public static final Map<String, Schema.RecordTypeInfo> BOUTIQUE_RESOURCES_RTS_BY_DEV_NAMES = Schema.SObjectType.Boutique_Resource__c.getRecordTypeInfosByDeveloperName();

    public static Id getBoutiqueResourceRTId(String developerName) {
        return BOUTIQUE_RESOURCES_RTS_BY_DEV_NAMES.get(developerName).getRecordTypeId();
    }

    public static Id getTeamMemberRTId() {
        return BOUTIQUE_RESOURCES_RTS_BY_DEV_NAMES.get(TEAM_MEMBER).getRecordTypeId();
    }

    public static Id getLocationRTId() {
        return BOUTIQUE_RESOURCES_RTS_BY_DEV_NAMES.get(LOCATION).getRecordTypeId();
    }

    public static Id getPurposeOfVisitRTId() {
        return BOUTIQUE_RESOURCES_RTS_BY_DEV_NAMES.get(PURPOSEOFVISIT).getRecordTypeId();
    }

}