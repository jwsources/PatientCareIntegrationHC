public class SMKPatientService {
    private static final String ServiceURL = 'http://IP:PORT~/ApiGateway/ApiGateWay.BS.PatientService/';

    public SMKPatient FetchPatient(String MPIID)
    {
        System.debug('Fetching patient for MPIID: ' + MPIID);
        SMKPatient Result;
       	Http http = new Http();
		HttpRequest request = new HttpRequest();
		
        request.setEndpoint(ServiceURL + 'patient/' + MPIID);
		request.setMethod('GET');
		request.setHeader('Content-Type', 'application/json');
        HTTPResponse response = http.send(request);
        System.debug('Status Code: ' + response.getStatusCode());
        if (response.getStatusCode() == 200)
        {
            Result = SMKPatient.parse(response.getBody());
    		System.debug('Response body: ' + response.getBody());		
        }
        else
            System.Debug('Response body: ' + response.getBody());
 		return Result;       
 
    }
    
    public List<SMKAppointment> FetchAppointments(String MPIID)
    {
        System.debug('Fetching appointments for MPIID: ' + MPIID);
        List<SMKAppointment> Result = new List<SMKAppointment>();
       	Http http = new Http();
		HttpRequest request = new HttpRequest();
		
        request.setEndpoint(ServiceURL + 'patient/' + MPIID + '/Appointments');
		request.setMethod('GET');
		request.setHeader('Content-Type', 'application/json');
        HTTPResponse response = http.send(request);
        System.debug('Status Code: ' + response.getStatusCode());
        if (response.getStatusCode() == 200)
        {
            Result = SMKAppointment.parse(response.getBody());
    		System.debug('Response body: ' + response.getBody());		
        }
        else
            System.Debug('Response body: ' + response.getBody());
 		return Result;       
 
    }
    
    public List<SMKLabOrder> FetchLabOrders(String MPIID)
    {
        System.debug('Fetching lab orders for MPIID: ' + MPIID);
        List<SMKLabOrder> Result = new List<SMKLabOrder>();
       	Http http = new Http();
		HttpRequest request = new HttpRequest();
		
        request.setEndpoint(ServiceURL + 'patient/' + MPIID + '/LabOrders');
		request.setMethod('GET');
		request.setHeader('Content-Type', 'application/json');
        HTTPResponse response = http.send(request);
        System.debug('Status Code: ' + response.getStatusCode());
        if (response.getStatusCode() == 200)
        {
            Result = SMKLabOrder.parse(response.getBody());
    		System.debug('Response body: ' + response.getBody());		
        }
        else
            System.Debug('Response body: ' + response.getBody());
 		return Result;       
 
    }
    
    public List<SMKMedication> FetchMedications(String MPIID)
    {
        System.debug('Fetching medications for MPIID: ' + MPIID);
        List<SMKMedication> Result = new List<SMKMedication>();
       	Http http = new Http();
		HttpRequest request = new HttpRequest();
		
        request.setEndpoint(ServiceURL + 'patient/' + MPIID + '/Medications');
		request.setMethod('GET');
		request.setHeader('Content-Type', 'application/json');
        HTTPResponse response = http.send(request);
        System.debug('Status Code: ' + response.getStatusCode());
        if (response.getStatusCode() == 200)
        {
            Result = SMKMedication.parse(response.getBody());
    		System.debug('Response body: ' + response.getBody());		
        }
        else
            System.Debug('Response body: ' + response.getBody());
 		return Result;       
 
    }
    
    public list<SMKSearchPatient> SearchPatient (String MPIID, String Name, String Telephone)
    {
        List<SMKSearchPatient> Result;
        Http http = new Http();
		HttpRequest request = new HttpRequest();
		Map<String,Object> SearchSpec = new Map<String,Object>();
        
        request.setEndpoint(ServiceURL + 'patient');
        
        System.Debug(request.getEndpoint());
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
        
        if (MPIID != '')
            SearchSpec.put('MPIID', MPIID);
        if (Name != '')
            SearchSpec.put('LastName',Name);
     	if (Telephone != '')
            SearchSpec.put('Telephone', Telephone);
     
        String InputsJSON = JSON.serialize(SearchSpec);
        
        System.debug(InputsJSON);
        request.setBody(InputsJSON);
               
        HTTPResponse response = http.send(request);
        System.debug('Status Code: ' + response.getStatusCode());
        if (response.getStatusCode() == 200)
        {
            Result = SMKSearchPatient.parse(response.getBody());
    		System.debug('Response body: ' + response.getBody());		
        }
        else
            System.Debug('Response body: ' + response.getBody());
        
        return Result;
    }

}