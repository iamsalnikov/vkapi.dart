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

    expect(res.hasError, true);
    expect(res.data == null, true);
    expect(res.errorCode != 0, true);
    expect(res.errorMessage.length > 0, true);
    expect(res.requestParams.length > 0, true);

  });
}