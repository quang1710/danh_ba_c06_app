// Thư viện equatable, giúp đơn giản hóa việc so sánh hai đối tượng trong Dart. Với equatable, bạn chỉ cần liệt kê các thuộc tính cần so sánh mà không cần tự định nghĩa lại phương thức == và hashCode.
import 'package:equatable/equatable.dart';

// Kế thừa từ Equatable, cho phép so sánh các đối tượng của ArticleEntity một cách dễ dàng dựa trên các thuộc tính mà lớp định nghĩa.
class AdminisBoundEntity extends Equatable {
  
  final int ? id;
  final String ? name;
  final String ? code;

  const AdminisBoundEntity({
    this.id,
    this.name,
    this.code,
  });
  
  // Phương thức props từ Equatable được override để chỉ định các thuộc tính nào sẽ được sử dụng khi so sánh hai đối tượng ArticleEntity. Hai đối tượng ArticleEntity được coi là bằng nhau nếu tất cả các thuộc tính trong props của chúng có giá trị giống nhau.
  @override
  List<Object?> get props {
    return [
      id,
      name,
      code
    ];
  }
}