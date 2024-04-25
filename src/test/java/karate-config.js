function fn() {
  karate.log('In karate-config.js');
  karate.log('env: ', karate.env);
  var env = karate.env; // get system property 'karate.env'
  karate.log('from property: env: ', env);
  karate.configure('ssl', { trustAll: true });
  karate.configure('connectTimeout', 30000);
  karate.configure('readTimeout', 60000);

  var testDataFile = java.lang.System.getProperty('TEST_DATA_FILE_NAME');
  karate.log('Loading testDataFile: ', testDataFile);
  var config = read(`classpath:${testDataFile}`);
  config = config[env];

  /* Begin update of configuration based on project needs */
  var username = java.lang.System.getProperty('user.name').replace(".", "").toLowerCase();

  // Add logic to determine if running in CI
  if (['anandbagmar'].indexOf(username) < 0) {
    username = "ci";
  }
  karate.log('Running test as:', username);
  config.user = username;

  var loadCommonFunctions = function() {
    return karate.callSingle('classpath:util.js', config);
  }
  config = loadCommonFunctions();

  var randomizer = function() {
    return karate.callSingle('classpath:com/znsio/common/Randomizer.feature@randomizerUtilities', config);
  }
  config = randomizer();

  //  Calling a function from randomizer
  //  karate.log("Random number: ", config.generateRandomNumber(10))

  /* End update of configuration based on project needs */

  //  karate.log('Running test with config:', config);
  return config;
}
