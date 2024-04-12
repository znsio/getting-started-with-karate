@template
Feature: Common Headers

  @commonheaders
  Scenario: Set common headers
    * def headerJson =
    """
    {
      "Authorization": "Bearer Invalid",
      "Data": "Invalid",
      "RandomNo": "#(randomNumber)",
      "StoreId": "#(store.storeID)",
      "X-API-Key": "#(env.xapikey)",
      "Content-Type":"application/x-www-form-urlencoded"
    }
    """

    * def headerJsonJava =
    """
    {
      "Authorization": "Bearer Invalid",
      "Data": "Invalid",
      "RandomNo": "#(randomNumber)",
      "StoreId": "#(store.storeID)",
      "X-API-Key": "#(env.xapikey)",
    }
    """
