import 'dart:io';

import 'card.dart';
import 'card_machine.dart';
import 'cards.dart';
import 'exceptions.dart';
import 'transaction.dart';
import 'validator.dart';

void main() {
  CardMachine cardMachine = CardMachineImpl(cards: cards);

  while (true) {
    login(cardMachine);

    transactionProcess(cardMachine);

    // keluarkan kartu setelah transaksi selesai
    cardMachine.removeCard();
  }
}

void transactionProcess(CardMachine cardMachine) {
  switch (cardMachine.loggedInCardType) {
    case ATM:
      {
        // menampilkan menu
        print("\nMenu");
        print("a. Informasi rekening");
        print("b. Tarik tunai");
        print("c. Setor tunai");
        print("d. Transfer");
        print("e. Top-Up E-Money");
        print("f. Mutasi kartu");
        print("g. Pembayaran");
        print("\nSilahkan pilih menu (urutan abjad):");

        // input pilihan menu dari user
        String selectedMenu = stdin.readLineSync() ?? "";

        switch (selectedMenu.toUpperCase()) {
          // menu informasi rekening
          case "A":
            {
              cardMachine.seeCardInformation();
            }
            break;

          // menu tarik tunai
          case "B":
            {
              withDraw(cardMachine);
            }
            break;

          // menu setor tunai
          case "C":
            {
              deposit(cardMachine);
            }
            break;

          // menu transfer
          case "D":
            {
              transfer(cardMachine);
            }
            break;

          // menu topup e money
          case "E":
            {
              topUp(cardMachine);
            }
            break;

          // menu mutasi rekening
          case "F":
            {
              seeMutation(cardMachine);
            }
            break;

          // menu pembayaran pembelanjaan
          case "G":
            {
              authenticate(cardMachine);
              checkout(cardMachine);
            }
            break;

          default:
            {}
        }
      }
      break;
    case EMoney:
      {
        // menampilkan menu
        print("\nMenu");
        print("a. Informasi rekening");
        print("b. Mutasi kartu");
        print("c. Pembayaran");
        print("\nSilahkan pilih menu (urutan abjad):");

        // input pilihan menu dari user
        String selectedMenu = stdin.readLineSync() ?? "";

        switch (selectedMenu.toUpperCase()) {
          // menu informasi rekening
          case "A":
            {
              cardMachine.seeCardInformation();
            }
            break;

          // menu mutasi rekening
          case "B":
            {
              seeMutation(cardMachine);
            }
            break;

          // menu pembayaran belanja
          case "C":
            {
              checkout(cardMachine);
            }
            break;
          default:
            {}
        }
      }
      break;
    default:
      {
        print("\nMaaf, atm tidak bisa melayani kartu anda");
      }
  }

  print("\nApakah anda ingin bertransaksi lagi ? y/n:");
  String nextTransaction = stdin.readLineSync() ?? "";

  if (nextTransaction.toUpperCase() == "Y") {
    try {
      authenticate(cardMachine);
      transactionProcess(cardMachine);
    } on UnauthenticatedException {
      print("Maaf, pin yang anda masukan salah");
    } on PinTidakValidException {
      print("Maaf, pin tidak valid");
    }
  }
}

void authenticate(CardMachine cardMachine) {
  print("\nMasukan pin:");
  String pin = stdin.readLineSync() ?? "";
  try {
    cardMachine.authenticate(pin);
  } on UnauthenticatedException {
    print("\nMaaf, pin yang anda masukkan salah");
  } on KartuBelumDimasukkanException {
    print("\nMaaf, anda harus memasukkan kartu terlebih dahulu");
  }
}

void checkout(CardMachine cardMachine) {
  try {
    // mengambil input nominal dari user
    double amount = inputAmount();

    cardMachine.checkOut(amount);
  } on SaldoKurangException {
    print("\nMaaf, saldo tidak cukup untuk melakukan transaksi ini");
  } on UnauthenticatedException {
    print("\nMaaf, kartu belum diautentikasi");
  }
}

void transfer(CardMachine cardMachine) {
  print("\nMasukan nomor rekening penerima:");
  String receiverAccountNumber = stdin.readLineSync() ?? "";

  print("\nMasukan nominal transfer       :");
  double amount = double.parse(stdin.readLineSync() ?? "");

  try {
    cardMachine.transfer(
      receiverAccountNumber: receiverAccountNumber,
      amount: amount,
    );
    print("\nTransaksi berhasil");
  } on UnauthenticatedException {
    print("\nBelum autentikasi");
  } on RekeningTidakTerdaftarException {
    print("\nMaaf, penerima tidak terdaftar");
  } on TransaksiDilarangException {
    print("\nMaaf, kartu anda tidak bisa melakukan transaksi ini");
  } on SaldoKurangException {
    print("\nMaaf, saldo anda kurang");
  }
}

