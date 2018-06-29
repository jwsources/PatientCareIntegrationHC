//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//


public class SMKMedication {

    @AuraEnabled
	public OrderItem OrderItem;
    @AuraEnabled
	public OrderItem OrderedBy;
    @AuraEnabled
	public String Status;
    @AuraEnabled
	public OrderItem Priority;
    @AuraEnabled
	public String EnteredOn;
    @AuraEnabled
	public String FromTime;
    @AuraEnabled
	public OrderItem DrugProduct;

	public class OrderItem {
        @AuraEnabled
		public String Code;
        @AuraEnabled
		public String Description;
	}

	
	public static List<SMKMedication> parse(String json) {
		return (List<SMKMedication>) System.JSON.deserialize(json, List<SMKMedication>.class);
	}
}