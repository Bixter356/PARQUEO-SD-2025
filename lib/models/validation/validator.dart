class Validator {
  static bool validNameParking(String? name) {
    return RegExp(r'^[A-Za-z\s]+$').hasMatch(name!);
  }

  static bool validateAddressParking(String? direccion) {
    return RegExp('').hasMatch(direccion!);
  }

  static bool validateDescriptionParking(String? description) {
    return RegExp('').hasMatch(description!);
  }
}
