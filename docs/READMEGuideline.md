# CODING GUIDLINES FOR AUTOMATION USING KARATE

## **Naming conventions**

1. For Folders:

* This should be in the context of project.
* We are following **camelCase**
* Currently we are following: Automation Project Name As **automationTests**
* Storing all the APIs: **api**
* Storing all the Templates: **templates**
* Storing all the contracts: **specmatic**
* Storing all the External contract-stubs: **external**
* Storing all the Workflows: **workflow**

2. For API test/feature/api files:

* File Name should be in camelCase **(Ex: fileName.feature, file.feature, fileNameTemplate.feature, fileName.spec)**
* File name should contain API name **(Ex: ottLogin.feature, ottLogin.template, ottLogin.spec)**

3. For Workflow files:

* File Name should be in camelCase **(Ex: fileName.feature, file.feature)**
* File name should contain a complete use case

## **Basic guidelines for different types of files (API/Template/Specmatic/Workflow)**

1. Feature: API description/what to test

* This can be in present or future tense based on API requirement

2. Scenario Outline/Scenario: API Scenario/how to test

* Should be in the present tense
* Should be included positive cases, edge cases and expected error cases
* Tests should be independent - i.e. no data dependencies, and no dependencies on other tests
* If any test or contract fails, then comment the **Observation ID** and mark it **@wip**
* Include API calls in one file. If we have any special scenario for the same API, then we can create another template
  in the same file **(specific to Template)**
* Write 1 Contract for 1 API in single file and include possible valid and invalid scenarios **(specific to Specmatic)**
* Should be in the context of Service/API

3. Variable Naming:

* Should be in context of the API
* Should be in readable format
* Should be easy to understand

4. **Follow proper spacing**



