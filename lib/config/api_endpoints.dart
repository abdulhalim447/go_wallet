class ApiEndpoints {
  static const String baseUrl = 'https://gowalletapp.xyz';

  // Auth endpoints
  static const String login = '$baseUrl/php/login.php';
  static const String register = '$baseUrl/php/register.php';
  static const String pin = '$baseUrl/php/pin.php';

  // User related endpoints
  static const String getBalance = '$baseUrl/php/get_u_balance.php';
  static const String updateProfile = '$baseUrl/php/update_profile.php';

  // Transaction related endpoints
  static const String addMoney = '$baseUrl/php/add_money/add_money.php';
  static const String getPaymentNumbers =
      '$baseUrl/php/add_money/get_numbers.php';
  static const String mobileBanking =
      '$baseUrl/php/mobile_banking/mobile_banking.php';
  static const String bankTransfer =
      '$baseUrl/php/mobile_banking/bank_transper.php';
  static const String history = '$baseUrl/php/history.php';

  // Notice and Support endpoints
  static const String notice = '$baseUrl/php/notice.php';
  static const String topNotice = '$baseUrl/php/top_notice.php';
  static const String support = '$baseUrl/php/support.php';

  // Ringit endpoint
  static const String getRingit = '$baseUrl/php/admin/ringit_update.php';
}
