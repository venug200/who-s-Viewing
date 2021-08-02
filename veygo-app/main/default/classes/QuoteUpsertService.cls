/**
 * QuoteUpsertService 
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-07-14
*/
public with sharing class QuoteUpsertService {

	private rflib_Logger logger;
	private AccountSelector accountSelector;

	public QuoteUpsertService() {
		this.logger = rflib_LoggerUtil.getFactory().createLogger('QuoteToBuyService');
		this.accountSelector = new AccountSelector();
	}

	public Account getCustomer(String cognitoId){
		return (String.isBlank(cognitoId)) ? null : accountSelector.getAccountByCognitoId(cognitoId);
	}

	/**
	* @description create the lead from the quote start dto
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-02 
	* @param dto 
	* @return Lead 
	**/
	public Lead createLead(QuoteStartDTO dto){
		Lead l = new Lead();
		
		setLeadFields(l, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote)), QuoteUpsertMapper.quoteUpdateLeadMapping);
		
		if(String.isBlank(l.LastName)){
			l.LastName = l.Quote_Number__c;
		}
		l.Status = dto.eventType;
		return l;
	}

	/**
	* @description create the lead from the quote update dto
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-02 
	* @param dto 
	* @return Lead 
	**/
	public Lead createLead(QuoteUpdateDTO dto){
		Lead l = new Lead();
		
		setLeadFields(l, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote)), QuoteUpsertMapper.quoteUpdateLeadMapping);
		setLeadFields(l, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.owner)), QuoteUpsertMapper.quoteUpdateOwnerLeadMapping);
		setLeadFields(l, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.driver.address)), QuoteUpsertMapper.quoteUpdateDriverAddressLeadMapping);
		setLeadFields(l, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.car)), QuoteUpsertMapper.quoteUpdateCarLeadMapping);
		setLeadFields(l, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.financials)), QuoteUpsertMapper.quoteUpdateFinancialsLeadMapping);
		setLeadFields(l, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.underwriting)), QuoteUpsertMapper.quoteUpdateUnderwritingLeadMapping);
		setLeadFields(l, (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto.quote.driver)), QuoteUpsertMapper.quoteUpdateDriverLeadMapping);

		if(String.isBlank(l.LastName)){
			l.LastName = l.Quote_Number__c;
		}
		
		l.Status = dto.eventType;

		return l;

	}

	private void setLeadFields(Lead l, Map<String, Object> quoteInfoMap, Map<String, String> mapper ){
		
		String leadField;
		String leadTypeField;
		Schema.DisplayType type;
		for(String dtoKey : quoteInfoMap.keySet()){
			leadField = mapper.get(dtoKey);
			if(leadField == null){ continue; }

			Object value = getValue(dtoKey, leadField, quoteInfoMap);
			l.put(leadField, value);			
		}

	}


	/**
	* @description return the value from the dto
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-02 
	* @param dtoKey 
	* @param leadField 
	* @param quoteInfo 
	* @return Object 
	**/
	private Object getValue(String dtoKey, String leadField, Map<String, Object> quoteInfo){
		if(getLeadFieldType(leadField) == Schema.DisplayType.DATE){
			return Date.valueOf((String)quoteInfo.get(dtoKey));
		}
		if(getLeadFieldType(leadField) == Schema.DisplayType.DATETIME){
			return Datetime.valueOf(((String)quoteInfo.get(dtoKey)).replace('T',' '));
		}
		if(dtoKey == 'failureReasons'){
			return String.valueOf(quoteInfo.get(dtoKey));
		}
		return quoteInfo.get(dtoKey);	
	}

	/**
	* @description return the field type of the given field
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-02 
	* @param fieldName 
	* @return Schema.DisplayType 
	**/
	private Schema.DisplayType getLeadFieldType(String fieldName){
		System.debug('....' + fieldName);
		return Schema.SObjectType.Lead.fields.getMap().get(fieldName).getDescribe().getType();
	}

}