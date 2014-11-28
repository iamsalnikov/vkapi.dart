part of vkapi;

/**
 * Provide vk app authentication
 */
abstract class Auth {

  static final AccessTokenUrl = new Uri.https("oauth.vk.com", "/access_token");
  static final AuthorizeUrl = new Uri.https("oauth.vk.com", "/authorize");

  Map _options = {};

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

  Uri get authUri {
    var options = _options;
    options.remove('client_secret');

    return AuthorizeUrl.replace(queryParameters: options);
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