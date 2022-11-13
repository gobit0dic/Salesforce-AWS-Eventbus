public without sharing class AwsEventBridgeBuilderPersistence {

    public static EventRelayConfig getEventRelayConfig(String developerName){
        try{
            return [
                    SELECT
                            Id
                    FROM EventRelayConfig
                    WHERE DeveloperName = :developerName
                    LIMIT 1
            ];
        }catch (Exception e){
            return null;
        }
    }

}