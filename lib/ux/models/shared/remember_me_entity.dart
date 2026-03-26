import 'package:isar/isar.dart';

part 'remember_me_entity.g.dart';

@collection
class RememberMeEntity {
  Id id = 1; // always single record

  String? email;
  String? password;
  bool rememberMe = false;
}