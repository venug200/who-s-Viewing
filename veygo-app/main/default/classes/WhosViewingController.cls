/**
 * @description       : This is a controller class to publish and subscribe events. When a record 
 *                      is viewed , a platform event is published and subscribed by all users so they can view.
 * @author            : venu.balne@veygo.com
 * @group             : 
 * @last modified on  : 2021-Nov-23
 * @last modified by  : venu.balne@veygo.com
**/
public class WhosViewingController {
    @AuraEnabled
    public static String getSessionId() {
        return UserInfo.getSessionId();
    }
    @AuraEnabled
    public static string pushViewing(
                                string userId, 
                                string recordId,
                                string status,
                                string responseTo
                                ){
        string response = '';   
        Datetime now = system.now();
        List<whosViewing__e> viewing = new List<whosViewing__e>();
        viewing.add(new whosViewing__e(
            recordId__c=recordId, 
            userId__c=userId, 
            status__c=status,
            responseTo__c=responseTo,
            timestamp__c=now));
        List<Database.SaveResult> results = EventBus.publish(viewing);
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                System.debug('Successfully published event.');
                response = 'success';
            } 
            else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Error returned: ' +
                                err.getStatusCode() +
                                ' - ' +
                                err.getMessage());
                }
                response = 'failed';
            }       
        }               
    return response ;
    }
}