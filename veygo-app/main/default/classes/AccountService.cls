/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-07-26
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
public with sharing class AccountService {

	private rflib_Logger logger;

	Id employedRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();


	public AccountService(){
		logger = rflib_LoggerUtil.getFactory().createLogger('AccountService');
	}

	//check if the creation or the edit wasn't made from the integration user and then sync the record
	public void handleSync(List<Account> accounts, String event){
		AccountSyncQueueable accountSyncQueueable = new AccountSyncQueueable(accounts, event);
		System.enqueueJob(accountSyncQueueable);
	}
	
}
