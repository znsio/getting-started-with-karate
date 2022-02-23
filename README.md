# getting-started-with-karate
Sample project to get started with implementing and running karate tests, in a structured fashion.

Results are published in junit, html and cucumber-reporting format

## Usage

`./gradlew test`

### Additional parameters

* `env=...` -> Run tests for specific environment. Data will be picked up accordingly from test_data.json
* `type=[api | workflow]` -> What type of test you want to run?
* `tag=...` -> What subset of tests you want to run? Ex: `tag=confengine` will run all tests having the tag confengine

# Contact
Contact [@BagmarAnand|https://twitter.com/BagmarAnand] for help / information / feedback on this repo 