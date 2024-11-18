import 'package:logger/logger.dart';

// Sử dụng package logger trong Dart để tạo một đối tượng logger giúp ghi lại (log) các sự kiện hoặc thông tin trong quá trình ứng dụng chạy. Về cơ bản là giống print nhưng chạy nhanh hơn, sau dễ mở rộng nếu cần log
final logger = Logger(
  level:
      Level.debug, // Set the log level (debug, info, warning, error, verbose)
  printer: PrettyPrinter(), // Use a different log printer
  // filter: MyFilter(), // Add a log filter
  // output: MyOutput(), // Define custom log output
);