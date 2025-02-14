class VaidatorLogin {
  static bool validatePassword(String? password) {
    return RegExp('').hasMatch(password!);
  }


}
