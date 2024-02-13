@prod
Feature: Edit the post

  @createPost
  Scenario Outline: Edit the post by creating it
    Given json postedDetails = karate.call('classpath:com/znsio/templates/fetchingUserDetailsJsonPlaceHolder.feature@t_CreatePost', {title:'<title>',body:'<body>',userId:'<userId>'}).post
    * print postedDetails
    * match postedDetails.title == '<title>'
    * match postedDetails.body == '<body>'
    * match postedDetails.userId == '<userId>'
    * def id = postedDetails.userId
    * print "generated id is ", id

    * def input = read('classpath:com/znsio/userDetails.json');
    Given json editedDetails = karate.call('classpath:com/znsio/templates/fetchingUserDetailsJsonPlaceHolder.feature@t_EditPost', {input : input,id : id}).edit
    * print editedDetails
    * match editedDetails.title == input.title
    * match editedDetails.body == input.body
    * match editedDetails.title == '#string'
    * match editedDetails.body == '#string'

    Examples:
      | title |body|userId|
      | Practice| hello | 50|
