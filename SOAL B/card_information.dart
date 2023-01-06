import 'package:equatable/equatable.dart';

abstract class CardInformation {
  final String _cardNumber;
  final double _balance;

  CardInformation({
    required String cardNumber,
    required double balance,
  })  : _cardNumber = cardNumber,
        _balance = balance;

  String get cardNumber {
    return _cardNumber;
  }

  double get balance {
    return _balance;
  }
}

class ATMInfo extends CardInformation implements Equatable{
  final String _accountNumber, _bankBranch, _name;
  ATMInfo({
    required super.cardNumber,
    required super.balance,
    required String accountNumber,
    required String bankBranch,
    required String name,
  })  : _accountNumber = accountNumber,
        _bankBranch = bankBranch,
        _name = name;

  String get accountNumber {
    return _accountNumber;
  }

  String get name {
    return _name;
  }

  String get bankBranch {
    return _bankBranch;
  }
  
  @override
  List<Object?> get props => [super._balance, super._cardNumber, _accountNumber, _bankBranch, _name];
  
  @override
  bool? get stringify => false;
}


class EMoneyInfo extends CardInformation implements Equatable{  
  EMoneyInfo({required super.cardNumber, required super.balance});
  
  @override
  List<Object?> get props => [super._balance, super._cardNumber];
  
  @override
  bool? get stringify => false;
}
