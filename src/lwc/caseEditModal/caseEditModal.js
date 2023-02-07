/**
 * Created by Mariya on 06.02.2023.
 */

import {LightningElement, api} from 'lwc';
import CASE_NUMBER_FIELD from '@salesforce/schema/Case.CaseNumber';
import CASE_SUBJECT_FIELD from '@salesforce/schema/Case.Subject';
import CASE_STATUS_FIELD from '@salesforce/schema/Case.Status';
import CASE_ESCALATED_FIELD from '@salesforce/schema/Case.IsEscalated';
import CASE_DATE_FIELD from '@salesforce/schema/Case.Appointment_Date__c';
import CASE_OBJ from '@salesforce/schema/Case'
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class CaseEditModal extends LightningElement {

    @api showModal;
    @api recordId;

    objectApiName = CASE_OBJ;

    caseNumber = CASE_NUMBER_FIELD;
    caseSubject = CASE_SUBJECT_FIELD;
    caseStatus = CASE_STATUS_FIELD;
    caseEscalated = CASE_ESCALATED_FIELD;
    caseDate = CASE_DATE_FIELD;

    closeModal() {
        this.dispatchEvent(new CustomEvent('close'));
    }

    successMessage() {
        const evt = new ShowToastEvent({
            title: 'Case Updated',
            message: 'Record ID: ' + this.recordId,
            variant: 'success',
        });
        this.dispatchEvent(evt);

        this.closeModal();

        window.location.reload(true);
    }

    errorMessage() {
        const evt = new ShowToastEvent({
            title: 'Case do not updated',
            message: 'Error',
            variant: 'error',
        });
        this.dispatchEvent(evt);
    }
}