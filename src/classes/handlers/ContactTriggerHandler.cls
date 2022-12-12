/**
 * Created by Mariya on 14.11.2022.
 */
public with sharing class ContactTriggerHandler {

    public static void handler(List<Contact> newTrigger,  Map<Id,Contact> oldContactById, Map<Id,Contact> newContactById, System.TriggerOperation triggerOperation){

        switch on TriggerOperation {

            when AFTER_INSERT{

                ContactService.createTeamMember(newTrigger);

            }

            when AFTER_UPDATE{

                ContactService.updateTeamMember(oldContactById, newContactById);

            }
        }
    }
}