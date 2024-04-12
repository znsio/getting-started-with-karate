# getting-started-with-karate
Sample project to get started with implementing and running karate tests, in a structured fashion.

Results are published in junit, html and cucumber-reporting format

## Running the tests with gradle command

Example
    
    TARGET_ENVIRONMENT=prod TYPE=workflow ./gradlew clean test

## Build the uber jar

- Build an uber jar:

  `./gradlew build`

- The above command will create a jar in the upload folder with the name like: `upload/getting-started-with-karate-0.0.1.jar`

### Running the tests with a shell script:

    cd upload 
    PARALLEL=3 TARGET_ENVIRONMENT=prod TYPE=workflow ./runAPIWorkflowTests.sh

### Running the tests with the uber jar:

    cd upload 
    PARALLEL=3 TARGET_ENVIRONMENT=prod TYPE=workflow java -jar getting-started-with-karate-0.0.1.jar

## ReportPortal
### Setup
[Install and setup ReportPortal](https://reportportal.io/installation) as a central server in your organisation

### Configure test framework
* Update [reportportal.properties](./src/test/resources/reportportal.properties) with the appropriate reportportal server and team information

### Enable sending reports to reportportal
You can enable sending reports to reportportal in 2 ways:
1. In [reportportal.properties](./src/test/resources/reportportal.properties), set `rp.enable=true`, or
2. Set environment variable `RP_ENABLE=true` and then run the tests [Running the tests with gradle command]
    Example
    > RP_ENABLE=true TARGET_ENVIRONMENT=prod TYPE=workflow ./runAPIWorkflowTests.sh
    > RP_ENABLE=true TARGET_ENVIRONMENT=prod TYPE=workflow ./gradlew clean test


### Configuration parameters

* `TARGET_ENVIRONMENT=...` -> Run tests for specific environment. Data will be picked up accordingly from test_data.json
* `TYPE=[api | workflow]` -> Type of test to run
* `PARALLEL=...` -> Parallel count for the test execution. Default is `PARALLEL=5`
* `TAG=...` -> Subset of tests to run? Ex: `TAG=confengine` will run all tests having the tag confengine
    * To run test with multiple tags specified, you can use a command like:
  
            TAG=@demo,~@sanity TARGET_ENVIRONMENT=prod TYPE=workflow ./gradlew clean test`

    * To run tests having tags as @tags OR @sample:
  
            TYPE=api  TARGET_ENVIRONMENT=prod  TAG=@tags,@sample ./gradlew clean test
  
    * To run tests having tags as @tags OR @sample AND exclude tags @demo2
  
            TYPE=api  TARGET_ENVIRONMENT=prod  TAG=@tags,@sample:~@demo2 ./gradlew clean test
    
    * To run tests having tags as @tags OR @sample AND exclude tests having either of the following tags: @demo2, @e2e

            TYPE=api  TARGET_ENVIRONMENT=prod  TAG=@tags,@sample:~@demo2:~@e2e ./gradlew clean test


# Guidelines 
Read the [CODING GUIDLINES FOR AUTOMATION USING KARATE](READMEGuideline.md) for writing tests in this framework

# Machine setup

* Install JDK 11 or higher
* Install IntelliJ Idea Community Edition
* Install the following plugins
  * .ignore
  * Cucumber for Java
  * Gherkin
  * SonarLint
  * Gradle
  * Maven
  * Groovy
  * Markdown
  * Properties
  * Shell Script
  * YAML
  * JUnit
  * TestNG
  * Git
  * GitHub
  * Terminal

# Contact
Contact [@BagmarAnand](https://twitter.com/BagmarAnand) for help / information / feedback on this repo
