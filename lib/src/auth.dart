part of vkapi;

/**
 * Provide vk app authentication
 */
class Auth {

  static final AccessTokenUrl = new Uri.https("oauth.vk.com", "/access_token");
  static final AuthorizeUrl = new Uri.https("oauth.vk.com", "/authorize");

  Map _options = {};

  /**
   * Constructor
   */
  Auth() {
    _options['response_type'] = 'code';
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

  Set get scope {
    return _options['scope'];
  }

  void set scope(Set scope) {
    _options['scope'] = scope;
  }

  void set version(String version) {
    _options['v'] = version;
  }

  dynamic getOption(String optionName) {
    return _options[optionName];
  }

  Uri getUrl() {
    return AuthorizeUrl.replace(queryParameters: _options);
  }

}