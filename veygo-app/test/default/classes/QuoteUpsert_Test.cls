/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-07-20
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
 * Modifications Log 
 * Ver   Date         Author                              Modification
 * 1.0   2021-07-20   matteo.iacucci@emea.merkleinc.com   Initial Version
**/
@isTest
public class QuoteUpsert_Test {
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
	public static void processQuoteUpsert(){
		String body = '{'+
		'  \"customerId\": \"customerId\",'+
		'  \"quoteId\": \"quoteId\",'+
		'  \"eventType\": \"quoteStage\",'+
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
		System.assertEquals(200, response.statusCode, 'Unexpected response status code');
	}

	@isTest
	public static void processQuoteUpsertNoType(){
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


