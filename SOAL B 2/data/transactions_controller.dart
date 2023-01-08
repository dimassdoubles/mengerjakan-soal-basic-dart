

import '../models/card.dart';
import '../models/transaction.dart';

abstract class TransactionsController {
  List<Transaction> getCardTransactions(Card card);
  void createTransaction(Transaction transaction);
}

class TransactionsControllerImpl extends TransactionsController {
  List<Transaction> _transactions;

  TransactionsControllerImpl(List<Transaction> transactions)
      : _transactions = transactions;

  @override
  void createTransaction(Transaction transaction) {
    _transactions.add(transaction);
  }

  @override
  List<Transaction> getCardTransactions(Card card) {
    return [
      ..._transactions.where((element) => element.cardNumber == card.cardNumber)
    ];
  }
}
