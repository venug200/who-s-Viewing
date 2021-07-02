/***************************************************************************************************
* Name          : sfpcz_AbstractTriggerHandler
* Description   : Abstract class to be inherited by trigger handler in order to be used by
*                 trigger controller. Defines key functions of the trigger handler.
* Date          : 17/05/2020
* Author        : Vladislav Rakita
***************************************************************************************************/
public abstract with sharing class sfpcz_AbstractTriggerHandler implements sfpcz_TriggerHandler {
    private static final String INVALID_TRIGGER_OPERATION_ERROR = 'Trigger operation "{0}" was not found.';

    private Boolean isEnabled = true;
    private final Map<TriggerOperation, OperationStatus> triggerOperationToStatus;


    /**
      * @desc Trigger operations map initialization
    */
    public sfpcz_AbstractTriggerHandler() {
        triggerOperationToStatus = new Map<TriggerOperation, OperationStatus>();

        for (TriggerOperation operation : TriggerOperation.values()) {
            triggerOperationToStatus.put(operation, new OperationStatus());
        }
    }

    /**
      * @desc Enables trigger
      * @return sfpcz_TriggerHandler - instance of sfpcz_TriggerHandler
    */
    public sfpcz_TriggerHandler enable() {
        this.isEnabled = true;
        return this;
    }

    /**
      * @desc Disables trigger
      * @return sfpcz_TriggerHandler - instance of sfpcz_TriggerHandler
    */
    public sfpcz_TriggerHandler disable() {
        this.isEnabled = false;
        return this;
    }

    /**
      * @desc Returns status of the trigger (enabled/disabled)
      * @return Boolean - status of the trigger handler
    */
    public Boolean isEnabled() {
        return this.isEnabled;
    }

    /**
      * @desc Starts trigger handler action based on current trigger operation
      * @return sfpcz_TriggerHandler - instance of sfpcz_TriggerHandler
    */
    public sfpcz_TriggerHandler start() {
        return startOperation(Trigger.operationType);
    }

    /**
      * @desc Starts particular trigger handler action
      * @param triggerOperation - trigger operation type
      * @return sfpcz_TriggerHandler - instance of sfpcz_TriggerHandler
    */
    public sfpcz_TriggerHandler startOperation(TriggerOperation triggerOperation) {
        if (triggerOperation == null) {
            throw new InvalidTriggerOperationException(triggerOperation);
        }

        if (!this.isEnabled || !triggerOperationToStatus.get(triggerOperation).readyForStart()) {
            return this;
        }

        triggerOperationToStatus.get(triggerOperation).startAction();


        if (triggerOperation == System.TriggerOperation.BEFORE_INSERT) {
            this.beforeInsert();
        } else if (triggerOperation == System.TriggerOperation.BEFORE_UPDATE) {
            this.beforeUpdate();
        } else if (triggerOperation == System.TriggerOperation.BEFORE_DELETE) {
            this.beforeDelete();
        } else if (triggerOperation == System.TriggerOperation.AFTER_INSERT) {
            this.afterInsert();
        } else if (triggerOperation == System.TriggerOperation.AFTER_UPDATE) {
            this.afterUpdate();
        } else if  (triggerOperation == System.TriggerOperation.AFTER_DELETE) {
            this.afterDelete();
        } else if (triggerOperation == System.TriggerOperation.AFTER_UNDELETE) {
            this.afterUndelete();
        }

        return this;
    }

    /**
      * @desc Enabled particular trigger handler action
      * @param operation - trigger operation type
      * @return sfpcz_TriggerHandler - instance of sfpcz_TriggerHandler
    */
    public sfpcz_TriggerHandler enableOperation(TriggerOperation operation) {
        getTriggerOperationStatus(operation).isEnabled = true;
        return this;
    }

    /**
      * @desc Disables particular trigger handler action
      * @param operation - trigger operation type
      * @return sfpcz_TriggerHandler - instance of sfpcz_TriggerHandler
    */
    public sfpcz_TriggerHandler disableOperation(TriggerOperation operation) {
        getTriggerOperationStatus(operation).isEnabled = false;
        return this;
    }

    /**
      * @desc Blocks recursion for entire trigger handler for single transaction
      * @return sfpcz_TriggerHandler - instance of sfpcz_TriggerHandler
    */
    public sfpcz_TriggerHandler blockRecursion() {
        for (OperationStatus opStatus : triggerOperationToStatus.values()) {
            opStatus.blockRecursion();
        }
        return this;
    }

    /**
      * @desc Blocks recursion for particular action in trigger handler for single transaction
      * @param operation - trigger operation type
      * @return sfpcz_TriggerHandler - instance of sfpcz_TriggerHandler
    */
    public sfpcz_TriggerHandler blockRecursionForOperation(TriggerOperation operation) {
        getTriggerOperationStatus(operation).blockRecursion();
        return this;
    }

    /**
      * @desc Allows recursion for entire trigger handler for single transaction
      * @return sfpcz_TriggerHandler - instance of sfpcz_TriggerHandler
    */
    public sfpcz_TriggerHandler allowRecursion() {
        for (OperationStatus opStatus : triggerOperationToStatus.values()) {
            opStatus.allowRecursion();
        }
        return this;
    }

    /**
      * @desc Allows recursion for particular action in trigger handler for single transaction
      * @param operation - trigger operation type
      * @return sfpcz_TriggerHandler - instance of sfpcz_TriggerHandler
    */
    public sfpcz_TriggerHandler allowRecursionForOperation(TriggerOperation operation) {
        getTriggerOperationStatus(operation).allowRecursion();
        return this;
    }

    /**
      * @desc Resets trigger status of previous run
      * @return sfpcz_TriggerHandler - instance of sfpcz_TriggerHandler
    */
    public sfpcz_TriggerHandler reset() {
        for (OperationStatus opStatus : triggerOperationToStatus.values()) {
            opStatus.reset();
        }
        return this;
    }

    /**
      * @desc Resets trigger status of previous run for particular operation
      * @param operation - trigger operation type
      * @return sfpcz_TriggerHandler - instance of sfpcz_TriggerHandler
    */
    public sfpcz_TriggerHandler resetOperation(TriggerOperation operation) {
        getTriggerOperationStatus(operation).reset();
        return this;
    }

    /**
      * @desc Resets trigger status of previous run for particular operation
      * @param operation - trigger operation type
      * @return Boolean - status of chosen operation
    */
    public Boolean operationReady(TriggerOperation operation) {
        if (!this.triggerOperationToStatus.containsKey(operation)) {
            throw new InvalidTriggerOperationException(operation);
        }
        return this.triggerOperationToStatus.get(operation).readyForStart();
    }

    /**
      * @desc Returns wrapper with all the information about particular operation
      * @param operation - trigger operation type
      * @return OperationStatus - wrapper with all the info about particular operation
    */
    private OperationStatus getTriggerOperationStatus(TriggerOperation operation) {
        if (!this.triggerOperationToStatus.containsKey(operation)) {
            throw new InvalidTriggerOperationException(operation);
        }
        return this.triggerOperationToStatus.get(operation);
    }

    /**
      * @desc Custom wrapper class to store all the necessary information about every separate trigger operation
    */
    public with sharing class OperationStatus {
        private Boolean recursionBlocked = false;
        private Boolean ranOnce = false;

        public Boolean isEnabled { get; set; } { isEnabled = true; }

        public Boolean readyForStart() {
            return isEnabled && (!recursionBlocked || !ranOnce);
        }

        public OperationStatus allowRecursion() {
            recursionBlocked = false;
            return this;
        }

        public OperationStatus blockRecursion() {
            recursionBlocked = true;
            return this;
        }

        public OperationStatus startAction() {
            ranOnce = true;
            return this;
        }

        public OperationStatus reset() {
            ranOnce = false;
            return this;
        }
    }

    protected virtual void beforeInsert() {}
    protected virtual void beforeUpdate() {}
    protected virtual void beforeDelete() {}
    protected virtual void afterInsert() {}
    protected virtual void afterUpdate() {}
    protected virtual void afterDelete() {}
    protected virtual void afterUndelete() {}

    public class InvalidTriggerOperationException extends Exception {
        public InvalidTriggerOperationException(TriggerOperation triggerOperation) {
            this(String.format(INVALID_TRIGGER_OPERATION_ERROR, new List<String> {String.valueOf(triggerOperation)}));
        }
    }
}