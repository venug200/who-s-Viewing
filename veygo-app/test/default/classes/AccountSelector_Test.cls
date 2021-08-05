/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-08-04
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
@IsTest
public class AccountSelector_Test {
	@IsTest
	public static void testGetAccountByCustomerId(){
		String lastName = 'lastName';
		Account account = (Account) TestDataFactory.createPersonAccount(lastName).insertObj();
        String customerId = [SELECT CustomerId__c FROM Account WHERE Id = :account.Id].CustomerId__c;
		Test.startTest();
		Account a = new AccountSelector().getAccountByCustomerId(customerId);
		Test.stopTest();
		System.assertEquals(a.Id, account.Id, 'The 2 Account are different.');	
	}
    @isTest
    public static void testGetAccountByCognitoId(){
		String lastName = 'lastName';
		Account account = (Account) TestDataFactory.createPersonAccount(lastName).insertObj();
		Test.startTest();
		Account a = new AccountSelector().getAccountByCognitoId('Cognito_' + lastName);
		Test.stopTest();
		System.assertEquals(a.Id, account.Id, 'The 2 Account are different.');	
	}
}