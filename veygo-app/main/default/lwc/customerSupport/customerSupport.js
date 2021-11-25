import { LightningElement, api, wire } from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import CUSTOMER_SUPPORT_OBJECT from '@salesforce/schema/Customer_Support__c';
import CATEGORY_FIELD from '@salesforce/schema/Customer_Support__c.Category__c';
import createCustomerSupport from '@salesforce/apex/CustomerSupportService.createCustomerSupport';
import updateCustomerSupport from '@salesforce/apex/CustomerSupportService.updateCustomerSupport';
import getCustomerSupportByAccountId from '@salesforce/apex/CustomerSupportSelector.getCustomerSupportByAccountId';
import { publish, MessageContext } from 'lightning/messageService';
import CONNECTOR_CHANNEL from '@salesforce/messageChannel/lwcConnector__c';

const actions = [
    { label: 'Delete', name: 'delete' },
];

const columns = [
    { label: 'Customer Support', fieldName: 'Email_Address__c' },
    { label: 'Category', fieldName: 'Category__c'},
    { label: 'Type', fieldName: 'Type__c'},
    { label: 'Start Date', fieldName: 'Start_date__c', type: 'date' },
    { label: 'End Date', fieldName: 'End_date__c', type: 'date' },
    { label: 'Details', fieldName: 'Details__c'},
    { label: 'Scripting Complete ', fieldName: 'Scripting_complete__c'},
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];

const INSERT = 'insert';
const UPDATE = 'update';

export default class CustomerSupport extends LightningElement {
    _title = 'Customer Support';
    message = 'Record created';
    variant = 'success';
    customerSupportRecords = false;
    customerSupportButton = true
    newCustomerSupport = false;
    activeSectionMessage = '';
    @api recordId;
    data = [];
    columns = columns;
    emailAddress = '';
    category = '';
    type = '';
    startDate = '';
    endDate = '';
    details = '';
    scriptingComplete = false;
    categorys = [];
    newCSData = {};
    recordOption;
    csRecordIdToUpdate;

    @wire(MessageContext)
    messageContext;

    connectedCallback(){
        this.loadCustomerSupportRecords();
    }

    async loadCustomerSupportRecords() {
        try {
            //console.log('loadCustomerSupportRecords')
            const csrecords = await getCustomerSupportByAccountId({ accountId: this.recordId})
            if(csrecords.length === 0){
                this.customerSupportRecords = false;
                this.publishMessageFromLWC(csrecords.length);
                return;
            }
            this.csNumberRecords = csrecords.length;
            this.publishMessageFromLWC(csrecords.length)
            //console.log('loadCustomerSupportRecords:'+JSON.stringify(csrecords));
            this.data = csrecords;
            this.customerSupportRecords = true;
        } catch (error) {
            console.log(JSON.stringify(error));
        }
    }