void topUp(CardMachine cardMachine) {
  print("\nMasukan nomor kartu E-money tujuan:");
  String receiverCardNumber = stdin.readLineSync() ?? "";

  // mengambil input nominal dari user
  double amount = inputAmount();

  try {
    cardMachine.topUpEmoney(
      receiverCardNumber: receiverCardNumber,
      amount: amount,
    );
  } on UnauthenticatedException {
    print(
      "\nBelum otentikasi",
    );
  } on TransaksiDilarangException {
    print(
      "\nMaaf, kartu anda tidak dapat digunakan untuk melakukan transaksi ini",
    );
  } on SaldoKurangException {
    print("\nMaaf, saldo anda tidak mencukupi");
  } on SaldoMelebihiBatasException {
    print("\nMaaf, saldo penerima melebihi batas maksimal");
  } on KartuTidakTerdaftarException {
    print("\nMaaf, nomor kartu tidak terdaftar");
  }
}

void seeMutation(CardMachine cardMachine) {
  print("\nMutasi Kartu");
  print("------------");
  // mendapatkan daftar transaksi dari mesin atm
  List<Transaction> transactions = cardMachine.getAccountMutation();

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

void deposit(CardMachine cardMachine) {
  // mengambil input nominal dari user
  double amount = inputAmount();

  try {
    cardMachine.deposit(amount);
    print("\nTransaksi berhasil");
    cardMachine.seeCardInformation();
  } on UnauthenticatedException {
    print(
      "\nBelum otentikasi",
    );
  } on TransaksiDilarangException {
    print("\nMaaf, kartu anda tidak dapat melakukan transaksi ini");
  }
}

void withDraw(CardMachine cardMachine) {
  // mengambil input nominal dari user
  double amount = inputAmount();

  try {
    cardMachine.withDraw(amount);
    print("\nTransaksi berhasil");
    cardMachine.seeCardInformation();
  } on SaldoKurangException {
    print("\nMaaf, saldo anda tidak mencukupi");
    cardMachine.seeCardInformation();
  }
}

double inputAmount() {
  double amount;
  try {
    print("\nMasukan nominal:");
    amount = double.parse(stdin.readLineSync()!);
    if (amount < 1) {
      throw Exception();
    }
    return amount;
  } catch (e) {
    print("\nNominal tidak valid");
    return inputAmount();
  }
}

/// Akan memanggil dirinya secara terus menerus apabila user salah memasukan nomor kartu atau nomor pin
void login(
  CardMachine cardMachine,
) {
  try {
    insertCard(cardMachine);

    // melakukan otentikasi
    autehenticate(cardMachine);
  }
  // ketika kartu tidak terdaftar
  // mesin restart proses login
  on KartuTidakTerdaftarException {
    print("\nKartu tidak terdaftar");
    login(cardMachine);
  }
  // ketika salah pin
  // mesin akan meminta untuk memasukan pin lagi
  on UnauthenticatedException {
    print("\nSalah pin");
    authenticate(cardMachine);
  }
  // ketika nomor kartu tidak valid
  // mesin akan memulai ulang proses login
  on NomorKartuTidakValidException {
    print("\nNomor kartu tidak valid");
    login(cardMachine);
  }
  // ketika pin tidak valid
  // mesin akan meminta masukan pin lagi
  on PinTidakValidException {
    print("\nPin tidak valid");
    authenticate(cardMachine);
  } on KartuBelumDimasukkanException {
    print("\nMasukan nomor kartu terlebih dahulu");
  }
}

void autehenticate(CardMachine cardMachine) {
  print("\nMasukan pin        :");
  String pin = stdin.readLineSync() ?? "";

  // melakukan validasi pin
  if (!isValidPin(pin)) {
    throw PinTidakValidException();
  }

  // melakukan otentikasi
  cardMachine.authenticate(pin);
}

void insertCard(CardMachine cardMachine) {
  print("\nMasukan nomor kartu:");
  String cardNumber = stdin.readLineSync() ?? "";

  // melakukan validasi nomor kartu
  if (!isvalidNumber(cardNumber)) {
    throw NomorKartuTidakValidException();
  }

  // kartu diterima mesin
  cardMachine.insertCard(cardNumber);
}
