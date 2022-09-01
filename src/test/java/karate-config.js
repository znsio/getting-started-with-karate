function fn() {
  karate.log('In karate-config.js');
  karate.log('env: ', karate.env);
  var env = karate.env; // get system property 'karate.env'
  karate.log('from property: env: ', env);
  karate.configure('ssl', { trustAll: true });
  karate.configure('connectTimeout', 30000);
  karate.configure('readTimeout', 60000);

  var config = read('classpath:test_data.json');
  config = config[env];
  var username = java.lang.System.getProperty('user.name').replace(".", "").toLowerCase();
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

//  karate.log('Running test with config:', config);
  return config;
}