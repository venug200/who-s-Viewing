/**
 * @description       : This is a Test Class for controller class WhosViewing to publish and subscribe events. When a record 
 *                      is viewed , a platform event is published and subscribed by all users so they can view.
 * @author            : venu.balne@veygo.com
 * @group             : 
 * @last modified on  : 2021-Nov-23
 * @last modified by  : venu.balne@veygo.com
**/

@isTest
private class WhosViewingTest
{
@IsTest static void testValidEvent(){
            string uId = UserInfo.getUserId();
            string rId='testRecordId'; 
            string s='Active';
            string rT='';
            Test.startTest();
            string pv = whosViewingController.pushViewing(uId,rId,s,rT);
            Test.stopTest();
            System.assertEquals('success', pv,'Published successfully');  
        }
}