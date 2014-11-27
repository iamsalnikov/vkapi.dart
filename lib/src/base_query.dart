part of vkapi;

abstract class BaseQuery {

  static final QueryUri = new Uri.https('api.vk.com', '/method');

  Map _params = {};
  String _accessToken = '';
  String _methodName = '';

  QueryResponse response = null;

  /**
   * Get query uri for api request
   */
  Uri get queryUri {
    Map params = _params;
    params['access_token'] = _accessToken;

    params = _normalizeParams(params);

    var path = '/method/' + _methodName;

    return new Uri.https('api.vk.com', path, params);
  }

  Future<QueryResponse> get() {
    return http.get(queryUri).then((http.Response res) {
      response = new QueryResponse.fromResponse(res);

      return new Future.value(response);
    });
  }

  String toString() {
    return queryUri.toString();
  }

  /**
   * Normalize params
   *
   * In this method we just convert lists to string
   */
  Map _normalizeParams(params) {
    params.forEach((key, value) {
      if (value is List) {
        value = value.join(',');
      }
      params[key] = value;
    });

    return params;
  }

}