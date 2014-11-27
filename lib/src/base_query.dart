part of vkapi;

abstract class BaseQuery {

  static final QueryUri = new Uri.https('api.vk.com', '/method');

  Map _params = {};
  String _accessToken = '';
  String _methodName = '';

  http.Response originalResponse = null;
  String data = '';

  /**
   * Get query uri for api request
   */
  Uri get queryUri {
    var params = _params;
    params['access_token'] = _accessToken;

    var path = '/method/' + _methodName;

    return new Uri.https('api.vk.com', path, _params);
  }

  Future get() {
    return http.get(queryUri).then((http.Response res) {
      print(res.body);
    });
  }

  String toString() {
    return queryUri.toString();
  }

}