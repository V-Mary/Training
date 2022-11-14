/**
 * Created by Mariya on 14.11.2022.
 */

trigger ContactTrigger on Contact (after insert, after update ) {

    ContactTriggerHandler.handler(Trigger.new, Trigger.newMap, Trigger.oldMap, Trigger.operationType);

}