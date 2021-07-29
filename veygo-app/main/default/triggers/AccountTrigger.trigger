/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-07-26
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
trigger AccountTrigger on Account (after insert ) {

	if(rflib_FeatureSwitch.isTurnedOn('AccountTrigger')){
		sfpcz_TriggersController.init(AccountTriggerHandler.class).start();
	}
}