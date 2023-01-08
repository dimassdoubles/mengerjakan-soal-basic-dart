import '../models/card.dart';

abstract class CardView {
  final _card;

  CardView({required Card card}) : _card = card;

  void printCardInformation() {
    print("Informasi Kartu");
    print("-----------------------");
    print("Tipe Kartu            : ${_card.runtimeType}");
    print("Nomor kartu           : ${_card.cardNumber}");
    print("Saldo                 : ${_card.balance}");
  }
}

class ATMView extends CardView {
  ATMView({required super.card});

  @override
  void printCardInformation() {
      super.printCardInformation();
      print("Nomor Rekening        : ${_card.accountNumber}");
      print("Cabang bank           : ${_card.bankBranch}");
      print("Nama pemilik rekening : ${_card.name}");
  }
}

class EMoneyView extends CardView {
  EMoneyView({required super.card});
}
