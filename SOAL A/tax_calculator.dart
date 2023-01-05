abstract class TaxCalculator {
  double calculate(double amount);
}

class TaxCalculatorPpn10 implements TaxCalculator {
  /// Mengembalikan nilai pajak 10%
  @override
  double calculate(double amount) {
    // amount tidak boleh negatif
    if (amount < 0) {
      throw Exception();
    }
    
    // % pajak
    double precentage = 0.10;

    return precentage * amount;
  }
}

class TaxCalculatorPpn11 implements TaxCalculator {
  /// Mengembalikan nilai pajak 11%
  @override
  double calculate(double amount) {
    // amount tidak boleh negatif
    if (amount < 0) {
      throw Exception();
    }
    
    // % pajak
    double precentage = 0.11;

    return precentage * amount;
  }
}

class TaxCalculatorPpn10IncludeTax implements TaxCalculator {
  /// Mengembalikan pajak dari [amount] yang sudah dikenai pajak 10%
  ///
  /// contoh kasus:
  ///
  /// [amount] = 110 (sudah termasuk pajak 10%)
  ///
  /// => 10
  @override
  double calculate(double amount) {
    // amount tidak boleh negatif
    if (amount < 0) {
      throw Exception();
    }

    // % pajak
    double precentage = 0.10;

    // amount di sini sudah dikenai pajak
    // kita ingin mencari tahu pajaknya berapa
    // jika amount = amount wo pajak + precentage * amount wo pajak
    // amount => x
    // amount wo pajak => y
    // precentage => 0.10

    // x = y + 0.1 * y
    // x = y (1 + 0.1)
    // x = 1.1 y
    // y = x : 1.1

    // untuk mencari pajaknya (0.1 * y) => 0.1 * (x:1.1)
    // dimana 0.1 = precentage, dan 1.1 adalah 1 + precentage

    return precentage * (amount / (1 + precentage));
  }
}

class TaxCalculatorPpn11IncludeTax implements TaxCalculator {
  /// Mengembalikan pajak dari [amount] yang sudah dikenai pajak 10%
  ///
  /// contoh kasus:
  ///
  /// [amount] = 111 (sudah termasuk pajak 11%)
  ///
  /// => 11
  @override
  double calculate(double amount) {
    // amount tidak boleh negatif
    if (amount < 0) {
      throw Exception();
    }

    // % pajak
    double precentage = 0.11;

    // kasus seperti TaxCalculatorPpn10IncludeTax
    // rumus mendapatkan pajaknya adalah
    // precentage * (amount : (1 + precentage))
    return precentage * (amount / (1 + precentage));
  }
}

class TaxCalculatorPph21 implements TaxCalculator {
  /// Mengembalikan pajak dari [amount] dengan ketentuan:
  ///
  /// [amount] < 40jt => pajak 0%
  ///
  /// [amount] 40jt - <50jt => pajak 5%
  ///
  /// [amount] 50jt - <250jt => pajak 15%
  ///
  /// [amount] 250jt - <500jt => pajak 25%
  ///
  /// [amount] >= 500jt => pajak 30%
  @override
  double calculate(double amount) {
    // amount tidak boleh negatif
    if (amount < 0) {
      throw Exception();
    }

    // satuan dalam juta
    double juta = 1000000;

    // % pajak
    late double precentage;

    if (amount < 40 * juta) {
      precentage = 0.00;
    } else if (amount < 50 * juta) {
      precentage = 0.05;
    } else if (amount < 250 * juta) {
      precentage = 0.15;
    } else if (amount < 500 * juta) {
      precentage = 0.25;
    } else if (amount >= 500 * juta) {
      precentage = 0.30;
    } else {
      precentage = -1;
    }

    return precentage * amount;
  }
}
