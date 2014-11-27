library testing;

import "dart:io";

import "package:unittest/unittest.dart";
import "package:vkapi/vkapi.dart";

part "get_token.dart";
part "has_data.dart";

main() {

  test("Has data", hasData);

}