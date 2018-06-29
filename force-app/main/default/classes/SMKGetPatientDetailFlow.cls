global class SMKGetPatientDetailFlow {
   @InvocableMethod
   public static void getAccountIds(List<String> ContactId) {
       SMKPatientService TheService = new SMKPatientService();
      SMKPatient ThePatient;
      Contact TheContact = [select Id, HomePhone, HealthCloudGA__Gender__c, HealthCloudGA__SourceSystemId__c , MailingCity, MailingPostalCode from Contact where Id=:ContactId[0]];
       
       
      ThePatient = TheService.FetchPatient(TheContact.HealthCloudGA__SourceSystemId__c);
       
      TheContact.HomePhone = ThePatient.ContactInfo.HomePhoneNumber;
      String Gender = ThePatient.Gender.Code;
      if (Gender == 'M')
      {
      	TheContact.HealthCloudGA__Gender__c = 'Male';
      }
      else
      {
      	TheContact.HealthCloudGA__Gender__c = 'Female';
      }
      SMKPatient.Addresses TheAddress = ThePatient.Addresses.get(0);
       
     // TheContact.MailingCity = TheAddress.City
     // TheContact.MailingPostalCode = TheAddress.Zip;
      
       Update TheContact;
      
      

   }
}