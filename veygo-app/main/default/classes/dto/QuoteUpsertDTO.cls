/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-07-29
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
public with sharing class QuoteUpsertDTO {

    public String customerId;
	public String quoteId;
	public String eventType;
	public String carRegistrationNumber;
	public String licenseType;
	public String licenseNumber;
	public String postcode;
	public String dob;
	public String ownerDriver;
	

	
	public static QuoteUpsertDTO parse(String json) {
		return (QuoteUpsertDTO) System.JSON.deserialize(json, QuoteUpsertDTO.class);
	}

}