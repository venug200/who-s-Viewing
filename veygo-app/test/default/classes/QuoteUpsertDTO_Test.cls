@IsTest
public class QuoteUpsertDTO_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"customerId\": \"customerId\",'+
		'  \"quoteId\": \"quoteId\",'+
		'  \"eventType\": \"quoteStage\",'+
		'  \"carRegistrationNumber\": \"carRegistrationNumber\",'+
		'  \"licenseType\": \"licenseType\",'+
		'  \"licenseNumber\": \"licenseNumber\",'+
		'  \"postcode\": \"postcode\",'+
		'  \"dob\": \"dob\",'+
		'  \"ownerDriver\": \"ownerDriver\"'+
		'}';
		QuoteUpsertDTO obj = QuoteUpsertDTO.parse(json);
		System.assert(obj != null, 'object not parsed');
	}
}