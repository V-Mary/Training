/**
 * Created by Mariya on 02.02.2023.
 */

import {api, LightningElement, track, wire} from 'lwc';
import getAppointmentResourcesByBoutiqueId
    from '@salesforce/apex/AppointmentResourcesSelector.getAppointmentResourcesByBoutiqueId';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class AppointmentsCustomTable extends LightningElement {

    @api recordId;
    @track data = [];

    @wire(getAppointmentResourcesByBoutiqueId, {boutiqueId: '$recordId'})
    wiredCases({error, data}) {
        this.data = data;
        if (this.data) {
            let preparedCases = [];
            this.data.forEach(caseRecord => {
                let preparedCase = {};
                preparedCase.Id = caseRecord.Appointment__c;
                preparedCase.BoutiqueName = caseRecord.Appointment__r.Boutique__r.Name;
                preparedCase.BoutiqueURL = '/lightning/r/Account/' + caseRecord.Appointment__r.Boutique__c + '/view';
                preparedCase.AppointmentDate = caseRecord.Appointment__r.Appointment_Date__c;
                preparedCase.StartTime = caseRecord.Appointment__r.Start_Time__c;
                preparedCase.Phone = caseRecord.Boutique_Resource__r.Work_Phone__c;
                preparedCase.Email = caseRecord.Appointment__r.ContactEmail;
                preparedCase.Visit = caseRecord.Appointment__r.Purpose_of_Visit__c;
                preparedCase.Comments = caseRecord.Appointment__r.Additional_Comments__c;
                preparedCase.CustomerName = caseRecord.Appointment__r.Customer__r.Name;
                preparedCase.CustomerURL = '/lightning/r/Account/' + caseRecord.Appointment__r.Customer__c + '/view';
                preparedCases.push(preparedCase);
            });
            this.data = preparedCases;
        } else if (error) {
            const evt = new ShowToastEvent({
                title: 'Error',
                message: error,
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }
    };
}