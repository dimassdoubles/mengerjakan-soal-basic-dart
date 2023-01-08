import '../data/cards.dart';
import '../models/card.dart';
import 'card_controller.dart';

class CardControllerFactory {
  dynamic getCardController(Card card) {
    switch (card.runtimeType) {
      case ATM:
        return ATMController(card);
      case EMoney:
        return EMoneyController(card);
      default:
        return null;
    }
  }
}

// void main() {
//   final cardControllerFactory = CardControllerFactory();

//   cardControllerFactory.getCardController(cards[0])!.setName();
// }
