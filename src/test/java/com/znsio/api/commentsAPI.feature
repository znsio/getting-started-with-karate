@posts
Feature: API tests for https://jsonplaceholder.typicode.com/
  Background:
    * def isPrime =
"""
function(number) {
 if (number < 2) {
    return false;
  }
  for (let i = 2; i <= Math.sqrt(number); i++) {
    if (number % i === 0) {
      return false;
    }
  }
  return true;
}
"""
  Scenario:Fetch all the comments belonging to prime numbered post IDs
    Given def commentResponse = karate.call('classpath:com/znsio/templates/commentAPITemplate.feature@t_fetchComments').comments
    * print "response from template -->", commentResponse
    When def comments = $commentResponse[*]
    Then def primeComments = karate.filter(comments, function(x){ return isPrime(x.id) })
    * print primeComments
    * match each primeComments[*].id == '#? isPrime(_) == true'
    * match each primeComments[*].name == "#string"
    * match each primeComments[*].name != null
    * match each primeComments[*].email == "#string"
    * match each primeComments[*].email != null
    * match each primeComments[*].body == "#string"
    * match each primeComments[*].body != null
    * match each primeComments[*].postId == "#number"
    * match each primeComments[*].postId != null

  Scenario:Filter the comments which contain the word “et” in text content of the body attribute of comments.
    Given def commentResponse = karate.call('classpath:com/znsio/templates/commentAPITemplate.feature@t_fetchComments').comments
    * print "response from template -->", commentResponse
    When def comments = $commentResponse[*]
    * def filteredComments = comments.filter(x => x.body.includes(' et '))
    * print filteredComments
    * karate.forEach(comments, function(value){ karate.match(value.body, '#string et') })
    * match each filteredComments[*].name == "#string"
    * match each filteredComments[*].name != null
    * match each filteredComments[*].email == "#string"
    * match each filteredComments[*].email != null
    * match each filteredComments[*].postId == "#number"
    * match each filteredComments[*].postId != null

  Scenario:Patch all these comments by replacing “et” with “the” for the text content of the body attribute
    Given def commentResponse = karate.call('classpath:com/znsio/templates/commentAPITemplate.feature@t_fetchComments').comments
    * print "response from template -->", commentResponse
    When def comments = $commentResponse[*]
    * def patchedComments = comments.map(x => ({ ...x, body: x.body.replace(/\bet\b/g, 'the') }))
    * print patchedComments
    * karate.forEach(comments, function(value){ karate.match(value.body, '!#string et') })
    * match each patchedComments[*].name == "#string"
    * match each patchedComments[*].name != null
    * match each patchedComments[*].email == "#string"
    * match each patchedComments[*].email != null
    * match each patchedComments[*].postId == "#number"
    * match each patchedComments[*].postId != null
