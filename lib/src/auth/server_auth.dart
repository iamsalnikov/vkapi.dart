part of vkapi;

class ServerAuth extends Auth implements AuthBehavior {

  Future _serverFuture = null;
  Future<Map> _serverAnswer = null;

  ServerAuth() {
    _options['response_type'] = 'code';
  }

  Future<String> getToken(url) {
    return _getServerAnswer(url).then((answer) {
      return new Future.value(answer['access_token']);
    });
  }

  Future<String> getUserId(String url) {
    return _getServerAnswer(url).then((answer) {
      return new Future.value(answer['user_id']);
    });
  }

  Future<String> getExpiresIn(String url) {
    return _getServerAnswer(url).then((answer) {
      return new Future.value(answer['expires_in']);
    });
  }

  Future<String> getEmail(String url) {
    return _getServerAnswer(url).then((answer) {
      return new Future.value(answer['email']);
    });
  }

  Future<String> getServerError(String url) {
    return _getServerAnswer(url).then((answer) {
      return new Future.value(answer['error']);
    });
  }

  Future<String> getServerErrorDescription(String url) {
    return _getServerAnswer(url).then((answer) {
      return new Future.value(answer['error_description']);
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

  Future<Map> _getServerAnswer(url) {
    if (_serverAnswer != null) {
      return _serverAnswer;
    }

    _serverAnswer = _getServerFuture(url).then((response) {
      if (response == null) {
        return new Future.value({});
      }

      var value = JSON.decode(response.body);
      return new Future.value(value);
    });

    return _serverAnswer;
  }

}