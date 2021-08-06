/**
 * QuotePolicyUpsertRestResource 
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-07-13
*/
@RestResource(urlMapping='/quotePolicyUpsert')
global with sharing class QuotePolicyUpsertRestResource {

	@HttpPost
	global static void processPost() {
		QuotePolicyUpsertHelper helper = new QuotePolicyUpsertHelper(RestContext.request, RestContext.response);
		helper.processQuotePolicyUpsert();
	}
}