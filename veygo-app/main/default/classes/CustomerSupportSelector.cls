public with sharing class CustomerSupportSelector {
    private static rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('CustomerSupportSelector');

    @AuraEnabled
    public static List<Customer_Support__c> getCustomerSupportByAccountId(String accountId){
		List<Customer_Support__c> customerSupportList = new List<Customer_Support__c>();
		if( Schema.Customer_Support__c.SObjectType.getDescribe().isAccessible() ){
			for(Customer_Support__c cs : [SELECT Id, Email_Address__c, Category__c, Type__c, Start_date__c, End_date__c, Details__c, Scripting_complete__c
								FROM Customer_Support__c 
								WHERE AccountId__c = :accountId
                                ORDER BY Start_date__c DESC
							]){
                customerSupportList.add(cs);
			}
		}else{
			logger.error('getCustomerSupportByAccountId(): User (userid: {0}) has no access right to Customer_Support__c', new List<Object> {String.valueOf(UserInfo.getUserId())});
		}		
		return customerSupportList;
	}

    public static Customer_Support__c getCustomerSupportById(String Id){
		Customer_Support__c customerSupport = null;
		if( Schema.Customer_Support__c.SObjectType.getDescribe().isAccessible() ){
			for(Customer_Support__c cs : [SELECT Id, Email_Address__c, Category__c, Type__c, Start_date__c, End_date__c, Details__c, Scripting_complete__c
								FROM Customer_Support__c 
								WHERE Id = :Id
							]){
                customerSupport = cs;
			}
		}else{
			logger.error('getCustomerSupportById(): User (userid: {0}) has no access right to Customer_Support__c', new List<Object> {String.valueOf(UserInfo.getUserId())});
		}		
		return customerSupport;
	}
}
