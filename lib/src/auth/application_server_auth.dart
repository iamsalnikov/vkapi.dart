part of vkapi;

class ApplicationServerAuth extends Auth implements AuthBehavior {

  Future _request = null;
  Future _serverAnswer = null;

  ApplicationServerAuth() {
    _options['grant_type'] = 'client_credentials';
  }

  Future<String> getToken() {
    return _getServerAnswer().then((data) {
      return new Future.value(data['access_token']);
    });
  }

  Future<String> getUserId() {
    return new Future.value("");
  }

  Future<String> getExpiresIn() {
    return _getServerAnswer().then((data) {
      return new Future.value(data['expires_in']);
    });
  }

  Uri get accessUrl {
    var params = {
        'client_id': _options['client_id'],
        'client_secret': _options['client_secret'],
        'v': _options['v'],
        'grant_type': _options['grant_type']
    };

    return Auth.AccessTokenUrl.replace(queryParameters: params);
  }

  Future _getRequest() {
    if (_request != null) {
      return _request;
    }

    _request = http.get(accessUrl);
    return _request;
  }

  Future _getServerAnswer() {
    if (_serverAnswer != null) {
      return _serverAnswer;
    }

    _serverAnswer = _getRequest().then((res) {
      var data = JSON.decode(res.body);
      return new Future.value(data);
    });

    return _serverAnswer;
  }

}