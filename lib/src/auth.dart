part of vkapi;

/**
 * Provide vk app authentication
 */
abstract class Auth {

  static final AccessTokenUrl = new Uri.https("oauth.vk.com", "/access_token");
  static final AuthorizeUrl = new Uri.https("oauth.vk.com", "/authorize");
  static final AccessTokenRegExp = new RegExp(r'access_token=([\w\d]+)');
  static final UserIdRegExp = new RegExp(r'user_id=(\d+)');
  static final ExpiresInRegExp = new RegExp(r'expires_in=(\d+)');

  Map _options = {};

  String _type = '';

  Future _serverFuture = null;
  Map _serverAnswer = {};

  factory Auth.standalone() {
    _options['response_type'] = 'token';
    _type = 'standalone';
  }

  factory Auth.server() {
    _options['response_type'] = 'code';
    _type = 'server';
  }

  String get appId {
    return _options['client_id'];
  }

  void set appId(String id) {
    _options['client_id'] = id;
  }

  String get secret {
    return _options['client_secret'];
  }

  void set secret(String secret) {
    _options['client_secret'] = secret;
  }

  String get redirectUri {
    return _options['redirect_uri'];
  }

  void set redirectUri(String redirectUri) {
    _options['redirect_uri'] = redirectUri;
  }

  void set scopes(List scope) {
    _options['scope'] = scope.join(",");
  }

  void set version(String version) {
    _options['v'] = version;
  }

  void set display(String display) {
    _options['display'] = display;
  }

  void set code(String code) {
    _options['code'] = code;
  }

  dynamic getOption(String optionName) {
    return _options[optionName];
  }

  Uri get url {
    return AuthorizeUrl.replace(queryParameters: _options);
  }

  Uri get accessUrl {
    var params = {
      'client_id': _options['client_id'],
      'client_secret': _options['client_secret'],
      'code': _options['code'],
      'redirect_uri': _options['redirect_uri']
    };

    return AccessTokenUrl.replace(queryParameters: params);
  }

  Future<String> getToken(url) {
    if (_type == 'standalone') {
      return new Future.value(_getStandaloneToken(url));
    }

    if (_type == 'server') {
      return _getServerToken(url);
    }

    return new Future.value("");
  }

  Future<String> _getServerToken(url) {
    return _getServerFuture(url).then((response) {
      if (response == null) {
        return new Future.value("");
      }

      _serverAnswer = JSON.decode(response.body);
      print(_serverAnswer);
      return new Future.value(_serverAnswer['access_token']);
    });
  }

  Future _getServerFuture(url) {
    if (_serverFuture != null) {
      print("use current future");
      return _serverFuture;
    }

    var uri = Uri.parse(url);
    if (!uri.queryParameters.containsKey('code')) {
      return new Future.value(null);
    }
    print("create new future");
    this.code = uri.queryParameters['code'];
    _serverFuture = http.get(accessUrl);

    return _serverFuture;
  }

  /**
   * Extract access token
   */
  String _getStandaloneToken(String url) {
    var m = AccessTokenRegExp.firstMatch(url);

    if (m == null) {
      return "";
    }

    return m.group(1);
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

  /**
   * Get error from url
   */
  String getError(String url) {
    Uri uri = Uri.parse(url);

    if (uri.queryParameters.containsKey('error')) {
      return uri.queryParameters['error'];
    }

    return "";
  }

  /**
   * Get error description from url
   */
  String getErrorDescription(String url) {
    Uri uri = Uri.parse(url);

    if (uri.queryParameters.containsKey('error_description')) {
      return uri.queryParameters['error_description'];
    }

    return "";
  }

}