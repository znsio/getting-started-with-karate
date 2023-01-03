Feature: JsonPlaceholder Utilities

  @jsonPlaceholderUtilities @template
  Scenario: JsonPlaceholder common functions
    * def buildQuery =
    """
    function(query){
     var map = new Map();
     for(var key in query){

        map[key] = query[key];
     }
    for(var key in map){
        if(map[key].length == 0){
            delete query[key];
        }

     }
      return query;
    }
  """
