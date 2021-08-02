/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-07-29
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
@IsTest
public class QuoteUpdateDTO_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"eventType\": \"DURATION_UPDATED\",'+
		'  \"userId\": \"string\",'+
		'  \"quote\": {'+
		'    \"product\": \"LDP\",'+
		'    \"quoteId\": \"string\",'+
		'    \"startDate\": \"2021-07-29T14:19:59.065Z\",'+
		'    \"endDate\": \"2021-07-29T14:19:59.065Z\",'+
		'    \"purchased\": true,'+
		'    \"financials\": {'+
		'      \"initialPrice\": 0,'+
		'      \"price\": 0,'+
		'      \"priceBeforeTax\": 0,'+
		'      \"tax\": 0,'+
		'      \"excess\": 0,'+
		'      \"discountCode\": \"string\"'+
		'    },'+
		'    \"policyNumber\": \"string\",'+
		'    \"underwriting\": {'+
		'      \"passed\": true,'+
		'      \"failureReasons\": ['+
		'        \"Reason 1\",'+
		'        \"Reason 2\"'+
		'      ]'+
		'    },'+
		'    \"documentDeliveryPreference\": \"string\",'+
		'    \"driver\": {'+
		'      \"title\": \"string\",'+
		'      \"firstName\": \"string\",'+
		'      \"middleName\": \"string\",'+
		'      \"lastName\": \"string\",'+
		'      \"email\": \"user@example.com\",'+
		'      \"phoneNumber\": \"string\",'+
		'      \"dateOfBirth\": \"2021-07-29\",'+
		'      \"occupationType\": \"string\",'+
		'      \"occupation\": \"string\",'+
		'      \"address\": {'+
		'        \"flatNo\": \"string\",'+
		'        \"houseNo\": \"string\",'+
		'        \"houseName\": \"string\",'+
		'        \"line1\": \"string\",'+
		'        \"line2\": \"string\",'+
		'        \"road\": \"string\",'+
		'        \"town\": \"string\",'+
		'        \"county\": \"string\",'+
		'        \"country\": \"string\",'+
		'        \"postcode\": \"string\"'+
		'      },'+
		'      \"licenceType\": \"UKM\",'+
		'      \"licenceCountry\": \"string\",'+
		'      \"licenceNumber\": \"string\",'+
		'      \"numberOfClaims\": 0,'+
		'      \"hasConvictions\": true,'+
		'      \"yearsNCB\": 0'+
		'    },'+
		'    \"owner\": {'+
		'      \"firstName\": \"string\",'+
		'      \"lastName\": \"string\",'+
		'      \"email\": \"user@example.com\",'+
		'      \"phoneNumber\": \"string\",'+
		'      \"dateOfBirth\": \"2021-07-29\",'+
		'      \"occupationType\": \"string\",'+
		'      \"occupation\": \"string\",'+
		'      \"postcode\": \"string\",'+
		'      \"relationship\": \"string\"'+
		'    },'+
		'    \"car\": {'+
		'      \"make\": \"string\",'+
		'      \"model\": \"string\",'+
		'      \"transmission\": \"string\",'+
		'      \"year\": 0,'+
		'      \"value\": 0,'+
		'      \"engineSize\": 0,'+
		'      \"insuranceGroup\": \"string\",'+
		'      \"mainInsurer\": \"string\"'+
		'    }'+
		'  }'+
		'}';
		QuoteUpdateDTO obj = QuoteUpdateDTO.parse(json);
		System.assert(obj != null);
	}
}