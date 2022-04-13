function fn() {
  karate.log('In karate-config.js');
  karate.log('env: ', karate.env);
  var env = karate.env; // get system property 'karate.env'
  karate.log('from property: env: ', env);
  karate.configure('ssl', { trustAll: true });
  var config = read('classpath:test_data.json');
  karate.configure('connectTimeout', 30000);
  karate.configure('readTimeout', 60000);
  config = function() {
        // If you add Java code in utils.js, you may end up with the following error when running tests as a fatjar:
        // org.graalvm.polyglot.PolyglotException: SyntaxError: No language for id regex found. Supported languages are: [js]
        // See this post for reference: https://github.com/karatelabs/karate/issues/1515
        // https://github.com/karatelabs/karate/issues/1515#issuecomment-800856613
        // https://github.com/karatelabs/karate/issues/1515#issuecomment-808898387
      karate.callSingle('classpath:util.js', config[env]);
    }
  var username = java.lang.System.getProperty('user.name').replace(".", "").toLowerCase();
  if (['anandbagmar'].indexOf(username) < 0) {
    username = "ci";
  }
  karate.log('Running test as:', username);
  config.user = username;
  return config;
}