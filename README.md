# AWS_SF_ESB

Proof of Concept to use AWS as a cost-efficient esb solution for small Salesforce projects

# Introduction
Since Salesforces Winter '23 release, you are able to use a standard connection between Salesforce Core Cloud and Amazon AWS Eventbride. I'll show a simple PoC how to build a stable Pub/Sub channel between the two services. In addition, I'll show an example ToC calculation which shows that it's an interesting solution for companies who are already using AWS or don't have a ESB in place yet.

# Advantages
- AWS is pretty cost efficient compared to other middleware solutions
- AWS can be setup via deployment as it supports Infrastructure As Code (IaC). Therefore it can scale very well for different customer
- Salesforce channel setup can also be deployed or created easy without in deep integration knowledge
- Pub/Sub (Fire & Forget) integration support error handling and replay of missed events. In that case you don't need to build custom retry mechanism at your REST endpoint. Instead you can monitor the event propagation in Salesforce and you can use declarative solutions at AWS side like SQS/SNS for deadletter queues

# Simple Architecture

[INSERT IMAGE]


# TCO Calculation
- Initial Setup per PlatformEventChannel + EventBusRelay ~ 1h
- Setup per Salesforce Platform Event incl. Salesforce record-triggered Flow ~ 1-2h
- Initial Setup AWS ~ 2h
- Setup AWS event handling tbd
- Setup 


- Updating Platform Events ~ 1h
- Updating AWS mapping ~ 1h





# Steps

0. Create a Custom Platform Event (if not exist)
You can create your custom Platform Event from the Saleforce GUI or via Metadata API (https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/platform_events_define.htm).
A sample platform event is included in this repo (./force-app/main/default/objects/TestForAWS__e.object-meta.xml).

1. Create a Channel for a Custom Platform Event
You can just use the class "EventBusSetup" from this repo. Call the method "createPlatformEventChannel" with following parameter:
//TODO

If you want to create them by your own, you can use Metadata API or Tooling API.

2. Create a Channel Member to Associate the Custom Platform Event
You can just use the class "EventBusSetup" from this repo. Call the method "createPlatformEventChannelMember" with following parameter:
//TODO

If you want to create them by your own, you can use Metadata API or Tooling API.

3. Create named credentials
You can just modify the example named credentials from this repo and deploy them. 
If you want to create them by your own, please use the legacy type of named credentials with following settings: 
- Identity Type = Named Principal 
- Authentication Protocol = No Authentication
- URL = arn:aws:[REGION]:[AWS ACCOUNTID]

4. Create an Event Relay Configuration (via Metadata API, Tooling API or via APEX classe)
You can just use the class "EventBusSetup" from this repo. Call the method "createEventRelayConfiguration" with following parameter:
//TODO

If you want to create them by your own, you can use Metadata API or Tooling API.

5. Activate the Event Bus in AWS Amazon EventBridge
TBD

6. Activate Event Relay Configuration (via Metadata API, Tooling API or via APEX classe)
You can just use the class "EventBusSetup" from this repo. Call the method "runEventRelayConfiguration" with following parameter:
//TODO

If you want to activate them by your own, you can use Metadata API or Tooling API.

You can check the status of the Bus via: 
SELECT EventRelayConfig.DeveloperName, Status, ErrorMessage, ErrorTime, ErrorCode FROM EventRelayFeedback

7. Send test event
Create a sample platform event via FlowBuilder or you can also send one via API or Apex. A sample code for sending one is in the repo called "createPlatformEvent"


# Future Improvements
- I will try to build a package to roll out the whole bus via deployment. In that case it scales much better and setup time will be lower
- I implement a monitoring system for the Salesforce-side of the bus

# Architecture Solution with Error Handling and subsystems

[INSERT IMAGE]

# Limitations
- It just work for me with ChannelTypes = event. Data channel like Change Data Capture should work but didn't for me. Probably we just have to wait for the next update until you can get rid of custom platform events
- Platform events are limited to a size of 1MB. If you want to use larger events, I recommend to just send the ID and changed fields and just query the data from Salesforce in the next step. 
- There is a chance that the EventRelay can fail at Salesforce side and needs to get restarted. I recommend to implement a solution to query the status of the EventRelay, notify your team and try to automatically restart it in case of failure. That could be easy build with scheduled APEX and Tooling API. (Also see Future Improvements)





Punkt 4:
Tooling API: 
String baseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v56.0/tooling/';
HTTPRequest req = new HTTPRequest();
req.setEndpoint(baseUrl + 'sobjects/EventRelayConfig');
req.setMethod('POST');
req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
req.setHeader('Content-Type', 'application/json');
req.setBody('{"FullName": "AwsEventRelay","Metadata": {"destinationResourceName": "callout:AWS_Eventbridge","eventChannel": "MyRelayChannel__chn","state": "STOP"}}');
Http h = new Http();
HttpResponse res = h.send(req);
System.debug(res.getBody());

Punkt 6: 
String baseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v56.0/tooling/';
HTTPRequest req = new HTTPRequest();
req.setEndpoint(baseUrl + 'sobjects/EventRelayConfig/7k23G000000000BQAQ');
req.setMethod('PATCH');
req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
req.setHeader('Content-Type', 'application/json');
req.setBody('{"Metadata": {"state": "RUN"}}');
Http h = new Http();
HttpResponse res = h.send(req);
System.debug(res.getBody());

