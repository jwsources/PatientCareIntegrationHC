global class SMKSearchPatientFlow {
   @InvocableMethod
   public static void getAccountIds(List<String> Name) {
       SMKPatientService TheService = new SMKPatientService();
      List<SMKSearchPatient> ThePatients;
       
      ThePatients = TheService.SearchPatient('', Name[0], '');
       
      List<SMKSearchResults__c> Results = [select id from SMKSearchResults__c];
       
      delete Results;
       
      Results = new List<SMKSearchResults__c>();
      for (SMKSearchPatient Patient : ThePatients)
      {
          SMKSearchResults__c Result = new SMKSearchResults__c();
          
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

   }
}