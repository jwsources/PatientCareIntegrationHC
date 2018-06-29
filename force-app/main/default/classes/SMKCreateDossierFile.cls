public class SMKCreateDossierFile {
    
   @AuraEnabled
   public static Map < string, object > SendDossierRequest(String MPIID) {
		
        String ServiceURL = 'http://IP:PORT/ApiGateway/ApiGateWay.BS.PatientService/';	
         system.debug(MPIID);
      
        if(MPIID == null)
        {
            //need to fetch account Id based on User Id
            system.debug('Get MPIID');

            List<Contact> ExternalIds = [SELECT HealthCloudGA__SourceSystemId__c FROM Contact WHERE Id IN (SELECT ContactId FROM User WHERE Id =: UserInfo.getUserId())];
            MPIID = ExternalIds[0].HealthCloudGA__SourceSystemId__c;
        }


      	Http http = new Http();
		HttpRequest request = new HttpRequest();
        
        request.setEndpoint(ServiceURL + 'patient/' + MPIID + '/CreateDossier');
		request.setMethod('GET');
		request.setHeader('Content-Type', 'application/json');
        HTTPResponse response = http.send(request);
        System.debug(response.getStatusCode());
		Map < String, Object > returnMap = (Map < String, Object > ) JSON.deserializeUntyped(response.getBody());
        if (response.getStatusCode() == 200)
        {
	       	// Deserialize the JSON string into collections of primitive data types.
			system.debug('returnMap-->' + returnMap);
       		if (returnMap.containsKey('filename')) {
 		       	// The deserialized response contains the expected key!
	            system.debug('Success!');
           }    
         }
        else
            System.Debug(response.getBody());
  		       
       return returnMap;
      
   }
}