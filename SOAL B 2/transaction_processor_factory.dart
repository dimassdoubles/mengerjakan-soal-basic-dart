import 'data/cards_controller.dart';
import 'data/transactions_controller.dart';
import 'models/card.dart';
import 'transaction_processor.dart';

class TransactionProcessorFactory {
  CardsController _cardsController;
  TransactionsController _transactionsController;

  TransactionProcessorFactory({
    required CardsController cardsController,
    required TransactionsController transactionsController,
  })  : _cardsController = cardsController,
        _transactionsController = transactionsController;

  dynamic getTransactionProcessor(Card card) {
    switch (card.runtimeType) {
      case ATM:
        return ATMProcessor(
          cardsController: _cardsController,
          transactionsController: _transactionsController,
          card: card,
        );
      case EMoney:
        return EMoneyProcessor(
          cardsController: _cardsController,
          transactionsController: _transactionsController,
          card: card,
        );
    }
  }
}
