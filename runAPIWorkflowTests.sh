#!/bin/bash
#set -e

# To enable debugging, replace the first list with this: `#!/bin/bash -x`

echo "Run the API / API Workflow tests"

testRunCommand="java -jar *.jar"
echo "Running Karate tests with arguments:: $testRunCommand"
eval "$testRunCommand"
