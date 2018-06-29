public class SMKAppointmentsListController {

    @AuraEnabled
    public static List<SMKAppointment> getAppointments(String AccountId)
    {
        String accId = AccountId;
        
        if(accId == '')
        {
            //need to fetch account Id based on User Id
            List<Contact> accountIds = [SELECT AccountId FROM Contact WHERE Id IN (SELECT ContactId FROM User WHERE Id =: UserInfo.getUserId())];
            accId = accountIds[0].AccountId;
        }
        
		return fetchAppointments(accId);
    }
    
    @AuraEnabled
    public static String syncAppointments(String AccountId) {
        String accId = AccountId;
        
        if(accId == '')
        {
            //need to fetch account Id based on User Id
            List<Contact> accountIds = [SELECT AccountId FROM Contact WHERE Id IN (SELECT ContactId FROM User WHERE Id =: UserInfo.getUserId())];
            accId = accountIds[0].AccountId;
        }
        
        System.debug('Going to fetch appointments');
		List<SMKAppointment> appointments =  fetchAppointments(accId);
        List<HealthCloudGA__EhrEncounter__c> encounters = new List<HealthCloudGA__EhrEncounter__c>();
        System.debug('Translating appointments to healthcloud encounters');
        for(SMKAppointment appt : appointments) {
            //check if appointment exists, if not do an insert
            //let's first try this with an upsert
            HealthCloudGA__EhrEncounter__c enc = new HealthCloudGA__EhrEncounter__c();
			enc.HealthCloudGA__Status__c = appt.Status;
            enc.No_Show__c = appt.NoShow;
            enc.Entered_On__c = (datetime)json.deserialize('"' + appt.EnteredOn + '"', datetime.class);
            enc.HealthCloudGA__PeriodStart__c = (datetime)json.deserialize('"' + appt.FromTime + '"', datetime.class);
            enc.Care_Provider__c = appt.CareProvider.Description;
//            enc.HealthCloudGA__ReasonCode__c = appt.
            enc.HealthCloudGA__SourceSystem__c = appt.EnteredAt.Description;
            enc.HealthCloudGA__Account__c = AccountId;
            encounters.add(enc);
        }
        
        String returnValue = '';
        
        //first delete the existing ehr encounters for this accountId
	 	List<HealthCloudGA__EhrEncounter__c> existingEncounters = [SELECT Id FROM HealthCloudGA__EhrEncounter__c];
        System.debug('Found ' + existingEncounters.size() + ' EhrEncounters, will delete them now');
		delete existingEncounters;        
        System.debug('Delete complete');
        
        System.debug('Going to upsert the encounters');
        
        //upsert list of encounters
        List<Database.UpsertResult> results = Database.upsert(encounters,false);
        for(Database.UpsertResult ur : results) {
            if(!ur.isSuccess()) {
                //operation failed, so get all errors
                for(Database.Error err : ur.getErrors()) {
                    returnValue += err.getStatusCode() + ': ' + err.getMessage() + ': ' + err.getFields() + '\r\n';
                }
            }
        }
        
        if(returnValue == '') {
            returnValue = 'No errors, upsert successful';
        }
        
        return returnValue;
    }
    
    private static List<SMKAppointment> fetchAppointments(String AccountId) {
        SMKPatientService TheService = new SMKPatientService();
        
        System.debug('Fetching appointments for accountId : ' + AccountId);
        Account TheAccount = [Select id, HealthCloudGA__SourceSystemId__c  from Account where Id=:AccountId];
        
        System.debug('SourceSystemId: ' + TheAccount.HealthCloudGA__SourceSystemId__c);
        
        List<SMKAppointment> appts =  TheService.FetchAppointments(TheAccount.HealthCloudGA__SourceSystemId__c);
        System.debug('Found ' + appts.size() + ' appointments');
        return appts;
    }
}