/**
 * Created by Mariya on 27.01.2023.
 */

import {LightningElement, api, wire, track} from 'lwc';
import getAppointmentResourcesByBoutiqueId
    from '@salesforce/apex/AppointmentResourceController.getAppointmentResourcesByBoutiqueId';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';

const actions = [
    {label: 'View', name: 'view'},
    {label: 'Edit', name: 'edit'},
    {label: 'Delete', name: 'delete'}
];

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
        label: 'Action',
        type: 'action',
        initialWidth: '50px',
        typeAttributes: {rowActions: actions},
    }
];

export default class BoutiqueAppointments extends NavigationMixin(LightningElement) {
    @api recordId;
    @track data = [];
    @track columns = COLS;

    @track dataToDisplay = [];
    @track page = 1;
    @track startingRecord = 1;
    @track endingRecord = 0;
    @track pageSize = 5;
    @track totalRecountCount = 0;
    @track totalPage = 0;
    isPageChanged = false;

    @wire(getAppointmentResourcesByBoutiqueId, {boutiqueId: '$recordId'})
    wiredCases({error, data}) {
        this.data = data;
        if (this.data) {
            let preparedCases = [];
            this.data.forEach(caseRecord => {
                let preparedCase = {};
                preparedCase.CaseId = caseRecord.Appointment__c;
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
            this.processRecords(this.data);
        } else if (error) {
            const evt = new ShowToastEvent({
                title: 'Error',
                message: error,
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }
    }

    processRecords(data) {
        this.items = data;
        this.totalRecountCount = data.length;
        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);

        this.dataToDisplay = this.items.slice(0, this.pageSize);
        this.endingRecord = this.pageSize;
    }

    previousHandler() {
        this.isPageChanged = true;
        if (this.page > 1) {
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
        }
    }

    nextHandler() {
        this.isPageChanged = true;
        if ((this.page < this.totalPage) && this.page !== this.totalPage) {
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);
        }
    }

    displayRecordPerPage(page) {
        this.startingRecord = ((page - 1) * this.pageSize);
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount)
            ? this.totalRecountCount : this.endingRecord;

        this.dataToDisplay = this.data.slice(this.startingRecord, this.endingRecord);
        this.startingRecord = this.startingRecord + 1;
    }

    handlePageSize(event) {
        this.pageSize = event.target.value;
    }

    updateTable() {
        this.displayRecordPerPage(this.page);
        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
        eval("$A.get('e.force:refreshView').fire();");
    }

    handleRowAction(event) {

        const actionName = event.detail.action.name;
        const row = event.detail.row;
        console.log(row);
        switch (actionName) {
            case 'edit':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.CaseId,
                        objectApiName: 'Case',
                        actionName: 'edit'
                    }
                });
                break;
        }
    }
}