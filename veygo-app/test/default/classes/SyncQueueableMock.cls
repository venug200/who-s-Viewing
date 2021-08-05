/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-08-05
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
public class SyncQueueableMock implements HttpCalloutMock {

	private Integer statusCode;

	public SyncQueueableMock(Integer statusCode){
		this.statusCode = statusCode;
	}

	public HTTPResponse respond(HTTPRequest req) {
		HTTPResponse response = new HTTPResponse();
		response.setStatusCode(this.statusCode);
		return response; 
	}
}