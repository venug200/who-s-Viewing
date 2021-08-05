/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-08-04
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
@IsTest
public class OpportunitySelector_Test {
	@IsTest
	public static void testGetOpportunitiesByQuoteNumbers(){
		String quoteNumber = 'quoteN1';
		Account account = (Account) TestDataFactory.createPersonAccount('test').insertObj();
		Opportunity opportunity  = (Opportunity) TestDataFactory.createOpportunity(quoteNumber, account.Id).insertObj();
		Test.startTest();
		Opportunity o = new OpportunitySelector().getOpportunityByQuoteNumber(quoteNumber);
		Test.stopTest();
		System.assertEquals(opportunity.Id, o.Id, 'The 2 opportunity are different.');	
	}
}