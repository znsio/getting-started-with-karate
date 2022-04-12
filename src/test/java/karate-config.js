function fn() {
  karate.log('In karate-config.js');
  karate.log('env: ', karate.env);
  var env = karate.env; // get system property 'karate.env'
  karate.log('from property: env: ', env);
  karate.configure('ssl', { trustAll: true });
  var config = read('classpath:test_data.json');
  karate.configure('connectTimeout', 30000);
  karate.configure('readTimeout', 60000);
  config = karate.call('classpath:util.js', config[env]);
  var username = java.lang.System.getProperty('user.name').replace(".", "").toLowerCase();
  if (['anandbagmar'].indexOf(username) < 0) {
    username = "ci";
  }
  karate.log('Running test as:', username);
  config.user = username;
  return config;
}
