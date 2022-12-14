({
    onInit : function(component, event, helper) {
        var rId = component.get("v.recordId");
        helper.pushEvent(component, rId, "New", "" );
        component.set('v.priorRecordId', rId);
	},
    
	recordChange : function(component, event, helper) {    
        component.set('v.whosViewing',[]);
        var prId = component.get('v.priorRecordId');
        helper.pushEvent(component, prId, "Left", "" );
        var rId = component.get('v.recordId');
        helper.pushEvent(component, rId, "New", "" );
        component.set('v.priorRecordId', rId); 
	},
    
    handleMessage : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var payload = event.getParam("payload");
        var payloadRecId = payload.recordId__c;
        var payloadStatus = payload.status__c;
        var payloadUserId = payload.userId__c;
        var payloadRT = payload.responseTo__c;
        var uId = $A.get("$SObjectType.CurrentUser.Id");
        var viewing = component.get("v.whosViewing");
        if (payloadStatus=="New" && recId == payloadRecId && payloadUserId != uId){
            var isViewing = helper.isUserViewing(component,payloadUserId);
            if (isViewing==false){
                viewing.push(payload);
                component.set("v.whosViewing",viewing);
            };
            helper.pushEvent(component, recId, "Response", payloadUserId );
        
        } else if (payloadStatus=="Response" && recId == payloadRecId && payloadRT == uId){
            viewing.push(payload);
        	component.set("v.whosViewing",viewing);
            
        } else if (payloadStatus=="Left" && recId == payloadRecId && payloadUserId != uId){
            var isViewing = helper.isUserViewing(component,payloadUserId);
            if (isViewing==true){
                var leftViewing=[];
                var i;
                for (i = 0; i < viewing.length; i++){
                    if(viewing[i].userId__c != payloadUserId){      
                        leftViewing.push(viewing[i]);
                    };  
                };  
                component.set("v.whosViewing",leftViewing);
            };  
        };     		        		
    },
    
    recordUpdated: function(component, event, helper) {
        var changeType = event.getParams().changeType;
        if (changeType === "ERROR") { 
            /* handle error; do this first! */
            helper.displayToast(component, 'error', 'Notifications: Error Connecting to Record.'); 
        } else if (changeType === "LOADED") { 
            /* handle record load */ 
            helper.displayToast(component, 'warning', 'Notifications: Record Loaded by another user.'); 
        } else if (changeType === "REMOVED") { 
            /* handle record removal */ 
            helper.displayToast(component, 'error', 'Notifications: This record have been deleted by another user.'); 
        } else if (changeType === "CHANGED") { 
            /* handle record change */ 
            helper.displayToast(component, 'error', 'Notifications: This record have been edited by another user.'); 
        }
    },
    onToggleMute : function(component, event, helper) {
        var isMuted = component.get('v.isMuted');
        component.set('v.isMuted', !isMuted);
        helper.displayToast(component, 'success', 'Notifications '+ ((!isMuted) ? 'muted' : 'unmuted') +'.');
    },
    utlityNotifications: function (component, event) {
        var viewing = component.get("v.whosViewing").length;
        if(viewing==0){
            var utilityAPI = component.find('utilitybar'); 
            var readNotification = component.get('v.readNotification');
            utilityAPI.setUtilityHighlighted({ highlighted : false }); 
            utilityAPI.setUtilityLabel(
                { label : 'Whos Viewing' });                       
            component.set('v.readNotification', true);
        } 
        else {
            var utilityAPI = component.find('utilitybar'); 
            var readNotification = component.get('v.readNotification');
            utilityAPI.setUtilityHighlighted({ highlighted : true });
            utilityAPI.setUtilityLabel(
                { label : 'Whos Viewing (' + viewing + ')' });                        
            component.set('v.readNotification', false);
        }
    }    
})