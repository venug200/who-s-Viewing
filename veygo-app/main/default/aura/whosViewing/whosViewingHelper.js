({
    pushEvent : function(component, rId, s, rT) {
        var uId = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get('c.pushViewing');
        action.setParams({ 	recordId : rId,
                         	  userId : uId,
                          	status :  s,
                          	responseTo : rT
                         });
  		action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state == 'SUCCESS') {
                }
        });
  		$A.enqueueAction(action);
  	},
    displayToast : function(component, type, message) {
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
          type: type,
          message: message
        });
        toastEvent.fire();
    },
    isUserViewing : function(component, pUserId) {
        var viewing = component.get("v.whosViewing");
        var userViewing=false;
        var i;
        for (i =0; i<viewing.length; i++){
            if(viewing[i].userId__c == pUserId ){
                  userViewing= true;
                  return userViewing;
              }else{
              };
            };
        return userViewing;
      },
})