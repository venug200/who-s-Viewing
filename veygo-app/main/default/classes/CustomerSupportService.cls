public with sharing class CustomerSupportService {
    private static rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('CustomerSupportService');
    
    @AuraEnabled
	public static String createCustomerSupport(String customerSupportInfo){
		CustomerSupportInfo input = (CustomerSupportInfo)JSON.deserialize(customerSupportInfo, CustomerSupportInfo.class);
		Customer_Support__c customerSupport = new Customer_Support__c();
		customerSupport.AccountId__c = input.accountId;
		customerSupport.Email_Address__c = input.emailAddress;
		customerSupport.Category__c = input.category;
		customerSupport.Type__c = input.type != null ? input.type : '';
		customerSupport.Start_date__c = input.startDate;
		customerSupport.End_date__c = input.endDate;
		customerSupport.Details__c = input.details != null ? input.details : '';
		customerSupport.Scripting_complete__c = input.scriptingComplete;
		insert customerSupport;        
        return customerSupport.Id;
	}

    @AuraEnabled
	public static String updateCustomerSupport(String recordId, String customerSupportInfo){
		Customer_Support__c customerSupport = CustomerSupportSelector.getCustomerSupportById(recordId);

        CustomerSupportInfo input = (CustomerSupportInfo)JSON.deserialize(customerSupportInfo, CustomerSupportInfo.class);
		customerSupport.AccountId__c = input.accountId;
		customerSupport.Email_Address__c = input.emailAddress;
		customerSupport.Category__c = input.category;
		customerSupport.Type__c = input.type != null ? input.type : '';
		customerSupport.Start_date__c = input.startDate;
		customerSupport.End_date__c = input.endDate;
		customerSupport.Details__c = input.details != null ? input.details : '';
		customerSupport.Scripting_complete__c = input.scriptingComplete;
		update customerSupport;        
        return customerSupport.Id;
	}

    @TestVisible
    private class CustomerSupportInfo {
        @AuraEnabled
        public String accountId;
        @AuraEnabled
        public String emailAddress;
        @AuraEnabled
        public String category;      
        @AuraEnabled
        public String type;    
        @AuraEnabled
        public Date startDate;    
        @AuraEnabled
        public Date endDate;    
        @AuraEnabled
        public String details;    
        @AuraEnabled
        public Boolean scriptingComplete;
    }
}
