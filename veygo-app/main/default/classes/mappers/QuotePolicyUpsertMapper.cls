/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-08-06
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
 * Modifications Log 
 * Ver   Date         Author                              Modification
 * 1.0   2021-07-19   matteo.iacucci@emea.merkleinc.com   Initial Version
**/
public with sharing class QuotePolicyUpsertMapper {
	public static Map<String, String> leadMap = new Map<String, String>{
		'quoteId' => 'Quote_Number__c',
		'eventType' => 'Status',
		'carRegistrationNumber' => 'Registration_Number__c',
		'licenseType' => 'License_Type__c',
		'licenseNumber' => 'License_Number__c',
		'postcode' => 'Postcode__c',
		'dob' => 'DOB__c',
		'ownerDriver' => 'Owner_Driver__c'
	};

	public static Map<String, String> quoteStartLeadMapping = new Map<String, String>{
		'product' => 'Product_Name__c',
 		'quoteId' => 'Quote_Number__c',
 		'licenceType' => 'License_Type__c',
 		'postcode' => 'Postcode__c',
 		'dateOfBirth' => 'OwnerDateOfBirth__c'
 	};

	public static Map<String, String> quoteStartOpportunityMapping = new Map<String, String>{
		'product' => 'Product_Name__c',
 		'quoteId' => 'Quote_Number__c',
 		'licenceType' => 'LicenceType__c',
 		'postcode' => 'OwnerPostcode__c',
 		'dateOfBirth' => 'OwnerDateOfBirth__c'
 	};

	public static Map<String, String> quoteUpdateLeadMapping = new Map<String, String>{
		'product' => 'Product_Name__c', //LDP, OTC, DTC
		'quoteId' => 'Quote_Number__c',
		'startDate' => 'Quote_Date__c',
		'endDate' => 'QuoteEnd__c',
		'policyNumber' => 'Policy_Number__c',
		'documentDeliveryPreference' => 'DocumentDeliveryPreference__c',
		'purchased' => 'Purchased__c'
		
	};

	public static Map<String, String> quoteUpdateOwnerLeadMapping = new Map<String, String>{
		'firstName' => 'OwnerFirstName__c',
		'lastName' => 'OwnerLastName__c',
		'email' => 'OwnerEmail__c',
		'phoneNumber' => 'OwnerPhone__c',
		'dateOfBirth' => 'OwnerDateOfBirth__c',
		'occupationType' => 'OwnerOccupationType__c',
		'occupation' => 'OwnerOccupation__c',
		'postcode' => 'Owner_PostCode__c',
		'relationship' => 'Owner_Relationship__c'
	};

	public static Map<String, String> quoteUpdateDriverAddressLeadMapping = new Map<String, String>{
		'flatNo' => 'DriverAddressFlatNum__c',
		'houseNo' => 'DriverAddressHouseNum__c',
		'houseName' => 'DriverAddressHouseName__c',
		'line1' => 'DriverAddressLine1__c',
		'line2' => 'DriverAddressLine2__c',
		'road' => 'DriverAddressRoad__c',
		'town' => 'DriverAddressTown__c',
		'county' => 'DriverAddressCounty__c',
		'country' => 'DriverAddressCountry__c',
		'postcode' => 'DriverAddressPostcode__c'
	};


	public static Map<String, String> quoteUpdateCarLeadMapping = new Map<String, String>{
		
		'make' => 'CarMake__c',
		'model' => 'CarModel__c',
		'transmission' => 'CarTransmission__c',
		'year' => 'Year__c',
		'value' => 'CarValue__c',
		'engineSize' => 'Car_Engine_Size__c',
		'insuranceGroup' => 'Car_Insurance_Group__c',
		'mainInsurer' => 'CarMainInsurer__c'
	};

	public static Map<String, String> quoteUpdateFinancialsLeadMapping = new Map<String, String>{
		
		'initialPrice' => 'Insurance_Initial_Price__c',
		'price' => 'Insurance_Price__c',
		'priceBeforeTax' => 'Insurance_Price_Before_Tax__c',
		'tax' => 'Insurance_Permium_Tax__c',
		'excess' => 'Excess__c',
		'discountCode' => 'DiscountCode__c'
	};

	public static Map<String, String> quoteUpdateUnderwritingLeadMapping = new Map<String, String>{
		'passed' => 'Underwriting_Passed__c',
		'failureReasons' => 'UnderwritingFailureReasons__c'
	};

	public static Map<String, String> quoteUpdateDriverLeadMapping = new Map<String, String>{
		'title' => 'DriverTitle__c',
		'firstName' => 'DriverFirstName__c',
		'middleName' => 'DriverMiddleName__c',
		'lastName' => 'DriverLastName__c',
		'email' => 'DriverEmail__c',
		'phoneNumber' => 'DriverPhoneNumber__c',
		'dateOfBirth' => 'DriverDateOfBirth__c',
		'occupationType' => 'DriverOccupationType__c',
		'occupation' => 'DriverOccupation__c',
		'licenceType' => 'LicenceType__c', //UKM, UKA, UKP, NUK
		'licenceCountry' => 'LicenceCountry__c',
		'licenceNumber' => 'License_Number__c',
		'numberOfClaims' => 'NumberOfClaims__c',
		'hasConvictions' => 'HasConvictions__c',
		'yearsNCB' => 'Years_NCB__c'
	};

//Oppo

	public static Map<String, String> quoteUpdateOpportunityMapping = new Map<String, String>{
		'product' => 'Product_Name__c', //LDP, OTC, DTC
		'quoteId' => 'Quote_Number__c',
		'startDate' => 'Actual_Quote_Creation_Date__c',
		'endDate' => 'QuoteEnd__c',
		'policyNumber' => 'Policy_Number__c',
		'documentDeliveryPreference' => 'DocumentDeliveryPreference__c',
		'purchased' => 'Purchased__c'
		
	};

	public static Map<String, String> quoteUpdateOwnerOpportunityMapping = new Map<String, String>{
		'firstName' => 'OwnerFirstName__c',
		'lastName' => 'OwnerLastName__c',
		'email' => 'OwnerEmail__c',
		'phoneNumber' => 'OwnerPhone__c',
		'dateOfBirth' => 'OwnerDateOfBirth__c',
		'occupationType' => 'OwnerOccupationType__c',
		'occupation' => 'OwnerOccupation__c',
		'postcode' => 'OwnerPostcode__c',
		'relationship' => 'Owner_Relationship__c'
	};

	public static Map<String, String> quoteUpdateDriverAddressOpportunityMapping = new Map<String, String>{
		'flatNo' => 'DriverAddressFlatNum__c',
		'houseNo' => 'DriverAddressHouseNum__c',
		'houseName' => 'DriverAddressHouseName__c',
		'line1' => 'DriverAddressLine1__c',
		'line2' => 'DriverAddressLine2__c',
		'road' => 'DriverAddressRoad__c',
		'town' => 'DriverAddressTown__c',
		'county' => 'DriverAddressCounty__c',
		'country' => 'DriverAddressCountry__c',
		'postcode' => 'DriverAddressPostcode__c'
	};


	public static Map<String, String> quoteUpdateCarOpportunityMapping = new Map<String, String>{
		
		'make' => 'CarMake__c',
		'model' => 'CarModel__c',
		'transmission' => 'CarTransmission__c',
		'year' => 'Year__c',
		'value' => 'CarValue__c',
		'engineSize' => 'Car_Engine_Size__c',
		'insuranceGroup' => 'Car_Insurance_Group__c',
		'mainInsurer' => 'CarMainInsurer__c'
	};

	public static Map<String, String> quoteUpdateFinancialsOpportunityMapping = new Map<String, String>{
		
		'initialPrice' => 'Insurance_Initial_Price__c',
		'price' => 'Insurance_Price__c',
		'priceBeforeTax' => 'Insurance_Price_Before_Tax__c',
		'tax' => 'Insurance_Permium_Tax__c',
		'excess' => 'Excess__c',
		'discountCode' => 'DiscountCode__c'
	};

	public static Map<String, String> quoteUpdateUnderwritingOpportunityMapping = new Map<String, String>{
		'passed' => 'Underwriting_Passed__c',
		'failureReasons' => 'UnderwritingFailureReasons__c'
	};

	public static Map<String, String> quoteUpdateDriverOpportunityMapping = new Map<String, String>{
		'title' => 'DriverTitle__c',
		'firstName' => 'DriverFirstName__c',
		'middleName' => 'DriverMiddleName__c',
		'lastName' => 'DriverLastName__c',
		'email' => 'DriverEmail__c',
		'phoneNumber' => 'DriverPhoneNumber__c',
		'dateOfBirth' => 'DriverDateOfBirth__c',
		'occupationType' => 'DriverOccupationType__c',
		'occupation' => 'DriverOccupation__c',
		'licenceType' => 'LicenceType__c', //UKM, UKA, UKP, NUK
		'licenceCountry' => 'LicenceCountry__c',
		'licenceNumber' => 'License_Number__c',
		'numberOfClaims' => 'NumberOfClaims__c',
		'hasConvictions' => 'HasConvictions__c',
		'yearsNCB' => 'Years_NCB__c'
	};

	//policy
	
	public static Map<String, String> quoteUpdatePolicyMapping = new Map<String, String>{
		'product' => 'Product_Name__c', //LDP, OTC, DTC
		'quoteId' => 'Quote_Number__c',
		'startDate' => 'Start_Date__c',
		'endDate' => 'End_Date__c',
		'policyNumber' => 'Name',
		'documentDeliveryPreference' => 'DocumentDeliveryPreference__c',
		'purchased' => 'Purchased__c'
		
	};

	public static Map<String, String> quoteUpdateOwnerPolicyMapping = new Map<String, String>{
		'firstName' => 'OwnerFirstName__c',
		'lastName' => 'OwnerLastName__c',
		'email' => 'OwnerEmail__c',
		'phoneNumber' => 'OwnerPhone__c',
		'dateOfBirth' => 'OwnerDateOfBirth__c',
		'occupationType' => 'OwnerOccupationType__c',
		'occupation' => 'OwnerOccupation__c',
		'postcode' => 'OwnerPostcode__c',
		'relationship' => 'Owner_Relationship__c'
	};

	public static Map<String, String> quoteUpdateDriverAddressPolicyMapping = new Map<String, String>{
		'flatNo' => 'DriverAddressFlatNum__c',
		'houseNo' => 'DriverAddressHouseNum__c',
		'houseName' => 'DriverAddressHouseName__c',
		'line1' => 'DriverAddressLine1__c',
		'line2' => 'DriverAddressLine2__c',
		'road' => 'DriverAddressRoad__c',
		'town' => 'DriverAddressTown__c',
		'county' => 'DriverAddressCounty__c',
		'country' => 'DriverAddressCountry__c',
		'postcode' => 'DriverAddressPostcode__c'
	};


	public static Map<String, String> quoteUpdateCarPolicyMapping = new Map<String, String>{
		
		'make' => 'CarMake__c',
		'model' => 'CarModel__c',
		'transmission' => 'CarTransmission__c',
		'year' => 'Year__c',
		'value' => 'CarValue__c',
		'engineSize' => 'Car_Engine_Size__c',
		'insuranceGroup' => 'Car_Insurance_Group__c',
		'mainInsurer' => 'CarMainInsurer__c'
	};

	public static Map<String, String> quoteUpdateFinancialsPolicyMapping = new Map<String, String>{
		
		'initialPrice' => 'Insurance_Initial_Price__c',
		'price' => 'Insurance_Price__c',
		'priceBeforeTax' => 'Insurance_Price_Before_Tax__c',
		'tax' => 'Premium_Tax__c',
		'excess' => 'Excess__c',
		'discountCode' => 'DiscountCode__c'
	};

	public static Map<String, String> quoteUpdateUnderwritingPolicyMapping = new Map<String, String>{
		'passed' => 'Underwriting_Passed__c',
		'failureReasons' => 'UnderwritingFailureReasons__c'
	};

	public static Map<String, String> quoteUpdateDriverPolicyMapping = new Map<String, String>{
		'title' => 'DriverTitle__c',
		'firstName' => 'DriverFirstName__c',
		'middleName' => 'DriverMiddleName__c',
		'lastName' => 'DriverLastName__c',
		'email' => 'DriverEmail__c',
		'phoneNumber' => 'DriverPhoneNumber__c',
		'dateOfBirth' => 'DriverDateOfBirth__c',
		'occupationType' => 'DriverOccupationType__c',
		'occupation' => 'DriverOccupation__c',
		'licenceType' => 'LicenceType__c', //UKM, UKA, UKP, NUK
		'licenceCountry' => 'LicenceCountry__c',
		'licenceNumber' => 'License_Number__c',
		'numberOfClaims' => 'NumberOfClaims__c',
		'hasConvictions' => 'HasConvictions__c',
		'yearsNCB' => 'Years_NCB__c'
	};
	



	  
}