import { LightningElement, api, wire } from 'lwc';
import getTeamData from '@salesforce/apex/TeamService.getTeamData';

export default class Team360View extends LightningElement {
    @api recordId;
    teamData;
    error;

    
    @wire(getTeamData, { teamId: '$recordId' })
    wiredTeamData({ data, error }) {
        console.log("Data test"+data);
        if (data) {
            this.teamData = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.teamData = undefined;
        }
    }
}