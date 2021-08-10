/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-08-10
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
public with sharing class QuotePolicyUpsertHandler {

	private rflib_Logger logger;
	private RestRequest request;
	private RestResponse response;

	private QuotePolicyUpsertService service;

	public QuotePolicyUpsertHandler(RestRequest request, RestResponse response){
		this.logger = rflib_LoggerUtil.getFactory().createLogger('QuotePolicyUpsertHandler');
		this.service = new QuotePolicyUpsertService();
		this.request = request;
		this.response = response;
	}
	
	/**
	* @description 
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-06 
	* @param dto 
	* @return String return the error in case of fail
	**/
	public String handleQuoteStartForLead(QuoteStartDTO dto){
		
		Map<String, String> responseBody = new Map<String, String>();
		
		Lead l = service.createLead(dto);
		Database.UpsertResult upResult = Database.upsert(l, Lead.Quote_Number__c, false);
		if(upResult.isSuccess()){
			this.response.statusCode = 200;
			responseBody.put('eventType', Constants.QUOTE_STARTED);
			responseBody.put('quoteId', l.Quote_Number__c);
			responseBody.put('leadId', l.Id);
		}else{
			return JSON.serialize(upResult.getErrors());
		}
		
		//set the resposne body
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
		return null;
	}

	
	
	/**
	* @description 
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-06 
	* @param dto 
	* @param customer 
	* @return String return the error in case of fail
	**/
	public String handleQuoteStartForCustomer(QuoteStartDTO dto, Account customer){
		
		Map<String, String> responseBody = new Map<String, String>();
		Opportunity o = service.createOpportunity(dto, customer);
		Database.UpsertResult upResult = Database.upsert(o, Opportunity.Quote_Number__c, false);
		if(upResult.isSuccess()){
			this.response.statusCode = 200;
			responseBody.put('eventType', Constants.QUOTE_STARTED);
			responseBody.put('quoteId', o.Quote_Number__c);
			responseBody.put('opportunityId', o.Id);+
			this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
		}else{
			return JSON.serialize(upResult.getErrors());
		}
		return null;
		
	}

	
	/**
	* @description 
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-06 
	* @param dto 
	* @return String return the error in case of fail
	**/
	public String handleQuoteUpdateForLead(QuoteUpdateDTO dto){
		
		Map<String, String> responseBody = new Map<String, String>();
	
		Lead l = service.createLead(dto);
		Database.UpsertResult upResult = Database.upsert(l, Lead.Quote_Number__c, false);
		if(upResult.isSuccess()){
			this.response.statusCode = 200;
			responseBody.put('eventType', Constants.QUOTE_UPDATED);
			responseBody.put('quoteId', dto.quote.quoteId);
			responseBody.put('leadId', l.Id);
		}else{
			return JSON.serialize(upResult.getErrors());
		}
		
		//set the resposne body
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
		return null;
	}


	
	/**
	* @description 
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-06 
	* @param dto 
	* @param customer 
	* @return String return the error in case of fail
	**/
	public String handleQuoteUpdateForCustomer(QuoteUpdateDTO dto, Account customer){
		//if user id is sent and the customer is in salesforce check if was created the lead at the beginning
		Lead l = service.getLead(dto.quote.quoteId);
		Opportunity o = service.createOpportunity(dto, customer);
		Database.UpsertResult upResult = Database.upsert(o, Opportunity.Quote_Number__c, false);
		if(upResult.isSuccess()){
			if(l != null && ! service.convertLead(l, customer, o.Id)){
				return 'Error convertin lead to opportunity - quoteId: ' + dto.quote.quoteId;
			}else{
				this.response.statusCode = 200;
				Map<String, String> responseBody = new Map<String, String>();
				responseBody.put('eventType', Constants.QUOTE_UPDATED);
				responseBody.put('quoteId', o.Quote_Number__c);
				responseBody.put('opportunityId', o.Id);
				//set the resposne body
				this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
			}
		}else{
			return JSON.serialize(upResult.getErrors());
		}	
		return null;
	}

	
	/**
	* @description 
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-06 
	* @param dto 
	* @param customer 
	* @param o 
	* @return String return the error in case of fail
	**/
	public String  handleSaleCompleted(QuoteUpdateDTO dto, Account customer, Opportunity o){
		
		InsurancePolicy policy = service.createPolicy(dto, customer);
		Database.UpsertResult upResult = Database.upsert(policy, InsurancePolicy.Policy_Number_Id__c, false);
		if(!upResult.isSuccess()){
			return JSON.serialize(upResult.getErrors());
			
		}
		//update Opportunity with the policy Id
		o.Insurance_Policy__c = policy.Id;
		o.StageName = Constants.OPPORTUNITY_CLOSED;
		upResult = Database.upsert(o, Opportunity.Quote_Number__c, false);
		if(!upResult.isSuccess()){
			return JSON.serialize(upResult.getErrors());
		}

		this.response.statusCode = 200;
		Map<String, String> responseBody = new Map<String, String>();
		responseBody.put('eventType', Constants.QUOTE_SALECOMPLETED);
		responseBody.put('quoteId', dto.quote.quoteId);
		responseBody.put('policyNumber', dto.quote.policyNumber);
		responseBody.put('policyId', policy.Id);
		//set the resposne body
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
		return null;
	}


	/**
	* @description 
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-06 
	* @param dto 
	* @param customer 
	* @return String 
	**/
	public String handlePolicyUpdated(QuoteUpdateDTO dto, Account customer){
		
		InsurancePolicy policy = service.createPolicy(dto, customer);
		Database.UpsertResult upResult = Database.upsert(policy, InsurancePolicy.Policy_Number_Id__c, false);
		if(!upResult.isSuccess()){
			return JSON.serialize(upResult.getErrors());
		}

		this.response.statusCode = 200;
		Map<String, String> responseBody = new Map<String, String>();
		responseBody.put('eventType', Constants.POLICY_UPDATED);
		responseBody.put('quoteId', dto.quote.quoteId);
		responseBody.put('policyNumber', dto.quote.policyNumber);
		responseBody.put('policyId', policy.Id);
		//set the resposne body
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
		return null;
	}

	public String handlePolicyCanceled(PolicyCanceledDTO dto, Account customer){
		InsurancePolicy policy = service.cancelPolicy(dto, customer);
		Database.UpsertResult upResult = Database.upsert(policy, InsurancePolicy.Policy_Number_Id__c, false);
		if(!upResult.isSuccess()){
			return JSON.serialize(upResult.getErrors());
		}

		this.response.statusCode = 200;
		Map<String, String> responseBody = new Map<String, String>();
		responseBody.put('eventType', Constants.POLICY_CANCELED);
		responseBody.put('policyNumber', dto.policyId);
		responseBody.put('policyId', policy.Id);
		//set the resposne body
		this.response.responseBody = Blob.valueOf(JSON.serializePretty(responseBody));
		return null;
	}
	
}
