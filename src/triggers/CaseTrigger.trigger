/**
 * Created by Mariya on 25.01.2023.
 */

trigger CaseTrigger on Case (after update, after insert) {

    CaseTriggerHandler.handler(Trigger.new, Trigger.oldMap, Trigger.newMap, Trigger.operationType);
}