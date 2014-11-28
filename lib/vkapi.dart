library vkapi;

import "dart:async";
import "dart:convert";

import "package:http/http.dart" as http;

part 'src/vk_api.dart';

part 'src/auth/auth_behavior.dart';
part 'src/auth/standalone_auth.dart';
part 'src/auth/server_auth.dart';
part 'src/auth/auth.dart';

part 'src/base_query.dart';
part 'src/query.dart';
part 'src/query_response.dart';

part 'src/helpers/scope.dart';
part 'src/helpers/display.dart';
part 'src/helpers/user_field.dart';
part 'src/helpers/name_case.dart';