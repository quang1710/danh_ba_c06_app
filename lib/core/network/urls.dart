class API {
  // Base url
  static String _baseUrl = 'http://172.16.250.69:3692/api';

  // Phương thức để cập nhật baseUrl
  static void setBaseUrl(String newUrl) {
    _baseUrl = newUrl;
  }

  // Getters để trả về các route dựa trên baseUrl hiện tại
  static String get baseUrl => _baseUrl;

  // Quản lý định danh
  // Đăng nhập
  static String get loginRoute => '$_baseUrl/auth/signin';
  // Kiểm tra thông tin đăng ký
  static String get checkSignupInforRoute => '$_baseUrl/auth/checkSignupInfo';
  // Gửi số điện thoại lấy OTP sms
  static String get otpRoute => '$_baseUrl/auth/generateOTP';
  // Đăng ký
  static String get signupRoute => '$_baseUrl/auth/signup';
  // Quên mật khẩu
  static String get forgotPassRoute => '$_baseUrl/auth/forgotPassword';
  // Đổi mật khẩu
  static String get changepasswordRoute => '$_baseUrl/users/changePassword';
}