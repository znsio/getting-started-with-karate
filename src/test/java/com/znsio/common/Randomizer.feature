@template
Feature: Randomizer Utilities

  @randomizerUtilities
  Scenario: Define randomizer functions
    * def generateRandomNumber =
    """
    function(s) {
      return Math.random().toString().slice(2, s + 2);
    }
    """

    * def findFirst =
    """
    function (arr, key, value) {
      for (var i = 0; i < arr.length; i++) {
        if (arr[i][key] === value) {
          return arr[i];
        }
      }
      throw new Error('Key ' + key + ' Not found');
    }
    """

    * def getCurrentTimeInMillis =
    """
    function () {
      var time = java.lang.System.currentTimeMillis().toString();
      return time;
    }
    """

    * def generateRandomEmail =
    """
    function (prefix) {
      return prefix + generateRandomNumber(5) + '@getnada.com';
    }
    """

    * def addLeadingZeroes =
    """
    function (n) {
      if (n <= 9) {
        return "0" + n;
      }
      return n;
    }
    """

    * def dateBeforeXDaysInDDMMMYYYYFormat =
    """
    function (minusNumDays) {
      var date = new Date();
      date.setDate(date.getDate() - minusNumDays);
      var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
      var formatted_month = months[date.getMonth()];
      var formatted_date = ("0" + date.getDate()).slice(-2);
      return formatted_date + '-' + formatted_month + '-' + date.getFullYear();
    }
    """

    * def dateAfterXDaysInDDMMMYYYYFormat =
    """
    function (afterNumDays) {
      var date = new Date();
      date.setDate(date.getDate() + afterNumDays);
      var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
      var formatted_month = months[date.getMonth()];
      var formatted_date = ("0" + date.getDate()).slice(-2);
      return formatted_date + '-' + formatted_month + '-' + date.getFullYear();
    }
    """

    * def generateAlphaNumericRandomString =
    """
    function (length) {
      var text = "";
      var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      for (var i = 0; i < length; i++) {
        text += possible.charAt(Math.floor(Math.random() * possible.length));
      }
      return text;
    }
    """

    * def randomNumberInRange =
    """
    function (min, max) {
      karate.log('Generate random number randomNumberInRange (Randomizer.feature) in between ' + min + ' and ' + max);
      return Math.floor(Math.random() * (max - min) + min);
    }
    """

    * def isNumberBetween =
    """
    function(number, min, max) {
      karate.log('Is number: ' + number + ' in between ' + min + ' and ' + max);
      return number >= min && number <= max;
    }
    """
