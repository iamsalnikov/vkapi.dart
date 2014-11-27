library testing;

import "dart:io";

import "package:unittest/unittest.dart";
import "package:vkapi/vkapi.dart";

part "get_token.dart";
part "has_data.dart";
part "has_error.dart";

main() {

  group("Access token test", () {
    test("Has data", hasData);
    test("Has error", hasError);
  });


}