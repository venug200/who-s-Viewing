/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-08-24
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
public with sharing class QuotePolicyUpsertService {

	private rflib_Logger logger;
	private AccountSelector accountSelector;
	private LeadSelector leadSelector;
	private OpportunitySelector opportunitySelector;

	public QuotePolicyUpsertService() {
		this.logger = rflib_LoggerUtil.getFactory().createLogger('QuotePolicyUpsertService');
		this.accountSelector = new AccountSelector();
		this.leadSelector = new leadSelector();
		this.opportunitySelector = new OpportunitySelector();
	}

	public Account getCustomer(String cognitoId){
		return (String.isBlank(cognitoId)) ? null : accountSelector.getAccountByCognitoId(cognitoId);
	}

	public Lead getLead(String quoteId){
		return (String.isBlank(quoteId)) ? null : leadSelector.getLeadByQuoteNumber(quoteId);
	}

	public Opportunity getOpportunity(String quoteId){
		return (String.isBlank(quoteId)) ? null : opportunitySelector.getOpportunityByQuoteNumber(quoteId);
	}


	/**
	* @description create the lead from the quote start dto
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-02 
	* @param dto 
	* @return Lead 
	**/
	public Lead createLead(QuoteStartDTO dto){
		Lead l = new Lead();
		
		setLeadFields(l, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote)), QuotePolicyUpsertMapper.quoteStartLeadMapping);
		
		if(String.isBlank(l.LastName)){
			l.LastName = l.Quote_Number__c;
		}
		l.Status = Constants.LEAD_QUOTESTART;
		return l;
	}

	/**
	* @description create the lead from the quote update dto
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-02 
	* @param dto 
	* @return Lead 
	**/
	public Lead updateLead(QuoteUpdateDTO dto){
		Lead l = new Lead();
		
		setLeadFields(l, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote)), QuotePolicyUpsertMapper.quoteUpdateLeadMapping);
		setLeadFields(l, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.owner)), QuotePolicyUpsertMapper.quoteUpdateOwnerLeadMapping);
		setLeadFields(l, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.driver.address)), QuotePolicyUpsertMapper.quoteUpdateDriverAddressLeadMapping);
		setLeadFields(l, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.car)), QuotePolicyUpsertMapper.quoteUpdateCarLeadMapping);
		setLeadFields(l, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.financials)), QuotePolicyUpsertMapper.quoteUpdateFinancialsLeadMapping);
		setLeadFields(l, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.underwriting)), QuotePolicyUpsertMapper.quoteUpdateUnderwritingLeadMapping);
		setLeadFields(l, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.driver)), QuotePolicyUpsertMapper.quoteUpdateDriverLeadMapping);

		if(String.isBlank(l.LastName)){
			l.LastName = l.Quote_Number__c;
		}
		
		setLeadStatus(l);

		return l;
	}

	public Opportunity createOpportunity(QuoteStartDTO dto, Account customer){
		Opportunity o = new Opportunity();
		setOpportunityFields(o, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote)), QuotePolicyUpsertMapper.quoteStartOpportunityMapping);
	
		o.StageName = Constants.OPPORTUNITY_QUOTESTART;
		o.Name = o.Quote_Number__c;
		if(o.CloseDate == null){
			o.CloseDate = Date.today();
		}
		return o;

	}

	public Opportunity updateOpportunity(QuoteUpdateDTO dto, Account customer){
		Opportunity o = new Opportunity();
		setOpportunityFields(o, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote)), QuotePolicyUpsertMapper.quoteUpdateOpportunityMapping);
		setOpportunityFields(o, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.owner)), QuotePolicyUpsertMapper.quoteUpdateOwnerOpportunityMapping);
		setOpportunityFields(o, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.driver.address)), QuotePolicyUpsertMapper.quoteUpdateDriverAddressOpportunityMapping);
		setOpportunityFields(o, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.car)), QuotePolicyUpsertMapper.quoteUpdateCarOpportunityMapping);
		setOpportunityFields(o, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.financials)), QuotePolicyUpsertMapper.quoteUpdateFinancialsOpportunityMapping);
		setOpportunityFields(o, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.underwriting)), QuotePolicyUpsertMapper.quoteUpdateUnderwritingOpportunityMapping);
		setOpportunityFields(o, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.driver)), QuotePolicyUpsertMapper.quoteUpdateDriverOpportunityMapping);
		o.StageName = dto.eventType;
		o.Name = o.Quote_Number__c;
		if(o.CloseDate == null){
			o.CloseDate = Date.today();
		}
		setOpportunityStatus(o);
		return o;
	}

	public InsurancePolicy createPolicy(QuoteUpdateDTO dto, Account customer){
		InsurancePolicy p = new InsurancePolicy();
		setPolicyFields(p, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote)), QuotePolicyUpsertMapper.quoteUpdatePolicyMapping);
		setPolicyFields(p, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.owner)), QuotePolicyUpsertMapper.quoteUpdateOwnerPolicyMapping);
		setPolicyFields(p, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.driver.address)), QuotePolicyUpsertMapper.quoteUpdateDriverAddressPolicyMapping);
		setPolicyFields(p, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.car)), QuotePolicyUpsertMapper.quoteUpdateCarPolicyMapping);
		setPolicyFields(p, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.financials)), QuotePolicyUpsertMapper.quoteUpdateFinancialsPolicyMapping);
		setPolicyFields(p, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.underwriting)), QuotePolicyUpsertMapper.quoteUpdateUnderwritingPolicyMapping);
		setPolicyFields(p, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.driver)), QuotePolicyUpsertMapper.quoteUpdateDriverPolicyMapping);

		p.NameInsuredId = customer.Id;
		p.PolicyName = dto.quote.policyNumber;
		p.Policy_Number_Id__c = dto.quote.policyNumber;

		return p;
	}

	public InsurancePolicy cancelPolicy(PolicyCanceledDTO dto, Account customer){
		InsurancePolicy p = new InsurancePolicy();
		p.Policy_Number_Id__c = dto.policyId;
		p.NameInsuredId = customer.Id;
		p.Status = 'Cancelled';
		return p;
	}

	/**
	* @description convert the lead to account and opportunity
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-04 
	* @param profileId 
	* @param contactId 
	* @param accountId 
	* @param opportunityId 
	* @return boolean 
	**/
	public boolean convertLead(Lead l, Account customer, Id opportunityId){
		l.OwnerId = UserInfo.getUserId();
		Database.LeadConvert lc = new Database.LeadConvert();
		lc.setLeadId(l.Id);
		lc.setContactId(customer.PersonContactId);
		lc.setAccountId(customer.Id);
		lc.setOpportunityId(opportunityId);
		lc.setDoNotCreateOpportunity(false);
		lc.setConvertedStatus(Constants.CONVERTED_LEADSTATUS);

		Database.LeadConvertResult lcr = Database.convertLead(lc);
		if(lcr.isSuccess()){
			return true;
		}else{
			logger.error('error during the convertion of the lead: ' + JSON.serializePretty(lcr.getErrors()));
			return false;
		}
	}

	/**
	* @description set the lead status according to the info sent to the lead.
	* the default status is Quote start then if the ininital price is sent the status is indicative quote, if the price is sent the status is full quote
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-10 
	* @param l 
	**/
	private void setLeadStatus(Lead l){
		//defaul status;
		String status = Constants.LEAD_QUOTESTART; 
		if(l.Insurance_Initial_Price__c != null){
			status = Constants.LEAD_INDICATIVEQUOTE;
		}
		if(l.Insurance_Price__c != null){
			status = Constants.LEAD_FULLQUOTE;
		}
		l.Status = status;
	}

	/**
	* @description set the opportunity status according to the info sent to the opportuny.
	* the default stagename is Quote start then if the ininital price is sent the status is indicative quote, if the price is sent the stage name is full quote
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-10 
	* @param l 
	**/
	private void setOpportunityStatus(Opportunity o){
		//defaul status;
		String status = Constants.OPPORTUNITY_QUOTESTART; 
		if(o.Insurance_Initial_Price__c != null){
			status = Constants.OPPORTUNITY_INDICATIVEQUOTE;
		}
		if(o.Insurance_Price__c != null){
			status = Constants.OPPORTUNITY_FULLQUOTE;
		}
		o.StageName = status;
	}



	/**
	* @description 
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-02
	* @param l 
	* @param quoteInfoMap 
	* @param mapper 
	**/
	private void setLeadFields(Lead l, Map<String, Object> quoteInfoMap, Map<String, String> mapper ){
		String field;
		for(String dtoKey : quoteInfoMap.keySet()){
			field = mapper.get(dtoKey);
			if(field == null){ continue; }

			Object value = getLeadFieldValue(dtoKey, field, quoteInfoMap);
			l.put(field, value);			
		}
	}

	/**
	* @description 
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-03
	* @param l 
	* @param quoteInfoMap 
	* @param mapper 
	**/
	private void setOpportunityFields(Opportunity o, Map<String, Object> quoteInfoMap, Map<String, String> mapper ){
		String field;
		Schema.DisplayType type;
		for(String dtoKey : quoteInfoMap.keySet()){
			field = mapper.get(dtoKey);
			if(field == null){ continue; }
			
			Object value = getOpportunityFieldValue(dtoKey, field, quoteInfoMap);
			o.put(field, value);			
		}
	}

	/**
	* @description 
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-05 
	* @param p 
	* @param quoteInfoMap 
	* @param mapper 
	**/
	private void setPolicyFields(InsurancePolicy p, Map<String, Object> quoteInfoMap, Map<String, String> mapper ){
		String field;
		Schema.DisplayType type;
		for(String dtoKey : quoteInfoMap.keySet()){
			field = mapper.get(dtoKey);
			if(field == null){ continue; }

			Object value = getPolicyFieldValue(dtoKey, field, quoteInfoMap);
			p.put(field, value);			
		}
	}

	/**
	* @description return the value from the dto
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-02 
	* @param dtoKey 
	* @param leadField the lead field name
	* @param quoteInfo 
	* @return Object 
	**/
	private Object getLeadFieldValue(String dtoKey, String field, Map<String, Object> quoteInfo){
		if(getLeadFieldType(field) == Schema.DisplayType.DATE 
			&& quoteInfo.get(dtoKey) != null){
			
			return Date.valueOf((String)quoteInfo.get(dtoKey));
		}
		if(getLeadFieldType(field) == Schema.DisplayType.DATETIME
			&& quoteInfo.get(dtoKey) != null){
			
			return Datetime.valueOf(((String)quoteInfo.get(dtoKey)).replace('T',' '));
		}
		if(getLeadFieldType(field) == Schema.DisplayType.Boolean
			&& quoteInfo.get(dtoKey) != null){
			
			return Boolean.valueOf(((String)quoteInfo.get(dtoKey)));
		}
		if(dtoKey == 'failureReasons'){
			return String.valueOf(quoteInfo.get(dtoKey));
		}
		return quoteInfo.get(dtoKey);	
	}

	/**
	* @description return the value from the dto
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-03
	* @param dtoKey 
	* @param field the opportunity field name 
	* @param quoteInfo 
	* @return Object 
	**/
	private Object getOpportunityFieldValue(String dtoKey, String field, Map<String, Object> quoteInfo){
		if(quoteInfo.get(dtoKey) == '') {
			return null;
		}
		
		if(getOpportunityFieldType(field) == Schema.DisplayType.DATE 
			&& quoteInfo.get(dtoKey) != null){

			return Date.valueOf((String)quoteInfo.get(dtoKey));
		}
		if(getOpportunityFieldType(field) == Schema.DisplayType.DATETIME 
			&& quoteInfo.get(dtoKey) != null){
			
			return Datetime.valueOf(((String)quoteInfo.get(dtoKey)).replace('T',' '));
		}
		if(dtoKey == 'failureReasons'){
			return String.valueOf(quoteInfo.get(dtoKey));
		}
		return quoteInfo.get(dtoKey);	
	}

	/**
	* @description return the value from the dto
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-05 
	* @param dtoKey 
	* @param field the policy field name
	* @param quoteInfo 
	* @return Object 
	**/
	private Object getPolicyFieldValue(String dtoKey, String field, Map<String, Object> quoteInfo){
		if(getPolicyFieldType(field) == Schema.DisplayType.DATE){
			return Date.valueOf((String)quoteInfo.get(dtoKey));
		}
		if(getPolicyFieldType(field) == Schema.DisplayType.DATETIME){
			return Datetime.valueOf(((String)quoteInfo.get(dtoKey)).replace('T',' '));
		}
		if(dtoKey == 'failureReasons'){
			return String.valueOf(quoteInfo.get(dtoKey));
		}
		return quoteInfo.get(dtoKey);	
	}

	/**
	* @description return the field type of the given lead field
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-02 
	* @param fieldName 
	* @return Schema.DisplayType 
	**/
	private Schema.DisplayType getLeadFieldType(String fieldName){
		return Schema.SObjectType.Lead.fields.getMap().get(fieldName).getDescribe().getType();
	}

	/**
	* @description return the field type of the given opportunity field
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-03 
	* @param fieldName 
	* @return Schema.DisplayType 
	**/
	private Schema.DisplayType getOpportunityFieldType(String fieldName){
		return Schema.SObjectType.Opportunity.fields.getMap().get(fieldName).getDescribe().getType();
	}

	/**
	* @description return the field type of the given Policy field
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-05 
	* @param fieldName 
	* @return Schema.DisplayType 
	**/
	private Schema.DisplayType getPolicyFieldType(String fieldName){
		return Schema.SObjectType.InsurancePolicy.fields.getMap().get(fieldName).getDescribe().getType();
	}

}