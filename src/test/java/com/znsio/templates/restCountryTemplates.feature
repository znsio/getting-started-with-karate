@template
  Feature: API tests for https://restcountries.com/

    Background:
      * print "user: " + user
      * print "number between: " + isNumberBetween(5,2,19)
      * print "time: " + getCurrentTimeInMillis()
      * print "addLeadingZeroes: " + addLeadingZeroes(5)
      * print "generateRandomEmail: " + generateRandomEmail("email")
      * print "dateBeforeXDaysInDDMMMYYYYFormat: " + dateBeforeXDaysInDDMMMYYYYFormat(5)
      * print "dateBeforeXDaysInDDMMYYYYFormat: " + dateBeforeXDaysInDDMMYYYYFormat(5)
      * print "dateAfterXDaysInDDMMMYYYYFormat: " + dateAfterXDaysInDDMMMYYYYFormat(5)
      * print "dateInDDMMYYYYFormatWithSlash: " + dateInDDMMYYYYFormatWithSlash(5)
      * print "generateStartTime: " + generateStartTime()
      * print "generateEndTime: " + generateEndTime()
      * print "generateEndDate: " + generateEndDate()
      * print "generateAlphaNumericRandomString: " + generateAlphaNumericRandomString(20)
      * print "randomNumberInRange: " + randomNumberInRange(20,1000)
      * print "generateTime: " + generateTime(5,10,20)
      * print "offsetCurrentTimeByHours: " + offsetCurrentTimeByHours(5)
      Given url env.restCountryUrl
      And print "restCountryUrl: " + env.restCountryUrl

    @t_getCountries
    Scenario: Get list of countries
      Given def path = "/all"
      And print "Get list of countries from " + env.restCountryUrl + path
      And path path
      When method GET
      Then status 200
      And print response.length
      And def countries = response

    @t_getCountryDetails
    Scenario: Get country details
      Given def path = "/name/" + countryName
      And print "Get country details for '" + countryName + "' from " + env.restCountryUrl + path
      And path path
      When method GET
      Then status 200
#      And print response
#      And def countryDetails = response

    @t_getCountryCapitalDetails
    Scenario: Get capital city details
      Given def path = "/capital/" + capitalName
      And print "Get capital city details for '" + capitalName + "' from " + env.restCountryUrl + path
      And path path
      When method GET
      Then status 200
#      And print response
#      And def capitalCity = response