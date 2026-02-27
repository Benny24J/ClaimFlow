import 'package:hive/hive.dart';

part 'user_profile_model.g.dart';

@HiveType(typeId: 1)
class UserProfileModel extends HiveObject {
  @HiveField(0)
  late String fullName;

  @HiveField(1)
  late String email;

  @HiveField(2)
  late String phone;
}