import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import AlertMessage from '@salesforce/label/c.AccountFraudAlertMessage';
import accountHasFraudCase from '@salesforce/apex/AccountFraudController.isHasCase';

export default class AccountFraudAlertMessage extends LightningElement {
    @api recordId;
    showMessage = false;

    label = {
        AlertMessage
    };

    connectedCallback() {
        accountHasFraudCase({ recordId: this.recordId })
		.then(result => {
            this.showMessage = result;
		})
		.catch(error => {
			this.showToast('Error', error.body.message, 'error');
		});
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            }),
        );
    }
}