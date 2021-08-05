/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-08-05
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
public class AccountCreatedEventDTO {


	public String eventType; //"SF_CUST_CREATED"
	public String userId;
	public String CustomerId;
	
	public static AccountCreatedEventDTO parse(String json) {
		return (AccountCreatedEventDTO) System.JSON.deserialize(json, AccountCreatedEventDTO.class);
	}
}