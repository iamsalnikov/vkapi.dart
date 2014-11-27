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

}