public with sharing class AwsEventBridgeBuilder {

    private final static String APIVERSION = 'v56.0';
    private final static String TOOLINGAPIPATH = URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/' + APIVERSION +'/tooling/';


    public HTTPRequest createHttpPOSTRequest(String objectName, String body){
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint(TOOLINGAPIPATH + 'sobjects/' + objectName);
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        req.setBody(body);
        return req;
    }

    public HTTPRequest createHttpPATCHRequest(String objectName, String objectId, String body){
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint(TOOLINGAPIPATH + 'sobjects/' + objectName + '/' + objectId);
        req.setMethod('PATCH');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        req.setBody(body);
        return req;
    }

}