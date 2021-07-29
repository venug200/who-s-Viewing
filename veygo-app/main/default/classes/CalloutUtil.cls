/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-07-26
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
public with sharing class CalloutUtil {
    
    public static HttpResponse performCallout(HttpRequest request, String jsonBody) {
        rflib_Logger logger = rflib_LoggerUtil.getFactory().createLogger('SyncQueuebleCalloutUtil');
		try{
			// Instantiate a new http object
			Http h = new Http();
			// Send the request, and return a response
			HttpResponse response = h.send(request);
			return response;
		}catch(Exception e){
			logger.error('performCallout() -> Exception: ' + e.getMessage(), e);
            throw e;
		}
	}
}
