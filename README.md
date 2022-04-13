# getting-started-with-karate
Sample project to get started with implementing and running karate tests, in a structured fashion.

Results are published in junit, html and cucumber-reporting format

## Running the tests with gradle command:

    `./gradlew test`

Example
    
    `env=prod type=workflow ./gradlew test`

## Running the tests as an uber jar:

- Build an uber jar


    `parallel=3 env=prod tag=demo type=api ./gradlew shadowJar` 

-  in the upload folder with the name like: `upload/getting-started-with-karate-0.0.1.jar`


    `parallel=3 env=prod tag=demo type=api java -jar upload/getting-started-with-karate-0.0.1.jar`

Example

    `env=prod type=workflow ./gradlew test`

### Additional parameters

* `env=...` -> Run tests for specific environment. Data will be picked up accordingly from test_data.json
* `type=[api | workflow]` -> What type of test you want to run?
* `tag=...` -> What subset of tests you want to run? Ex: `tag=confengine` will run all tests having the tag confengine
* `parallel=...` -> What is the parallel count for the test execution. Default is `parallel=5`

# Guidelines 
Read the [Guidelines](READMEGuideline.md) for writing tests in this framework

# Contact
Contact [@BagmarAnand](https://twitter.com/BagmarAnand) for help / information / feedback on this repo
