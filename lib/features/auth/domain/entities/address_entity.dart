// Thư viện equatable, giúp đơn giản hóa việc so sánh hai đối tượng trong Dart. Với equatable, bạn chỉ cần liệt kê các thuộc tính cần so sánh mà không cần tự định nghĩa lại phương thức == và hashCode.
import 'package:danh_ba_c06_app/features/auth/data/models/adminis_bound_model.dart';
import 'package:equatable/equatable.dart';

// Kế thừa từ Equatable, cho phép so sánh các đối tượng của ArticleEntity một cách dễ dàng dựa trên các thuộc tính mà lớp định nghĩa.
class AddressEntity extends Equatable {
  
  final AdminisBoundModel ? province;
  final AdminisBoundModel ? district;
  final AdminisBoundModel ? ward;

  const AddressEntity ({
    this.province,
    this.district,
    this.ward,
  });
  
  // Phương thức props từ Equatable được override để chỉ định các thuộc tính nào sẽ được sử dụng khi so sánh hai đối tượng ArticleEntity. Hai đối tượng ArticleEntity được coi là bằng nhau nếu tất cả các thuộc tính trong props của chúng có giá trị giống nhau.
  @override
  List<Object?> get props {
    return [
      province,
      district,
      ward
    ];
  }
}