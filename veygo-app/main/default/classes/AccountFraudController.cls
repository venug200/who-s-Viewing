public with sharing class AccountFraudController {

    @AuraEnabled(cacheable=true)
    public static Boolean isHasCase(String recordId) {
        Id accountId;
        Id recordTypeId;

        try {
            accountId = Id.valueOf(recordId);
            recordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Fraud' LIMIT 1].Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        List<Case> caseList = [SELECT Id FROM Case WHERE AccountId = :accountId AND RecordTypeId = :recordTypeId];
        
        return !caseList.isEmpty();
    }
}