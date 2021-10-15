/**
 * QuotePolicyUpsertHelper 
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-07-13
*/
public with sharing class QuotePolicyUpsertHelper {

	private rflib_Logger logger;
	private QuotePolicyUpsertService service;
	private QuotePolicyUpsertHandler handler;
	private RestRequest request;
	private RestResponse response;
	private System.Savepoint sp;

	public QuotePolicyUpsertHelper(RestRequest request, RestResponse response) {
		
		this.logger = rflib_LoggerUtil.getFactory().createLogger('QuotePolicyUpsertHelper');
		this.service = new QuotePolicyUpsertService();
		this.handler = new QuotePolicyUpsertHandler(request, response);
		this.request = request;
		this.response = response;

		if(!Test.isRunningTest()){
			this.sp = Database.setSavePoint();
		}		
	}

	public void processQuotePolicyUpsert(){
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
				}else if(eventType == Constants.POLICY_UPDATED){
					handlePolicyUpdated();
				}else if(eventType == Constants.POLICY_CANCELED){
					handlePolicyCanceled();
				}else{
					error400('eventype not handled');
				}
			}else{
				error400('eventType not specified');
			}
					
		}catch(Exception e){
			//handling of the exception
			logger.error('processQuotePolicyUpsert() : 500 returned, Exception: ' + e.getMessage(), e);

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
		String errormessage;
		//check if the request as the cognitoId
		if(customer == null){
			//create lead
			errormessage = handler.handleQuoteStartForLead(dto);
		}else{
			//create oppty
			errormessage = handler.handleQuoteStartForCustomer(dto, customer);
		}
		if(!String.isBlank(errormessage)){
			error400(errormessage);
		}
	}

	public void handleQuoteUpdate(){
		QuoteUpdateDTO dto = QuoteUpdateDTO.parse(request.requestBody.toString());
		Account customer = service.getCustomer(dto.userId);
		String errormessage;
		//check if the request as the cognitoId
		if(customer == null){
			//update lead lead
			errormessage = handler.handleQuoteUpdateForLead(dto);
		}else{
			errormessage = handler.handleQuoteUpdateForCustomer(dto, customer);
		}
		if(!String.isBlank(errormessage)){
			error400(errormessage);
		}
	}

	public void handleSaleCompleted(){
		QuoteUpdateDTO dto = QuoteUpdateDTO.parse(request.requestBody.toString());
		Account customer = service.getCustomer(dto.userId);
		String errormessage;
		if(customer == null){
			error400('No customer fould for CognitoId = ' + dto.userId);
			return;
		}
		Opportunity o = service.getOpportunity(dto.quote.quoteId);
		if(o == null){
			error400('No customer fould for CognitoId = ' + dto.userId);
			return;
		}
		errormessage = handler.handleSaleCompleted(dto, customer, o);
		if(!String.isBlank(errormessage)){
			error400(errormessage);
		}
	}

	public void handlePolicyUpdated(){
		QuoteUpdateDTO dto = QuoteUpdateDTO.parse(request.requestBody.toString());
		Account customer = service.getCustomer(dto.userId);
		String errormessage;
		if(customer == null){
			error400('No customer fould for CognitoId = ' + dto.userId);
			return;
		}
		errormessage = handler.handlePolicyUpdated(dto, customer);
		if(!String.isBlank(errormessage)){
			error400(errormessage);
		}
	}

	public void handlePolicyCanceled(){
		PolicyCanceledDTO dto = PolicyCanceledDTO.parse(request.requestBody.toString());
		Account customer = service.getCustomer(dto.userId);
		String errormessage;
		if(customer == null){
			error400('No customer fould for CognitoId = ' + dto.userId);
			return;
		}
		errormessage = handler.handlePolicyCanceled(dto, customer);
		if(!String.isBlank(errormessage)){
			error400(errormessage);
		}

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