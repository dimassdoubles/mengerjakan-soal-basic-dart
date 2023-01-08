import '../errors/exceptions.dart';
import '../models/card.dart';
import '../views/card_view_factory.dart';

abstract class CardController {
  final _card;
  CardViewFactory _cardViewFactory = CardViewFactory();

  CardController(Card card) : _card = card;

  void updateView() {
    _cardViewFactory.getCardView(_card)!.printCardInformation();
  }

  void setBalance(double amount) {
    _card.setBalance = amount;
  }

  String getPin() {
    return _card.pin;
  }

  String getCardNumber() {
    return _card.cardNumber;
  }

  double getBalance() {
    return _card.balance;
  }
}

class ATMController extends CardController {
  ATMController(super.card);

  String getAccountNumber() {
    return _card.accountNumber;
  }

  String getName() {
    return _card.name;
  }

  String getBankBranch() {
    return _card.bankBranch;
  }
}

class EMoneyController extends CardController {
  EMoneyController(super.card);

  @override
  void setBalance(double amount) {
    if (amount > 1000000) {
      throw MelebihiSaldoMaksimal();
    } else {
      super.setBalance(amount);
    }
  }
}
