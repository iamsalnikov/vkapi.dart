part of vkapi;

class Query extends BaseQuery {

  /**
   * Constructor
   */
  Query(method, token, [params]) {
    _methodName = method;
    _accessToken = token;

    if (params is Map) {
      _params = params;
    }
  }

}