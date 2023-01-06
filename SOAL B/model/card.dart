class Card {
  final String _cardNumber, _pin;
  double _balance;

  Card({
    required String cardNumber,
    required String pin,
    required double balance,
  })  : _cardNumber = cardNumber,
        _pin = pin,
        _balance = balance;

  String get cardNumber {
    return _cardNumber;
  }

  String get pin {
    return _pin;
  }

  double get balance {
    return _balance;
  }

  set setBalance(double balance) {
    _balance = balance;
  }

}

class ATM extends Card {
  final String _name, _accountNumber, _bankBranch;
  ATM(
      {required super.cardNumber,
      required super.pin,
      required super.balance,
      required String name,
      required String accountNumber,
      required String bankBranch,
      required})
      : _name = name,
        _accountNumber = accountNumber,
        _bankBranch = bankBranch;
  String get name {
    return _name;
  }

  String get accountNumber {
    return _accountNumber;
  }

  String get bankBranch {
    return _bankBranch;
  }
}

class EMoney extends Card {
  EMoney(
      {required super.cardNumber, required super.pin, required super.balance});
}
