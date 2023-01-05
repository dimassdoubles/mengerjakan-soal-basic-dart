bool isvalidNumber(String number) {
  // regex numeric dengan panjang karakter 10
  final numeric = RegExp(r'^([0-9]){10}$');

  return numeric.hasMatch(number);
}

bool isValidPin(String pin) {
  // regex numeric dengan panjang karakter 6
  final numeric = RegExp(r'^([0-9]){6}$');

  return numeric.hasMatch(pin);
}
