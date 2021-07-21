/**
 * QuoteUpsertDTO 
 * @author  Matteo Iacucci
 * @version 1.0
 * @since   2021-07-13
*/

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