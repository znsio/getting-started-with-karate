@template
  Feature: API tests for https://restcountries.com/

    Background:
      Given url env.restCountryUrl

    @t_getCountries
    Scenario: Get list of countries
      * print "Get list of countries from " + env.restCountryUrl
      * def path = "/all"
      Given path path
      When method GET
      Then status 200
      * print response.length
      * def countries = response

