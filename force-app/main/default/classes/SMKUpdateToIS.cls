public class SMKUpdateToIS {
    
   @Future(callout=true)
   public static void UpdatePatient(String SourceSystemId, String Email, String HomePhone) {

        String ServiceURL = 'http://IP:PORT/ApiGateway/ApiGateWay.BS.PatientService/';

       Http http = new Http();
		HttpRequest request = new HttpRequest();
		String Body = '{"email": "' + Email + '", "telnr": "' + HomePhone + '"}';
           
        request.setEndpoint(ServiceURL + 'patient/' + SourceSystemId);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
        System.debug('Body -->' + Body);
        request.setBody(Body);
        HTTPResponse response = http.send(request);
        System.debug(response.getStatusCode());
        if (response.getStatusCode() == 200)
        {
             system.debug('Success!');
        }
        else
            System.Debug(response.getBody());
   }
}