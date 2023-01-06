import 'card_machine.dart';
import 'cards.dart';
import 'exceptions.dart';

void main() {
  CardMachine cardMachine = CardMachineImpl(cards: cards);

  try {
    cardMachine.login(cardNumber: "A1234567", pin: "dimas");
  } on SalahPinException {
    print("Maaf, pin yang anda masukan salah");
  } on KartuTidakTerdaftarException {
    print("Maaf, kartu tidak terdaftar");
  }

  try {
    cardMachine.withDraw(1);
  } on SaldoKurangException {
    print("Maaf, saldo kurang");
  } on BelumLoginException {
    print("Maaf, anda harus memasukan nomor kartu dan pin terlebih dahulu");
  } on TransaksiDilarangException {
    print("Maaf, kartu yang anda gunakan tidak bisa melakukan transaksi ini");
  }

  cardMachine.seeCardInformation();

  print(cardMachine.loggedInCardType);

  try {
    final transactions = cardMachine.getAccountMutation();
    for (int i = 0; i < transactions.length; i++) {
      print(
          "${transactions[i].runtimeType} - ${transactions[i].amount} - ${transactions[i].balance}");
    }
  } catch (e) {}
}
