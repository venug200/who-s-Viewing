/***************************************************************************************************
* Name          : sfpcz_TriggersControllerTest
* Description   : Test class for testing sfpcz_TriggersController functionality.
* Date          : 17/05/2020
* Author        : Vladislav Rakita
***************************************************************************************************/
@IsTest
private class sfpcz_TriggersControllerTest {

    // class without AbstractShell extension
    class WrongTriggerHandler {}

    class BasicTriggerHandler extends sfpcz_AbstractTriggerHandler {
        public Boolean status = false;
    }

    class BasicTriggerHandler_Two extends sfpcz_AbstractTriggerHandler {
        public Boolean status = false;
    }

    @IsTest
    static void test_WrongHandlerType_NoTriggerHandlerInstance() {
        sfpcz_TriggersController.InvalidTriggerHandlerException expectedExcptn;

        Test.startTest();
            try {
                sfpcz_TriggersController.init(WrongTriggerHandler.class);
                System.assert(false, 'Exception is expected.');
            }
            catch (sfpcz_TriggersController.InvalidTriggerHandlerException e) {
                expectedExcptn = e;
            }
        Test.stopTest();

        System.assertEquals('Trigger handler "sfpcz_TriggersControllerTest.WrongTriggerHandler" is not valid!',
                                                        expectedExcptn.getMessage(), 'Different error is expected.');
    }

    @IsTest
    static void test_WrongHandlerType_NullValue() {
        sfpcz_TriggersController.InvalidTriggerHandlerException expectedExcptn;

        Test.startTest();
            try {
                sfpcz_TriggersController.init(null);
                System.assert(false, 'Exception is expected.');
            }
            catch (sfpcz_TriggersController.InvalidTriggerHandlerException e) {
                expectedExcptn = e;
            }
        Test.stopTest();

        System.assertEquals('Trigger handler "null" is not valid!', expectedExcptn.getMessage(), 'Different error is expected.');
    }

    @IsTest
    static void test_WrongHandlerType_TriggerHandlerInterface() {
        sfpcz_TriggersController.InvalidTriggerHandlerException expectedExcptn;

        Test.startTest();
            try {
                sfpcz_TriggersController.init(sfpcz_TriggerHandler.class);
                System.assert(false, 'Exception is expected.');
            }
            catch (sfpcz_TriggersController.InvalidTriggerHandlerException e) {
                expectedExcptn = e;
            }
        Test.stopTest();

        System.assertEquals('sfpcz_TriggerHandler cannot be constructed', expectedExcptn.getMessage(), 'Different error is expected.');
    }

    @IsTest
    static void test_WrongHandlerType_Object() {
        sfpcz_TriggersController.InvalidTriggerHandlerException expectedExcptn;

        Test.startTest();
            try {
                sfpcz_TriggersController.init(Object.class);
                System.assert(false, 'Exception is expected.');
            }
            catch (sfpcz_TriggersController.InvalidTriggerHandlerException e) {
                expectedExcptn = e;
            }
        Test.stopTest();

        System.assertEquals('Trigger handler "Object" is not valid!', expectedExcptn.getMessage(), 'Different error is expected.');
    }

    @IsTest
    static void test_Success_NewInstance() {
        Test.startTest();
            sfpcz_TriggerHandler triggerHandler = sfpcz_TriggersController.init(BasicTriggerHandler.class);
        Test.stopTest();

        System.assertNotEquals(null, triggerHandler, 'Trigger handler instance wasn\'t created.');
        System.assertEquals(true, triggerHandler instanceof BasicTriggerHandler, 'Unexpected trigger handler type.');
        System.assertEquals(true, triggerHandler.isEnabled(), 'Trigger is supposed to be enabled.');
    }

    @IsTest
    static void test_Success_NewInstanceStatusChanged() {
        Test.startTest();
            sfpcz_TriggerHandler triggerHandler = sfpcz_TriggersController.init(BasicTriggerHandler.class);
        Test.stopTest();

        System.assertNotEquals(null, triggerHandler, 'Trigger handler instance wasn\'t created.');
        System.assertEquals(true, triggerHandler instanceof BasicTriggerHandler, 'Unexpected trigger handler type.');

        ((BasicTriggerHandler)triggerHandler).status = true;

        System.assertEquals(true, ((BasicTriggerHandler)sfpcz_TriggersController.init(BasicTriggerHandler.class)).status,
                                                                                'Status is supposed to be saved.');
    }

    @IsTest
    static void test_Success_TwoClassesStatusChanged() {
        sfpcz_TriggerHandler triggerHandler = sfpcz_TriggersController.init(BasicTriggerHandler.class);

        System.assertNotEquals(null, triggerHandler, 'Trigger handler instance wasn\'t created.');
        System.assertEquals(true, triggerHandler instanceof BasicTriggerHandler, 'Unexpected trigger handler type.');

        ((BasicTriggerHandler)triggerHandler).status = true;

        Test.startTest();
            sfpcz_TriggerHandler triggerHandler_Two = sfpcz_TriggersController.init(BasicTriggerHandler_Two.class);
        Test.stopTest();

        System.assertNotEquals(null, triggerHandler_Two, 'Trigger handler instance wasn\'t created.');
        System.assertEquals(true, triggerHandler_Two instanceof BasicTriggerHandler_Two,
                                                                    'Unexpected trigger handler type.');

        ((BasicTriggerHandler_Two)triggerHandler_Two).status = true;

        System.assertEquals(true, ((BasicTriggerHandler)sfpcz_TriggersController.init(BasicTriggerHandler.class)).status,
                                                                                        'Status wasn\'t changed.');
        System.assertEquals(true, ((BasicTriggerHandler_Two)sfpcz_TriggersController.init(BasicTriggerHandler_Two.class)).status,
                                                                                        'Status wasn\'t changed.');
    }

