/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-08-05
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
public with sharing class LeadSelector {
	rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('LeadSelector');

	
	/**
	* @description return the lead by quote id ( quote number)
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-03 
	* @param quoteId 
	* @return lead 
	**/
	public Lead getLeadByQuoteNumber(String quoteId){
		Lead lead = null;
		if( Schema.Account.SObjectType.getDescribe().isAccessible() ){
			for(Lead l : [SELECT Id, Quote_Number__c
						FROM Lead
						WHERE Quote_Number__c = :quoteId 
					]){
				lead = l;
			}
		}else{
			logger.error('getLeadByQuoteNumber(): User (userid: {0}) has no access right to Lead', new List<Object> {String.valueOf(UserInfo.getUserId())});
		}		
		return lead;
	}

	
}