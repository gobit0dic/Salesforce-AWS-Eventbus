@IsTest
global with sharing class AwsEventBridgeBuilderTest {

    global class MockHttpResponseGenerator implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            return res;
        }
    }

    testMethod static void createNamedCredentialsPositive(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        AwsEventBridgeBuilderFacade.createNamedCredentials('test', 'labelTest', 'EU-CENTRAL-1', '111111111111');
    }

    testMethod static void createEventRelayConfigPositive(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        AwsEventBridgeBuilderFacade.createEventRelayConfig('test', 'labelTest', 'namedCredentials');
    }

    testMethod static void createPlatformEventChannelPositive(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        AwsEventBridgeBuilderFacade.createPlatformEventChannel('test__chn', 'labelTest', true);
    }

    testMethod static void createPlatformEventChannelWrongChannelName(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        try{
            AwsEventBridgeBuilderFacade.createPlatformEventChannel('test', 'labelTest', true);
            System.assert(false);
        }catch (Exception e){
            System.assert(true);
        }
    }

    testMethod static void createPlatformEventChannelMemberPositive(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        AwsEventBridgeBuilderFacade.createPlatformEventChannelMember('test', 'labelTest__chn', 'testEvent');
    }

    testMethod static void createPlatformEventChannelMemberWrongChannelName(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        try{
            AwsEventBridgeBuilderFacade.createPlatformEventChannelMember('test', 'labelTest', 'testEvent');
            System.assert(false);
        }catch (Exception e){
            System.assert(true);
        }
    }

    testMethod static void runEventRelayConfigPositive(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        AwsEventBridgeBuilderFacade.runEventRelayConfig('test');
    }

}