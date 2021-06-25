/***************************************************************************************************
* Name          : sfpcz_AbstractTriggerHandlerTest
* Description   : Test class for AbstractTrigger handler which tests it's functionality.
* Date          : 17/05/2020
* Author        : Vladislav Rakita
***************************************************************************************************/
@IsTest
private class sfpcz_AbstractTriggerHandlerTest {

    private class TestHandler extends sfpcz_AbstractTriggerHandler {
        public TestHandler() {
            super();
        }

        public Boolean beforeInsertRan {
            get {
                if (beforeInsertRan == null) {
                    return false;
                }

                return beforeInsertRan;
            } set;
        }

        public Boolean beforeUpdateRan {
            get {
                if (beforeUpdateRan == null) {
                    return false;
                }

                return beforeUpdateRan;
            } set;
        }

        public Boolean beforeDeleteRan {
            get {
                if (beforeDeleteRan == null) {
                    return false;
                }

                return beforeDeleteRan;
            } set;
        }

        public Boolean afterInsertRan {
            get {
                if (afterInsertRan == null) {
                    return false;
                }

                return afterInsertRan;
            } set;
        }

        public Boolean afterUpdateRan {
            get {
                if (afterUpdateRan == null) {
                    return false;
                }

                return afterUpdateRan;
            } set;
        }

        public Boolean afterDeleteRan {
            get {
                if (afterDeleteRan == null) {
                    return false;
                }

                return afterDeleteRan;
            } set;
        }

        public Boolean afterUndeleteRan {
            get {
                if (afterUndeleteRan == null) {
                    return false;
                }

                return afterUndeleteRan;
            } set;
        }

        protected override void beforeInsert() {
            super.beforeInsert();
            this.beforeInsertRan = true;
        }

        protected override void beforeUpdate() {
            super.beforeUpdate();
            this.beforeUpdateRan = true;
        }

        protected override void beforeDelete() {
            super.beforeDelete();
            this.beforeDeleteRan = true;
        }

        protected override void afterInsert() {
            super.afterInsert();
            this.afterInsertRan = true;
        }

        protected override void afterUpdate() {
            super.afterUpdate();
            this.afterUpdateRan = true;
        }

        protected override void afterDelete() {
            super.afterDelete();
            this.afterDeleteRan = true;
        }

        protected override void afterUndelete() {
            super.afterUndelete();
            this.afterUndeleteRan = true;
        }
    }

    @IsTest
    static void test_DisableHandler() {
        TestHandler triggerHandler = new TestHandler();

        Test.startTest();
        triggerHandler.disable();
        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        Test.stopTest();

        System.assertEquals(false, triggerHandler.isEnabled());
        System.assertEquals(false, triggerHandler.beforeInsertRan);
    }

    @IsTest
    static void test_DisabledOperation() {
        TestHandler triggerHandler = new TestHandler();

        Test.startTest();
        triggerHandler.disableOperation(TriggerOperation.AFTER_INSERT);

        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        triggerHandler.startOperation(TriggerOperation.AFTER_INSERT);
        Test.stopTest();

        System.assertEquals(true, triggerHandler.beforeInsertRan, 'Before insert operation didn\'t happen.');
        System.assertEquals(false, triggerHandler.afterInsertRan, 'After insert is not supposed to happen.');
    }

    @IsTest
    static void test_EnableHandler() {
        TestHandler triggerHandler = new TestHandler();
        triggerHandler.disable();

        System.assertEquals(false, triggerHandler.isEnabled());

        Test.startTest();
        triggerHandler.enable();
        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        Test.stopTest();

        System.assertEquals(true, triggerHandler.isEnabled());
        System.assertEquals(true, triggerHandler.beforeInsertRan);
    }

    @IsTest
    static void test_EnableOperation() {
        TestHandler triggerHandler = new TestHandler();

        Test.startTest();
        triggerHandler.disableOperation(TriggerOperation.AFTER_INSERT);

        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        triggerHandler.startOperation(TriggerOperation.AFTER_INSERT);

        System.assertEquals(true, triggerHandler.beforeInsertRan, 'Before insert operation didn\'t happen.');
        System.assertEquals(false, triggerHandler.afterInsertRan, 'After insert is not supposed to happen.');

        triggerHandler.enableOperation(TriggerOperation.AFTER_INSERT);
        triggerHandler.startOperation(TriggerOperation.AFTER_INSERT);
        Test.stopTest();

        System.assertEquals(true, triggerHandler.afterInsertRan, 'After insert is supposed to happen.');
    }

