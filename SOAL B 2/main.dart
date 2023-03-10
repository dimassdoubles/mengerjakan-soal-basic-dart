import 'data/cards.dart';
import 'data/cards_controller.dart';
import 'data/transactions.dart';
import 'data/transactions_controller.dart';
import 'errors/exceptions.dart';
import 'input_number.dart';
import 'input_pin.dart';
import 'models/card.dart';
import 'transaction_processor_factory.dart';

void main() {
  InputNumber inputCardNumber = InputNumber(
    label: "\nMasukan nomor kartu:",
    errorMessage: "\nMaaf, nomor kartu tidak valid",
  );

  InputPin inputPin = InputPin(
    label: "\nMasukan pin:",
    errorMessage: "\nMaaf, pin tidak valid",
  );

  CardsController cardsController = CardsControllerImpl(cards);
  TransactionsController transactionsController =
      TransactionsControllerImpl(transactions);

  TransactionProcessorFactory transactionProcessorFactory =
      TransactionProcessorFactory(
    cardsController: cardsController,
    transactionsController: transactionsController,
  );

  while (true) {
    try {
      String cardNumber = inputCardNumber();

      // jika baris ini terlewati maka, kartu ada
      Card card = cardsController.findByCardNumber(cardNumber);

      String pin = inputPin();

      if (cardsController.authenticateCard(cardNumber, pin)) {
        transactionProcessorFactory.getTransactionProcessor(card).pickMenu();
      }
    } on KartuTidakTerdaftar {
      print("\nMaaf, kartu tidak terdaftar");
    }
  }
}
