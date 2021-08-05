/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-08-05
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
@IsTest
public class AccountCreatedEventDTO_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"eventType\": \"SF_CUST_CREATED\",'+
		'  \"userId\": \"string\",'+
		'  \"CustomerId\": \"string\"'+
		'}';
		AccountCreatedEventDTO obj = AccountCreatedEventDTO.parse(json);
		System.assert(obj != null);
	}
}