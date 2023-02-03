/**
 * Created by Mariya on 02.02.2023.
 */

import {LightningElement, api} from 'lwc';

export default class TableRow extends LightningElement {
    @api record;
    @api field;

    value;

    connectedCallback() {
        this.value = this.record[this.field];
    }
}