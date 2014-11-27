part of vkapi;

class VkApi {

  Map _params = {};

  String _lang = '';
  String _version = '';
  String _token = '';
  bool _testMode = false;

  set testMode(bool value) {
    _testMode = value;

    if (_testMode) {
      _setParam('test_mode', '1');
    } else if (_params.containsKey('test_mode')) {
      _params.remove('test_mode');
    }
  }

  /**
   * Set one param
   */
  VkApi _setParam(key, value) {
    _params[key] = value;

    return this;
  }

  set token(String value) => _token = value;

  set lang(String value) {
    _lang = value;
    _setParam('lang', value);
  }

  set apiVersion(String value) {
    _version = value;
    _setParam('v', value);
  }

  Query query(method, [params]) {

    if (!(params is Map)) {
      params = {};
    }

    params.addAll(_params);

    return new Query(method, _token, params);

  }

  VkApi reset() {
    _params = {};
    _setParam('lang', _lang);
    _setParam('v', _version);

    if (_testMode) {
      _setParam('test_mode', '1');
    }

    return this;
  }
}