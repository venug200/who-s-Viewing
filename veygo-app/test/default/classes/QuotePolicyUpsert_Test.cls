/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-08-06
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
 * Modifications Log 
 * Ver   Date         Author                              Modification
 * 1.0   2021-07-20   matteo.iacucci@emea.merkleinc.com   Initial Version
**/
@isTest
public class QuotePolicyUpsert_Test {

	@isTest
	public static void processQuoteStartLead(){
		String body = '{'+
		'  \"eventType\": \"QUOTE_STARTED\",'+
		'  \"quote\": {'+
		'    \"product\": \"LDP\",'+
		'    \"quoteId\": \"testQuoteId\",'+
		'    \"licenceType\": \"UKM\",'+
		'    \"postcode\": \"string\",'+
		'    \"dateOfBirth\": \"1990-03-01\",'+
        '    \"isDriverOwner\": false'+
		'  }'+
		'}';
		//set the rest context
		RestRequest request = new RestRequest();
		RestResponse response = new RestResponse();

		request.requestBody = Blob.valueof(body);

		RestContext.request = request;
		RestContext.response = response;
		
		Test.startTest();
		QuotePolicyUpsertRestResource.processPost();
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
		'    \"dateOfBirth\": \"1990-03-01\",'+
        '    \"isDriverOwner\": false'+
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
		QuotePolicyUpsertRestResource.processPost();
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
        '    \"isDriverOwner\": false,'+
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
		'      \"mainInsurer\": \"string\",'+
        '      \"registration\": \"string\"'+
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
		QuotePolicyUpsertRestResource.processPost();
		Test.stopTest();
		System.assertEquals(200, response.statusCode, 'processQuoteUpdatedLead() Unexpected response status code');
		Map<String, String> res = (Map<String, String>) JSON.deserialize(response.responseBody.toString(), Map<String, String>.class);
        System.assertEquals('string', [SELECT Registration_Number__c FROM Lead LIMIT 1].Registration_Number__c);
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
        '    \"isDriverOwner\": false,'+
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
		'      \"mainInsurer\": \"string\",'+
        '      \"registration\": \"string\"'+
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
		QuotePolicyUpsertRestResource.processPost();
		Test.stopTest();
		System.assertEquals(200, response.statusCode, 'processQuoteUpdatedLead() Unexpected response status code');
		Map<String, String> res = (Map<String, String>) JSON.deserialize(response.responseBody.toString(), Map<String, String>.class);
		System.assertEquals([SELECT Id FROM Opportunity LIMIT 1].Id, res.get('opportunityId'), 'processQuoteUpdatedLead() Wrong Opportunity id');

	}


	@isTest
	public static void processQuoteSaleCompleted(){
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
        '    \"isDriverOwner\": false,'+
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
		'      \"mainInsurer\": \"string\",'+
        '      \"registration\": \"string\"'+
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
		QuotePolicyUpsertRestResource.processPost();
		Test.stopTest();
		System.assertEquals(200, response.statusCode, 'processQuoteSaleCompleted() Unexpected response status code');
		Map<String, String> res = (Map<String, String>) JSON.deserialize(response.responseBody.toString(), Map<String, String>.class);
		System.assertEquals([SELECT Id, Policy_Number_Id__c FROM InsurancePolicy LIMIT 1].Policy_Number_Id__c, res.get('policyNumber'), 'processQuoteSaleCompleted() Wrong policy number id');
		System.assertEquals([SELECT Id, Policy_Number_Id__c FROM InsurancePolicy LIMIT 1].Id, res.get('policyId'), 'processQuoteSaleCompleted() Wrong policy id');



	}


	@isTest
	public static void processPolicyUpdated(){
		Test.setMock(HttpCalloutMock.class, new SyncQueueableMock(200));
		String lastName = 'testAccount';
		String quoteNumber = 'QN_TEST';
		String body = 	'{'+
		'  \"eventType\": \"' + Constants.POLICY_UPDATED + '\",'+
		'  \"userId\": \"Cognito_' + lastName +'\",'+
		'  \"quote\": {'+
		'    \"product\": \"LDP\",'+
		'    \"quoteId\": \"'+ quoteNumber + '\",'+
		'    \"startDate\": \"2021-07-29T14:19:59.000Z\",'+
		'    \"endDate\": \"2021-07-29T14:19:59.000Z\",'+
		'    \"purchased\": true,'+
        '    \"isDriverOwner\": false,'+
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
        '      \"isDriverOwner\": true,'+
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
		'      \"dateOfBirth\": \"2000-07-29\",'+
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
		'      \"mainInsurer\": \"string\",'+
        '      \"registration\": \"string\"'+
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
		QuotePolicyUpsertRestResource.processPost();
		Test.stopTest();
		System.assertEquals(200, response.statusCode, 'processQuoteSaleCompleted() Unexpected response status code');
		Map<String, String> res = (Map<String, String>) JSON.deserialize(response.responseBody.toString(), Map<String, String>.class);
        System.assertEquals('string', [SELECT Registration_Number__c FROM InsurancePolicy LIMIT 1].Registration_Number__c);
		System.assertEquals([SELECT Id, Policy_Number_Id__c FROM InsurancePolicy LIMIT 1].Policy_Number_Id__c, res.get('policyNumber'), 'processQuoteSaleCompleted() Wrong policy number id');
		System.assertEquals([SELECT Id, Policy_Number_Id__c FROM InsurancePolicy LIMIT 1].Id, res.get('policyId'), 'processQuoteSaleCompleted() Wrong policy id');
	}


	
	@isTest
	public static void processPolicyCanceled(){
		Test.setMock(HttpCalloutMock.class, new SyncQueueableMock(200));
		String lastName = 'testAccount';
		String quoteNumber = 'QN_TEST';
		String policyNumber = '3fa85f64-5717-4562-b3fc-2c963f66afa6';
		String body = '{'+
		'  \"eventType\": \"' + Constants.POLICY_CANCELED + '\",'+
		'  \"userId\": \"Cognito_' + lastName +'\",'+
		'  \"policyId\": \"' + policyNumber +'\"'+
		'}';
		//set the rest context
		RestRequest request = new RestRequest();
		RestResponse response = new RestResponse();

		request.requestBody = Blob.valueof(body);

		RestContext.request = request;
		RestContext.response = response;

		Account account = (Account) TestDataFactory.createPersonAccount(lastName).insertObj();
		Opportunity opportunity  = (Opportunity) TestDataFactory.createOpportunity(quoteNumber, account.Id).insertObj();
		InsurancePolicy policy = (InsurancePolicy) TestDataFactory.createPolicy(policyNumber, account.Id).insertObj();

		
		Test.startTest();
		QuotePolicyUpsertRestResource.processPost();
		Test.stopTest();
		System.assertEquals(200, response.statusCode, 'processPolicyCanceled() Unexpected response status code');
		Map<String, String> res = (Map<String, String>) JSON.deserialize(response.responseBody.toString(), Map<String, String>.class);
		System.assertEquals('Cancelled', [SELECT Id, Status FROM InsurancePolicy LIMIT 1].Status,  'processPolicyCanceled() Policy were not cancelled');
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
		QuotePolicyUpsertRestResource.processPost();
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
		QuotePolicyUpsertRestResource.processPost();
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
		QuotePolicyUpsertRestResource.processPost();
		Test.stopTest();
		System.assertEquals(400, response.statusCode, 'processQuoteUpsertEventTypeNoHandled() Unexpected response status code');
	}
} 