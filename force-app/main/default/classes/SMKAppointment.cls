//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class SMKAppointment {

    @AuraEnabled
	public String Status;
    @AuraEnabled
	public Boolean NoShow;
    @AuraEnabled
	public String EnteredOn;
    @AuraEnabled
	public String FromTime;
    @AuraEnabled
	public CareProvider CareProvider;
    @AuraEnabled
	public CareProvider EnteredAt;

	public class CareProvider {
        @AuraEnabled
		public String Code;
        @AuraEnabled
		public String Description;
	}

	
	public static List<SMKAppointment> parse(String json) {
		return (List<SMKAppointment>) System.JSON.deserialize(json, List<SMKAppointment>.class);
	}
}