    @IsTest
    static void test_StartWithNoTrigger() {
        TestHandler triggerHandler = new TestHandler();
        sfpcz_AbstractTriggerHandler.InvalidTriggerOperationException expectedExcptn;

        Test.startTest();
        try {
            triggerHandler.start();
            System.assert(false, 'Exception is supposed to be thrown.');
        } catch (sfpcz_AbstractTriggerHandler.InvalidTriggerOperationException e) {
            expectedExcptn = e;
        }

        System.assertEquals('Trigger operation "null" was not found.', expectedExcptn.getMessage(),
                'Different error is expected.');
    }

    @IsTest
    static void test_RunBeforeInsert() {
        TestHandler triggerHandler = new TestHandler();

        Test.startTest();
        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        Test.stopTest();

        System.assertEquals(true, triggerHandler.beforeInsertRan);
        System.assertEquals(false, triggerHandler.beforeUpdateRan);
        System.assertEquals(false, triggerHandler.beforeDeleteRan);
        System.assertEquals(false, triggerHandler.afterInsertRan);
        System.assertEquals(false, triggerHandler.afterUpdateRan);
        System.assertEquals(false, triggerHandler.afterDeleteRan);
        System.assertEquals(false, triggerHandler.afterUndeleteRan);
    }

    @IsTest
    static void test_RunBeforeUpdate() {
        TestHandler triggerHandler = new TestHandler();

        Test.startTest();
        triggerHandler.startOperation(TriggerOperation.BEFORE_UPDATE);
        Test.stopTest();

        System.assertEquals(false, triggerHandler.beforeInsertRan);
        System.assertEquals(true, triggerHandler.beforeUpdateRan);
        System.assertEquals(false, triggerHandler.beforeDeleteRan);
        System.assertEquals(false, triggerHandler.afterInsertRan);
        System.assertEquals(false, triggerHandler.afterUpdateRan);
        System.assertEquals(false, triggerHandler.afterDeleteRan);
        System.assertEquals(false, triggerHandler.afterUndeleteRan);
    }

    @IsTest
    static void test_RunBeforeDelete() {
        TestHandler triggerHandler = new TestHandler();

        Test.startTest();
        triggerHandler.startOperation(TriggerOperation.BEFORE_DELETE);
        Test.stopTest();

        System.assertEquals(false, triggerHandler.beforeInsertRan);
        System.assertEquals(false, triggerHandler.beforeUpdateRan);
        System.assertEquals(true, triggerHandler.beforeDeleteRan);
        System.assertEquals(false, triggerHandler.afterInsertRan);
        System.assertEquals(false, triggerHandler.afterUpdateRan);
        System.assertEquals(false, triggerHandler.afterDeleteRan);
        System.assertEquals(false, triggerHandler.afterUndeleteRan);
    }

    @IsTest
    static void test_RunAfterInsert() {
        TestHandler triggerHandler = new TestHandler();

        Test.startTest();
        triggerHandler.startOperation(TriggerOperation.AFTER_INSERT);
        Test.stopTest();

        System.assertEquals(false, triggerHandler.beforeInsertRan);
        System.assertEquals(false, triggerHandler.beforeUpdateRan);
        System.assertEquals(false, triggerHandler.beforeDeleteRan);
        System.assertEquals(true, triggerHandler.afterInsertRan);
        System.assertEquals(false, triggerHandler.afterUpdateRan);
        System.assertEquals(false, triggerHandler.afterDeleteRan);
        System.assertEquals(false, triggerHandler.afterUndeleteRan);
    }

    @IsTest
    static void test_RunAfterUpdate() {
        TestHandler triggerHandler = new TestHandler();

        Test.startTest();
        triggerHandler.startOperation(TriggerOperation.AFTER_UPDATE);
        Test.stopTest();

        System.assertEquals(false, triggerHandler.beforeInsertRan);
        System.assertEquals(false, triggerHandler.beforeUpdateRan);
        System.assertEquals(false, triggerHandler.beforeDeleteRan);
        System.assertEquals(false, triggerHandler.afterInsertRan);
        System.assertEquals(true, triggerHandler.afterUpdateRan);
        System.assertEquals(false, triggerHandler.afterDeleteRan);
        System.assertEquals(false, triggerHandler.afterUndeleteRan);
    }

