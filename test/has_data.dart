part of testing;

hasData() {
  VkApi vk = new VkApi();
  vk..testMode = true
    ..token = getToken();

  return vk.query('users.get', {
      'user_ids': [1, 2],
      'fields': [UserField.PhotoMaxOrig, UserField.About, UserField.Status],
      'name_case': NameCase.Gen
  }).get().then((QueryResponse res) {
    print(res.errorMessage);
    expect(res.hasError, isFalse);
    expect(res.data, isNotNull);
  });
}