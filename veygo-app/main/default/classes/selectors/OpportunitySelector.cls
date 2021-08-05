/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-08-05
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
public with sharing class OpportunitySelector {
	rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('OpportunitySelector');

	
	/**
	* @description return the opportunity by quote id ( quote number)
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-03 
	* @param quoteId 
	* @return Opportunity 
	**/
	public Opportunity getOpportunityByQuoteNumber(String quoteId){
		Opportunity opportunity = null;
		if( Schema.Account.SObjectType.getDescribe().isAccessible() ){
			for(Opportunity o : [SELECT Id, Quote_Number__c
						FROM Opportunity
						WHERE Quote_Number__c = :quoteId 
					]){
				opportunity = o;
			}
		}else{
			logger.error('getOpportunityByQuoteNumber(): User (userid: {0}) has no access right to Opportunity', new List<Object> {String.valueOf(UserInfo.getUserId())});
		}		
		return opportunity;
	}

	
}