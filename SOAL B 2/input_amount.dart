import 'dart:io';

import 'validator.dart';

class InputAmount {
  final String _label;
  final String _errorMessage;

  InputAmount({required String label, required String errorMessage})
      : _label = label,
        _errorMessage = errorMessage;

  double call() {
    double amount;
    try {
      print("$_label");
      amount = double.parse(stdin.readLineSync()!);
      if (!isValidAmount(amount)) {
        throw Exception();
      }
      return amount;
    } catch (e) {
      print("$_errorMessage");
      return call();
    }
  }
}

// void main() {
//   InputAmount inputAmount = InputAmount(
//     label: "Masukan nominal:",
//     errorMessage: "Maaf, nominal tidak valid",
//   );

//   inputAmount();
// }