    @IsTest
    static void test_RunAfterDelete() {
        TestHandler triggerHandler = new TestHandler();

        Test.startTest();
        triggerHandler.startOperation(TriggerOperation.AFTER_DELETE);
        Test.stopTest();

        System.assertEquals(false, triggerHandler.beforeInsertRan);
        System.assertEquals(false, triggerHandler.beforeUpdateRan);
        System.assertEquals(false, triggerHandler.beforeDeleteRan);
        System.assertEquals(false, triggerHandler.afterInsertRan);
        System.assertEquals(false, triggerHandler.afterUpdateRan);
        System.assertEquals(true, triggerHandler.afterDeleteRan);
        System.assertEquals(false, triggerHandler.afterUndeleteRan);
    }

    @IsTest
    static void test_RunAfterUndelete() {
        TestHandler triggerHandler = new TestHandler();

        Test.startTest();
        triggerHandler.startOperation(TriggerOperation.AFTER_UNDELETE);
        Test.stopTest();

        System.assertEquals(false, triggerHandler.beforeInsertRan);
        System.assertEquals(false, triggerHandler.beforeUpdateRan);
        System.assertEquals(false, triggerHandler.beforeDeleteRan);
        System.assertEquals(false, triggerHandler.afterInsertRan);
        System.assertEquals(false, triggerHandler.afterUpdateRan);
        System.assertEquals(false, triggerHandler.afterDeleteRan);
        System.assertEquals(true, triggerHandler.afterUndeleteRan);
    }

    @IsTest
    static void test_BlockRecursion() {
        TestHandler triggerHandler = new TestHandler();

        Test.startTest();
        triggerHandler.blockRecursion();

        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        triggerHandler.startOperation(TriggerOperation.AFTER_INSERT);

        System.assertEquals(true, triggerHandler.beforeInsertRan, 'Before insert operation didn\'t happen.');
        System.assertEquals(true, triggerHandler.afterInsertRan, 'After insert operation didn\'t happen.');

        triggerHandler.beforeInsertRan = false;
        triggerHandler.afterInsertRan = false;

        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        triggerHandler.startOperation(TriggerOperation.AFTER_INSERT);
        Test.stopTest();

        System.assertEquals(false, triggerHandler.beforeInsertRan, 'Before insert is not supposed to be run again.');
        System.assertEquals(false, triggerHandler.afterInsertRan, 'After insert is not supposed to be run again.');
    }

    @IsTest
    static void test_BlockRecursionForOperation() {
        TestHandler triggerHandler = new TestHandler();

        Test.startTest();
        triggerHandler.blockRecursionForOperation(TriggerOperation.AFTER_INSERT);

        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        triggerHandler.startOperation(TriggerOperation.AFTER_INSERT);

        System.assertEquals(true, triggerHandler.beforeInsertRan, 'Before insert operation didn\'t happen.');
        System.assertEquals(true, triggerHandler.afterInsertRan, 'After insert operation didn\'t happen.');

        triggerHandler.beforeInsertRan = false;
        triggerHandler.afterInsertRan = false;

        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        triggerHandler.startOperation(TriggerOperation.AFTER_INSERT);
        Test.stopTest();

        System.assertEquals(true, triggerHandler.beforeInsertRan, 'Before insert is supposed to be run again.');
        System.assertEquals(false, triggerHandler.afterInsertRan, 'After insert is not supposed to be run again.');
    }

    @IsTest
    static void test_AllowRecursion() {
        TestHandler triggerHandler = new TestHandler();

        Test.startTest();
        triggerHandler.allowRecursion();

        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        triggerHandler.startOperation(TriggerOperation.AFTER_INSERT);

        System.assertEquals(true, triggerHandler.beforeInsertRan, 'Before insert operation didn\'t happen.');
        System.assertEquals(true, triggerHandler.afterInsertRan, 'After insert operation didn\'t happen.');

        triggerHandler.beforeInsertRan = false;
        triggerHandler.afterInsertRan = false;

        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        triggerHandler.startOperation(TriggerOperation.AFTER_INSERT);
        Test.stopTest();

        System.assertEquals(true, triggerHandler.beforeInsertRan, 'Before insert is supposed to be run again.');
        System.assertEquals(true, triggerHandler.afterInsertRan, 'After insert is supposed to be run again.');
    }

