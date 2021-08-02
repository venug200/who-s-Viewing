/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-07-29
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
public class QuoteStartDTO {

    public String eventType; //QUOTE_STARTED
	public Quote quote;

    public class Quote {
		public String product; //LDP, OTC, DTC 
		public String userId;
		public String quoteId;
		public String licenceType; //UKM, UKA, UKP, NUK
		public String postcode;
		public String dateOfBirth;
	}

	public static QuoteStartDTO parse(String json) {
		return (QuoteStartDTO) System.JSON.deserialize(json, QuoteStartDTO.class);
	}

}
