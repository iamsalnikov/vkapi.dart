part of vkapi;

class StandaloneAuth extends Auth implements AuthBehavior {

  StandaloneAuth() {
    _options['response_type'] = 'token';
  }

}