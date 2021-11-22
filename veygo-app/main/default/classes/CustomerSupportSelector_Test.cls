@IsTest
public class CustomerSupportSelector_Test {
    private static final String LAST_NAME = 'lastName';
    private static final String CATEGORY = 'Health';

    @testSetup
    static void setup(){
		Account account = (Account) TestDataFactory.createPersonAccount(LAST_NAME).insertObj();
        
        Customer_Support__c cs = (Customer_Support__c) TestDataFactory.createCustomerSupport(CATEGORY, account.Id).insertObj();   
    }

    @IsTest
	public static void testGetCustomerSupportByAccountId(){
        String accId = [SELECT Id FROM Account WHERE Name = :LAST_NAME].Id;
		Test.startTest();
		List<Customer_Support__c> customerSupportList = CustomerSupportSelector.getCustomerSupportByAccountId(accId);
		Test.stopTest();
		System.assertEquals(CATEGORY, customerSupportList[0].Category__c, 'Customer Support category');
	}
    
    @IsTest
	public static void testGetCustomerSupportById(){
        String csId = [SELECT Id, Category__c FROM Customer_Support__c WHERE Category__c = :CATEGORY].Id;
		Test.startTest();
		Customer_Support__c customerSupport = CustomerSupportSelector.getCustomerSupportById(csId);
		Test.stopTest();
		System.assertEquals(CATEGORY, customerSupport.Category__c, 'Customer Support category');
	}
}