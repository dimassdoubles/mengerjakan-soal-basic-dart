import 'card.dart';
import 'exceptions.dart';
import 'transaction.dart';

// TODO : validasi amount
// TODO : validasi nomor kartu
// TODO : validasi nomor rekening

abstract class CardMachine {
  Type get loggedInCardType;

  List<Transaction> getAccountMutation();

  void seeCardInformation();

  void login({
    required String cardNumber,
    required String pin,
  });

  void logout();

  void checkOut(double amount);

  // hanya atm

  void withDraw(double amount);

  void deposit(double amount);

  void transfer({
    required String receiverAccountNumber,
    required double amount,
  });

  void topUpEmoney({
    required String receiverCardNumber,
    required double amount,
  });
}

class CardMachineImpl extends CardMachine {
  // index kartu yang sedang bertransaksi
  // -1 berarti tidak ada kartu yang sedang bertransaksi
  int _cardIndex = -1;

  // list kartu yang terdaftar
  final List<Card> _cards;

  // list transaksi
  List<Transaction> _transactions = [];

  CardMachineImpl({required List<Card> cards}) : _cards = cards;

  void mustAuthenticated() {
    if (_cardIndex < 0) {
      throw BelumLoginException();
    }
  }

  void mustEnoughBalance(double amount) {
    if (amount > _cards[_cardIndex].balance) {
      throw SaldoKurangException();
    }
  }

  void mustATM() {
    if (_cards[_cardIndex] is! ATM) {
      throw TransaksiDilarangException();
    }
  }

  /// Mencari nomor rekening di daftar
  ///
  /// Apabila ditemukan, fungsi akan mengembalikan index kartu
  ///
  /// Apabila tidak, fungsi akan throw [KartuTidakTerdaftarException]
  int mustRegisteredAccountNumber(String accountNumber) {
    final cardIndex = _cards.indexWhere(
      (element) {
        if (element is ATM) {
          return element.accountNumber == accountNumber;
        }
        return false;
      },
    );

    // mengecek apakah kartu terdaftar di daftar
    if (cardIndex == -1) {
      throw KartuTidakTerdaftarException();
    }

    return cardIndex;
  }

  /// Mencari nomor kartu di daftar
  ///
  /// Apabila ditemukan, fungsi akan mengembalikan index kartu
  ///
  /// Apabila tidak, fungsi akan throw [KartuTidakTerdaftarException]
  int mustRegisteredCardNumber(String cardNumber) {
    final cardIndex = _cards.indexWhere(
      (element) => element.cardNumber == cardNumber,
    );

    // mengecek apakah kartu terdaftar di daftar
    if (cardIndex == -1) {
      throw KartuTidakTerdaftarException();
    }

    return cardIndex;
  }

  @override
  Type get loggedInCardType {
    // memastikan sudah login
    mustAuthenticated();

    return _cards[_cardIndex].runtimeType;
  }

  @override
  List<Transaction> getAccountMutation() {
    // memastikan sudah login
    mustAuthenticated();

    // mencari transaksi berdasarkan nomor kartu
    return _transactions
        .where(
          (element) => element.cardNumber == _cards[_cardIndex].cardNumber,
        )
        .toList();
  }

  @override
  void login({required String cardNumber, required String pin}) {
    // mencari nomor kartu di list kartu
    int cardIndex = mustRegisteredCardNumber(cardNumber);

    // mengecek apakah nomor kartu dan pin sesuai
    bool isCorrectPin = _cards[cardIndex].pin == pin;
    if (isCorrectPin) {
      // mengganti index kartu yang sedang bertransaksi
      _cardIndex = cardIndex;
    } else {
      throw SalahPinException();
    }
  }

  @override
  void logout() {
    // set card index = -1
    _cardIndex = -1;
  }

  @override
  void checkOut(double amount) {
    // memastikan sudah login
    mustAuthenticated();

    // memastikan saldo cukup untuk bertransaksi
    mustEnoughBalance(amount);

    // mengurangi saldo
    _cards[_cardIndex].setBalance = _cards[_cardIndex].balance - amount;

    // mencatat transaksi
    _transactions.add(
      CheckOutTransaction(
        cardNumber: _cards[_cardIndex].cardNumber,
        amount: amount,
        balance: _cards[_cardIndex].balance - amount,
      ),
    );
  }

