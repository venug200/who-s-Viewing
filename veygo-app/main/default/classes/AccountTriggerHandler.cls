/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-07-26
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/

public with sharing class AccountTriggerHandler extends sfpcz_AbstractTriggerHandler {
	AccountService accountService = new AccountService();
	rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('AccountTriggerHandler');

	protected override void afterInsert(){
		handleSync('AccountCreated', 'SyncAccountCreated', Trigger.new);
	}

	//method to handle the sync
	//check first if the sync feature is active
	private void handleSync(String event, String switchName, List<sObject> objs){
		//check if sync is active
		if(rflib_FeatureSwitch.isTurnedOn(switchName)){
			//handle the sycn
			accountService.handleSync((List<Account>)objs, event);
		}
	}
}