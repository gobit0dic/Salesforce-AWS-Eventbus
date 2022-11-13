public without sharing class SamplePlatformEventPropagation {

    public static void publishSamplePlatformEvent(){
        TestForAWS__e event = new TestForAWS__e();
        Database.SaveResult result = EventBus.publish(event);
        if (result.isSuccess()) {
            System.debug('Successfully published event.');
        } else {
            for(Database.Error err : result.getErrors()) {
                System.debug('Error returned: ' +
                        err.getStatusCode() +
                        ' - ' +
                        err.getMessage()
                );
            }
        }
    }

}