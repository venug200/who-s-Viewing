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

	public Account getCustomer(String customerId){
		return (String.isBlank(customerId)) ? null : accountSelector.getAccountByCustomerId(customerId);
	}

	public Lead createLead(QuoteUpsertDTO dto){
		Lead l = new Lead();
		
		Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dto));
		String leadField;
		String leadTypeField;
		for(String k : m.keySet()){
			leadField = QuoteUpsertMapper.leadMap.get(k);
			if(leadField == null) continue;
			
			l.put(leadField, m.get(k));
		}
		if(String.isBlank(l.LastName)){
			l.LastName = dto.quoteId;
		}

		return l;

	}

}

	