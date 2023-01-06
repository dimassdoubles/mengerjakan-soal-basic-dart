import 'card.dart';
import 'card_information.dart';
import 'exceptions.dart';
import 'transaction.dart';
import 'validator.dart';

abstract class CardMachine {
  Type get insertedCardType;

  List<Transaction> getAccountMutation();

  CardInformation? getCardInformation();

  void insertCard(String cardNumber);

  void removeCard();

  void authenticate(String pin);

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
  // index kartu yang dimasukkan ke mesin atm
  // -1 berarti tidak ada kartu yang sedang dimasukkan
  int _cardIndex = -1;

  //
  bool _authenticated = false;

  // list kartu yang terdaftar
  final List<Card> _cards;

  // list transaksi
  List<Transaction> _transactions = [];

  CardMachineImpl({required List<Card> cards}) : _cards = cards;

  void mustInsertCard() {
    if (_cardIndex < 0) {
      throw KartuBelumDimasukkanException();
    }
  }

  void mustValidCardNumber(String cardNumber) {
    if (!isvalidNumber(cardNumber)) {
      throw NomorKartuTidakValidException();
    }
  }

  void mustValidAccountNumber(String accountNumber) {
    if (!isvalidNumber(accountNumber)) {
      throw NomorRekeningTidakValidException();
    }
  }

  void mustValidAmount(double amount) {
    if (amount < 1) {
      throw NominalTidakValidException();
    }
  }

  void mustValidPin(String pin) {
    if (!isValidPin(pin)) {
      throw PinTidakValidException();
    }
  }

  void mustAuthenticated() {
    if (!_authenticated) {
      throw UnauthenticatedException();
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
      throw RekeningTidakTerdaftarException();
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
  Type get insertedCardType {
    // memastikan sudah di otentikasi
    mustAuthenticated();

    return _cards[_cardIndex].runtimeType;
  }

  @override
  List<Transaction> getAccountMutation() {
    // memastikan sudah di otentikasi
    mustAuthenticated();

    // mencari transaksi berdasarkan nomor kartu
    return _transactions
        .where(
          (element) => element.cardNumber == _cards[_cardIndex].cardNumber,
        )
        .toList();
  }

  @override
  void insertCard(String cardNumber) {
    // memastikan tidak ada kartu yang ada di dalam mesin
    if (_cardIndex != -1) {
      throw MesinAtmSedangDigunakanException();
    }

    // memastikan nomor kartu valid
    mustValidCardNumber(cardNumber);

    // ketika memasukan kartu, pasti autentikasi false
    _authenticated = false;

    // mencari nomor kartu di list kartu
    int cardIndex = mustRegisteredCardNumber(cardNumber);

    // mengganti index kartu yang sedang bertransaksi
    _cardIndex = cardIndex;
  }

  @override
  void removeCard() {
    // set card index = -1
    _cardIndex = -1;

    _authenticated = false;
  }

  @override
  void checkOut(double amount) {
    // memastikan nominal valid
    mustValidAmount(amount);

    // memastikan sudah di otentikasi
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
        balance: _cards[_cardIndex].balance,
      ),
    );
  }

  @override
  CardInformation? getCardInformation() {
    // memastikan sudah di otentikasi
    mustAuthenticated();

    // menampilkan informasi kartu sesuai jenisnya
    final card = _cards[_cardIndex];
    if (card is ATM) {
      return ATMInfo(
        accountNumber: card.accountNumber,
        balance: card.balance,
        cardNumber: card.cardNumber,
        bankBranch: card.bankBranch,
        name: card.name,
      );
    } else if (card is EMoney) {
      return EMoneyInfo(
        cardNumber: card.cardNumber,
        balance: card.balance,
      );
    }
    return null;
  }

  @override
  void authenticate(String pin) {
    // memeastikan sudah kartu sudah diterima mesin
    mustInsertCard();

    // memastikan pin valid
    mustValidPin(pin);

    // memastikan pin sesuai dengan nomor kartu saat ini
    if (_cards[_cardIndex].pin == pin) {
      _authenticated = true;
    } else {
      _authenticated = false;
      throw UnauthenticatedException();
    }
  }

  // must atm

  @override
  void withDraw(double amount) {
    // memastikan nominal valid
    mustValidAmount(amount);

    // memastikan sudah di otentikasi
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
    // memastikan nominal valid
    mustValidAmount(amount);

    // memastikan user sudah di otentikasi
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
        balance: _cards[_cardIndex].balance,
      ),
    );
  }

  @override
  void topUpEmoney({
    required String receiverCardNumber,
    required double amount,
  }) {
    // memastikan nomor kartu valid
    mustValidCardNumber(receiverCardNumber);

    // memastikan nominal valid
    mustValidAmount(amount);

    // memastikan sudah di otentikasi
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
        balance: _cards[_cardIndex].balance,
        receiverCardNumber: receiverCardNumber,
      ),
    );

    final senderCard = _cards[_cardIndex];
    if (senderCard is ATM)
      _transactions.add(
        ReceiveTransaction(
          cardNumber: _cards[receiverIndex].cardNumber,
          amount: amount,
          balance: _cards[receiverIndex].balance,
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
    // memastikan nomor kartu valid
    mustValidAccountNumber(receiverAccountNumber);

    // memastikan nominal valid
    mustValidAmount(amount);

    // memastikan sudah di otentikasi
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
