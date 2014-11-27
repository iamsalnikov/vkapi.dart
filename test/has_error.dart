part of testing;

hasError() {
  VkApi vk = new VkApi();
  vk..testMode = true
    ..token = 'error_token';

  return vk.query('users.get', {
      'user_ids': [1, 2],
      'fields': [UserField.PhotoMaxOrig, UserField.About, UserField.Status],
      'name_case': NameCase.Gen
  }).get().then((QueryResponse res) {

    expect(res.hasError, isTrue);
    expect(res.data, isNull);
    expect(res.errorCode, greaterThan(0));
    expect(res.errorMessage, isNot(isEmpty));
    expect(res.requestParams, isNot(isEmpty));

  });
}