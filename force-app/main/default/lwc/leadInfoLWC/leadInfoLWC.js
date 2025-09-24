import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, refreshApex } from 'lightning/uiRecordApi';

import COMPANY_FIELD from '@salesforce/schema/Lead.Company';
import COUNTRY_FIELD from '@salesforce/schema/Lead.LeadInfo_Country__c';
import CITY_FIELD from '@salesforce/schema/Lead.LeadInfo_City__c';
import INDUSTRY_FIELD from '@salesforce/schema/Lead.LeadInfo_Industry__c';
import FOUNDED_FIELD from '@salesforce/schema/Lead.LeadInfo_Founded__c';
import LOGO_FIELD from '@salesforce/schema/Lead.LeadInfo_Logo__c';

const FIELDS = [
    COMPANY_FIELD, COUNTRY_FIELD, CITY_FIELD, INDUSTRY_FIELD, 
    FOUNDED_FIELD, LOGO_FIELD
];

export default class LeadInfoLWC extends LightningElement {
    @api recordId;
    @track leadInfo = {};
    @track loading = true;
    @track error = null;

    wiredLeadResult;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredLead(result) {
        this.wiredLeadResult = result;
        
        if (result.data) {
            this.setLeadInfo(result.data);
            this.error = null;
        } else if (result.error) {
            this.error = 'Error loading lead data';
            console.error('Error:', result.error);
        }
        
        this.loading = false;
    }

    setLeadInfo(data) {
        const fields = data.fields;
        
        this.leadInfo = {
            company: this.getFieldValue(fields.Company),
            country: this.getFieldValue(fields.LeadInfo_Country__c),
            city: this.getFieldValue(fields.LeadInfo_City__c),
            industry: this.getFieldValue(fields.LeadInfo_Industry__c),
            logo: this.getFieldValue(fields.LeadInfo_Logo__c)
        };
    }

    getFieldValue(field) {
        return field && field.value ? field.value : '';
    }

    handleLogoError(event) {
        event.target.style.display = 'none';
    }
   
    @api
    refreshData() {
        this.loading = true;
        if (this.wiredLeadResult) {
            refreshApex(this.wiredLeadResult);
        }
    }
}
