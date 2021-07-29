/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-07-26
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
public with sharing class AccountSyncQueueable implements Queueable , Database.AllowsCallouts {
	//list of account to sync
	private List<Account> accounts;
	//logger instance
	private rflib_Logger logger;
	//event (creation or edit)
	private String event;

	//costructor
	public AccountSyncQueueable(List<Account> accounts, String event) {
		this.logger = rflib_LoggerUtil.getFactory().createLogger('AccountSyncQueueable');
		this.accounts = accounts;
		this.event = event;
	}


	public void execute(QueueableContext context) {
		logger.debug('execute(): sync for event ' + this.event);
		//create the body
		Map<String, object> body = createBody();
		//serialize the body
		String jsonAccounts = JSON.serialize(body);
		//make the callout
		postCallout(jsonAccounts);

		
	}

	private Map<String, object> createBody(){
		Map<String, object> body = new Map<String, object>();
		//create the body as a map with the event and the record to sync
		body.put('event_name', (object) event);
		List<Map<String, String>> records  = new List<Map<String, String>>();
		
		Map<String, String> record;
		for(Account a : this.accounts){
			record = new Map<String,String>();
			record.put('cognitoId', a.CognitoId__c);
			record.put('customerId', a.CustomerId__c);
			records.add(record);
		}
		body.put('records', (object) records);
		return body;
	}

	//perform the sync and log the result
	private void postCallout(String jsonBody) {
		HttpRequest request = createHttpRequest(jsonBody);
		try{
			HttpResponse response = CalloutUtil.performCallout(request, jsonBody);
			if(response?.getStatusCode() != 200){
				logger.error('postCallout() -> Event: ' + this.event + ',returned status code: ' + response?.getStatusCode() + ', body: ' + response?.getBody());
			}else{
				logger.debug('postCallout() -> Event: ' + this.event + ',returned status code: ' + response?.getStatusCode() + ', body: ' + response?.getBody());
			}
		}catch(Exception e){
			logger.error('postCallout() -> Exception: ' + e.getMessage(), e);
		}
	}

	private HttpRequest createHttpRequest(String jsonBody){
		HttpRequest request = new HttpRequest();
		/*Map<String, String> body = new Map<String, String>{
			'username' => '{!$Credential.UserName}',
			'password' => '{!$Credential.Password}'
		};*/
		String endpoint = 'callout:TestNamedCred/35084a39-1098-4f28-a77b-ecf45d16fef8';
		request.setEndpoint(endpoint);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setBody(jsonBody);	
		return request;
		
	}
}
