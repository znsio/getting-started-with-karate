function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  karate.configure('ssl', { trustAll: true });
  if (!env) {
    env = 'local';
  }
  karate.log('Running tests in env: ', env);
  var config = read('classpath:test_data.json')
  karate.configure('connectTimeout', 30000);
  karate.configure('readTimeout', 60000);
  config = karate.call('classpath:util.js', config[env]);
  var username = java.lang.System.getProperty('user.name').replace(".", "").toLowerCase();
  if (['anandbagmar'].indexOf(username) < 0) {
    username = "ci";
  }
  karate.log('Running test as:', username);
  config.user = username
  return config;
}
