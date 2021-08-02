/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-08-02
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
 * Modifications Log 
 * Ver   Date         Author                              Modification
 * 1.0   2021-07-20   matteo.iacucci@emea.merkleinc.com   Initial Version
**/
@isTest
public class QuoteUpsert_Test {

	@isTest
	public static void processQuoteStarted(){
		String body = '{'+
		'  \"eventType\": \"QUOTE_STARTED\",'+
		'  \"quote\": {'+
		'    \"product\": \"LDP\",'+
		'    \"quoteId\": \"testQuoteId\",'+
		'    \"licenceType\": \"UKM\",'+
		'    \"postcode\": \"string\",'+
		'    \"dateOfBirth\": \"1990-03-01\"'+
		'  }'+
		'}';
		//set the rest context
		RestRequest request = new RestRequest();
		RestResponse response = new RestResponse();

		request.requestBody = Blob.valueof(body);

		RestContext.request = request;
		RestContext.response = response;
		
		Test.startTest();
		QuoteUpsertRestResource.processPost();
		Test.stopTest();
		System.assertEquals(200, response.statusCode, 'Unexpected response status code');
		Map<String, String> res = (Map<String, String>) JSON.deserialize(response.responseBody.toString(), Map<String, String>.class);
		System.assertEquals([SELECT Id FROM Lead LIMIT 1].Id, res.get('leadId'), 'Wrong lead id');

	}


	@isTest
	public static void processQuoteUpdated(){
		String body = 	'{'+
		'  \"eventType\": \"DURATION_UPDATED\",'+
		'  \"quote\": {'+
		'    \"product\": \"LDP\",'+
		'    \"quoteId\": \"string\",'+
		'    \"startDate\": \"2021-07-29T14:19:59.000Z\",'+
		'    \"endDate\": \"2021-07-29T14:19:59.000Z\",'+
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
		//set the rest context
		RestRequest request = new RestRequest();
		RestResponse response = new RestResponse();

		request.requestBody = Blob.valueof(body);

		RestContext.request = request;
		RestContext.response = response;
		
		Test.startTest();
		QuoteUpsertRestResource.processPost();
		Test.stopTest();
		System.assertEquals(200, response.statusCode, 'Unexpected response status code');
		Map<String, String> res = (Map<String, String>) JSON.deserialize(response.responseBody.toString(), Map<String, String>.class);
		System.assertEquals([SELECT Id FROM Lead LIMIT 1].Id, res.get('leadId'), 'Wrong lead id');

	}


	@isTest
	public static void processQuoteUpsertException(){
	   
		//set the rest context
		RestRequest request = new RestRequest();
		RestResponse response = new RestResponse();

		request.requestBody = Blob.valueof('{exceptuon}');

		RestContext.request = request;
		RestContext.response = response;
		
		Test.startTest();
		QuoteUpsertRestResource.processPost();
		Test.stopTest();
		System.assertEquals(500, response.statusCode, 'Unexpected response status code');
	}

	@isTest
	public static void processQuoteUpsertNoEventType(){
		String body = '{'+
		'  \"customerId\": \"customerId\",'+
		'  \"quoteId\": \"quoteId\",'+
		'  \"carRegistrationNumber\": \"carRegistrationNumber\",'+
		'  \"licenseType\": \"licenseType\",'+
		'  \"licenseNumber\": \"licenseNumber\",'+
		'  \"postcode\": \"postcode\",'+
		'  \"dob\": \"dob\",'+
		'  \"ownerDriver\": \"ownerDriver\"'+
		'}';
		//set the rest context
		RestRequest request = new RestRequest();
		RestResponse response = new RestResponse();

		request.requestBody = Blob.valueof(body);

		RestContext.request = request;
		RestContext.response = response;
		
		Test.startTest();
		QuoteUpsertRestResource.processPost();
		Test.stopTest();
		System.assertEquals(400, response.statusCode, 'Unexpected response status code');
	}
}


