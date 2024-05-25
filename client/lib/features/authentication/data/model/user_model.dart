import 'package:gemini/core/constants/constant.dart';
import 'package:gemini/features/authentication/business/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel(
      {required String name,
      required String email,
      required String phonenumber,
      required String password})
      : super(
            name: name,
            email: email,
            phonenumber: phonenumber,
            password: password);

  Map<String, dynamic> toJson() {
    return {
      kname: name,
      kemail: email,
      kphnumber: phonenumber,
      kpassword: password,
    };
  }
}
