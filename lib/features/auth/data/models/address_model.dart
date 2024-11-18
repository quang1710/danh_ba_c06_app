import 'package:danh_ba_c06_app/features/auth/data/models/adminis_bound_model.dart';
import 'package:danh_ba_c06_app/features/auth/domain/entities/address_entity.dart';
// Class DistrictModel kế thừa từ AdminisBoundEntity
class AddressModel extends AddressEntity {
  const AddressModel ({
    super.province,
    super.district,
    super.ward,
  });
  // Phương thức chuyển đổi từ dữ liệu dạng Map về dạng Model
  factory AddressModel.fromJson(Map<String, dynamic> map) {
    return AddressModel(
      province: AdminisBoundModel.fromJson(map['province']),
      district: AdminisBoundModel.fromJson(map['district']),
      ward: AdminisBoundModel.fromJson(map['ward']),
    );
  }
  // Phương thức chuyển đổi từ dữ liệu dạng Model về dạng String json
  Map<String, dynamic> toJson() {
    return {
      'province': province ?? "",
      'district': district ?? "",
      'ward': ward ?? "",
    };
  }
}