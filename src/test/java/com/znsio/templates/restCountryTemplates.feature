@template
  Feature: API template tests for https://restcountries.com/

    Background:
      And print "user: " + user
      And print "number between: " + isNumberBetween(5,2,19)
      And print "time: " + getCurrentTimeInMillis()
      And print "addLeadingZeroes: " + addLeadingZeroes(5)
      And print "generateRandomEmail: " + generateRandomEmail("email")
      And print "dateBeforeXDaysInDDMMMYYYYFormat: " + dateBeforeXDaysInDDMMMYYYYFormat(5)
      And print "generateAlphaNumericRandomString: " + generateAlphaNumericRandomString(20)
      And print "randomNumberInRange: " + randomNumberInRange(20,1000)
      Given url env.restCountryUrl
      And print "restCountryUrl: " + env.restCountryUrl

    @t_getCountries
    Scenario: Get list of countries
      Given def path = "/all"
      And print "Get list of countries from " + env.restCountryUrl + path
      And path path
      When method GET
      Then status 200
      And def countries = response
      And print "Number of countries:", response.length
      And print "Number of countries:", countries.length
#      And print "Response from /all: ", response

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
