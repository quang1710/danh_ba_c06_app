import 'package:dio/dio.dart';

abstract class DataState<T> {  //Lớp này định nghĩa trạng thái của dữ liệu, có thể là thành công hoặc thất bại.
  final T ? data;  // T? cho phép data có thể là null
  final DioException ? error;  // lưu trữ lỗi (nếu có) khi có sự cố xảy ra trong quá trình thực hiện tác vụ

  const DataState ({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {  // là một lớp con của DataState<T>, đại diện cho trạng thái thành công của một tác vụ.
  const DataSuccess(T data) : super(data: data);
} // Khi tác vụ thành công, bạn sẽ sử dụng lớp này để truyền dữ liệu thành công vào.

class DataFailed<T> extends DataState<T> {  // là một lớp con khác của DataState<T>, đại diện cho trạng thái thất bại của một tác vụ.
  const DataFailed(DioException error) : super(error: error);
} // Khi tác vụ gặp lỗi (ví dụ lỗi mạng, lỗi API), bạn sẽ sử dụng lớp này để truyền lỗi vào.