    @IsTest
    static void test_AllowRecursionForOperation() {
        TestHandler triggerHandler = new TestHandler();

        Test.startTest();
        triggerHandler.blockRecursion().allowRecursionForOperation(TriggerOperation.AFTER_INSERT);

        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        triggerHandler.startOperation(TriggerOperation.AFTER_INSERT);

        System.assertEquals(true, triggerHandler.beforeInsertRan, 'Before insert operation didn\'t happen.');
        System.assertEquals(true, triggerHandler.afterInsertRan, 'After insert operation didn\'t happen.');

        triggerHandler.beforeInsertRan = false;
        triggerHandler.afterInsertRan = false;

        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        triggerHandler.startOperation(TriggerOperation.AFTER_INSERT);
        Test.stopTest();

        System.assertEquals(false, triggerHandler.beforeInsertRan, 'Before insert is not supposed to be run again.');
        System.assertEquals(true, triggerHandler.afterInsertRan, 'After insert is supposed to be run again.');
    }

    @IsTest
    static void test_ResetHandler() {
        TestHandler triggerHandler = new TestHandler();

        Test.startTest();
        triggerHandler.blockRecursion();

        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);

        System.assertEquals(true, triggerHandler.beforeInsertRan, 'Before insert operation didn\'t happen.');

        triggerHandler.beforeInsertRan = false;

        triggerHandler.reset();

        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        Test.stopTest();

        System.assertEquals(true, triggerHandler.beforeInsertRan, 'Before insert is supposed to be run again.');
    }

    @IsTest
    static void test_ResetHandlerForOperation() {
        TestHandler triggerHandler = new TestHandler();

        Test.startTest();
        triggerHandler.blockRecursion();

        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        triggerHandler.startOperation(TriggerOperation.AFTER_INSERT);

        System.assertEquals(true, triggerHandler.beforeInsertRan, 'Before insert operation didn\'t happen.');
        System.assertEquals(true, triggerHandler.afterInsertRan, 'After insert operation didn\'t happen.');

        triggerHandler.beforeInsertRan = false;
        triggerHandler.afterInsertRan = false;

        triggerHandler.resetOperation(TriggerOperation.BEFORE_INSERT);

        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        triggerHandler.startOperation(TriggerOperation.AFTER_INSERT);
        Test.stopTest();

        System.assertEquals(true, triggerHandler.beforeInsertRan, 'Before insert is supposed to be run again.');
        System.assertEquals(false, triggerHandler.afterInsertRan, 'After insert is not supposed to be run again.');
    }

    @IsTest
    static void test_OperationReady() {
        TestHandler triggerHandler = new TestHandler();

        Test.startTest();
        triggerHandler.blockRecursion();

        System.assertEquals(true, triggerHandler.operationReady(TriggerOperation.BEFORE_INSERT),
                'Operation is supposed to be ready to run.');

        triggerHandler.startOperation(TriggerOperation.BEFORE_INSERT);
        Test.stopTest();

        System.assertEquals(true, triggerHandler.beforeInsertRan, 'Before insert operation didn\'t happen.');
        System.assertEquals(false, triggerHandler.operationReady(TriggerOperation.BEFORE_INSERT),
                'Operation is not supposed to be ready to run.');
    }

    @IsTest
    static void test_Error_NullParameter() {
        TestHandler triggerHandler = new TestHandler();
        sfpcz_AbstractTriggerHandler.InvalidTriggerOperationException expectedExcptn;

        Test.startTest();
        try {
            triggerHandler.operationReady(null);
        } catch (sfpcz_AbstractTriggerHandler.InvalidTriggerOperationException e) {
            expectedExcptn = e;
        }
        Test.stopTest();

        System.assertEquals('Trigger operation "null" was not found.', expectedExcptn.getMessage(),
                'Different error is expected.');
    }

    @IsTest
    static void test_DisableOperation_NullParameter() {
        TestHandler triggerHandler = new TestHandler();
        sfpcz_AbstractTriggerHandler.InvalidTriggerOperationException expectedExcptn;

        Test.startTest();
        try {
            triggerHandler.disableOperation(null);
        } catch (sfpcz_AbstractTriggerHandler.InvalidTriggerOperationException e) {
            expectedExcptn = e;
        }
        Test.stopTest();

        System.assertEquals('Trigger operation "null" was not found.', expectedExcptn.getMessage(),
                'Different error is expected.');
    }
}