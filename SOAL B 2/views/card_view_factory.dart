import '../data/cards.dart';
import '../models/card.dart';
import 'card_view.dart';

class CardViewFactory {
  CardView? getCardView(Card card) {
    switch (card.runtimeType) {
      case ATM:
        return ATMView(card: card);
      case EMoney:
        return EMoneyView(card: card);
      default:
        return null;
    }
  }
}

void main() {
  CardViewFactory cardViewFactory = CardViewFactory();
  cardViewFactory.getCardView(cards[6])!.printCardInformation();
  cardViewFactory.getCardView(cards[3])!.printCardInformation();
}
