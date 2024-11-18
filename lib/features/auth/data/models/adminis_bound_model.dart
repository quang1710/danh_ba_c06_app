import 'package:danh_ba_c06_app/features/auth/domain/entities/adminis_bound_entity.dart';
// Class AdminisBoundModel kế thừa từ AdminisBoundEntity
class AdminisBoundModel extends AdminisBoundEntity {
  const AdminisBoundModel ({
    super.id,
    super.name,
    super.code,
  });
  // Phương thức chuyển đổi từ dữ liệu dạng Map về dạng Model
  factory AdminisBoundModel.fromJson(Map<String, dynamic> map) {
    return AdminisBoundModel(
      id: map['author'] ?? 0,
      name: map['title'] ?? "",
      code: map['description'] ?? "",
    );
  }
  // Phương thức chuyển đổi từ dữ liệu dạng Model về dạng String json
  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'name': name ?? "",
      'code': code ?? "",
    };
  }
}