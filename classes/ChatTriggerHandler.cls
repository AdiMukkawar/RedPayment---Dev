/******************************************************************************
Author             | Date           | Description
Aditya Mukkawar    | 05-March-2019  | To send chat email alert
******************************************************************************
 Updates
* Author            | Date            | Description
**********************************************************************************/
public class ChatTriggerHandler {

	@future(Callout=true)
	public static void sendEmail(set<Id> chatIds){
		List<Chat__c> chatList = [SELECT Id, Name, Subject__c, Message__c, Type__c, Opportunity__c, To__c, CC__c, Source__c, Destination__c, Template_Id__c FROM Chat__c WHERE id In:chatIds];
		Folder objChatFolder = [SELECT Id FROM Folder WHERE Name = 'Chat images' limit 1];
		Map<String,Document> imageNameAndDocMap = new Map<String,Document>();
		Map<String,List<String>> inputStringAndListMap = new Map<String,List<String>>();
		Map<Id,Id> chatOpportunityIdMap = new Map<Id,Id>();
		List<Messaging.SingleEmailMessage> lstEmailMsg = new List<Messaging.SingleEmailMessage>();

		for(Chat__c objChat : chatList){
			if(objChat.Opportunity__c !=null){
				chatOpportunityIdMap.put(objChat.id,objChat.Opportunity__c);
				List<String> inputStringList = new List<String>();			
	            String inputString = objChat.Message__c;
	            system.debug('inputString=>'+inputString);
	            
            	if(inputString.contains('<p>')){
            		while(inputString.length()>0){
		                Integer startString = inputString.indexOfAny('<p>');
		                Integer endString = inputString.indexOf('</p>', 0);
		                inputStringList.add(inputString.subString(startString+3, endString));
	                	inputString = inputString.subString(endString+4, inputString.length());
	                }
	            }else{
	            	inputStringList.add(inputString);
	            }
	            
	            inputStringAndListMap.put(objChat.Message__c,inputStringList);
			}			
		}
		system.debug('inputStringAndListMap=>'+inputStringAndListMap);
		if(inputStringAndListMap.keyset().size()>0){
			for(Chat__c objChat : chatList){
				for(String objString:inputStringAndListMap.get(objChat.Message__c)){
		            if(objString.contains('<img')){
		                String chat = objString.substringBetween('<img', '>');
		                String imgsrc = chat.substringBetween('src="', '"');
		                imgsrc = imgsrc.replace('amp;', '');
		                system.debug('imgsrc=>'+imgsrc);
		                //if(imgsrc !='' && imgsrc !=null){
			                PageReference page = new PageReference(imgsrc);
			                Blob imgblob; 
			                if (Test.IsRunningTest()){
			                    imgblob = Blob.valueOf('UNIT.TEST');
			                }else{
			                    imgblob = page.getContent();
			                }
			                Document objDoc = new Document();
			                objDoc.FolderId = objChatFolder.id;
			                objDoc.AuthorId = UserInfo.getUserId();
			                objDoc.Body = imgblob;
			                objDoc.IsPublic = true;
			                string randomString = generateRandomString(10);
			                objDoc.Name = 'Image'+randomString+'.jpg';
			                imageNameAndDocMap.put(objString,objDoc);
			            //}
		            }		            
		        }		        
		    }
		    if(imageNameAndDocMap.keyset().size()>0){
	            insert imageNameAndDocMap.values();
	        }
	    }
	    
	    for(Chat__c objChat : chatList){
	    	system.debug('objChat=>'+objChat);
	    	List<String> toEmailIds=new List<String>();
	    	List<String> ccEmailIds=new List<String>();
	    	if(objChat.To__c !=null){
	    		for(String key : objChat.To__c.split(',')){
					toEmailIds.add(key);
				}
	    		//toEmailIds.add(objChat.To__c);
	    	}
	    	if(objChat.cc__c !=null){
	    		for(String key : objChat.cc__c.split(',')){
					ccEmailIds.add(key);
				}
	    		//ccEmailIds.add(objChat.cc__c);
	    	}
	    	Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
	    	String msgText = '';
            for(String objString:inputStringAndListMap.get(objChat.Message__c)){
                if(objString.contains('<img')){
                    msgText = msgText + '<img src="'+System.Label.Site_URL+'/servlet/servlet.ImageServer?id='+imageNameAndDocMap.get(objString).Id+'&oid='+UserInfo.getOrganizationId()+'"/>';
                }else{
                    msgText = msgText + objString;
                }
            }
            system.debug('msgText=>'+msgText);
            string body = '';
            Messaging.SingleEmailMessage mesg = Messaging.renderStoredEmailTemplate(objChat.Template_Id__c,userInfo.getUserId(),objChat.Opportunity__c);
            body = mesg.HtmlBody;
            body = body.replace('MessageText',msgText);
            emailMsg.setToAddresses(toEmailIds);
            if(ccEmailIds.size()>0){
            	emailMsg.setCcAddresses(ccEmailIds);
            }
            emailMsg.setTargetObjectId(UserInfo.getUserId());
            emailMsg.setWhatId(objChat.Opportunity__c);
            emailMsg.setSubject(mesg.Subject);
            emailMsg.setHtmlBody(body);
            emailMsg.setPlainTextBody(mesg.PlainTextBody);
            emailMsg.SaveAsActivity = False;
            emailMsg.setTreatTargetObjectAsRecipient(false);
            lstEmailMsg.add(emailMsg);
	    }
	    if(lstEmailMsg.size()>0){
            Messaging.sendEmail(lstEmailMsg);
        }
	}

	//method to generate random string to append before file name     
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
}