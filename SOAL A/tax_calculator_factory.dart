import 'tax_calculator.dart';

const String ppn10 = "ppn10";
const String ppn11 = "ppn11";
const String ppn10IncludeTax = "ppn10IncludeTax";
const String ppn11IncludeTax = "ppn11IncludeTax";
const String pph21 = "pph21";

class TaxCalculatorFactory {
  TaxCalculator? getCalculator(String calculatorType) {
    switch (calculatorType) {
      case ppn10:
        {
          return TaxCalculatorPpn10();
        }
      case ppn10IncludeTax:
        {
          return TaxCalculatorPpn10IncludeTax();
        }
      case ppn11:
        {
          return TaxCalculatorPpn11();
        }
      case ppn11IncludeTax:
        {
          return TaxCalculatorPpn11IncludeTax();
        }
      case pph21:
        {
          return TaxCalculatorPph21();
        }
      default:
        {
          return null;
        }
    }
  }
}
