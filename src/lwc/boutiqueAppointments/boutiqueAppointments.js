/**
 * Created by Mariya on 27.01.2023.
 */

import {LightningElement, api, wire, track} from 'lwc';
import getAppointmentResourcesByBoutiqueId
    from '@salesforce/apex/AppointmentResourceController.getAppointmentResourcesByBoutiqueId';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

const COLS = [
    {
        label: 'Boutique', fieldName: 'Boutique', type: 'url',
        typeAttributes: {label: {fieldName: 'boutiqueURL'}}
    },
    {
        label: 'Customer', fieldName: 'Customer', type: 'url',
        typeAttributes: {label: {fieldName: 'customerURL'}}
    },
    {label: 'Phone', fieldName: 'Phone', type: 'phone'},
    {label: 'Email', fieldName: 'Email', type: 'email'},
    {label: 'Purpose of Visit', fieldName: 'Visit'},
    {label: 'Date', fieldName: 'AppointmentDate'},
    {
        label: 'Start time', fieldName: 'StartTime', type: 'date', typeAttributes: {
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit',
            hour12: true
        }
    },
    {
        label: 'Comments', type: 'customComment',
        typeAttributes: {
            comment: {fieldName: 'Comments'}
        }
    }
];

export default class BoutiqueAppointments extends LightningElement {
    @api recordId;
    @track data = [];
    @track columns = COLS;

    @wire(getAppointmentResourcesByBoutiqueId, {boutiqueId: '$recordId'})
    wiredCases({error, data}) {
        this.data = data;
        if (this.data) {
            let preparedCases = [];
            this.data.forEach(caseRecord => {
                let preparedCase = {};
                preparedCase.Boutique = '/lightning/r/Boutique/' + caseRecord.Appointment__r.Boutique__c + '/view';
                preparedCase.AppointmentDate = caseRecord.Appointment__r.Appointment_Date__c;
                preparedCase.StartTime = caseRecord.Appointment__r.Start_Time__c;
                preparedCase.Phone = caseRecord.Boutique_Resource__r.Work_Phone__c;
                preparedCase.Email = caseRecord.Appointment__r.ContactEmail;
                preparedCase.Visit = caseRecord.Appointment__r.Purpose_of_Visit__c;
                preparedCase.Comments = caseRecord.Appointment__r.Additional_Comments__c;
                preparedCase.Customer = '/lightning/r/Account/' + caseRecord.Appointment__r.Customer__c + '/view';
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
        ;
    }
}