    @IsTest
    static void test_Success_DisableTrigger() {
        sfpcz_TriggerHandler triggerHandler = sfpcz_TriggersController.init(BasicTriggerHandler.class);

        Test.startTest();
            sfpcz_TriggersController.disableAllHandlers();
        Test.stopTest();

        System.assertEquals(false, triggerHandler.isEnabled(), 'Trigger is supposed to be disabled.');
    }

    @IsTest
    static void test_Success_DisableTriggerOperation() {
        sfpcz_TriggerHandler triggerHandler = sfpcz_TriggersController.init(BasicTriggerHandler_Two.class);

        System.assertEquals(true, triggerHandler.operationReady(TriggerOperation.BEFORE_INSERT),
                                                                'Operation is supposed to be enabled.');

        Test.startTest();
            sfpcz_TriggersController.disableAllHandlersOperation(TriggerOperation.BEFORE_INSERT);
        Test.stopTest();

        System.assertEquals(true, triggerHandler.isEnabled(), 'Trigger is supposed to be enabled.');

        System.assertEquals(false, triggerHandler.operationReady(TriggerOperation.BEFORE_INSERT),
                                                                'Operation is supposed to be disabled.');
    }

    @IsTest
    static void test_Success_DisableTriggerBeforeInitialisation() {
        sfpcz_TriggersController.disableAllHandlers();

        Test.startTest();
            sfpcz_TriggerHandler triggerHandler = sfpcz_TriggersController.init(BasicTriggerHandler.class);
        Test.stopTest();

        System.assertEquals(false, triggerHandler.isEnabled(), 'Trigger is supposed to be disabled.');
    }

    @IsTest
    static void test_Success_EnableTrigger() {
        sfpcz_TriggerHandler triggerHandler = sfpcz_TriggersController.init(BasicTriggerHandler.class);

        sfpcz_TriggersController.disableAllHandlers();

        System.assertEquals(false, triggerHandler.isEnabled(), 'Trigger is supposed to be disabled.');

        Test.startTest();
            sfpcz_TriggersController.enableAllHandlers();
        Test.stopTest();

        System.assertEquals(true, triggerHandler.isEnabled(), 'Trigger is supposed to be enabled.');
    }

    @IsTest
    static void test_Success_EnableTriggerOperation() {
        sfpcz_TriggerHandler triggerHandler = sfpcz_TriggersController.init(BasicTriggerHandler_Two.class);

        sfpcz_TriggersController.disableAllHandlersOperation(TriggerOperation.BEFORE_INSERT);

        System.assertEquals(true, triggerHandler.isEnabled(), 'Trigger is supposed to be enabled.');
        System.assertEquals(false, triggerHandler.operationReady(TriggerOperation.BEFORE_INSERT),
                                                            'Operation is supposed to be disabled.');

        Test.startTest();
            sfpcz_TriggersController.enableAllHandlersOperation(TriggerOperation.BEFORE_INSERT);
        Test.stopTest();

        System.assertEquals(true, triggerHandler.isEnabled(), 'Trigger is supposed to be enabled.');
        System.assertEquals(true, triggerHandler.operationReady(TriggerOperation.BEFORE_INSERT),
                                                            'Operation is supposed to be enabled.');
    }

    @IsTest
    static void test_Success_ResetHandlers() {
        sfpcz_TriggerHandler triggerHandler = sfpcz_TriggersController.init(BasicTriggerHandler_Two.class).blockRecursion();
        triggerHandler = (sfpcz_AbstractTriggerHandler)triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);

        System.assertEquals(false, triggerHandler.operationReady(TriggerOperation.BEFORE_INSERT),
                                                            'Operation is supposed to be disabled.');

        Test.startTest();
            sfpcz_TriggersController.resetAllHandlers();
        Test.stopTest();

        System.assertEquals(true, triggerHandler.isEnabled(), 'Trigger is supposed to be enabled.');
        System.assertEquals(true, triggerHandler.operationReady(TriggerOperation.BEFORE_INSERT),
                                                            'Operation is supposed to be enabled.');
    }

    @IsTest
    static void test_Success_ResetHandlersOperation() {
        sfpcz_TriggerHandler triggerHandler = sfpcz_TriggersController.init(BasicTriggerHandler_Two.class).blockRecursion();
        triggerHandler = (sfpcz_AbstractTriggerHandler)triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        triggerHandler = (sfpcz_AbstractTriggerHandler)triggerHandler.startOperation(TriggerOperation.AFTER_INSERT);

        System.assertEquals(false, triggerHandler.operationReady(TriggerOperation.BEFORE_INSERT),
                                                            'Operation is supposed to be disabled.');

        System.assertEquals(false, triggerHandler.operationReady(TriggerOperation.AFTER_INSERT),
                                                            'Operation is supposed to be disabled.');

        Test.startTest();
            sfpcz_TriggersController.resetAllHandlersOperation(TriggerOperation.BEFORE_INSERT);
        Test.stopTest();

        System.assertEquals(true, triggerHandler.isEnabled(), 'Trigger is supposed to be enabled.');
        System.assertEquals(true, triggerHandler.operationReady(TriggerOperation.BEFORE_INSERT),
                                                            'Operation is supposed to be enabled.');
        System.assertEquals(false, triggerHandler.operationReady(TriggerOperation.AFTER_INSERT),
                                                            'Operation is supposed to be enabled.');
    }
}