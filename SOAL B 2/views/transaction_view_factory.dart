import '../models/transaction.dart';
import 'transaction_view.dart';

class TransactionViewFactory {
  TransactionView? getTransactionView(Transaction transaction) {
    switch (transaction.runtimeType) {
      case SendTransaction:
        return SendTransactionView(transaction);
      case ReceiveTransaction:
        return ReceiveTransactionView(transaction);
      case TopUpTransaction:
        return TopUpTransactionView(transaction);
      case CheckOutTransaction:
        return CheckOutTransactionView(transaction);
      case WithDrawTransaction:
        return WithDrawTransactionView(transaction);
      case DepositTransaction:
        return DepositTransactionView(transaction);
      default:
        return null;
    }
  }
}

void main() {
  DepositTransaction depositTransaction = DepositTransaction(
    cardNumber: "12",
    amount: 012,
    balance: 123,
  );

  SendTransaction sendTransaction = SendTransaction(
      cardNumber: "123",
      amount: 123,
      balance: 123,
      receiverAccountNumber: "123",
      receiverName: "123");

  TransactionViewFactory transactionViewFactory = TransactionViewFactory();

  transactionViewFactory
      .getTransactionView(sendTransaction)!
      .printTransactionDetails();

  transactionViewFactory
      .getTransactionView(depositTransaction)!
      .printTransactionDetails();
}
