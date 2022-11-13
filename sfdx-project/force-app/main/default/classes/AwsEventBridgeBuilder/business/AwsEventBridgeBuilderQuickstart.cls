public without sharing class AwsEventBridgeBuilderQuickstart {

    public static void fullSetup(String region, String arnId, String platformEventName){
        String namedCredentialsName = 'AWS_Eventbridge';
        String platformEventNameParsed = platformEventName.replace('__e', '');
        String configName = platformEventNameParsed + 'EventRelay';
        String channelName = platformEventNameParsed + '__chn';

        NamedCredential credential = AwsEventBridgeBuilderPersistence.getNamedCredentials(namedCredentialsName);
        if(credential == null){
            AwsEventBridgeBuilderFacade.createNamedCredentials(namedCredentialsName, namedCredentialsName, region, arnId);
        }
        AwsEventBridgeBuilderFacade.createPlatformEventChannel(channelName, platformEventNameParsed, false);
        AwsEventBridgeBuilderFacade.createPlatformEventChannelMember(platformEventNameParsed, channelName, platformEventName);
        AwsEventBridgeBuilderFacade.createEventRelayConfig(configName, channelName, 'AWS_Eventbridge');
        AwsEventBridgeBuilderFacade.runEventRelayConfig(configName);
    }

}