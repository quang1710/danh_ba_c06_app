import 'package:danh_ba_c06_app/features/auth/data/models/address_model.dart';
import 'package:danh_ba_c06_app/features/auth/domain/entities/user_entity.dart';
// Class DistrictModel kế thừa từ AdminisBoundEntity
class UserModel extends UserEntity {
  const UserModel ({
    required super.id,
    super.username,
    super.fullname,
    super.selfphone,
    super.workphone,
    super.level,
    super.position,
    super.address,
    super.workplace,
  });
  // Phương thức chuyển đổi từ dữ liệu dạng Map về dạng Model
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"] ?? 0,
      username: map["username"] ?? "",
      fullname: map["fullname"] ?? "",
      selfphone: map["selfphone"] ?? "",
      workphone: map["workphone"] ?? "",
      level: map["level"] ?? "",
      position: map["position"] ?? "",
      address: AddressModel.fromJson(map["address"]),
      workplace: AddressModel.fromJson(map["workplace"]),
    );
  }
  // Phương thức chuyển đổi từ dữ liệu dạng Model về dạng String json
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "fullname": fullname,
      "selfphone": selfphone,
      "workphone": workphone,
      "level": level,
      "position": position,
      "address": address,
      "workplace": workplace,
    };
  }
}