public with sharing class AwsEventBridgeBuilderMapper {

    public static JSONGenerator mapToConfigCreationBody(String configName, String eventChannelAPIName, String namedCredentialsName){
        JSONGenerator bodyJSON = JSON.createGenerator(true);
        bodyJSON.writeStartObject();
        bodyJSON.writeStringField('FullName', configName);
        bodyJSON.writeFieldName('Metadata');
        bodyJSON.writeStartObject();
        bodyJSON.writeStringField('destinationResourceName', 'callout:' + namedCredentialsName);
        bodyJSON.writeStringField('eventChannel', eventChannelAPIName);
        bodyJSON.writeStringField('state', 'STOP');
        return bodyJSON;
    }

    public static JSONGenerator mapToNamedCredentialsCreationBody(String developerName, String label, String region, String arnId){
        JSONGenerator bodyJSON = JSON.createGenerator(true);
        bodyJSON.writeStartObject();
        bodyJSON.writeStringField('FullName', developerName);
        bodyJSON.writeFieldName('Metadata');
        bodyJSON.writeStartObject();
        bodyJSON.writeStringField('protocol', 'NoAuthentication');
        bodyJSON.writeStringField('principalType', 'NamedUser');
        bodyJSON.writeStringField('label', label);
        bodyJSON.writeStringField('endpoint', 'arn:aws:' + region.toUpperCase() + ':' + arnId);
        return bodyJSON;
    }

    public static JSONGenerator mapToEventChannelMemberCreationBody(String eventChannelMemberName, String eventChannelName, String platformEventName){
        JSONGenerator bodyJSON = JSON.createGenerator(true);
        bodyJSON.writeStartObject();
        bodyJSON.writeStringField('FullName', eventChannelMemberName);
        bodyJSON.writeFieldName('Metadata');
        bodyJSON.writeStartObject();
        bodyJSON.writeStringField('eventChannel', eventChannelName);
        bodyJSON.writeStringField('selectedEntity', platformEventName);
        return bodyJSON;
    }

    public static JSONGenerator mapToEventChannelCreationBody(String channelName, Boolean isData, String label){
        JSONGenerator bodyJSON = JSON.createGenerator(true);
        bodyJSON.writeStartObject();
        bodyJSON.writeStringField('FullName', channelName);
        bodyJSON.writeFieldName('Metadata');
        bodyJSON.writeStartObject();
        String channelType = 'data';
        if(!isData){
            channelType = 'event';
        }
        bodyJSON.writeStringField('channelType', channelType);
        bodyJSON.writeStringField('label', label);
        return bodyJSON;
    }

    public static JSONGenerator mapToConfigRunBody(){
        JSONGenerator bodyJSON = JSON.createGenerator(true);
        bodyJSON.writeStartObject();
        bodyJSON.writeFieldName('Metadata');
        bodyJSON.writeStartObject();
        bodyJSON.writeStringField('state', 'RUN');
        return bodyJSON;
    }

}