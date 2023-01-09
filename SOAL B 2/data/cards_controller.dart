import '../errors/exceptions.dart';
import '../models/card.dart';

abstract class CardsController {
  Card findByCardNumber(String cardNumber);
  Card findByAccountNumber(String accountNumber);
  bool authenticateCard(String cardNumber, String pin);
  void updateCard(Card newCard);
}

class CardsControllerImpl extends CardsController {
  List<Card> _cards;
  CardsControllerImpl(List<Card> cards) : _cards = cards;

  @override
  bool authenticateCard(String cardNumber, String pin) {
    try {
      return findByCardNumber(cardNumber).pin == pin;
    } catch (e) {
      return false;
    }
  }

  @override
  Card findByAccountNumber(String accountNumber) {
    final i = _cards.indexWhere(
      (element) {
        if (element is ATM) {
          return element.accountNumber == accountNumber;
        } else {
          return false;
        }
      },
    );

    // mengecek apakah kartu terdaftar di daftar
    if (i == -1) {
      throw KartuTidakTerdaftar();
    }

    return _cards[i];
  }

  @override
  Card findByCardNumber(String cardNumber) {
    final i = _cards.indexWhere(
      (element) {
        return element.cardNumber == cardNumber;
      },
    );

    // mengecek apakah kartu terdaftar di daftar
    if (i == -1) {
      throw KartuTidakTerdaftar();
    }

    return _cards[i];
  }

  @override
  void updateCard(Card newCard) {
    final i = _cards.indexWhere(
      (element) {
        return element.cardNumber == newCard.cardNumber;
      },
    );

    // mengecek apakah kartu terdaftar di daftar
    if (i == -1) {
      throw KartuTidakTerdaftar();
    }

    _cards[i] = newCard;
  }
}

// void main() {
//   final cardsController = CardsControllerImpl(cards);
//   Card testCard = ATM(
//     cardNumber: "1111111111",
//     accountNumber: "3333333333",
//     pin: "555555",
//     name: "Update",
//     bankBranch: "Semarang",
//     balance: 100,
//   );

//   print(cardsController.findByCardNumber(testCard.cardNumber).pin);
//   cardsController.updateCard(testCard);
//   print(cardsController.findByCardNumber(testCard.cardNumber).pin);
// }
