@posts
Feature: API flow tests for https://jsonplaceholder.typicode.com/

  Scenario: Fetch comments for prime numbered posts IDs, Filter comments which contain the word “et” in text content of the body attribute and
  Patch all comments by replacing “et” with “the” for the text content of the body attribute

    Given def commentResponse = karate.callSingle('classpath:com/znsio/templates/commentAPITemplate.feature@t_fetchComments')
#  * def prime = read('classpath:com/znsio/common/CheckPrime.feature@primeNoCheckerUtility')
    * print "response from template -->", commentResponse
    When def comments = $commentResponse[*]
    Then def primeComments = karate.filter(comments, function(x){ return checkPrime.isPrime(x.id) })
    * match each primeComments[*].id == '#? prime.isPrime(_) == true'
    * print primeComments
    * def filteredComments = primeComments.filter(x => x.body.includes(' et '))
    * print filteredComments
    * karate.forEach(filteredComments, function(value){ karate.match(value.body, '#string et') })
    * def patchedComments = filteredComments.map(x => ({ ...x, body: x.body.replace(/\bet\b/g, 'the') }))
    * print patchedComments
    * karate.forEach(patchedComments, function(value){ karate.match(value.body, '!#string et') })
    * match each patchedComments[*].name == "#string"
    * match each patchedComments[*].name != null
    * match each patchedComments[*].email == "#string"
    * match each patchedComments[*].email != null
    * match each patchedComments[*].postId == "#number"
    * match each patchedComments[*].postId != null