import { LightningElement, api, wire } from 'lwc';
import {
    subscribe,
    APPLICATION_SCOPE,
    MessageContext
} from 'lightning/messageService';
import CONNECTOR_CHANNEL from '@salesforce/messageChannel/lwcConnector__c';
import AlertMessage from '@salesforce/label/c.CustomerSupportAlertMessage';

export default class CustomerSupportAlert extends LightningElement {
    @wire(MessageContext)
    messageContext;

    showMessage = false;
    alertMessage = AlertMessage;

    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                CONNECTOR_CHANNEL,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    handleMessage(message) {
        if (message.valueTo > 0){
            this.showMessage = true;
        }else{
            this.showMessage = false;
        }
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
    }
}