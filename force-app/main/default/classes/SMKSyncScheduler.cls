public class SMKSyncScheduler implements Schedulable{
    public void execute(SchedulableContext SC) {
        System.enqueueJob(new SMKSyncQueueable());
    }
}