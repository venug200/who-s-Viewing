/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-08-10
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
@IsTest
public class QuoteStartDTO_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"eventType\": \"QUOTE_STARTED\",'+
		'  \"quote\": {'+
		'    \"product\": \"LDP\",'+
		'    \"userId\": \"string\",'+
		'    \"quoteId\": \"string\",'+
		'    \"licenceType\": \"UKM\",'+
		'    \"postcode\": \"string\",'+
		'    \"dateOfBirth\": \"1990-03-01\"'+
		'  }'+
		'}';
		QuoteStartDTO obj = QuoteStartDTO.parse(json);
		System.assert(obj != null);
	}
}