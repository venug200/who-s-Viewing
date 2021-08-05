/**
 * QuoteUpsertHelper 
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-07-13
*/
public with sharing class QuoteUpsertHelper {

	private rflib_Logger logger;
	private QuoteUpsertService service;
	private RestRequest request;
	private RestResponse response;
	private System.Savepoint sp;

	public QuoteUpsertHelper(RestRequest request, RestResponse response) {
		this.logger = rflib_LoggerUtil.getFactory().createLogger('QuoteUpsertHelper');
		this.service = new QuoteUpsertService();
		this.request = request;
		this.response = response;
		if(!Test.isRunningTest()){
			this.sp = Database.setSavePoint();
		}
		
	}

	public void processQuoteUpsert(){
		logger.trace('processQuoteUpsert(): request {0}, response {1}', new List<Object> { request.requestBody.toString(), response });
		
		// set default response attrbutes
		response.addHeader('Content-Type', 'application/json');
		this.response.statusCode = 200;

		try {
			Map<String, Object> requestBody = (Map<String,Object>) JSON.deserializeUntyped(request.requestBody.toString());
			String eventType = (String) requestBody.get('eventType');
			if(!String.isBlank(eventType)){
				
				if(eventType == Constants.QUOTE_STARTED){
					handleQuoteStart();
				}else if(eventType == Constants.QUOTE_UPDATED){
					handleQuoteUpdate();
				}else if(eventType == Constants.QUOTE_SALECOMPLETED){
					handleSaleCompleted();
				}else{
					error400('eventype not handled');
				}
			}else{
				error400('eventType not specified');
			}
					
		}catch(Exception e){
			//handling of the exception
			logger.error('processQuoteUpsert() : 500 returned, Exception: ' + e.getMessage(), e);

			Map<String, String> responseBody = new Map<String, String>();
			responseBody.put('error', e.getMessage());
			this.response.statusCode = 500;
			this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
			if(!Test.isRunningTest()){
				Database.rollback(sp);
			}

		}
	}

	public void handleQuoteStart(){
		QuoteStartDTO dto = QuoteStartDTO.parse(request.requestBody.toString());
		Account customer = service.getCustomer(dto.quote.userId);
		//check if the request as the cognitoId
		if(customer == null){
			//create lead
			handleQuoteStartForLead(dto);
		}else{
			//create oppty
			handleQuoteStartForCustomer(dto, customer);
		}
	}

	private void handleQuoteStartForLead(QuoteStartDTO dto){
		
		Map<String, String> responseBody = new Map<String, String>();
		
		Lead l = service.createLead(dto);
		Database.UpsertResult upResult = Database.upsert(l, Lead.Quote_Number__c, false);
		if(upResult.isSuccess()){
			this.response.statusCode = 200;
			responseBody.put('quoteId', l.Quote_Number__c);
			responseBody.put('leadId', l.Id);
		}else{
			error400(JSON.serialize(upResult.getErrors()));
		}
		
		//set the resposne body
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
	}

	private void handleQuoteUpdateForLead(QuoteUpdateDTO dto){
		
		Map<String, String> responseBody = new Map<String, String>();
	
		Lead l = service.createLead(dto);
		Database.UpsertResult upResult = Database.upsert(l, Lead.Quote_Number__c, false);
		if(upResult.isSuccess()){
			this.response.statusCode = 200;
			responseBody.put('quoteId', dto.quote.quoteId);
			responseBody.put('leadId', l.Id);
		}else{
			error400(JSON.serialize(upResult.getErrors()));
		}
		
		//set the resposne body
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
	}

	private void handleQuoteStartForCustomer(QuoteStartDTO dto, Account customer){
		
		Map<String, String> responseBody = new Map<String, String>();
		Opportunity o = service.createOpportunity(dto, customer);
		Database.UpsertResult upResult = Database.upsert(o, Opportunity.Quote_Number__c, false);
		if(upResult.isSuccess()){
			this.response.statusCode = 200;
			responseBody.put('quoteId', o.Quote_Number__c);
			responseBody.put('opportunityId', o.Id);+
			this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
		}else{
			error400(JSON.serialize(upResult.getErrors()));
		}
		
	}


	public void handleQuoteUpdate(){
		QuoteUpdateDTO dto = QuoteUpdateDTO.parse(request.requestBody.toString());
		Account customer = service.getCustomer(dto.userId);
		//check if the request as the cognitoId
		if(customer == null){
			//update lead lead
			handleQuoteUpdateForLead(dto);
		}else{
			handleQuoteUpdateForCustomer(dto, customer);
		}
	}


	private void handleQuoteUpdateForCustomer(QuoteUpdateDTO dto, Account customer){
		//if user id is sent and the customer is in salesforce check if was created the lead at the beginning
		Lead l = service.getLead(dto.quote.quoteId);
		Opportunity o = service.createOpportunity(dto, customer);
		Database.UpsertResult upResult = Database.upsert(o, Opportunity.Quote_Number__c, false);
		if(upResult.isSuccess()){
			if(l != null && ! service.convertLead(l, customer, o.Id)){
				error400('Error convertin lead to opportunity - quoteId: ' + dto.quote.quoteId);
			}else{
				this.response.statusCode = 200;
				Map<String, String> responseBody = new Map<String, String>();
				responseBody.put('quoteId', o.Quote_Number__c);
				responseBody.put('opportunityId', o.Id);
				//set the resposne body
				this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
			}
		}else{
			error400(JSON.serialize(upResult.getErrors()));
		}	
	}

	private void handleSaleCompleted(){
		QuoteUpdateDTO dto = QuoteUpdateDTO.parse(request.requestBody.toString());
		Account customer = service.getCustomer(dto.userId);
		if(customer == null){
			error400('No customer fould for CognitoId = ' + dto.userId);
			return;
		}
		Opportunity o = service.getOpportunity(dto.quote.quoteId);
		InsurancePolicy policy = service.createPolicy(dto, customer);
		Database.UpsertResult upResult = Database.upsert(policy, InsurancePolicy.Policy_Number_Id__c, false);
		if(!upResult.isSuccess()){
			error400(JSON.serialize(upResult.getErrors()));
			return;
		}
		//update Opportunity with the policy Id
		o.Insurance_Policy__c = policy.Id;
		upResult = Database.upsert(o, Opportunity.Quote_Number__c, false);
		if(!upResult.isSuccess()){
			error400(JSON.serialize(upResult.getErrors()));
			return;
		}

		this.response.statusCode = 200;
		Map<String, String> responseBody = new Map<String, String>();
		responseBody.put('quoteId', dto.quote.quoteId);
		responseBody.put('policyNumber', dto.quote.policyNumber);
		responseBody.put('policyId', policy.Id);
		//set the resposne body
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));


	}


	/**
	* @description set the response with the provided error message and rollbak the db
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-04 
	* @param errormessage 
	**/
	private void error400(String errormessage){
		//handling of the errors
		logger.error('processQuoteUpsert() : 400 returned, ' + errormessage);
		Map<String, String> responseBody = new Map<String, String>();
		responseBody.put('error', 'processQuoteUpsert() : 400 returned, ' + errormessage);
		this.response.statusCode = 400;
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
		if(!Test.isRunningTest()){
			Database.rollback(sp);
		}
	}
	

}