@posts
Feature: API flow tests for https://jsonplaceholder.typicode.com/

  Scenario: Fetch comments for prime numbered posts IDs, Filter comments which contain the word “et” in text content of the body attribute and
  Patch all comments by replacing “et” with “the” for the text content of the body attribute

    Given def commentResponse = karate.call('classpath:com/znsio/templates/commentAPITemplate.feature@t_fetchComments').comments
    * print "response from template -->", commentResponse
    When def comments = $commentResponse[*]

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

    Then def primeComments = karate.filter(comments, function(x){ return isPrime(x.postId) })
    * match each primeComments[*].postId == '#? isPrime(_) == true'
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

    And def patchCall =
"""
function(dataList) {
  for (var index in dataList) {
    karate.log('index ---', index)
    var postId = dataList[index].postId
    karate.log("postId ---", postId)
    var body = dataList[index].body
    karate.log("body ---", body)
    karate.call('classpath:com/znsio/templates/commentAPITemplate.feature@t_patchComments', { "requestBody": { "postId": postId, "body": body } })
  }
}
"""

    * call patchCall(patchedComments)
