/***************************************************************************************************
* Name          : sfpcz_TriggersController
* Description   : Controller class to store trigger handlers instances and manipulate them.
* Date          : 17/05/2020
* Author        : Vladislav Rakita
***************************************************************************************************/
public with sharing class sfpcz_TriggersController {
    private static final String INVALID_TRIGGER_HANDLER_ERROR = 'Trigger handler "{0}" is not valid!';

    // map to store information about every separate active trigger handler for current transaction
    private static Map<Type, sfpcz_TriggerHandler> tHandlersMap = new Map<Type, sfpcz_TriggerHandler>();
    private static Boolean disableAll = false;

    /**
      * @desc Creates new instance of trigger handler class to store it in map
      * @param triggerHandlerType - type of Trigger handler class
      * @return sfpcz_TriggerHandler - instance of sfpcz_TriggerHandler
    */
    private static sfpcz_TriggerHandler createTriggerHandler(Type triggerHandlerType) {
        if ((triggerHandlerType == null) || (triggerHandlerType == Object.class)) {
            throw new InvalidTriggerHandlerException(triggerHandlerType);
        }

        Object triggerHandlerUnit;

        try {
            triggerHandlerUnit = triggerHandlerType.newInstance();
        } catch (Exception e) {
            throw new InvalidTriggerHandlerException(triggerHandlerType, e);
        }

        if (!(triggerHandlerUnit instanceof sfpcz_TriggerHandler)) {
            throw new InvalidTriggerHandlerException(triggerHandlerType);
        }

        return (sfpcz_TriggerHandler) triggerHandlerUnit;
    }

    /**
      * @desc Initialises new trigger handler type and add it to the map if it fits criteria
      * @param triggerHandlerType - type of Trigger Handler class
      * @return sfpcz_TriggerHandler - instance of sfpcz_TriggerHandler
    */
    public static sfpcz_TriggerHandler init(Type triggerHandlerType) {
        if (!tHandlersMap.containsKey(triggerHandlerType)) {
            sfpcz_TriggerHandler tHandler = createTriggerHandler(triggerHandlerType);

            if (disableAll) {
                tHandler.disable();
            }

            tHandlersMap.put(triggerHandlerType, tHandler);
        }

        return tHandlersMap.get(triggerHandlerType);
    }

    /**
      * @desc Disables all the triggers stored in trigger handlers map
    */
    public static void disableAllHandlers() {
        disableAll = true;

        for (sfpcz_TriggerHandler item : tHandlersMap.values()) {
            item.disable();
        }
    }

    /**
      * @desc Disables particular operation for all the triggers stored in trigger handlers map
    */
    public static void disableAllHandlersOperation(TriggerOperation operation) {
        for (sfpcz_TriggerHandler item : tHandlersMap.values()) {
            item.disableOperation(operation);
        }
    }

    /**
      * @desc Enables all the triggers stored in trigger handlers map
    */
    public static void enableAllHandlers() {
        disableAll = true;

        for (sfpcz_TriggerHandler item : tHandlersMap.values()) {
            item.enable();
        }
    }

    /**
      * @desc Enables particular operation for all the triggers stored in trigger handlers map
    */
    public static void enableAllHandlersOperation(TriggerOperation operation) {
        for (sfpcz_TriggerHandler item : tHandlersMap.values()) {
            item.enableOperation(operation);
        }
    }

    /**
     * @desc Reset status of all the triggers stored in trigger handlers map
   */
    public static void resetAllHandlers() {
        for (sfpcz_TriggerHandler item : tHandlersMap.values()) {
            item.reset();
        }
    }

    /**
     * @desc Reset status of particular operation for all the triggers stored in trigger handlers map
   */
    public static void resetAllHandlersOperation(TriggerOperation operation) {
        for (sfpcz_TriggerHandler item : tHandlersMap.values()) {
            item.resetOperation(operation);
        }
    }

    public class InvalidTriggerHandlerException extends Exception {
        private Type requestedType;

        public InvalidTriggerHandlerException(Type triggerHandlerType) {
            this(String.format(INVALID_TRIGGER_HANDLER_ERROR, new List<String> { String.valueOf(triggerHandlerType)}));
        }

        // overloading constructor with additional parameter in order to catch unexpected errors
        public InvalidTriggerHandlerException(Type wrongType, Exception e) {
            this(e.getMessage(), e);
            this.requestedType = wrongType;
        }
    }
}