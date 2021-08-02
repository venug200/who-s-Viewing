/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-07-30
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
public class QuoteUpdateDTO {

	public String eventType; // DURATION_UPDATED, CAR_CONFIRMED, DRIVER_ADDED, DRIVER_HISTORY_ADDED, QUOTE_COMPLETED, UNDERWRITING_FAILED, SALE_COMPLETED 
	public String userId;
	public Quote quote;

	public class Quote {
		public String product; //LDP, OTC, DTC
		public String quoteId;
		public String startDate;
		public String endDate;
		public String policyNumber;
		public Boolean purchased;
		public Financials financials;
		public Underwriting underwriting;
		public String documentDeliveryPreference;
		public Driver driver;
		public Owner owner;
		public Car car;
	}

	public class Owner {
		public String firstName;
		public String lastName;
		public String email;
		public String phoneNumber;
		public String dateOfBirth;
		public String occupationType;
		public String occupation;
		public String postcode;
		public String relationship;
	}

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

	public class Car {
		public String make;
		public String model;
		public String transmission;
		public Integer year;
		public Integer value;
		public Integer engineSize;
		public String insuranceGroup;
		public String mainInsurer;
	}

	public class Underwriting {
		public Boolean passed;
		public List<String> failureReasons;
	}

	public class Financials {
		public Integer initialPrice;
		public Integer price;
		public Integer priceBeforeTax;
		public Integer tax;
		public Integer excess;
		public String discountCode;
	}

	public class Driver {
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
		public String licenceType; //UKM, UKA, UKP, NUK
		public String licenceCountry;
		public String licenceNumber;
		public Integer numberOfClaims;
		public Boolean hasConvictions;
		public Integer yearsNCB;
	}

		
	public static QuoteUpdateDTO parse(String json) {
		return (QuoteUpdateDTO) System.JSON.deserialize(json, QuoteUpdateDTO.class);
	}
}