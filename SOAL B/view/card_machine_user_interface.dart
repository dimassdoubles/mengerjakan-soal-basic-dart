import 'dart:io';

import '../contoller/card_machine.dart';
import '../exceptions.dart';
import '../model/card_information.dart';
import '../model/transaction.dart';
import '../validator.dart';

class TransactionProcessor {
  CardMachine _cardMachine;
  TransactionProcessor(CardMachine cardMachine): _cardMachine = cardMachine;

  void printDefaultMenu() {
    print("\nMenu");
    print("a. Informasi rekening");
    print("b. Mutasi kartu");
    print("c. Pembayaran");
  }

  void authenticate(String pin) {}

  void seeMutation() {
    print("\nMutasi Kartu");
    print("------------");
    // mendapatkan daftar transaksi dari mesin atm
    List<Transaction> transactions = _cardMachine.getAccountMutation();

    // menampilkan transaksi sesuai dengan jenisnya
    int no = 1;
    for (int i = transactions.length - 1; i >= 0; i--) {
      final transaction = transactions[i];
      if (transaction is SendTransaction) {
        print(
          "$no. ${transaction.date} - Mengirim transfer ke ${transaction.receiverAccountNumber} ${transaction.receiverName} - Nominal: ${transaction.amount} - Saldo: ${transaction.balance}",
        );
      } else if (transaction is ReceiveTransaction) {
        print(
          "$no. ${transaction.date} - Menerima transfer dari ${transaction.senderAccountNumber} ${transaction.senderName} - Nominal: ${transaction.amount} - Saldo: ${transaction.balance}",
        );
      } else if (transaction is TopUpTransaction) {
        print(
          "$no. ${transaction.date} - Top-Up E-money ke ${transaction.receiverCardNumber} - Nominal: ${transaction.amount} - Saldo: ${transaction.balance}",
        );
      } else if (transaction is CheckOutTransaction) {
        print(
          "$no. ${transaction.date} - Pembayaran pembelanjaan - Nominal: ${transaction.amount} - Saldo: ${transaction.balance}",
        );
      } else if (transaction is WithDrawTransaction) {
        print(
          "$no. ${transaction.date} - Tarik tunai - Nominal: ${transaction.amount} - Saldo: ${transaction.balance}",
        );
      } else if (transaction is DepositTransaction) {
        print(
          "$no. ${transaction.date} - Setor tunai - Nominal: ${transaction.amount} - Saldo: ${transaction.balance}",
        );
      }
      no += 1;
    }
  }

  void autehenticate() {
  print("\nMasukan pin        :");
  String pin = stdin.readLineSync() ?? "";

  // melakukan validasi pin
  if (!isValidPin(pin)) {
    throw PinTidakValidException();
  }

  // melakukan otentikasi
  _cardMachine.authenticate(pin);
}

  void printCardInformation() {
  CardInformation cardInfo = _cardMachine.getCardInformation()!;
  if (cardInfo is ATMInfo) {
    print("Informasi Kartu");
    print("-----------------------");
    print("Jenis kartu           : ATM");
    print("Nomor kartu           : ${cardInfo.cardNumber}");
    print("Nomor Rekening        : ${cardInfo.accountNumber}");
    print("Cabang bank           : ${cardInfo.bankBranch}");
    print("Nama pemilik rekening : ${cardInfo.name}");
    print("Sisal saldo           : ${cardInfo.balance}");
  } else if (cardInfo is EMoneyInfo) {
    print("Informasi Kartu");
    print("-----------------------");
    print("Jenis kartu           : E-Money");
    print("Nomor kartu           : ${cardInfo.cardNumber}");
    print("Sisa Saldo            : ${cardInfo.balance}");
  }
}

  void pickMenu() {}
}

class EMoneyTransactionprocessor extends TransactionProcessor {
  EMoneyTransactionprocessor(super.cardMachine);
}

class ATMTransactionProcessor extends TransactionProcessor {
  ATMTransactionProcessor(super.cardMachine);
  
  
}