# Configuration parameters

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
