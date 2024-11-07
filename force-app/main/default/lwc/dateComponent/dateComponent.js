import { LightningElement, api } from 'lwc';

export default class DateComponent extends LightningElement {

    @api dateValue;

    get formattedDate() {
        if (this.dateValue) {
            const date = new Date(this.dateValue);

            // Format the date as yyyy-MM-dd H:m:s
            const options = {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit',
                hour12: false
            };
            const formattedDate = new Intl.DateTimeFormat('en-GB', options).format(date);

            // Adjust to 'yyyy-MM-dd H:m:s' format
            return formattedDate;
        }
        return '';
    }
}