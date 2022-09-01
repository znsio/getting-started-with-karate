#!/bin/bash
#set -e

# To enable debugging, replace the first list with this: `#!/bin/bash -x`

echo "Run the API / API Workflow tests"

testRunCommand=""
if [ -z "$TYPE" ]
then
      echo "TYPE NOT provided"
      exit 1;
else
    TYPE=$(echo "$TYPE" | awk '{print tolower($0)}')
    case "$TYPE" in api | workflow) ;; *)
      printf >&2 'Error. TYPE NOT SET. Run again with TYPE set [api||workflow]\n'
      exit 1
      ;;
    esac
    testRunCommand+="TYPE=$TYPE "
fi

if [ -z "$TARGET_ENVIRONMENT" ]
then
      echo "TARGET_ENVIRONMENT NOT provided"
      exit 1;
else
    testRunCommand+=" TARGET_ENVIRONMENT=$TARGET_ENVIRONMENT "
fi

if [ -z "$PARALLEL" ]
then
      echo "PARALLEL NOT provided. Use default"
else
    echo "Using PARALLEL=$PARALLEL"
    testRunCommand+=" PARALLEL=$PARALLEL "
fi

if [ -z "$TAG" ]
then
      echo "No custom tags provided. Run everything"
else
      echo "Using TAG=$TAG"
      testRunCommand+=" TAG=$TAG "
fi

testRunCommand+=" java -jar *.jar"
echo "Running Karate tests with arguments:: $testRunCommand"
eval "$testRunCommand"