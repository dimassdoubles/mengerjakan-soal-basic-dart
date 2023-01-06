import 'eceptions.dart';
import 'tax_calculator.dart';
import 'dart:io';

void main() {
  final taxCalculatorPpn10 = TaxCalculatorPpn10();
  final taxCalculatorPpn11 = TaxCalculatorPpn11();
  final taxCalculatorPpn10IncludeTax = TaxCalculatorPpn10IncludeTax();
  final taxCalculatorPpn11IncludeTax = TaxCalculatorPpn11IncludeTax();
  final taxCalculatorPph21 = TaxCalculatorPph21();

  while (true) {
    try {
      calculateProcess(taxCalculatorPpn10IncludeTax, taxCalculatorPpn10,
          taxCalculatorPpn11IncludeTax, taxCalculatorPpn11, taxCalculatorPph21);
    } on PilihanTidakValidException {
      print("\nMaaf, pilihan anda tidak valid");
    }
    print("\n");
  }
}

void calculateProcess(
    TaxCalculatorPpn10IncludeTax taxCalculatorPpn10IncludeTax,
    TaxCalculatorPpn10 taxCalculatorPpn10,
    TaxCalculatorPpn11IncludeTax taxCalculatorPpn11IncludeTax,
    TaxCalculatorPpn11 taxCalculatorPpn11,
    TaxCalculatorPph21 taxCalculatorPph21) {
  String taxSelected = selectTaxType().toUpperCase();
  String amountType = "";
  bool ppnSelected = false;

  switch (taxSelected) {
    // calculator ppn 10%
    case "A":
      {
        ppnSelected = true;
        amountType = selectAmountType().toUpperCase();
      }
      break;

    // calculator ppn 11%
    case "B":
      {
        ppnSelected = true;
        amountType = selectAmountType().toUpperCase();
      }
      break;

    // calculator pph 21
    case "C":
      {}
      break;

    // ketika inputan tidak ada di menu
    default:
      {
        throw PilihanTidakValidException();
      }
  }

  // menampilkan pesan error ketika user salah input jenis harga
  if (ppnSelected && amountType != "A" && amountType != "B") {
    throw PilihanTidakValidException();
  }

  double amount = inputAmount();

  print("\nHasil Perhitungan Pajak");
  print("-----------------------");

  late double result;
  switch (taxSelected + amountType) {
    // kasus taxCalculatorPpn10IncludeTax
    case "AA":
      {
        print("Jenis Pajak  : PPN 10% / Harga Include Tax");
        result = taxCalculatorPpn10IncludeTax.calculate(amount);
      }
      break;

    // kasus taxCalculatorPpn10
    case "AB":
      {
        print("Jenis Pajak  : PPN 10% / Harga Exclude Tax");
        result = taxCalculatorPpn10.calculate(amount);
      }
      break;

    // kasus taxCalculatorPpn11IncludeTax
    case "BA":
      {
        print("Jenis Pajak  : PPN 11% / Harga Include Tax");
        result = taxCalculatorPpn11IncludeTax.calculate(amount);
      }
      break;

    // kasus taxCalculatorPpn11
    case "BB":
      {
        {
          print("Jenis Pajak  : PPN 11% / Harga Exclude Tax");
          result = taxCalculatorPpn11.calculate(amount);
        }
      }
      break;

    // kasus taxCalculatorPph21
    case "C":
      {
        print("Jenis Pajak  : PPH 21");
        result = taxCalculatorPph21.calculate(amount);
      }
      break;

    default:
      {
        result = -1;
      }
  }

  // mengecek apakah hasilnya valid atau tidak
  print("Nilai Amount : $amount");
  print("Pajak        : $result");
}

double inputAmount() {
  try {
    print("\nSilahkan masukan harga:");
    double amount = double.parse(stdin.readLineSync()!);
    if (amount < 1) {
      throw Exception();
    }
    return amount;
  } catch (e) {
    print("\nMaaf, nominal yang anda masukkan tidak valid");
    return inputAmount();
  }
}

String selectTaxType() {
  print("\na. PPN 10%");
  print("b. PPN 11%");
  print("c. PPH 21");
  print("Silahkan masukan jenis pajak (urutan abjadnya):");
  return stdin.readLineSync() ?? "";
}

String selectAmountType() {
  print("\na. Harga Include Tax");
  print("b. Harga Exclude Tax");
  print("Silahkan masukan jenis harga (urutan abjadnya):");
  return stdin.readLineSync() ?? "";
}
