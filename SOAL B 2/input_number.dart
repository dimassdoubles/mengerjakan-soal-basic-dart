import 'dart:io';

import 'validator.dart';

class InputNumber {
  final String _label;
  final String _errorMessage;
  InputNumber({required String label, required String errorMessage})
      : _label = label,
        _errorMessage = errorMessage;

  String call() {
    print("$_label");
    String number = stdin.readLineSync() ?? "";

    if (!isvalidNumber(number)) {
      print("$_errorMessage");
      return call();
    }
    return number;
  }
}

// void main() {
//   // String cardNumber = inputCardNumber();
//   InputNumber inputCardNumber = InputNumber(
//     label: "Masukan nomor kartu:",
//     errorMessage: "Maaf, nomor tidak valid",
//   );
//   String cardNumber = inputCardNumber();
//   print(cardNumber);
// }
