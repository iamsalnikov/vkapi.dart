part of vkapi;

class QueryResponse {

  http.Response _original = null;
  Map _decoded = {};

  QueryResponse.fromResponse(http.Response res) {
    _original = res;

    _decoded = JSON.decode(res.body);
  }

  QueryResponse.fromJson(String json) {
    _decoded = JSON.decode(json);
  }

  bool get hasError {
    return _decoded.containsKey('error');
  }

  int get errorCode {
    return hasError ? _decoded['error']['error_code'] : 0;
  }

  String get errorMessage {
    return hasError ? _decoded['error']['error_msg'] : '';
  }

  Map<String, String> get requestParams {
    return hasError ? _decoded['error']['request_params'] : '';
  }

  get data {
    return hasError ? null : _decoded['response'];
  }

  String toString() {
    return _decoded.toString();
  }

}