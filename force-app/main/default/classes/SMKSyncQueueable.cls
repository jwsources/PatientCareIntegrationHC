public class SMKSyncQueueable implements Queueable, Database.AllowsCallouts {
    
    public void execute(QueueableContext context) {
        //hardcoded account id for Jos de Ruiter
        String returnvalue = SMKAppointmentsListController.syncAppointments('0011r00001ro8rYAAQ');
        System.debug('Sync Return Value: ' + returnvalue);
    }
}