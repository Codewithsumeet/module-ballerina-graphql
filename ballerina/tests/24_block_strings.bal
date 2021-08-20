// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/test;

@test:Config {
    groups: ["block_strings"]
}
isolated function testBlockStrings() returns error? {
    http:Request request = new;
    string document = check getGraphQLDocumentFromFile("block_strings.txt");
    string url = "http://localhost:9091/inputs";
    json actualPayload = check getJsonPayloadFromService(url, document);
    json expectedPayload = check getJsonContentFromFile("block_strings.json");
    test:assertEquals(actualPayload, expectedPayload);
}

@test:Config {
    groups: ["block_strings", "variables"]
}
isolated function testBlockStringsWithVariables() returns error? {
    http:Request request = new;
    string document = check getGraphQLDocumentFromFile("block_strings_with_variables.txt");
    json variables = { 
        block: string`
        This,
            is
                Graphql
                    Block
                        Strings!` 
    };
    string url = "http://localhost:9091/inputs";
    json actualPayload = check getJsonPayloadFromService(url, document, variables);
    json expectedPayload = check getJsonContentFromFile("block_strings_with_variables.json");
    test:assertEquals(actualPayload, expectedPayload);
}

@test:Config {
    groups: ["block_strings"]
}
isolated function testBlockStringsWithVariableDefaultValue() returns error? {
    http:Request request = new;
    string document = check getGraphQLDocumentFromFile("block_string_with_variable_default_value.txt");
    string url = "http://localhost:9091/inputs";
    json actualPayload = check getJsonPayloadFromService(url, document);
    json expectedPayload = check getJsonContentFromFile("block_strings_with_variables_default_value.json");
    test:assertEquals(actualPayload, expectedPayload);
}

@test:Config {
    groups: ["block_strings", "variables"]
}
isolated function testBlockStringsWithVariablesIncludedInvalidCharacters() returns error? {
    http:Request request = new;
    string document = check getGraphQLDocumentFromFile("block_strings_with_variables.txt");
    json variables = { 
        block: string`
        Hello,
            World!,
\"""
        Yours, """
            GraphQL` 
    };
    string url = "http://localhost:9091/inputs";
    json actualPayload = check getJsonPayloadFromBadRequest(url, document, variables);
    json expectedPayload = check getJsonContentFromFile("block_strings_with_variables_included_invalid_characters.json");
    test:assertEquals(actualPayload, expectedPayload);
}
