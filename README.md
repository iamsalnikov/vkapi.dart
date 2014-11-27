# VkApi.dart

Пакет `vkapi.dart` дает возможность работать с API vk.com на Dart.

На данный момент реализована только самая базовая функциональность и многое еще предстоит
сделать.

## Получение токена для работы с API

Для того, чтобы работать с API vk.com нам необходимо иметь токен (но он необходим не для всех
методов). Сейчас реализован только один способ авторизации приложения -
[клиентская авторизация](https://vk.com/dev/auth_mobile), которая подходит для
[Standalone-приложений](https://vk.com/dev/standalone).

### Клиентская авторизация

На первом шаге клиентской авторизации мы должны создать объект класса `Auth`, c помощью конструктора
`Auth.standalone()`. Затем указать ID приложения, redirect uri, набор scopes, версию api.
Полный список параметров, которые можно установить для получения токена:

Параметр      | Описание
--------------|----------------------------------|
`appId`       | Идентификатор Вашего приложения  |
`redirectUri` | Url, на который будет перенаправлен пользователь после подтверждения/отклонения запроса на авторизацию приложения. Для standalone-приложений рекомендуется выставить значение `redirectUri` |
`scopes`      | Список прав, которые необходимы приложению. Для простоты можно воспользоваться константами класса `Scope`. Пример: `[Scope.Friends, Scope.Photos, Scope.Audio]` |
`display`     | Внешний вид окна авторизации. Для простоты можно воспользоваться константами класса `Display`. Пример: `Display.Mobile`. Это необязательный параметр |
`version`     | Версия Api, которую используем   |

После этого мы можем получить ссылку, на которую нужно направить пользователя с помощью геттера `url`.

Пример получения ссылки, на которую нужно направить пользователя:

```dart
import "package:vkapi/vkapi.dart";

void main() {

  Auth auth = new Auth.standalone();
  auth..appId = "APP_ID"
      ..redirectUri = "https://oauth.vk.com/blank.html"
      ..version = "5.27"
      ..scopes = [Scope.Friends, Scope.Photos, Scope.Audio];

  // Выведем ссылку на консоль
  print(auth.url);

}
```

После получения ссылки мы должны направить по ней пользователя, чтобы он подтвердил или отказался от
выдачи прав приложению. После того, как пользователь сделает свой выбор мы должны будем получить url,
на который он будет перенаправлен. После получения url мы можем извлечь из него токен, время его жизни,
id пользователя, а если произошла ошибка - то ошибку и ее описание.

Пример получения информации из url:

```dart

import "package:vkapi/vkapi.dart";

void main() {

  Auth auth = new Auth.standalone();

  var url = "https://oauth.vk.com/blank.html#access_token=accesstoken&expires_in=86400&user_id=1";
  var errorUrl = "http://oauth.vk.com?error=access_denied&error_description=The+user+or+authorization+server+denied+the+request.";

  // Получим токен
  print(auth.getToken(url: url));
  // Получим ID пользователя
  print(auth.getUserId(url));
  // Получим время жизни токена
  print(auth.getExpiresIn(url));

  // Получим ошибку
  print(auth.getError(errorUrl));
  // Получим описание ошибки
  print(auth.getErrorDescription(errorUrl));

}

```