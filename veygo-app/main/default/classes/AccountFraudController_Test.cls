@IsTest
private class AccountFraudController_Test {
    
    // @IsTest
    static void AccountFraudControllerPos_Test() {
        Account testAccount = (Account) TestDataFactory.createPersonAccount('test').insertObj();

        Test.startTest();
        Boolean result = AccountFraudController.isHasCase(String.valueOf(testAccount.Id));
        Test.stopTest();

        System.assertEquals(false, result, 'We expect no cases there.');
    }

    @IsTest
    static void AccountFraudControllerNeg_Test() {
        Exception caughtException;
        Test.startTest();
        try {
            AccountFraudController.isHasCase('test');
        } catch (Exception e) {
            caughtException = e;
        }
        Test.stopTest();

        System.assert(caughtException != null, 'We expect Exception be thow.');
    }
}