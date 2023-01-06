import 'package:test/test.dart';

import '../validator.dart';

void main() {
  group("NumberValidator", () {
    // wrong card / account number
    List<String> wrongNumbers = ["12345", "12345678901", "123456789a"];

    for (int i = 0; i < wrongNumbers.length; i++) {
      test(wrongNumbers[i], () {
        // given / when
        bool result = isvalidNumber(wrongNumbers[i]);

        // then
        // gagal, result harus false
        expect(result, false);
      });
    }
  });

  group("PinValidator", () {
    // wrong pin number
    List<String> wrongPins = ["12", "1234567", "12345s"];

    for (int i = 0; i < wrongPins.length; i++) {
      test(wrongPins[i], () {
        // given / when
        bool result = isValidPin(wrongPins[i]);

        // then
        // gagal, result harus false
        expect(result, false);
      });
    }
  });
}
