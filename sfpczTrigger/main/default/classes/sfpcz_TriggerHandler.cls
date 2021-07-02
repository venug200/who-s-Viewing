/***************************************************************************************************
* Name          : sfpcz_TriggerHandler
* Description   : Interface which defines the key functions of the trigger handler necessary for trigger handler control.
* Date          : 17/05/2020
* Author        : Vladislav Rakita
***************************************************************************************************/
public interface sfpcz_TriggerHandler {

    Boolean isEnabled();

    Boolean operationReady(TriggerOperation operation);

    sfpcz_TriggerHandler enable();
    sfpcz_TriggerHandler enableOperation(TriggerOperation operation);

    sfpcz_TriggerHandler disable();
    sfpcz_TriggerHandler disableOperation(TriggerOperation operation);

    sfpcz_TriggerHandler start();
    sfpcz_TriggerHandler startOperation(TriggerOperation operation);

    sfpcz_TriggerHandler reset();
    sfpcz_TriggerHandler resetOperation(TriggerOperation operation);

    sfpcz_TriggerHandler blockRecursion();
    sfpcz_TriggerHandler blockRecursionForOperation(TriggerOperation operation);

    sfpcz_TriggerHandler allowRecursion();
    sfpcz_TriggerHandler allowRecursionForOperation(TriggerOperation operation);
}