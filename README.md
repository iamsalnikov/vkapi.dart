# VkApi.dart

Пакет `vkapi.dart` дает возможность работать с API vk.com на Dart.

На данный момент реализована только самая базовая функциональность и многое еще предстоит
сделать.

## Получение токена для работы с API

Для того, чтобы работать с API vk.com нам необходимо иметь токен (но он необходим не для всех
методов). Сейчас реализовано два способа авторизации приложения:

1. [клиентская авторизация](https://vk.com/dev/auth_mobile) - подходит для
[Standalone-приложений](https://vk.com/dev/standalone).
2. [серверная авторизация](https://vk.com/dev/auth_sites) - подходит для подключения
сайтов и сторонних мобильных платформ.

### Клиентская авторизация

На первом шаге клиентской авторизации мы должны создать объект класса `StandaloneAuth` c помощью конструктора
`StandaloneAuth()`. Затем указать ID приложения, redirect uri (для `standalone` это обычно `https://oauth.vk.com/blank.html`), набор scopes, версию api.
Полный список параметров, которые можно установить для получения токена:

Параметр      | Описание
--------------|----------------------------------|
`appId`       | Идентификатор Вашего приложения  |
`redirectUri` | Url, на который будет перенаправлен пользователь после подтверждения/отклонения запроса на авторизацию приложения. Для standalone-приложений рекомендуется выставить значение `redirectUri` |
`scopes`      | Список прав, которые необходимы приложению. Для простоты можно воспользоваться константами класса `Scope`. Пример: `[Scope.Friends, Scope.Photos, Scope.Audio]` |
`display`     | Внешний вид окна авторизации. Для простоты можно воспользоваться константами класса `Display`. Пример: `Display.Mobile`. Это необязательный параметр |
`version`     | Версия Api, которую используем   |
`secret`      | Секретный ключ приложения        |

> **Примечание:**
>
> `redirectUri` в классе `StandaloneAuth` по-умолчанию установлен в `https://oauth.vk.com/blank.html`

После этого мы можем получить ссылку, на которую нужно направить пользователя с помощью геттера `authUri`.

Пример получения ссылки, на которую нужно направить пользователя:

```dart
import "package:vkapi/vkapi.dart";

void main() {

  var auth = new StandaloneAuth();
  auth..appId = "APP_ID"
      ..version = "5.27"
      ..scopes = [Scope.Friends, Scope.Photos, Scope.Audio];

  // Выведем ссылку на консоль
  print(auth.authUri);

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

  var auth = new StandaloneAuth();

  var url = "https://oauth.vk.com/blank.html#access_token=accesstoken&expires_in=86400&user_id=1";
  var errorUrl = "http://oauth.vk.com?error=access_denied&error_description=The+user+or+authorization+server+denied+the+request.";

  var list = [auth.getToken(url), auth.getUserId(url), auth.getExpiresIn(url)];

  Future.wait(list).then((List values) {
    print(values);
  });

  // Получим ошибку
  print(auth.getError(errorUrl));
  // Получим описание ошибки
  print(auth.getErrorDescription(errorUrl));

}
```

Методы `getToken()`, `getUserId()`, `getExpiresIn()` возвращают `Future<String>`.

#### Пример того, как можно получить токен в Chrome Packaged App

Для получения токена в Chrome Packaged App мы можем создать объект webview, у которого указать URL для получения прав.
После решения пользователя по выдаче прав приложению получить текущий url webview (который сменится) и извлечь из него
токен, либо информацию об ошибке.

### Серверная авторизация

На первом шаге серверной мы должны создать объект класса `ServerAuth` c помощью конструктора
`ServerAuth()`. Затем указать ID приложения, redirect uri, набор scopes, версию api.
Полный список параметров, которые можно установить для получения токена точно такой же, как и для класса
`StandaloneAuth`, который описан в разделе **Клиентская авторизация**.

Пример получения ссылки, на по которой нужно направить пользователя при серверной авторизации:

```dart
var auth = new ServerAuth();
auth..appId = "APP_ID"
    ..redirectUri = "http://redirect.uri/"
    ..version = "5.27"
    ..scopes = [Scope.Friends, Scope.Photos, Scope.Email, Scope.Audio];
print(auth.authUri);
```

После того, как пользователь прошел по ссылке и принял/отклонил запрос на выдачу прав приложению мы можем
попытаться получить токен, либо обработать ошибки.

Вот список методов, с помощью которых мы можем это сделать:

Метод                             | Описание
----------------------------------|------------------------------------------------------------------------------------------|
`getToken(url)`                   | получение токена по url, на который после выдачи прав был перенаправлен пользователь. Возвращает `Future<String>`, значением которого будет токен |
`getUserId(url)`                  | получение id пользователя по url. Возвращает `Future<String>`, значением которого будет ID пользователя |
`getExpiresIn(url)`               | получение времени жизни токена |
`getEmail(url)`                   | если были запрошены права на получение email, то вернет `Future<String>`, значением которого будет email |
`getError(url)`                   | получаем ошибку по url. Эту ошибку мы возьмем из параметров URL |
`getErrorDescription(url)`        | получаем описание ошибки по url. Эту ошибку мы возьмем из параметров URL |
`getServerError(url)`             | получаем ошибку, которая приходит в ответ на попытку получить токен. Возвращает `Future<String>` с текстом ошибки |
`getServerErrorDescription(url)`  | получаем описание ошибки, которая приходит в ответ на попытку получить токен. Возвращает `Future<String> с описанием ошибки |

*Заметьте*, что перед тем, как попытаться получить токен, нужно указать секретный ключ приложения через сеттер `secret`.

Пример получения токена:

```dart
ServerAuth auth = new ServerAuth();
auth..appId = "APP_ID"
    ..secret = 'APP_SECRET'
    ..redirectUri = "http://redirect.uri/"
    ..version = "5.27"
    ..scopes = [Scope.Friends, Scope.Photos, Scope.Email, Scope.Audio];

var url = "http://redirect.uri/?code=hardcode";
var errorUrl = "http://redirect.uri/?error=access_denied&error_reason=user_denied&error_description=User+denied+your+request";

var list = [
    auth.getToken(url),
    auth.getUserId(url),
    auth.getExpiresIn(url),
    auth.getEmail(url),
    auth.getServerError(url),
    auth.getServerErrorDescription(url)
];
Future.wait(list).then((List values) {
  print(values);
});

print(auth.getError(errorUrl));
print(auth.getErrorDescription(errorUrl));
```

#### Пример последовательности действий для получения токена с помощью серверной авторизации

1. Создаем объект `ServerAuth`, указываем значения для нужных полей и отправляем пользователя по полученной ссылке
2. После того, как пользователь был снова перенаправлен на наш сайт, получаем url и передаем его необходимым методам:
`getToken()`, `getUserId()`, `getExpiresIn()`, `getEmail()`, `getServerError()`, `getServerErrorDescription()`,
`getError()`, `getErrorDescription()`.

## Выполнение запросов к API

После того, как получен токен, можно выполнять запросы к API vk.com. Для этого нужно создать экземлпяр класса `VkApi`
и установить его свойство `token` в значение, равное значению токена.

Пример:

```dart
import "package:vkapi/vkapi.dart";

void main() {

  Auth auth = new Auth.standalone();

  var url = "https://oauth.vk.com/blank.html#access_token=accesstoken&expires_in=86400&user_id=1";

  VkApi vk = new VkApi();
  vk.token = auth.getToken(url: url);

}
```

Но токен - это не все, что можно указать у объекта класса `VkApi`. Вот полный список его свойств, которые
можно установить:

Параметр      | Описание
--------------|----------------------------------|
`token`       | Токен для работы с API           |
`lang`        | Определяет язык, на котором будут возвращаться различные данные, например названия стран и городов. Также если указан не русский, украинский и белорусский язык, то кириллические имена будут автоматически транслированы в латиницу. **ru** - Русский, **ua** - Украинский, **be** - Белорусский, **en** - Английский, **es** - Испанский, **fi** - Финский, **de** - Немецкий, **it** - Итальянский. Также поддерживается числовой идентификатор языка, возвращаемый методом [account.getInfo](https://vk.com/dev/account.getInfo) |
`apiVersion`  | Версия API                       |
`testMode`    | Принимает `true` или `false` в зависимости от использования тестового режима. Тестовый режим, позволяет выполнять запросы из нативного приложения без его включения на всех пользователей. |

Для осуществления запроса к API нужно вызвать метод `query()` объекта класса `VkApi`.
Метод `query()` принимает два параметра:

* `method` - строковое имя метода, который вызываем. Например `'users.get'`
* `params` - дополнительные параметры для запроса. В качестве данного параметра
передается значение типа `Map`, где ключ - имя параметра, а значение - это значение параметра. Если в качестве
значения параметра будет передан `List`, то для него вызовется метод `List.join(',')` перед формированием строки
запроса.

Метод `query()` возвращает объект класса `Query`, у которого есть один метод `get()`, который выполняет запрос
и возвращает `Future<QueryResponse>`. Объект класса `QueryResponse` обладает следующими свойствами:

Свойство      | Описание
--------------|----------------------------------|
`hasError`    | Была ли ошибка при выполнении запроса |
`errorCode`   | Код ошибки                       |
`errorMessage`| Сообщение об ошибке              |
`requestParams` | Параметры запроса. Если ошибки не было, то вернет `null` |
`data`        | Данные, которые вернул сервер API. Если была ошибка, то вернет `null` |

Пример выполнения запроса на получение списка пользователей:

```dart
import "package:vkapi/vkapi.dart";

void main() {
  Auth auth = new Auth.standalone();

  var url = "https://oauth.vk.com/blank.html#access_token=accesstoken&expires_in=86400&user_id=1";

  VkApi vk = new VkApi();
  vk.token = auth.getToken(url: url);

  Query q = vk.query('users.get', {'user_ids': [1, 2, 3]});
  q.get().then(processResponse);
}

void processResponse(QueryResponse data) {

  print("");
  print("Response has error: ${data.hasError ? 'true' : 'false'}");
  print("Response error code: ${data.errorCode}");
  print("Response error message: ${data.errorMessage}");
  print("Response request params: ${data.requestParams}");
  print("Response data: ${data.data}");

}
```
