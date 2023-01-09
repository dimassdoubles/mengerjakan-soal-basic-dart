import 'dart:io';

import 'controllers/card_controller_factory.dart';
import 'data/cards.dart';
import 'data/cards_controller.dart';
import 'data/transactions.dart';
import 'data/transactions_controller.dart';
import 'errors/exceptions.dart';
import 'input_amount.dart';
import 'input_number.dart';
import 'input_pin.dart';
import 'models/card.dart';
import 'models/transaction.dart';
import 'views/transaction_view_factory.dart';

const String informasiRekening = "A";
const String mutasiKartu = "B";
const String pembayaran = "C";
const String tarikTunai = "D";
const String setorTunai = "E";
const String transfer = "F";
const String topUpEmoney = "G";

abstract class TransactionProcessor {
  CardControllerFactory _cardControllerFactory = CardControllerFactory();
  TransactionViewFactory _transactionViewFactory = TransactionViewFactory();

  // database controller
  CardsController _cardsController;
  TransactionsController _transactionsController;

  // input taker
  InputAmount inputAmount = InputAmount(
    label: "Masukan nominal:",
    errorMessage: "Maaf, nominal tidak valid",
  );
  InputNumber inputCardNumber = InputNumber(
    label: "Masukan nomor kartu:",
    errorMessage: "Maaf, nomor kartu tidak valid",
  );
  InputNumber inputAccountNumber = InputNumber(
    label: "Masukan nomor rekening:",
    errorMessage: "Maaf, nomor rekening tidak valid",
  );
  InputPin inputPin = InputPin(
    label: "Masukan pin:",
    errorMessage: "Maaf, pin tidak valid",
  );

  final _card;

  TransactionProcessor({
    required CardsController cardsController,
    required TransactionsController transactionsController,
    required Card card,
  })  : _cardsController = cardsController,
        _transactionsController = transactionsController,
        _card = card;

  void _runMenu(String selectedMenu) {
    switch (selectedMenu.toUpperCase()) {
      case informasiRekening:
        return _printInformation();
      case mutasiKartu:
        return _printMutation();
      case pembayaran:
        return _checkout();
    }
  }

  void _printMenu() {
    print("\nMenu");
    print("a. Informasi rekening");
    print("b. Mutasi kartu");
    print("c. Pembayaran");
  }

  void pickMenu() {
    _printMenu();
    print("\n\nSilahkan pilih menu (urutan abjad):");
    try {
      String selectedMenu = stdin.readLineSync() ?? "";
      _runMenu(selectedMenu);
    } catch (e) {
      print("\nMaaf, terjadi kesalahan");
    }

    print("\n\nIngin melakukan transaksi lagi ? y/n:");
    String again = stdin.readLineSync() ?? "";
    if (again.toUpperCase() == "Y") {
      return pickMenu();
    }
  }

  void _printInformation() {
    _cardControllerFactory.getCardController(_card)!.updateView();
  }

  void _printMutation() {
    final transactions = _transactionsController.getCardTransactions(_card);

    int no = 1;
    for (int i = transactions.length - 1; i >= 0; i--) {
      stdout.write("\n$no. ");
      _transactionViewFactory
          .getTransactionView(transactions[i])!
          .printTransactionDetails();
      no += 1;
    }
  }

  void _checkout() {
    double amount = inputAmount();

    // check saldo
    final balance =
        _cardControllerFactory.getCardController(_card)!.getBalance();

    if (balance > amount) {
      _cardControllerFactory
          .getCardController(_card)!
          .setBalance(balance - amount);
      _cardsController.updateCard(_card);
      _transactionsController.createTransaction(
        CheckOutTransaction(
          cardNumber: _card.cardNumber,
          amount: amount,
          balance: _card.balance,
        ),
      );
      print("\nPembayaran berhasil");
    } else {
      print("\nMaaf, saldo tidak cukup");
    }
  }
}

class ATMProcessor extends TransactionProcessor {
  ATMProcessor(
      {required super.cardsController,
      required super.transactionsController,
      required super.card});

  @override
  void _printMenu() {
    super._printMenu();
    print("d. Tarik tunai");
    print("e. Setor tunai");
    print("f. Transfer");
    print("g. Top-Up E-Money");
  }

  @override
  void _runMenu(String selectedMenu) {
    super._runMenu(selectedMenu);
    switch (selectedMenu.toUpperCase()) {
      case tarikTunai:
        return _withDraw();
      case setorTunai:
        return _deposit();
      case topUpEmoney:
        return _topUp();
      case transfer:
        return _transfer();
    }
  }

  @override
  void _checkout() {
    String pin = inputPin();
    if (_cardsController.authenticateCard(_card.cardNumber, pin)) {
      super._checkout();
    } else {
      print("\nMaaf, pin salah");
    }
  }

