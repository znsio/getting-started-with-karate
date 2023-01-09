@template
  Feature: API tests for Rest Countries

    Background:
      * karate.log("user: " + user)
      * karate.log("number between: " + isNumberBetween(5,2,19))
      * karate.log("time: " + getCurrentTimeInMillis())
      * karate.log("addLeadingZeroes: " + addLeadingZeroes(5))
      * karate.log("generateRandomEmail: " + generateRandomEmail("email"))
      * karate.log("dateBeforeXDaysInDDMMMYYYYFormat: " + dateBeforeXDaysInDDMMMYYYYFormat(5))
      * karate.log("generateAlphaNumericRandomString: " + generateAlphaNumericRandomString(20))
      * karate.log("randomNumberInRange: " + randomNumberInRange(20,1000))
      Given url env.restCountryUrl
      And karate.log("restCountryUrl: " + env.restCountryUrl)

    @t_getCountries
    Scenario: Get list of countries
      Given def path = "/all"
      And karate.log("Get list of countries from " + env.restCountryUrl + path)
      And path path
      When method GET
      Then status 200
      And karate.log("Length of response:",response.length)
      And def countries = response
      * karate.log("Response from /all: ", response)

    @t_getCountryDetails
    Scenario: Get country details
      Given def path = "/name/" + countryName
      And karate.log("Get country details for '" + countryName + "' from " + env.restCountryUrl + path)
      And path path
      When method GET
      Then status 200

    @t_getCountryCapitalDetails
    Scenario: Get capital city details
      Given def path = "/capital/" + capitalName
      And karate.log("Get capital city details for '" + capitalName + "' from " + env.restCountryUrl + path)
      And path path
      When method GET
      Then status 200