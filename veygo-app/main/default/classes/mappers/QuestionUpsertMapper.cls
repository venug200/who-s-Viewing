/**
 * @description       : 
 * @author            : matteo.iacucci@emea.merkleinc.com
 * @group             : 
 * @last modified on  : 2021-07-19
 * @last modified by  : matteo.iacucci@emea.merkleinc.com
 * Modifications Log 
 * Ver   Date         Author                              Modification
 * 1.0   2021-07-19   matteo.iacucci@emea.merkleinc.com   Initial Version
**/
public with sharing class QuestionUpsertMapper {
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

	  
}