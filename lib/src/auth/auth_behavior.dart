part of vkapi;

abstract class AuthBehavior {

  Future<String> getToken(String url);

  Future<String> getUserId(String url);

  Future<String> getExpiresIn(String url);

  Uri get authUri;

}