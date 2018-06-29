public class SMKMedicationsListController {

    @AuraEnabled
    public static List<SMKMedication> getMedications(String AccountId)
    {
        SMKPatientService TheService = new SMKPatientService();
        
        Account TheAccount = [Select id, HealthCloudGA__SourceSystemId__c  from Account where Id=:AccountId];
        
        return TheService.FetchMedications(TheAccount.HealthCloudGA__SourceSystemId__c );
    }
    
}