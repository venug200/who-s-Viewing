/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-07-29
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
public class AccountCreatedEventDTO {

	public class Address {
		public String flatNo;
		public String houseNo;
		public String houseName;
		public String line1;
		public String line2;
		public String road;
		public String town;
		public String county;
		public String country;
		public String postcode;
	}

	public class Customer {
		public String title;
		public String firstName;
		public String middleName;
		public String lastName;
		public String email;
		public String phoneNumber;
		public String dateOfBirth;
		public String occupationType;
		public String occupation;
		public Address address;
		public String licenceType;
		public String licenceCountry;
		public String licenceNumber;
		public Integer numberOfClaims;
		public Boolean hasConvictions;
		public Integer yearsNCB;
	}

	public String eventType;
	public String userId;
	public Customer customer;

	
	public static AccountCreatedEventDTO parse(String json) {
		return (AccountCreatedEventDTO) System.JSON.deserialize(json, AccountCreatedEventDTO.class);
	}
}