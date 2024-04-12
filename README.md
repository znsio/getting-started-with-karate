# getting-started-with-karate
Sample project to get started with implementing and running karate tests, in a structured fashion.

Results are published in junit, html and cucumber-reporting format. Results are also published to [ReportPortal](./docs/ReportPortal.md)

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

## [ReportPortal](./docs/ReportPortal.md)

## [Configuration parameters](./docs/ConfigurationParameters.md)

## [Project specific customisations](./docs/ProjectSpecificCustomizations.md)

## [Machine setup](./docs/MachineSetup.md)

## Guidelines 
Read the [CODING GUIDLINES FOR AUTOMATION USING KARATE](docs/READMEGuideline.md) for writing tests in this framework

# Contact
Contact [@BagmarAnand](https://twitter.com/BagmarAnand) for help / information / feedback on this repo
