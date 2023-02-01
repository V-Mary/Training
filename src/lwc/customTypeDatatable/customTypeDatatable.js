import LightningDatatable from 'lightning/datatable';
import customCommentTemplate from './customComment.html';

export default class customTypeDatatable extends LightningDatatable {
    static customTypes = {
        customComment: {
            template: customCommentTemplate,
             typeAttributes: ['comment'],
        }
    }
}