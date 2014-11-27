part of testing;

void hasData() {
  VkApi vk = new VkApi();
  vk..testMode = true
    ..token = getToken();

  vk.query('users.get', {
      'user_ids': [1, 2],
      'fields': [UserField.PhotoMaxOrig, UserField.About, UserField.Status],
      'name_case': NameCase.Gen
  }).get().then((QueryResponse res) {
    expect(res.hasError, false);
  });
}