  @override
  void seeCardInformation() {
    // memastikan sudah login
    mustAuthenticated();

    // menampilkan informasi kartu sesuai jenisnya
    final card = _cards[_cardIndex];
    if (card is ATM) {
      print("Informasi Kartu");
      print("-----------------------");
      print("Jenis kartu           : ATM");
      print("Nomor kartu           : ${card.cardNumber}");
      print("Nomor Rekening        : ${card.accountNumber}");
      print("Cabang bank           : ${card.bankBranch}");
      print("Nama pemilik rekening : ${card.name}");
      print("Sisal saldo           : ${card.balance}");
    } else if (card is EMoney) {
      print("Informasi Kartu");
      print("-----------------------");
      print("Jenis kartu           : E-Money");
      print("Nomor kartu           : ${card.cardNumber}");
      print("Sisa Saldo            : ${card.balance}");
    }
  }

  // must atm

  @override
  void withDraw(double amount) {
    // memastikan sudah login
    mustAuthenticated();

    // memastikan jenis kartu adalah atm
    mustATM();

    // memastikan saldo kartu cukup
    mustEnoughBalance(amount);

    // mengurang saldo
    double balance = _cards[_cardIndex].balance - amount;
    _cards[_cardIndex].setBalance = balance;

    // mencatat transaksi withdraw
    _transactions.add(
      WithDrawTransaction(
        cardNumber: _cards[_cardIndex].cardNumber,
        amount: amount,
        balance: balance,
      ),
    );
  }

  @override
  void deposit(double amount) {
    // memastikan user sudah login
    mustAuthenticated();

    // memastikan kartu untuk transaksi adalah atm
    mustATM();

    // menambah saldo
    _cards[_cardIndex].setBalance = _cards[_cardIndex].balance + amount;

    // mencatat transaksi
    _transactions.add(
      DepositTransaction(
        cardNumber: _cards[_cardIndex].cardNumber,
        amount: amount,
        balance: _cards[_cardIndex].balance + amount,
      ),
    );
  }

  @override
  void topUpEmoney({
    required String receiverCardNumber,
    required double amount,
  }) {
    // memastikan sudah login
    mustAuthenticated();

    // memastikan kartu pengirim adalah ATM
    mustATM();

    // memastikan saldo cukup untuk melakukan transaksi
    mustEnoughBalance(amount);

    // memastikan nomor kartu penerima terdaftar
    int receiverIndex = mustRegisteredCardNumber(receiverCardNumber);

    // memastikan kartu penerima adalah E-Money
    if (_cards[receiverIndex] is! EMoney) {
      throw TransaksiDilarangException();
    }

    // memastikan saldo tidak melebihi 1jt
    if (_cards[receiverIndex].balance + amount > 1000000) {
      throw SaldoMelebihiBatasException();
    }

    // mengurangi saldo pengirim
    _cards[_cardIndex].setBalance = _cards[_cardIndex].balance - amount;

    // menambah saldo penerima
    _cards[receiverIndex].setBalance = _cards[receiverIndex].balance + amount;

    // mencatat transaksi
    _transactions.add(
      TopUpTransaction(
        cardNumber: _cards[_cardIndex].cardNumber,
        amount: amount,
        balance: _cards[_cardIndex].balance - amount,
        receiverCardNumber: receiverCardNumber,
      ),
    );

    final senderCard = _cards[_cardIndex];
    if (senderCard is ATM)
      _transactions.add(
        ReceiveTransaction(
          cardNumber: _cards[receiverIndex].cardNumber,
          amount: amount,
          balance: _cards[receiverIndex].balance + amount,
          senderAccountNumber: senderCard.accountNumber,
          senderName: senderCard.name,
        ),
      );
  }

  @override
  void transfer({
    required String receiverAccountNumber,
    required double amount,
  }) {
    // memastikan sudah login
    mustAuthenticated();

    // memastikan kartu yang digunakan adalah ATM
    mustATM();

    // memastikan saldonya cukup untuk bertransaksi
    mustEnoughBalance(amount);

    // memastikan nomor rekening penerima terdaftar
    int receiverIndex = mustRegisteredAccountNumber(receiverAccountNumber);

    // mengurangi saldo pengirim
    _cards[_cardIndex].setBalance = _cards[_cardIndex].balance - amount;

    // menambah saldo penerima
    _cards[receiverIndex].setBalance = _cards[receiverIndex].balance + amount;

    // mencatat transaksi
    final sender = _cards[_cardIndex];
    final receiver = _cards[receiverIndex];
    if (sender is ATM && receiver is ATM) {
      _transactions.add(
        SendTransaction(
          cardNumber: sender.cardNumber,
          amount: amount,
          balance: sender.balance,
          receiverAccountNumber: receiver.accountNumber,
          receiverName: receiver.name,
        ),
      );
      _transactions.add(
        ReceiveTransaction(
          cardNumber: receiver.cardNumber,
          amount: amount,
          balance: receiver.balance,
          senderAccountNumber: sender.accountNumber,
          senderName: sender.name,
        ),
      );
    }
  }
}
