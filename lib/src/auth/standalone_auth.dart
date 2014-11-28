part of vkapi;

class StandaloneAuth extends Auth implements AuthBehavior {

  static final AccessTokenRegExp = new RegExp(r'access_token=([\w\d]+)');
  static final UserIdRegExp = new RegExp(r'user_id=(\d+)');
  static final ExpiresInRegExp = new RegExp(r'expires_in=(\d+)');

  StandaloneAuth() {
    _options['response_type'] = 'token';
  }

  Future<String> getToken(url) {
    var m = AccessTokenRegExp.firstMatch(url);

    if (m == null) {
      return new Future.value("");
    }

    return new Future.value(m.group(1));
  }

  /**
   * Extract user id
   */
  Future<String> getUserId(String url) {
    var m = UserIdRegExp.firstMatch(url);

    if (m == null) {
      return new Future.value("");
    }

    return new Future.value(m.group(1));
  }

  /**
   * Extract expires in
   */
  Future<String> getExpiresIn(String url) {
    var m = ExpiresInRegExp.firstMatch(url);

    if (m == null) {
      return new Future.value("");
    }

    return new Future.value(m.group(1));
  }

}