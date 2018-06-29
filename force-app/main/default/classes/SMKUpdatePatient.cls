public class SMKUpdatePatient {
    
   @InvocableMethod
   public static void UpdatePatient(list<String> ContactDetails) {
		
        User TheUser = [select Id, Name, Phone, Email, ContactId from User where Id=:ContactDetails];
        Contact TheContact = [select Id, AccountId, Name, HomePhone, MobilePhone, Email, MPIID__c, HealthCloudGA__SourceSystemId__c from Contact where Id=:TheUser.ContactId];
 
       Account accPat = [SELECT Id, Name, Phone FROM Account WHERE Id=:TheContact.AccountId];
       system.debug(accPat.Name + ' ' + accPat.Name);
       accPat.Phone = TheContact.HomePhone; 
       update accPat;

       system.debug('Call UpdateToIS!');
        SMKUpdateToIS.UpdatePatient(TheContact.HealthCloudGA__SourceSystemId__c, TheUser.Email, TheUser.Phone);

   }
}