function fn(config) {
  config.findFirst = function (arr, key, value) {
    for (var i = 0; i < arr.length; i++) {
      if (arr[i][key] === value) {
        return arr[i];
      }
    }
    throw new Error('Key ' + key + ' Not found');
  };
  config.findFirstValidateNegative = function (arr, key, value) {
    for (var i = 0; i < arr.length; i++) {
      if (arr[i][key] === value) {
        return arr[i];
      }
    }
    return ('Not found');
  };
  config.getCurrentTimeInMillis = function () {
    var time = java.lang.System.currentTimeMillis().toString();
    var currTime = time.substr(0, 10);
    return currTime;
  };
  config.getTimeInMilliSec = function () {
    var time = java.lang.System.currentTimeMillis().toString();
    return time;
  };
  config.generateRandomNumber = function (length) {
    return Math.random().toFixed(length).split('.')[1];
  };
  config.generateRandomEmail = function (prefix) {
    return prefix + generateRandomNumber(5) + '@getnada.com';
  };
  config.addLeadingZeroes = function appendLeadingZeroes(n) {
    if (n <= 9) {
      return "0" + n;
    }
    return n;
  };
  config.dateBeforeXDaysInDDMMMYYYYFormat = function (minusNumDays) {
    var date = new Date();
    date.setDate(date.getDate() - minusNumDays);
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    var formatted_month = months[date.getMonth()];
    var formatted_date = ("0" + date.getDate()).slice(-2);
    return formatted_date + '-' + formatted_month + '-' + date.getFullYear();
  };
  config.dateAfterXDaysInDDMMMYYYYFormat = function (minusNumDays) {
    var date = new Date();
    date.setDate(date.getDate() + minusNumDays);
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    var formatted_month = months[date.getMonth()];
    var formatted_date = ("0" + date.getDate()).slice(-2);
    return formatted_date + '-' + formatted_month + '-' + date.getFullYear();
  };
  config.dateBeforeXDaysInDDMMYYYYFormat = function (minusNumDays) {
    var date = new Date();
    date.setDate(date.getDate() - minusNumDays);
    return addLeadingZeroes(date.getDate()) + "-" + addLeadingZeroes(date.getMonth() + 1) + "-" + date.getFullYear();
  };
  config.dateInDDMMYYYYFormatWithSlash = function (minusNumDays) {
    var date = new Date();
    date.setDate(date.getDate() - minusNumDays);
    return addLeadingZeroes(date.getDate()) + "/" + addLeadingZeroes(date.getMonth() + 1) + "/" + date.getFullYear();
  };
  // need to test and fix
  config.generateStartTime = function () {
    var date = new Date();
    date.setDate(date.getDate() + 15);
    return addLeadingZeroes(date.getDate()) + "/" + addLeadingZeroes(date.getMonth() + 1) + "/" + date.getFullYear();
  };
  config.generateEndTime = function () {
    var date = new Date();
    date.setDate(date.getDate() + 45);
    return addLeadingZeroes(date.getDate()) + "/" + addLeadingZeroes(date.getMonth() + 1) + "/" + date.getFullYear();
  };
  config.generateEndDate = function () {
    var date = new Date();
    date.setDate(date.getDate() - 15);
    return addLeadingZeroes(date.getDate()) + "/" + addLeadingZeroes(date.getMonth() + 1) + "/" + date.getFullYear();
  };
  // ending 
  config.generateAlphaNumericRandomString = function (length) {
    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    for (var i = 0; i < length; i++) {
      text += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    return text;
  };
  config.randomNumberInRange = function (min, max) {
    return Math.floor(Math.random() * (max - min) + min);
  };
  config.generateTime = function (adjDays, adjHours, adjMins) {
    var date = new Date();
    date.setDate(date.getDate() + adjDays);
    date.setHours(date.getHours() + adjHours);
    date.setMinutes(date.getMinutes() + adjMins);
    karate.log("#######", date.toISOString())
    return date.toISOString();
  };
  config.offsetCurrentTimeByHours = function (offsetInHours) {
    var date = new Date();
    date.setHours(date.getHours() + offsetInHours);
    date.setMilliseconds(0);
    return date.toISOString();
  };
  config.validateTimeStampFormat = function (ts) {
    var SimpleDateFormat = Java.type("java.text.SimpleDateFormat");
    var sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    try {
      sdf.parse(ts).time;
      karate.log('*** date string:', ts);
      return ts;
    } catch (e) {
      karate.log('*** invalid date string:', ts);
      throw (e);
    }
  };
  config.isNumberInRange = function(number, min, max) {
    return number >= min && number <= max;
  };
  function escapeRegExp(stringToGoIntoTheRegex) {
    return stringToGoIntoTheRegex.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
  }
  return config;
}