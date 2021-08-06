/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-08-06
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
public class PolicyCanceledDTO {

	public String eventType;
	public String userId;
	public String policyId;

	
	public static PolicyCanceledDTO parse(String json) {
		return (PolicyCanceledDTO) System.JSON.deserialize(json, PolicyCanceledDTO.class);
	}
}