/**
 * AccountSelector
 * is data access class. All SOQL to Account DB are stored here. 
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-07-14
*/
public with sharing class AccountSelector {
	rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('AccountSelector');

	/**
	 * retrieve the Account by ext id customerId
	 * @param customerId 
	 * @return Account
	 */
	public Account getAccountByCustomerId(String customerId) {
		Account account = null;
		try{
			if( Schema.Account.SObjectType.getDescribe().isAccessible() ){
			
				account = [SELECT Id
						FROM Account
						WHERE CustomerId__c = :customerId 
					];
			}else{
				logger.error('getAccountByCustomerId(): User (userid: {0}) has no access right to Account', new List<Object> {String.valueOf(UserInfo.getUserId())});
			}
		}catch(QueryException qe){
			logger.warn('getAccountByCustomerId() : no Account with customerId = ' + customerId);
		}catch(Exception e){
			logger.error('getAccountByCustomerId() : Exception: ', e);
		}
		
		return account;
	}

	/**
	* @description 
	* @author matteo.iacucci@emea.merkleinc.com | 2021-07-30 
	* @param cognitoId 
	* @return Account 
	**/
	public Account getAccountByCognitoId(String cognitoId) {
		Account account = null;
		try{
			if( Schema.Account.SObjectType.getDescribe().isAccessible() ){
			
				account = [SELECT Id
						FROM Account
						WHERE CognitoId__c = :cognitoId 
					];
			}else{
				logger.error('getAccountByCustomerId(): User (userid: {0}) has no access right to Account', new List<Object> {String.valueOf(UserInfo.getUserId())});
			}
		}catch(QueryException qe){
			logger.warn('getAccountByCustomerId() : no Account with cognitoId = ' + cognitoId);
		}catch(Exception e){
			logger.error('getAccountByCustomerId() : Exception: ', e);
		}
		
		return account;
	}
}