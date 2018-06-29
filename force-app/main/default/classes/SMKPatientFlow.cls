global class SMKPatientFlow implements Process.Plugin { 

   global Process.PluginResult invoke(Process.PluginRequest request) { 
      String MPIID = (String) request.inputParameters.get('MPIID');
      String LastName = (String) request.inputParameters.get('LastName');
      String Telephone = (String) request.inputParameters.get('Telephone'); 
       
      SMKPatientService TheService = new SMKPatientService();
      List<SMKSearchPatient> ThePatients;
       
       
      Database.query('delete [select id from SMKSearchResult__c limit 10000]');
       
      ThePatients = TheService.SearchPatient(MPIID, LastName, Telephone);
       
      List<SMKSearchResults__c> Results = new List<SMKSearchResults__c>();
      for (SMKSearchPatient Patient : ThePatients)
      {
          SMKSearchResults__c Result = new SMKSearchResults__c();
          
		
          //HealthCloudGA.HcPatient mypatient = new HealthCloudGA.HcPatient();
          //mypatient.PatientClass = 'Individual';
          //HealthCloudGA.PatientService.createPatient(mypatient);
          
          Result.Facility__c = Patient.Facility;
          Result.FirstName__c = Patient.FirstName;
          Result.LastName__c = Patient.LastName;
          Result.MPIIID__c  = Patient.MPIID;
          Result.Prefix__c = Patient.Prefix;
          Result.Sex__c = Patient.Sex;
          Result.Telephone__c = Patient.Telephone;    
          Result.MRN__c = Patient.MRN;
          
          Results.add(Result);
      }
       
      Insert Results;
       
      Map<String,Object> result = new Map<String,Object>();
      result.put('recordCount', '0');
      return new Process.PluginResult(result); 
     
   }

   global Process.PluginDescribeResult describe() { 
      Process.PluginDescribeResult result = new Process.PluginDescribeResult(); 
      result.Name = 'Search Patient';
      result.Tag = 'Account Classes';
      result.inputParameters = new List<Process.PluginDescribeResult.InputParameter>();
      Process.PluginDescribeResult.InputParameter MPIID = new Process.PluginDescribeResult.InputParameter('MPIID', Process.PluginDescribeResult.ParameterType.STRING,false);
      Process.PluginDescribeResult.InputParameter LastName = new Process.PluginDescribeResult.InputParameter('LastName', Process.PluginDescribeResult.ParameterType.STRING,false);
      Process.PluginDescribeResult.InputParameter Telephone = new Process.PluginDescribeResult.InputParameter('Telephone', Process.PluginDescribeResult.ParameterType.STRING,false);
      result.inputParameters.add(MPIID);
      result.inputParameters.add(LastName);
      result.inputParameters.add(Telephone);
       
       
   	  result.outputParameters = new 
         List<Process.PluginDescribeResult.OutputParameter>{              
            new Process.PluginDescribeResult.OutputParameter('recordCount', 
            Process.PluginDescribeResult.ParameterType.STRING )
                }; 
      return result; 
   }
}