/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-08-06
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
@IsTest
public class TestDataFactory {

	private SObject obj;

	public TestDataFactory(SObject obj){
		this.obj = obj;
	}

	public SObject insertObj(){
		insert this.obj;
		return this.obj;
	}

	public SObject getObj(){
		return this.obj;
	}

	/**
	* @description create a person account with the indicated lastName, Email = <lastName>@test.com, cognitoId = Cognito_<lastName>
	* @author matteo.iacucci@emea.merkleinc.com | 2021-08-03 
	* @param lastName 
	* @return TestDataFactory 
	**/
	public static TestDataFactory createPersonAccount(String lastName){
		Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
		Account a = new Account(
			RecordTypeId = personAccountRecordTypeId,
			LastName = lastName,
			PersonEmail = lastName + '@test.com',
			CognitoId__c = 'Cognito_' + lastName
		);

		return new TestDataFactory((SObject) a);
	}

	public static TestDataFactory createLead(String lastName){
		Lead l = new Lead(
			LastName = lastName,
			Email = lastName + '@test.com',
			Quote_Number__c = 'QN-' + lastName
		);

		return new TestDataFactory((SObject) l);
	}

	public static TestDataFactory createOpportunity(String quoteNumber, Id accountId ){
		Opportunity oppty = new Opportunity(
			AccountId = accountId,
			Name = quoteNumber,
			CloseDate = Date.today(),
			Quote_Number__c = quoteNumber,
			StageName = Constants.QUOTE_STARTED
		);
		return new TestDataFactory((SObject) oppty);
	}

	public static TestDataFactory createPolicy(String policyNumber, Id accountId){
		InsurancePolicy p = new InsurancePolicy(
			NameInsuredId = accountId,
			Name = policyNumber,
			PolicyName = policyNumber,
			Policy_Number_Id__c = policyNumber

		);
		return new TestDataFactory((SObject) p);
	}
	
}