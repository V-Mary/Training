/**
 * Created by Mariya on 25.01.2023.
 */

trigger CaseTrigger on Case (before update) {

    CaseTriggerHandler.handler(Trigger.new, Trigger.oldMap, Trigger.operationType);
}