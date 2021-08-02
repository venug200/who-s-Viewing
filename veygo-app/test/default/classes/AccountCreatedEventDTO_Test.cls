/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-07-29
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
@IsTest
public class AccountCreatedEventDTO_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"eventType\": \"ACCOUNT_CREATED\",'+
		'  \"userId\": \"string\",'+
		'  \"customer\": {'+
		'    \"title\": \"string\",'+
		'    \"firstName\": \"string\",'+
		'    \"middleName\": \"string\",'+
		'    \"lastName\": \"string\",'+
		'    \"email\": \"user@example.com\",'+
		'    \"phoneNumber\": \"string\",'+
		'    \"dateOfBirth\": \"2021-07-29\",'+
		'    \"occupationType\": \"string\",'+
		'    \"occupation\": \"string\",'+
		'    \"address\": {'+
		'      \"flatNo\": \"string\",'+
		'      \"houseNo\": \"string\",'+
		'      \"houseName\": \"string\",'+
		'      \"line1\": \"string\",'+
		'      \"line2\": \"string\",'+
		'      \"road\": \"string\",'+
		'      \"town\": \"string\",'+
		'      \"county\": \"string\",'+
		'      \"country\": \"string\",'+
		'      \"postcode\": \"string\"'+
		'    },'+
		'    \"licenceType\": \"UKM\",'+
		'    \"licenceCountry\": \"string\",'+
		'    \"licenceNumber\": \"string\",'+
		'    \"numberOfClaims\": 0,'+
		'    \"hasConvictions\": true,'+
		'    \"yearsNCB\": 0'+
		'  }'+
		'}';
		AccountCreatedEventDTO obj = AccountCreatedEventDTO.parse(json);
		System.assert(obj != null);
	}
}