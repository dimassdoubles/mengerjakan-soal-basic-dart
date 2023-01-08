import 'dart:io';

import 'validator.dart';

class InputPin {
  final String _label;
  final String _errorMessage;

  InputPin({required String label, required String errorMessage})
      : _label = label,
        _errorMessage = errorMessage;

  String call() {
    print("$_label");
    String pin = stdin.readLineSync() ?? "";

    if (!isValidPin(pin)) {
      print("$_errorMessage");
      return call();
    }
    return pin;
  }
}

void main() {
  InputPin inputPin = InputPin(
    label: "Masukan pin",
    errorMessage: "Maaf, pin tidak valid",
  );

  inputPin();
}
