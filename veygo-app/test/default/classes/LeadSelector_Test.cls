/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-08-04
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
**/
@IsTest
public class LeadSelector_Test {
	@IsTest
	public static void testGetOpportunitiesByQuoteNumbers(){
		String lastName = 'test';
		Lead l  = (Lead) TestDataFactory.createLead(lastName).insertObj();
		Test.startTest();
		Lead rl = new LeadSelector().getLeadByQuoteNumber('QN-' + lastName);
		Test.stopTest();
		System.assertEquals(l.Id, rl.Id, 'The 2 lead are different.');	
	}
}