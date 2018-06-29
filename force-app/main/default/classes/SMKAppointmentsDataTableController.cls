public class SMKAppointmentsDataTableController {

   
    @AuraEnabled
    public static Integer getTotalCount(String AccountId) {
		String accId = AccountId;
        
        if(accId == '')
        {
            //need to fetch account Id based on User Id
            List<Contact> accountIds = [SELECT AccountId FROM Contact WHERE Id IN (SELECT ContactId FROM User WHERE Id =: UserInfo.getUserId())];
            accId = accountIds[0].AccountId;
        }
        
        AggregateResult results = [SELECT COUNT(Id) total FROM HealthCloudGA__EhrEncounter__c WHERE HealthCloudGA__Account__c =: accId];
        
        Integer total = (Integer)results.get('total');
        return total;
    }
    
    @AuraEnabled
    public static List<HealthCloudGA__EhrEncounter__c> getAppointments(String AccountId, Integer limits, Integer offsets)
    {
        System.debug('limits'+limits);
        System.debug('offsets'+offsets);
        Integer intlimits = integer.valueof(limits);
        Integer intoffsets = integer.valueof(offsets);
        
        String accId = AccountId;
        
        if(accId == '')
        {
            //need to fetch account Id based on User Id
            List<Contact> accountIds = [SELECT AccountId FROM Contact WHERE Id IN (SELECT ContactId FROM User WHERE Id =: UserInfo.getUserId())];
            accId = accountIds[0].AccountId;
        }
        
        List<HealthCloudGA__EhrEncounter__c> encounters = [SELECT HealthCloudGA__Status__c, No_Show__c, Entered_On__c, HealthCloudGA__PeriodStart__c, HealthCloudGA__SourceSystem__c, Care_Provider__c FROM HealthCloudGA__EhrEncounter__C WHERE HealthCloudGA__Account__c = :accId ORDER BY HealthCloudGA__PeriodStart__c LIMIT :intlimits OFFSET :intoffsets];
        System.debug('returning ' + encounters.size() + ' encounters');
        return encounters;
    }
}