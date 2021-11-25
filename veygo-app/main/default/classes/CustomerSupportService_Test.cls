@IsTest
public class CustomerSupportService_Test {
    private static final String LAST_NAME = 'lastName';
    private static final String CATEGORY = 'Health';

    @testSetup
    static void setup(){
		Account account = (Account) TestDataFactory.createPersonAccount(LAST_NAME).insertObj();
        
        Customer_Support__c cs = (Customer_Support__c) TestDataFactory.createCustomerSupport(CATEGORY, account.Id).insertObj();
    }

    @IsTest
	public static void testCreateCustomerSupport(){
        String accId = [SELECT Id FROM Account WHERE Name = :LAST_NAME].Id;
		String customerRecordToCreate = '{"accountId":"'+accID+'","emailAddress":"test@mail.com","category":"Health","type":"test type","startDate":"2021-11-15","endDate":"2021-12-24","details":"test details","scriptingComplete":false}';
		Test.startTest();
		String customerRecordId = CustomerSupportService.createCustomerSupport(customerRecordToCreate);
		Test.stopTest();
		System.assertEquals(18, customerRecordId.length(), 'The record Id is returned');
	}
    
    @IsTest
	public static void testUpdateCustomerSupport(){
        String accId = [SELECT Id FROM Account WHERE Name = :LAST_NAME].Id;
        String csId = [SELECT Id, Category__c FROM Customer_Support__c WHERE Category__c = :CATEGORY].Id;
		String customerRecordToCreate = '{"accountId":"'+accID+'","emailAddress":"test@mail.com","category":"Health","type":"test type","startDate":"2021-11-15","endDate":"2021-12-24","details":"test details","scriptingComplete":false}';
		Test.startTest();
		String customerRecordId = CustomerSupportService.updateCustomerSupport(csId, customerRecordToCreate);
		Test.stopTest();
		System.assertEquals(18, customerRecordId.length(), 'The record Id is returned');
	}
}