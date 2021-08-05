/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-08-05
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
 * Modifications Log 
 * Ver   Date         Author                              Modification
 * 1.0   2021-07-20   matteo.iacucci@emea.merkleinc.com   Initial Version
**/
@isTest
public class QuoteUpsert_Test {

	@isTest
	public static void processQuoteStartLead(){
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
		System.assertEquals(200, response.statusCode, 'processQuoteStartLead(). Unexpected response status code');
		Map<String, String> res = (Map<String, String>) JSON.deserialize(response.responseBody.toString(), Map<String, String>.class);
		System.assertEquals([SELECT Id FROM Lead LIMIT 1].Id, res.get('leadId'), 'Wrong lead id');

	}

	@isTest
	public static void processQuoteStartOpportunity(){
		Test.setMock(HttpCalloutMock.class, new SyncQueueableMock(200));
		String lastName = 'testAccount';
		String body = '{'+
		'  \"eventType\": \"QUOTE_STARTED\",'+
		'  \"quote\": {'+
		'  \"userId\": \"Cognito_' + lastName +'\",'+
		'    \"product\": \"LDP\",'+
		'    \"quoteId\": \"testQuoteId\",'+
		'    \"licenceType\": \"UKM\",'+
		'    \"postcode\": \"string\",'+
		'    \"dateOfBirth\": \"1990-03-01\"'+
		'  }'+
		'}';

		Account account = (Account) TestDataFactory.createPersonAccount(lastName).insertObj();
		//set the rest context
		RestRequest request = new RestRequest();
		RestResponse response = new RestResponse();

		request.requestBody = Blob.valueof(body);

		RestContext.request = request;
		RestContext.response = response;
		
		Test.startTest();
		QuoteUpsertRestResource.processPost();
		Test.stopTest();
		System.assertEquals(200, response.statusCode, 'processQuoteStartOpportunity() Unexpected response status code');
		Map<String, String> res = (Map<String, String>) JSON.deserialize(response.responseBody.toString(), Map<String, String>.class);
		System.assertEquals([SELECT Id FROM Opportunity LIMIT 1].Id, res.get('opportunityId'), 'processQuoteStartOpportunity() Wrong opportunity id');

	}


	@isTest
	public static void processQuoteUpdatedLead(){
		String body = 	'{'+
		'  \"eventType\": \"QUOTE_UPDATED\",'+
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
		System.assertEquals(200, response.statusCode, 'processQuoteUpdatedLead() Unexpected response status code');
		Map<String, String> res = (Map<String, String>) JSON.deserialize(response.responseBody.toString(), Map<String, String>.class);
		System.assertEquals([SELECT Id FROM Lead LIMIT 1].Id, res.get('leadId'), 'processQuoteUpdatedLead() Wrong lead id');

	}

	@isTest
	public static void processQuoteUpdatedOpportunity(){
		Test.setMock(HttpCalloutMock.class, new SyncQueueableMock(200));

		String lastName = 'accounttest';
		String body = 	'{'+
		'  \"eventType\": \"QUOTE_UPDATED\",'+
		'  \"userId\": \"Cognito_' + lastName +'\",'+
		'  \"quote\": {'+
		'    \"product\": \"LDP\",'+
		'    \"quoteId\": \"QN-' + lastName +'\",'+
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

		Account account = (Account) TestDataFactory.createPersonAccount(lastName).insertObj();
		Lead l = (Lead) TestDataFactory.createLead(lastName).insertObj();

		
		Test.startTest();
		QuoteUpsertRestResource.processPost();
		Test.stopTest();
		System.assertEquals(200, response.statusCode, 'processQuoteUpdatedLead() Unexpected response status code');
		Map<String, String> res = (Map<String, String>) JSON.deserialize(response.responseBody.toString(), Map<String, String>.class);
		System.assertEquals([SELECT Id FROM Opportunity LIMIT 1].Id, res.get('opportunityId'), 'processQuoteUpdatedLead() Wrong Opportunity id');

	}


	@isTest
	public static void processQuoteSeleCompleted(){
		Test.setMock(HttpCalloutMock.class, new SyncQueueableMock(200));
		String lastName = 'testAccount';
		String quoteNumber = 'QN_TEST';
		String body = 	'{'+
		'  \"eventType\": \"SALE_COMPLETED\",'+
		'  \"userId\": \"Cognito_' + lastName +'\",'+
		'  \"quote\": {'+
		'    \"product\": \"LDP\",'+
		'    \"quoteId\": \"'+ quoteNumber + '\",'+
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

		Account account = (Account) TestDataFactory.createPersonAccount(lastName).insertObj();
		Opportunity opportunity  = (Opportunity) TestDataFactory.createOpportunity(quoteNumber, account.Id).insertObj();

		
		Test.startTest();
		QuoteUpsertRestResource.processPost();
		Test.stopTest();
		System.assertEquals(200, response.statusCode, 'processQuoteSeleCompleted() Unexpected response status code');
		Map<String, String> res = (Map<String, String>) JSON.deserialize(response.responseBody.toString(), Map<String, String>.class);
		System.assertEquals([SELECT Id, Policy_Number_Id__c FROM InsurancePolicy LIMIT 1].Policy_Number_Id__c, res.get('policyNumber'), 'processQuoteSeleCompleted() Wrong policy number id');
		System.assertEquals([SELECT Id, Policy_Number_Id__c FROM InsurancePolicy LIMIT 1].Id, res.get('policyId'), 'processQuoteSeleCompleted() Wrong policy id');



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
		System.assertEquals(500, response.statusCode, 'processQuoteUpsertException() Unexpected response status code');
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
		System.assertEquals(400, response.statusCode, 'processQuoteUpsertNoEventType() Unexpected response status code');
	}

	@isTest
	public static void processQuoteUpsertEventTypeNoHandled(){
		String body = '{'+
		'  \"eventType\": \"NOHANDLED\",'+
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
		System.assertEquals(400, response.statusCode, 'processQuoteUpsertEventTypeNoHandled() Unexpected response status code');
	}
}


