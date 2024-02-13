# getting-started-with-karate
Sample project to get started with implementing and running karate tests, in a structured fashion.

Results are published in junit, html and cucumber-reporting format

## Running the tests with gradle command:

    ./gradlew clean test

Example
    
    TARGET_ENVIRONMENT=prod TYPE=workflow ./gradlew clean test

## Running the tests as an uber jar:

### Build the uber jar

- Build an uber jar:

    `./gradlew shadowJar` 

- The above command will create a jar in the upload folder with the name like: `upload/getting-started-with-karate-0.0.1.jar`

### Running tests using the uber jar

- **Gradle command**: 
  - You can run the test using a gradle command:  

    Example


          TARGET_ENVIRONMENT=prod TYPE=workflow ./gradlew clean test

- **Uber jar**:
  - You can run the tests using the same format as the `./gradlew test` command:

    Example 


          PARALLEL=3 TARGET_ENVIRONMENT=prod TAG=demo TYPE=api java -jar getting-started-with-karate-0.0.1.jar

- **Shell Script**:
  - You can also run the tests using a script file using this command:

    Example


          PARALLEL=3 TARGET_ENVIRONMENT=prod TAG=demo TYPE=api ./runAPIWorkflowTests.sh


### Configuration parameters

* `TARGET_ENVIRONMENT=...` -> Run tests for specific environment. Data will be picked up accordingly from test_data.json
* `TYPE=[api | workflow]` -> What type of test you want to run?
* `TAG=...` -> What subset of tests you want to run? Ex: `TAG=confengine` will run all tests having the tag confengine
  * To run test with multiple tags specified, you can use a command like:
  `TAG=@demo,~@sanity TARGET_ENVIRONMENT=prod TYPE=workflow ./gradlew clean test`
  * To run tests having tags as @tags OR @sample:
  

        TYPE=api  TARGET_ENVIRONMENT=prod  TAG=@tags,@sample ./gradlew clean test
  
  * To run tests having tags as @tags OR @sample AND exclude tags @demo2

    
        TYPE=api  TARGET_ENVIRONMENT=prod  TAG=@tags,@sample:~@demo2 ./gradlew clean test
  * To run tests having tags as @tags OR @sample AND exclude tests having either of the following tags: @demo2, @e2e
    

        TYPE=api  TARGET_ENVIRONMENT=prod  TAG=@tags,@sample:~@demo2:~@e2e ./gradlew clean test

  * `PARALLEL=...` -> What is the parallel count for the test execution. Default is `PARALLEL=5`

# Guidelines 
Read the [Guidelines](READMEGuideline.md) for writing tests in this framework

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
