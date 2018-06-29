public class SMKSyncObservationsScheduler implements Schedulable{
    public void execute(SchedulableContext SC) {
        System.enqueueJob(new SMKSyncQueueableObservations());
    }
}