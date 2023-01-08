import 'dart:io';

import '../models/transaction.dart';

abstract class TransactionView {
  // ignore: unused_field
  final _transaction;

  TransactionView(Transaction transaction) : _transaction = transaction;

  void _printDate() {
    stdout.write("${_transaction.date} - ");
  }

  void _printAmountInformation() {
    print(
      " - Nominal: ${_transaction.amount} - Saldo: ${_transaction.balance}",
    );
  }

  void _printDescription();

  void printTransactionDetails() {
    _printDate();
    _printDescription();
    _printAmountInformation();
  }
}

class SendTransactionView extends TransactionView {
  SendTransactionView(super.transaction);

  @override
  void _printDescription() {
    stdout.write(
      "Mengirim transfer ke ${_transaction.receiverAccountNumber} ${_transaction.receiverName}",
    );
  }
}

class ReceiveTransactionView extends TransactionView {
  ReceiveTransactionView(super.transaction);

  @override
  void _printDescription() {
    stdout.write(
      "Menerima transfer dari ${_transaction.senderAccountNumber} ${_transaction.senderName}",
    );
  }
}

class TopUpTransactionView extends TransactionView {
  TopUpTransactionView(super.transaction);

  @override
  void _printDescription() {
    stdout.write("Top-Up E-money ke ${_transaction.receiverCardNumber}");
  }
}

class CheckOutTransactionView extends TransactionView {
  CheckOutTransactionView(super.transaction);

  @override
  void _printDescription() {
    stdout.write("Pembayaran pembelanjaan");
  }
}

class WithDrawTransactionView extends TransactionView {
  WithDrawTransactionView(super.transaction);

  @override
  void _printDescription() {
    stdout.write(
      "Tarik tunai",
    );
  }
}

class DepositTransactionView extends TransactionView {
  DepositTransactionView(super.transaction);

  @override
  void _printDescription() {
    stdout.write("Setor tunai");
  }
}
