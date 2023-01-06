abstract class Transaction {
  final String _cardNumber, _date;
  final double _amount, _balance;

  Transaction({
    required String cardNumber,
    required double amount,
    required double balance,
  })  : _cardNumber = cardNumber,
        _date = DateTime.now().toString(),
        _amount = amount,
        _balance = balance;

  String get cardNumber {
    return _cardNumber;
  }

  double get balance {
    return _balance;
  }

  double get amount {
    return _amount;
  }

  String get date {
    return _date;
  }
}

class SendTransaction extends Transaction {
  final String _receiverAccountNumber, _receiverName;

  SendTransaction({
    required super.cardNumber,
    required super.amount,
    required super.balance,
    required String receiverAccountNumber,
    required String receiverName,
  })  : _receiverAccountNumber = receiverAccountNumber,
       _receiverName = receiverName;

  String get receiverAccountNumber {
    return _receiverAccountNumber;
  }

  String get receiverName {
    return _receiverName;
  }
}

class ReceiveTransaction extends Transaction {
  final String _senderAccountNumber, _senderName;
  ReceiveTransaction({
    required super.cardNumber,
    required super.amount,
    required super.balance,
    required String senderAccountNumber,
    required String senderName,
  })  : _senderAccountNumber = senderAccountNumber,
        _senderName = senderName;

  String get senderAccountNumber {
    return _senderAccountNumber;
  }

  String get senderName {
    return _senderName;
  }
}

class TopUpTransaction extends Transaction {
  final String _receiverCardNumber;
  TopUpTransaction({
    required super.cardNumber,
    required super.amount,
    required super.balance,
    required String receiverCardNumber,
  }) : _receiverCardNumber = receiverCardNumber;

  String get receiverCardNumber {
    return _receiverCardNumber;
  }
}

class CheckOutTransaction extends Transaction {
  CheckOutTransaction({
    required super.cardNumber,
    required super.amount,
    required super.balance,
  });
}

class WithDrawTransaction extends Transaction {
  WithDrawTransaction({
    required super.cardNumber,
    required super.amount,
    required super.balance,
  });
}

class DepositTransaction extends Transaction {
  DepositTransaction({
    required super.cardNumber,
    required super.amount,
    required super.balance,
  });
}
