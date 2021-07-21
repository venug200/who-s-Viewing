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

	public QuoteUpsertHelper(RestRequest request, RestResponse response) {
		this.logger = rflib_LoggerUtil.getFactory().createLogger('QuoteUpsertHelper');
		this.service = new QuoteUpsertService();
		this.request = request;
		this.response = response;
	}

	public void processQuoteUpsert(){
		logger.trace('processQuoteUpsert(): request {0}, response {1}', new List<Object> { request.requestBody.toString(), response });
		
		// set default response attrbutes
		response.addHeader('Content-Type', 'application/json');
		this.response.statusCode = 200;

		try {
			//deserialize the body to istance of class QuoteUpsertDTO
			QuoteUpsertDTO quoteUpsertDto = QuoteUpsertDTO.parse(request.requestBody.toString()) ;
			if(!String.isBlank(quoteUpsertDto.eventType)){
				//check if the request as the cognitoId
				Account customer = service.getCustomer(quoteUpsertDto.customerId);
				if(customer == null){
					//create lead
					handleQuoteForLead(quoteUpsertDto);
				}else{
					//create oppty
					//handleQuoteForCustomer(quoteUpsertDto, customer);
				}

			}else{
				//handling of the errors
				logger.error('processQuoteUpsert() : 400 returned, stage event not specified');
				Map<String, String> responseBody = new Map<String, String>();
				responseBody.put('error', 'processQuoteUpsert() : 400 returned, stage (eventType) not specified');
				this.response.statusCode = 400;
				this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
			}
			
					
		}catch(Exception e){
			//handling of the exception
			logger.error('processQuoteUpsert() : 500 returned, Exception: ' + e.getMessage(), e);

			Map<String, String> responseBody = new Map<String, String>();
			responseBody.put('error', e.getMessage());
			this.response.statusCode = 500;
			this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));

		}
	}

	private void handleQuoteForLead(QuoteUpsertDTO dto){
		
		System.Savepoint sp = Database.setSavePoint();
		Map<String, String> responseBody = new Map<String, String>();
		try{
			Lead l = service.createLead(dto);
			Database.UpsertResult upResult = Database.upsert(l, Lead.Quote_Number__c, false);
			if(upResult.isSuccess()){
				this.response.statusCode = 200;
				responseBody.put('customerId', dto.customerId);
				responseBody.put('leadId', l.Id);
			}else{
				this.response.statusCode = 400;
				responseBody.put('errror',JSON.serialize(upResult.getErrors()));
			}
			
		}catch(Exception e){
			this.logger.error('Exception handleSaleCompleteCustomer()', e);
			this.response.statusCode = 500;
			responseBody.put('error', e.getMessage());
			Database.rollback(sp);
		}
		//set the resposne body
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
	}

	

}