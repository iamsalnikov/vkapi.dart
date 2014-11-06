part of vkapi;

/**
 * Provide vk app authentication
 */
class Auth {

  static final UrlAccessToken = "https://oauth.vk.com/access_token?client_id=%s&client_secret=%s&code=%s&redirect_uri=%s";
  static final AuthorizeUrl = "https://oauth.vk.com/authorize?%s";

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

}