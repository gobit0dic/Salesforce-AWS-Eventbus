/**
 * Created by pascalklos on 13.11.22.
 */

public with sharing class AwsEventBridgeBuilderFacade {

    public class NotFoundException extends Exception {}
    public class WrongPayloadException extends Exception {}

    public static void createNamedCredentials(String developerName, String label, String region, String arnId){
        AwsEventBridgeBuilder builder = new AwsEventBridgeBuilder();
        JSONGenerator bodyJSON = AwsEventBridgeBuilderMapper.mapToNamedCredentialsCreationBody(developerName, label, region, arnId);
        HTTPRequest req = builder.createHttpPOSTRequest('NamedCredentials', bodyJSON.getAsString());
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(res.getBody());
    }

    public static void createPlatformEventChannel(String channelName, String label, Boolean isDataChannel){
        AwsEventBridgeBuilder builder = new AwsEventBridgeBuilder();
        if(!channelName.endsWith('__chn')){
            throw new WrongPayloadException('The channel name has to ends with "__chn" !');
        }
        JSONGenerator bodyJSON = AwsEventBridgeBuilderMapper.mapToEventChannelCreationBody(channelName, isDataChannel, label);
        HTTPRequest req = builder.createHttpPOSTRequest('PlatformEventChannel', bodyJSON.getAsString());
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(res.getBody());
    }

    public static void createPlatformEventChannelMember(String channelMemberName, String channelName, String platformEventName){
        AwsEventBridgeBuilder builder = new AwsEventBridgeBuilder();
        if(!channelName.endsWith('__chn')){
            throw new WrongPayloadException('The channel name has to ends with "__chn" !');
        }
        JSONGenerator bodyJSON = AwsEventBridgeBuilderMapper.mapToEventChannelMemberCreationBody(channelMemberName, channelName, platformEventName);
        HTTPRequest req = builder.createHttpPOSTRequest('PlatformEventChannelMember', bodyJSON.getAsString());
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(res.getBody());
    }

    public static void createEventRelayConfig(String configName, String eventChannelAPIName, String namedCredentialsName){
        AwsEventBridgeBuilder builder = new AwsEventBridgeBuilder();
        JSONGenerator bodyJSON = AwsEventBridgeBuilderMapper.mapToConfigCreationBody(configName, eventChannelAPIName, namedCredentialsName);
        HTTPRequest req = builder.createHttpPOSTRequest('EventRelayConfig', bodyJSON.getAsString());
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(res.getBody());
    }

    public static void runEventRelayConfig(String eventRelayConfigAPIName){
        AwsEventBridgeBuilder builder = new AwsEventBridgeBuilder();
        EventRelayConfig eventRelayConfig = AwsEventBridgeBuilderPersistence.getEventRelayConfig(eventRelayConfigAPIName);
        if(eventRelayConfig == null){
            if(!Test.isRunningTest()){
                throw new NotFoundException('EventRelayConfig with name: ' + eventRelayConfigAPIName + ' not found!');
            }else{
                eventRelayConfig = new EventRelayConfig();
            }
        }
        JSONGenerator bodyJSON = AwsEventBridgeBuilderMapper.mapToConfigRunBody();
        HTTPRequest req = builder.createHttpPATCHRequest('EventRelayConfig', eventRelayConfig.Id, bodyJSON.getAsString());
        Http h = new Http();
        HttpResponse res = h.send(req);
        System.debug(res.getBody());
    }

}