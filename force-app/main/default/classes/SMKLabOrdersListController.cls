public class SMKLabOrdersListController {

    private static List<SMKLabOrder> fetchLabOrders (String AccountId) {
        SMKPatientService TheService = new SMKPatientService();
        
        Account TheAccount = [Select id, HealthCloudGA__SourceSystemId__c  from Account where Id=:AccountId];
        
        return TheService.FetchLabOrders(TheAccount.HealthCloudGA__SourceSystemId__c );
    }
    
    @AuraEnabled
    public static List<SMKLabOrder> getLabOrders(String RecordId, String ObjectType)
    {
        Id accId = null;
        if(ObjectType == 'Account') {
            accId = RecordId;
        }
        else if(ObjectType == 'Contact') {
            List<Contact> contacts = [SELECT AccountId FROM Contact WHERE Id =: RecordId];
            //should only have 1 as matched on ContactId
            accId = contacts[0].AccountId;
        }
        else {
            accId = RecordId;
        }
        
        return fetchLabOrders(accId);
    }
    
    @AuraEnabled
    public static String syncLabOrders(String AccountId) {
        String accId = AccountId;
        
        if(accId == '')
        {
            //need to fetch account Id based on User Id
            List<Contact> accountIds = [SELECT AccountId FROM Contact WHERE Id IN (SELECT ContactId FROM User WHERE Id =: UserInfo.getUserId())];
            accId = accountIds[0].AccountId;
        }
        
        System.debug('Going to fetch laborders');
		List<SMKLabOrder> labOrders =  fetchLabOrders(accId);
        List<HealthCloudGA__EhrObservation__c> observations = new List<HealthCloudGA__EhrObservation__c>();
        System.debug('Translating labOrders to healthcloud observations');
        for(SMKLabOrder lo : labOrders) {
            for(SMKLabOrder.ResultItems ri : lo.Result.ResultItems)
            {
                HealthCloudGA__EhrObservation__c o = new HealthCloudGA__EhrObservation__c();
                o.HealthCloudGA__SourceSystem__c = lo.FillerId;
                o.HealthCloudGA__NameLabel__c = lo.OrderItem.Description;
                o.HealthCloudGA__IssuedDate__c = (datetime)json.deserialize('"' + lo.SpecimenCollectedTime + '"', datetime.class);
                o.HealthCloudGA__Status__c = lo.Status;
                o.Priority__c = lo.Priority.Description;
                o.HealthCloudGA__AppliesDateTime__c = (datetime)json.deserialize('"' + lo.FromTime + '"', datetime.class);
                o.HealthCloudGA__ValueLabel__c = lo.Result.ResultType;
                o.HealthCloudGA__ValueCode__c = ri.TestItemCode.Code;
                o.Result_Normal_Range__c = ri.ResultNormalRange;
                o.HealthCloudGA__ValueQuantity__c = ri.ResultValue;
                o.HealthCloudGA__ValueQuantityUnit__c = ri.ObservationValueType;
                o.Result_Status__c = lo.Result.ResultStatus;
                o.HealthCloudGA__InterpretationCode__c = lo.Result.ResultInterpretation;
                o.HealthCloudGA__Account__c = AccountId;
                observations.add(o);
            }
        }
        
        String returnValue = '';
        
        //first delete the existing ehr observations for this accountId
	 	List<HealthCloudGA__EhrObservation__c> existingObservations = [SELECT Id FROM HealthCloudGA__EhrObservation__c];
        System.debug('Found ' + existingObservations.size() + ' EhrObservations, will delete them now');
		delete existingObservations;        
        System.debug('Delete complete');
        
        System.debug('Going to upsert the observations');
        
        //upsert list of observations
        List<Database.UpsertResult> results = Database.upsert(observations,false);
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
    
}