  void _withDraw() {
    double amount = inputAmount();

    // check saldo
    final balance =
        _cardControllerFactory.getCardController(_card)!.getBalance();

    if (balance > amount) {
      _cardControllerFactory
          .getCardController(_card)!
          .setBalance(balance - amount);

      _cardsController.updateCard(_card);

      _transactionsController.createTransaction(
        WithDrawTransaction(
          cardNumber: _card.cardNumber,
          amount: amount,
          balance: balance - amount,
        ),
      );
      print("\nTarik tunai berhasil");
    } else {
      print("\nMaaf, saldo tidak cukup");
    }
  }

  void _deposit() {
    double amount = inputAmount();

    // check saldo
    final balance =
        _cardControllerFactory.getCardController(_card)!.getBalance();

    _cardControllerFactory
        .getCardController(_card)!
        .setBalance(balance + amount);

    _cardsController.updateCard(_card);

    _transactionsController.createTransaction(
      DepositTransaction(
        cardNumber: _card.cardNumber,
        amount: amount,
        balance: balance + amount,
      ),
    );
    print("\nSetor tunai berhasil");
  }

  void _transfer() {
    try {
      String receiverAccountNumber = inputAccountNumber();
      Card receiverCard =
          _cardsController.findByAccountNumber(receiverAccountNumber);

      double amount = inputAmount();

      double senderBalance =
          _cardControllerFactory.getCardController(_card)!.getBalance();

      String senderAccountNumber = _cardControllerFactory
          .getCardController(receiverCard)!
          .getAccountNumber();

      String senderName =
          _cardControllerFactory.getCardController(_card)!.getName();

      double receiverBalance =
          _cardControllerFactory.getCardController(receiverCard)!.getBalance();

      String receiverName =
          _cardControllerFactory.getCardController(receiverCard)!.getName();


      if (senderBalance > amount) {
        _cardControllerFactory
            .getCardController(_card)!
            .setBalance(senderBalance - amount);
        _cardControllerFactory
            .getCardController(receiverCard)!
            .setBalance(receiverBalance + amount);

        _cardsController.updateCard(_card);
        _cardsController.updateCard(receiverCard);

        _transactionsController.createTransaction(
          SendTransaction(
            cardNumber: _card.cardNumber,
            amount: amount,
            balance: senderBalance - amount,
            receiverAccountNumber: receiverAccountNumber,
            receiverName: receiverName,
          ),
        );
        _transactionsController.createTransaction(
          ReceiveTransaction(
            cardNumber: receiverCard.cardNumber,
            amount: amount,
            balance: receiverCard.balance + amount,
            senderAccountNumber: senderAccountNumber,
            senderName: senderName,
          ),
        );
        print("\nTransfer berhasil");
      } else {
        print("\nMaaf, saldo anda tidak cukup");
      }
    } on KartuTidakTerdaftar {
      print("\nMaaf, kartu nomor rekening tidak terdaftar");
    }
  }

  void _topUp() {
    try {
      String receiverCardNumber = inputCardNumber();
      Card emoneyCard = _cardsController.findByCardNumber(receiverCardNumber);

      double amount = inputAmount();

      double senderBalance =
          _cardControllerFactory.getCardController(_card)!.getBalance();

      String senderName =
          _cardControllerFactory.getCardController(_card)!.getName();

      String senderAccountNumber =
          _cardControllerFactory.getCardController(_card)!.getAccountNumber();

      double receiverBalance =
          _cardControllerFactory.getCardController(emoneyCard)!.getBalance();

      if (senderBalance > amount) {
        _cardControllerFactory
            .getCardController(emoneyCard)!
            .setBalance(receiverBalance + amount);

        _cardControllerFactory
            .getCardController(_card)!
            .setBalance(senderBalance - amount);

        _cardsController.updateCard(_card);
        _cardsController.updateCard(emoneyCard);

        _transactionsController.createTransaction(
          TopUpTransaction(
            cardNumber: _card.cardNumber,
            amount: amount,
            balance: senderBalance - amount,
            receiverCardNumber: receiverCardNumber,
          ),
        );
        _transactionsController.createTransaction(
          ReceiveTransaction(
            cardNumber: receiverCardNumber,
            amount: amount,
            balance: receiverBalance - amount,
            senderAccountNumber: senderAccountNumber,
            senderName: senderName,
          ),
        );

        print("\nTop up berhasil");
      } else {
        print("\nMaaf, saldo anda tidak cukup");
      }
    } on MelebihiSaldoMaksimal {
      print("\nMaaf, saldo melebihi batas maksimal, transaksi dibatalkan");
    } on KartuTidakTerdaftar {
      print("\nMaaf, kartu tidak terdaftar");
    }
  }
}

class EMoneyProcessor extends TransactionProcessor {
  EMoneyProcessor(
      {required super.cardsController,
      required super.transactionsController,
      required super.card});
}

// void main() {
//   CardsController cardsController = CardsControllerImpl(cards);
//   TransactionsController transactionsController =
//       TransactionsControllerImpl(transactions);
//   ATMProcessor atmProcessor = ATMProcessor(
//     cardsController: cardsController,
//     transactionsController: transactionsController,
//     card: cards[0],
//   );

//   atmProcessor.pickMenu();
// }
