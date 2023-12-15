import ballerina/http;
import ballerina/io;
import ballerina/test;

http:Client testClient = check new ("http://localhost:9090");

// Before Suite Function

@test:BeforeSuite
function beforeSuiteFunc() {
    io:println("Running Address API Service tests...");
}

// Test function
@test:Config {}
function testServiceWithProperNIC() {
    json|error response = testClient->get("/address/getAddressByNIC/?nic=200005703120");
    json[] responseJson = [{"_id": "6576a8ab242308a723a5aca3", "nic": "200005703120", "address": "123, Molpe, Moratuwa"}];
    test:assertEquals(response, responseJson);
}

// Negative test function

@test:Config {}
function testServiceWithNoNIC() returns error? {
    http:Response response = check testClient->get("/address/getAddressByNIC/?nic=");
    test:assertEquals(response.statusCode, 500);
    json errorPayload = check response.getJsonPayload();
    test:assertEquals(errorPayload.message, "NIC cannot be empty");
}

@test:Config {}
function testServiceWithInvalidNIC() returns error? {
    http:Response response_1 = check testClient->get("/address/getAddressByNIC/?nic=1234567");
    http:Response response_2 = check testClient->get("/address/getAddressByNIC/?nic=12345689781367");
    test:assertEquals(response_1.statusCode, 500);
    test:assertEquals(response_2.statusCode, 500);
    json errorPayload_1 = check response_1.getJsonPayload();
    json errorPayload_2 = check response_1.getJsonPayload();
    test:assertEquals(errorPayload_1.message, "Invalid NIC");
    test:assertEquals(errorPayload_2.message, "Invalid NIC");
}

// After Suite Function

@test:AfterSuite
function afterSuiteFunc() {
    io:println("Address API Service tests completed...");
}
