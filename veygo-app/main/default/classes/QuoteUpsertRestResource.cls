/**
 * QuoteUpsertRestResource 
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-07-13
*/
@RestResource(urlMapping='/quoteUpsert')
global with sharing class QuoteUpsertRestResource {

	@HttpPost
	global static void processPost() {
		QuoteUpsertHelper helper = new QuoteUpsertHelper(RestContext.request, RestContext.response);
		helper.processQuoteUpsert();
	}
}