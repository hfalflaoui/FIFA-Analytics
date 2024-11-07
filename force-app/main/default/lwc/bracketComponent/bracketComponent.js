import { LightningElement, wire } from 'lwc';
import getBracketData from '@salesforce/apex/BracketData.getBracketData';


export default class BracketComponent extends LightningElement {
    stages;

    
@wire(getBracketData)
wiredTeamData({ data, error }) {
    console.log("Data test"+data);
    if (data) {
        this.stages = data;
        this.error = undefined;
    } else if (error) {
        this.error = error;
        this.stages = undefined;
    }
}


}