    @wire(getObjectInfo, { objectApiName: CUSTOMER_SUPPORT_OBJECT })
    objectInfo;
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: CATEGORY_FIELD })
    getPicklistValuesHandler({error, data}){
        if(data){
            this.categorys = data.values.map(role => ({key: role.value, value: role.value, label: role.value ? role.value.trim() : '', selected: false}));
        }else if(error){
            console.log(error);
        }
    }

    publishMessageFromLWC(messageTo) {
        const payload = { valueTo: messageTo };
        publish(this.messageContext, CONNECTOR_CHANNEL, payload);
    }

    handleToggleSection(event) {
        this.activeSectionMessage =
            'Open section name:  ' + event.detail.openSections;
    }

    addNewCustomerSupport() {
        this.recordOption = INSERT;
        this.customerSupportRecords = false;
        this.newCustomerSupport = true;
        this.customerSupportButton = false;
    }

    handleCustomerSupportChange(event){
        this.emailAddress = event.detail.value;
    }
    handleCategoryChange(event){
        this.category = event.detail.value;
    }
    handleTypeChange(event){
        this.type = event.detail.value;
    }
    handleStartDateChange(event){
        this.startDate = event.detail.value;
    }
    handleEndDateChange(event){
        this.endDate = event.detail.value;
    }
    handleDetailsChange(event){
        this.details = event.detail.value;
    }
    handleScriptingCompleteChange(event){
        this.scriptingComplete = event.target.checked;
    }
    cancelCustomerSupport() {
        this.cleanFields();
        this.newCustomerSupport = false;
        this.customerSupportButton = true;
        this.customerSupportRecords = true;
    }
    saveCustomerSupport() {
        const isInputsCorrect = [...this.template.querySelectorAll('lightning-input, lightning-combobox, lightning-textarea')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
        if (isInputsCorrect) {
            if(this.recordOption == INSERT){
                this.createCustomerSupportRecord();

            }
            if(this.recordOption == UPDATE){
                this.updateCustomerSupportRecord();
            }
            this.loadCustomerSupportRecords();
            this.cleanFields();
            this.newCustomerSupport = false;
            this.customerSupportButton = true;
        }
    }
    async createCustomerSupportRecord(){
        try{
            this.newCSData = JSON.stringify({
                accountId: this.recordId, 
                emailAddress: this.emailAddress, 
                category: this.category, 
                type: this.type, 
                startDate: this.startDate,
                endDate: this.endDate,
                details: this.details,
                scriptingComplete: this.scriptingComplete
            });
            //console.log('newCSData:'+this.newCSData);
            let response = await createCustomerSupport({customerSupportInfo: this.newCSData});
            //console.log('response:'+JSON.stringify(response));
            this.showNotification();
            this.loadCustomerSupportRecords();
        }catch(error) {
            console.log(error);
        }
    }

    async updateCustomerSupportRecord(){
        try{
            this.newCSData = JSON.stringify({
                accountId: this.recordId, 
                emailAddress: this.emailAddress, 
                category: this.category, 
                type: this.type, 
                startDate: this.startDate,
                endDate: this.endDate,
                details: this.details,
                scriptingComplete: this.scriptingComplete
            });
            //console.log('newCSData:'+this.newCSData);
            let response = await updateCustomerSupport({recordId: this.csRecordIdToUpdate, customerSupportInfo: this.newCSData});
            //console.log('response:'+JSON.stringify(response));
            this.showUpdateNotification();
            this.loadCustomerSupportRecords();
        }catch(error) {
            console.log(error);
        }
    }

    showNotification() {
        const evt = new ShowToastEvent({
            title: this._title,
            message: this.message,
            variant: this.variant,
        });
        this.dispatchEvent(evt);
    }

    showUpdateNotification() {
        const evt = new ShowToastEvent({
            title: this._title,
            message: 'Record updated',
            variant: this.variant,
        });
        this.dispatchEvent(evt);
    }

    handleEditCustomerSupport(event){
        this.csRecordIdToUpdate = event.currentTarget.dataset.id;
        let recordArray = this.data.filter(item => item.Id === this.csRecordIdToUpdate);
        this.emailAddress = recordArray[0].Email_Address__c;
        this.category = recordArray[0].Category__c;
        this.type = recordArray[0].Type__c;
        this.startDate = recordArray[0].Start_date__c;
        this.endDate = recordArray[0].End_date__c;
        this.details = recordArray[0].Details__c;
        this.scriptingComplete = recordArray[0].Scripting_complete__c;

        this.recordOption = UPDATE;
        this.customerSupportRecords = false;
        this.newCustomerSupport = true;
        this.customerSupportButton = false;
    }

    handleDeleteCustomerSupport(event){
        this.deleteCustomerSupport(event.currentTarget.dataset.id);
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'delete':
                this.deleteCustomerSupport(row.Id);
                break;
            default:
        }
    }

    deleteCustomerSupport(id) {
        console.log('deleteRow-id:'+id);
        deleteRecord(id)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: this._title,
                        message: 'Record deleted',
                        variant: 'success'
                    })
                );
                this.loadCustomerSupportRecords();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: this._title,
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    cleanFields(){
        this.emailAddress = '';
        this.category = '';
        this.type = '';
        this.startDate = '';
        this.endDate = '';
        this.details = '';
        this.scriptingComplete = false;
    }
}