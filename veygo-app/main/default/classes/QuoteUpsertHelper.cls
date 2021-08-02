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
		this.sp = Database.setSavePoint();
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
					QuoteStartDTO dto = QuoteStartDTO.parse(request.requestBody.toString());
					Account customer = service.getCustomer(dto.quote.userId);
					//check if the request as the cognitoId
					if(customer == null){
						//create lead
						handleQuoteStartForLead(dto);
					}else{
						//create oppty
						//handleQuoteForCustomer(quoteUpsertDto, customer);
					}
				}else{
					QuoteUpdateDTO dto = QuoteUpdateDTO.parse(request.requestBody.toString());
					Account customer = service.getCustomer(dto.userId);
					if(customer == null){
						
						//update lead

						handleQuoteUpdateForLead(dto);
					}else{
						//create oppty
						//handleQuoteForCustomer(quoteUpsertDto, customer);
					}
					//QuoteUpdateDTO dto = QuoteUpdateDTO.parse(request.requestBody.toString());
				}
			}else{
				//handling of the errors
				logger.error('processQuoteUpsert() : 400 returned, stage event not specified');
				Map<String, String> responseBody = new Map<String, String>();
				responseBody.put('error', 'processQuoteUpsert() : 400 returned, stage (eventType) not specified');
				this.response.statusCode = 400;
				this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
				Database.rollback(sp);
			}
			
					
		}catch(Exception e){
			//handling of the exception
			logger.error('processQuoteUpsert() : 500 returned, Exception: ' + e.getMessage(), e);

			Map<String, String> responseBody = new Map<String, String>();
			responseBody.put('error', e.getMessage());
			this.response.statusCode = 500;
			this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
			Database.rollback(sp);

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
			this.response.statusCode = 400;
			responseBody.put('errror',JSON.serialize(upResult.getErrors()));
			Database.rollback(sp);
		}
		
		//set the resposne body
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
	}

	private void handleQuoteUpdateForLead(QuoteUpdateDTO dto){
		
		System.Savepoint sp = Database.setSavePoint();
		Map<String, String> responseBody = new Map<String, String>();
	
		Lead l = service.createLead(dto);
		Database.UpsertResult upResult = Database.upsert(l, Lead.Quote_Number__c, false);
		if(upResult.isSuccess()){
			this.response.statusCode = 200;
			responseBody.put('quoteId', dto.quote.quoteId);
			responseBody.put('leadId', l.Id);
		}else{
			this.response.statusCode = 400;
			responseBody.put('errror',JSON.serialize(upResult.getErrors()));
			Database.rollback(sp);
		}
		
		//set the resposne body
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
	}

	

}