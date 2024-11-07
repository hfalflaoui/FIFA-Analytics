import { LightningElement, api, wire, track } from 'lwc';
import getReportSummary from '@salesforce/apex/ReportSummaryController.getReportSummary';

export default class ReportSummary extends LightningElement {
    @api reportId = "00OWU0000071Wmb2AE"; // Report ID passed as a parameter
    @track summaryData = [];
    @track error;

    connectedCallback() {
        this.fetchReportSummary();
    }

    fetchReportSummary() {
        getReportSummary({ reportId: this.reportId })
            .then((result) => {
                this.summaryData = this.processSummaryData(result);
                this.error = undefined;
            })
            .catch((error) => {
                this.error = 'Error retrieving report summary: ' + error.body.message;
                this.summaryData = undefined;
            });
    }

    processSummaryData(data) {
        // Customize this to display desired summary data fields
        const summaryItems = [];
        for (let key in data) {
            if (data[key]) {
                data[key].forEach((aggregate) => {
                    summaryItems.push({
                        key: aggregate.label,
                        label: aggregate.label,
                        value: aggregate.value
                    });
                });
            }
        }
        return summaryItems;
    }
}
