// Thư viện equatable, giúp đơn giản hóa việc so sánh hai đối tượng trong Dart. Với equatable, bạn chỉ cần liệt kê các thuộc tính cần so sánh mà không cần tự định nghĩa lại phương thức == và hashCode.
import 'package:equatable/equatable.dart';

// Kế thừa từ Equatable, cho phép so sánh các đối tượng của ArticleEntity một cách dễ dàng dựa trên các thuộc tính mà lớp định nghĩa.
class ArticleEntity extends Equatable {
  
  final int ? id;
  final String ? author;
  final String ? title;
  final String ? description;
  final String ? url;
  final String ? urlToImage;
  final String ? publishedAt;
  final String ? content;

  const ArticleEntity({
    this.id,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content
  });
  
  // Phương thức props từ Equatable được override để chỉ định các thuộc tính nào sẽ được sử dụng khi so sánh hai đối tượng ArticleEntity. Hai đối tượng ArticleEntity được coi là bằng nhau nếu tất cả các thuộc tính trong props của chúng có giá trị giống nhau.
  @override
  List<Object?> get props {
    return [
      id,
      author,
      title,
      description,
      url,
      urlToImage,
      publishedAt,
      content
    ];
  }
}