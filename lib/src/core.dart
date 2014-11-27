part of vkapi;

class Core {

  Map _params = {};

  String _lang = '';
  String _version = '';
  String _token = '';

  /**
   * Set one param
   */
  Core setParam(key, value, [defaultValue = false]) {
    if ( (value == null || value.length == 0) && defaultValue != false ) {
      value = defaultValue;
    }

    _params[key] = value;

    return this;
  }

  set token(String value) => _token = value;

  set lang(String value) {
    _lang = value;
    setParam('lang', value);
  }

  Core setParams(Map params) {
    params.forEach((key, value) {
      setParam(key, value);
    });

    return this;
  }

  set apiVersion(String value) {
    _version = value;
    setParam('v', value);
  }

  Core reset() {
    _params = {};
    setParam('lang', _lang);
    setParam('v', _version);

    return this;
  }

}