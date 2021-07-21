/**
 * ContactSelector
 * is data access class. All SOQL to Contact DB are stored here. 
 *
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-07-14
*/
public with sharing class ContactSelector {
	rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('ContactSelector');

	/**
	 * retrieve the Contact by ext id customerId
	 * @param profileId 
	 * @return contact
	 */
	public Contact getContactByCustomerId(String customerId) {
		Contact contact = null;
		try{
			if( Schema.Contact.SObjectType.getDescribe().isAccessible() ){
			
				contact = [SELECT Id
						FROM Contact
						WHERE Customer_Id__c = :customerId 
					];
			}else{
				logger.error('getContactByCustomerId(): User (userid: {0}) has no access right to Contact', new List<Object> {String.valueOf(UserInfo.getUserId())});
			}
		}catch(QueryException qe){
			logger.warn('getContactByCustomerId() : no Contact with profileId = ' + customerId);
		}catch(Exception e){
			logger.error('getContactByCustomerId() : Exception: ', e);
		}
		
		return contact;
	}
}