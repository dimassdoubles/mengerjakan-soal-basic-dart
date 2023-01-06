import 'package:test/test.dart';

import '../card.dart';
import '../card_information.dart';
import '../card_machine.dart';
import '../cards.dart';
import '../exceptions.dart';

void main() {
  late CardMachine cardMachine;
  late List<Card> testCards;

  group("ATM", () {
    const cardNumber = "1111111111";
    const accountNumber = "0000000000";
    const bankBranch = "Semarang";
    const name = "Dimas";
    const balance = 100.0;
    const pin = "111111";
    final cardInfo = ATMInfo(
      cardNumber: cardNumber,
      accountNumber: accountNumber,
      bankBranch: bankBranch,
      balance: balance,
      name: name,
    );
    const receiverCardNumber = "2222222222";
    const receiverPin = "222222";
    const receiverAccountNumber = "9999999999";
    const emoneyCardNumber = "3333333333";
    const emoneyPin = "333333";

    setUp(() {
      testCards = [
        ATM(
          cardNumber: "1111111111",
          accountNumber: "0000000000",
          pin: "111111",
          name: "Dimas",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "2222222222",
          accountNumber: "9999999999",
          pin: "222222",
          name: "Abi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9371047517",
          accountNumber: "1379290461",
          pin: "256351",
          name: "Ozi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "6109164644",
          accountNumber: "0075772055",
          pin: "143273",
          name: "Brian",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9803420422",
          accountNumber: "4998144570",
          pin: "109149",
          name: "Henik",
          bankBranch: "Semarang",
          balance: 100,
        ),
        EMoney(
          cardNumber: "3333333333",
          pin: "333333",
          balance: 100,
        ),
        EMoney(
          cardNumber: "1408822288",
          pin: "680071",
          balance: 100,
        ),
      ];

      cardMachine = CardMachineImpl(cards: testCards);
    });
    test("getter insertedCardType", () {
      // given
      cardMachine.insertCard(cardNumber);
      cardMachine.authenticate(pin);

      // when
      Type cardType = cardMachine.insertedCardType;

      // then (kondisi yang diharapkan)
      expect(cardType, ATM);
    });

    setUp(() {
      testCards = [
        ATM(
          cardNumber: "1111111111",
          accountNumber: "0000000000",
          pin: "111111",
          name: "Dimas",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "2222222222",
          accountNumber: "9999999999",
          pin: "222222",
          name: "Abi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9371047517",
          accountNumber: "1379290461",
          pin: "256351",
          name: "Ozi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "6109164644",
          accountNumber: "0075772055",
          pin: "143273",
          name: "Brian",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9803420422",
          accountNumber: "4998144570",
          pin: "109149",
          name: "Henik",
          bankBranch: "Semarang",
          balance: 100,
        ),
        EMoney(
          cardNumber: "3333333333",
          pin: "333333",
          balance: 100,
        ),
        EMoney(
          cardNumber: "1408822288",
          pin: "680071",
          balance: 100,
        ),
      ];

      cardMachine = CardMachineImpl(cards: testCards);
    });
    test("insertCard", () {
      // given / when
      cardMachine.insertCard(cardNumber);

      //
    });

    setUp(() {
      testCards = [
        ATM(
          cardNumber: "1111111111",
          accountNumber: "0000000000",
          pin: "111111",
          name: "Dimas",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "2222222222",
          accountNumber: "9999999999",
          pin: "222222",
          name: "Abi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9371047517",
          accountNumber: "1379290461",
          pin: "256351",
          name: "Ozi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "6109164644",
          accountNumber: "0075772055",
          pin: "143273",
          name: "Brian",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9803420422",
          accountNumber: "4998144570",
          pin: "109149",
          name: "Henik",
          bankBranch: "Semarang",
          balance: 100,
        ),
        EMoney(
          cardNumber: "3333333333",
          pin: "333333",
          balance: 100,
        ),
        EMoney(
          cardNumber: "1408822288",
          pin: "680071",
          balance: 100,
        ),
      ];

      cardMachine = CardMachineImpl(cards: testCards);
    });
    test("authenticate", () {
      // given
      cardMachine.insertCard(cardNumber);

      // when / then
      // sukses otentikasi
      cardMachine.authenticate(pin);
    });

    setUp(() {
      testCards = [
        ATM(
          cardNumber: "1111111111",
          accountNumber: "0000000000",
          pin: "111111",
          name: "Dimas",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "2222222222",
          accountNumber: "9999999999",
          pin: "222222",
          name: "Abi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9371047517",
          accountNumber: "1379290461",
          pin: "256351",
          name: "Ozi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "6109164644",
          accountNumber: "0075772055",
          pin: "143273",
          name: "Brian",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9803420422",
          accountNumber: "4998144570",
          pin: "109149",
          name: "Henik",
          bankBranch: "Semarang",
          balance: 100,
        ),
        EMoney(
          cardNumber: "3333333333",
          pin: "333333",
          balance: 100,
        ),
        EMoney(
          cardNumber: "1408822288",
          pin: "680071",
          balance: 100,
        ),
      ];

      cardMachine = CardMachineImpl(cards: testCards);
    });
    test("getCardInformation", () {
      // given
      cardMachine.insertCard(cardNumber);
      cardMachine.authenticate(pin);

      // then
      expect(cardMachine.getCardInformation()!, cardInfo);
    });

    setUp(() {
      testCards = [
        ATM(
          cardNumber: "1111111111",
          accountNumber: "0000000000",
          pin: "111111",
          name: "Dimas",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "2222222222",
          accountNumber: "9999999999",
          pin: "222222",
          name: "Abi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9371047517",
          accountNumber: "1379290461",
          pin: "256351",
          name: "Ozi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "6109164644",
          accountNumber: "0075772055",
          pin: "143273",
          name: "Brian",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9803420422",
          accountNumber: "4998144570",
          pin: "109149",
          name: "Henik",
          bankBranch: "Semarang",
          balance: 100,
        ),
        EMoney(
          cardNumber: "3333333333",
          pin: "333333",
          balance: 100,
        ),
        EMoney(
          cardNumber: "1408822288",
          pin: "680071",
          balance: 100,
        ),
      ];

      cardMachine = CardMachineImpl(cards: testCards);
    });
    test("removeCard", () {
      // given
      cardMachine.insertCard(cardNumber);
      cardMachine.authenticate(pin);

      // when
      cardMachine.removeCard();

      // then
      // sukses mengubah status otentikasi, ditandai dengan
      // throw unauthenticated ketika ingin melakukan checkout
      expect(() => cardMachine.checkOut(1000),
          throwsA(isA<UnauthenticatedException>()));
    });

    setUp(() {
      testCards = [
        ATM(
          cardNumber: "1111111111",
          accountNumber: "0000000000",
          pin: "111111",
          name: "Dimas",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "2222222222",
          accountNumber: "9999999999",
          pin: "222222",
          name: "Abi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9371047517",
          accountNumber: "1379290461",
          pin: "256351",
          name: "Ozi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "6109164644",
          accountNumber: "0075772055",
          pin: "143273",
          name: "Brian",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9803420422",
          accountNumber: "4998144570",
          pin: "109149",
          name: "Henik",
          bankBranch: "Semarang",
          balance: 100,
        ),
        EMoney(
          cardNumber: "3333333333",
          pin: "333333",
          balance: 100,
        ),
        EMoney(
          cardNumber: "1408822288",
          pin: "680071",
          balance: 100,
        ),
      ];

      cardMachine = CardMachineImpl(cards: testCards);
    });
    test("checkout", () {
      // given
      cardMachine.insertCard(cardNumber);
      cardMachine.authenticate(pin);

      // when
      cardMachine.checkOut(10);

      // then
      // saldo berkurang 100 - 10 = 90
      expect(cardMachine.getCardInformation()!.balance, 90.0);
    });

    setUp(() {
      testCards = [
        ATM(
          cardNumber: "1111111111",
          accountNumber: "0000000000",
          pin: "111111",
          name: "Dimas",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "2222222222",
          accountNumber: "9999999999",
          pin: "222222",
          name: "Abi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9371047517",
          accountNumber: "1379290461",
          pin: "256351",
          name: "Ozi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "6109164644",
          accountNumber: "0075772055",
          pin: "143273",
          name: "Brian",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9803420422",
          accountNumber: "4998144570",
          pin: "109149",
          name: "Henik",
          bankBranch: "Semarang",
          balance: 100,
        ),
        EMoney(
          cardNumber: "3333333333",
          pin: "333333",
          balance: 100,
        ),
        EMoney(
          cardNumber: "1408822288",
          pin: "680071",
          balance: 100,
        ),
      ];

      cardMachine = CardMachineImpl(cards: testCards);
    });
    test("withdraw", () {
      // given
      cardMachine.insertCard(cardNumber);
      cardMachine.authenticate(pin);

      // when
      cardMachine.withDraw(10);

      // then
      // saldo berkurang 10 menjadi 90
      expect(cardMachine.getCardInformation()!.balance, 90.0);
    });

    setUp(() {
      testCards = [
        ATM(
          cardNumber: "1111111111",
          accountNumber: "0000000000",
          pin: "111111",
          name: "Dimas",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "2222222222",
          accountNumber: "9999999999",
          pin: "222222",
          name: "Abi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9371047517",
          accountNumber: "1379290461",
          pin: "256351",
          name: "Ozi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "6109164644",
          accountNumber: "0075772055",
          pin: "143273",
          name: "Brian",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9803420422",
          accountNumber: "4998144570",
          pin: "109149",
          name: "Henik",
          bankBranch: "Semarang",
          balance: 100,
        ),
        EMoney(
          cardNumber: "3333333333",
          pin: "333333",
          balance: 100,
        ),
        EMoney(
          cardNumber: "1408822288",
          pin: "680071",
          balance: 100,
        ),
      ];

      cardMachine = CardMachineImpl(cards: testCards);
    });
    test("deposit", () {
      // given
      cardMachine.insertCard(cardNumber);
      cardMachine.authenticate(pin);

      // when
      cardMachine.deposit(10);

      // then
      // saldo bertambah 10 menjadi 110
      expect(cardMachine.getCardInformation()!.balance, 110.0);
    });

    setUp(() {
      testCards = [
        ATM(
          cardNumber: "1111111111",
          accountNumber: "0000000000",
          pin: "111111",
          name: "Dimas",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "2222222222",
          accountNumber: "9999999999",
          pin: "222222",
          name: "Abi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9371047517",
          accountNumber: "1379290461",
          pin: "256351",
          name: "Ozi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "6109164644",
          accountNumber: "0075772055",
          pin: "143273",
          name: "Brian",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9803420422",
          accountNumber: "4998144570",
          pin: "109149",
          name: "Henik",
          bankBranch: "Semarang",
          balance: 100,
        ),
        EMoney(
          cardNumber: "3333333333",
          pin: "333333",
          balance: 100,
        ),
        EMoney(
          cardNumber: "1408822288",
          pin: "680071",
          balance: 100,
        ),
      ];

      cardMachine = CardMachineImpl(cards: testCards);
    });
    test("transfer", () {
      // given
      cardMachine.insertCard(cardNumber);
      cardMachine.authenticate(pin);

      // when
      cardMachine.transfer(
        receiverAccountNumber: receiverAccountNumber,
        amount: 10,
      );

      // then
      // saldo pengirim berkurang menjadi 90
      expect(cardMachine.getCardInformation()!.balance, 90.0);

      // saldo penerima bertambah menjadi 110
      cardMachine.removeCard();
      cardMachine.insertCard(receiverCardNumber);
      cardMachine.authenticate(receiverPin);
      expect(cardMachine.getCardInformation()!.balance, 110.0);
    });

    setUp(() {
      testCards = [
        ATM(
          cardNumber: "1111111111",
          accountNumber: "0000000000",
          pin: "111111",
          name: "Dimas",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "2222222222",
          accountNumber: "9999999999",
          pin: "222222",
          name: "Abi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9371047517",
          accountNumber: "1379290461",
          pin: "256351",
          name: "Ozi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "6109164644",
          accountNumber: "0075772055",
          pin: "143273",
          name: "Brian",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9803420422",
          accountNumber: "4998144570",
          pin: "109149",
          name: "Henik",
          bankBranch: "Semarang",
          balance: 100,
        ),
        EMoney(
          cardNumber: "3333333333",
          pin: "333333",
          balance: 100,
        ),
        EMoney(
          cardNumber: "1408822288",
          pin: "680071",
          balance: 100,
        ),
      ];

      cardMachine = CardMachineImpl(cards: testCards);
    });
    test("topUpEmoney", () {
      // given
      cardMachine.insertCard(cardNumber);
      cardMachine.authenticate(pin);

      // when
      cardMachine.topUpEmoney(receiverCardNumber: emoneyCardNumber, amount: 10);

      // then
      // saldo pengirim berkurnag 10 menjadi 90
      expect(cardMachine.getCardInformation()!.balance, 90.0);

      // saldo penerima bertambah 10 menjadi 110
      cardMachine.removeCard();
      cardMachine.insertCard(emoneyCardNumber);
      cardMachine.authenticate(emoneyPin);
      expect(cardMachine.getCardInformation()!.balance, 110.0);
    });
  });

  group("E-Money", () {
    const cardNumber = "3333333333";
    const pin = "333333";

    setUp(() {
      testCards = [
        ATM(
          cardNumber: "1111111111",
          accountNumber: "0000000000",
          pin: "111111",
          name: "Dimas",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "2222222222",
          accountNumber: "9999999999",
          pin: "222222",
          name: "Abi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9371047517",
          accountNumber: "1379290461",
          pin: "256351",
          name: "Ozi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "6109164644",
          accountNumber: "0075772055",
          pin: "143273",
          name: "Brian",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9803420422",
          accountNumber: "4998144570",
          pin: "109149",
          name: "Henik",
          bankBranch: "Semarang",
          balance: 100,
        ),
        EMoney(
          cardNumber: "3333333333",
          pin: "333333",
          balance: 100,
        ),
        EMoney(
          cardNumber: "1408822288",
          pin: "680071",
          balance: 100,
        ),
      ];

      cardMachine = CardMachineImpl(cards: testCards);
    });
    test("getter insertedCardType", () {
      // given
      cardMachine.insertCard(cardNumber);
      cardMachine.authenticate(pin);

      // when
      Type cardType = cardMachine.insertedCardType;

      // then (kondisi yang diharapkan)
      expect(cardType, EMoney);
    });

    setUp(() {
      testCards = [
        ATM(
          cardNumber: "1111111111",
          accountNumber: "0000000000",
          pin: "111111",
          name: "Dimas",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "2222222222",
          accountNumber: "9999999999",
          pin: "222222",
          name: "Abi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9371047517",
          accountNumber: "1379290461",
          pin: "256351",
          name: "Ozi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "6109164644",
          accountNumber: "0075772055",
          pin: "143273",
          name: "Brian",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9803420422",
          accountNumber: "4998144570",
          pin: "109149",
          name: "Henik",
          bankBranch: "Semarang",
          balance: 100,
        ),
        EMoney(
          cardNumber: "3333333333",
          pin: "333333",
          balance: 100,
        ),
        EMoney(
          cardNumber: "1408822288",
          pin: "680071",
          balance: 100,
        ),
      ];

      cardMachine = CardMachineImpl(cards: testCards);
    });
    test("insertCard", () {
      // given / when
      cardMachine.insertCard(cardNumber);

      //
    });

    setUp(() {
      testCards = [
        ATM(
          cardNumber: "1111111111",
          accountNumber: "0000000000",
          pin: "111111",
          name: "Dimas",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "2222222222",
          accountNumber: "9999999999",
          pin: "222222",
          name: "Abi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9371047517",
          accountNumber: "1379290461",
          pin: "256351",
          name: "Ozi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "6109164644",
          accountNumber: "0075772055",
          pin: "143273",
          name: "Brian",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9803420422",
          accountNumber: "4998144570",
          pin: "109149",
          name: "Henik",
          bankBranch: "Semarang",
          balance: 100,
        ),
        EMoney(
          cardNumber: "3333333333",
          pin: "333333",
          balance: 100,
        ),
        EMoney(
          cardNumber: "1408822288",
          pin: "680071",
          balance: 100,
        ),
      ];

      cardMachine = CardMachineImpl(cards: testCards);
    });
    test("authenticate", () {
      // given
      cardMachine.insertCard(cardNumber);

      // when / then
      // sukses otentikasi
      cardMachine.authenticate(pin);
    });

    setUp(() {
      testCards = [
        ATM(
          cardNumber: "1111111111",
          accountNumber: "0000000000",
          pin: "111111",
          name: "Dimas",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "2222222222",
          accountNumber: "9999999999",
          pin: "222222",
          name: "Abi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9371047517",
          accountNumber: "1379290461",
          pin: "256351",
          name: "Ozi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "6109164644",
          accountNumber: "0075772055",
          pin: "143273",
          name: "Brian",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9803420422",
          accountNumber: "4998144570",
          pin: "109149",
          name: "Henik",
          bankBranch: "Semarang",
          balance: 100,
        ),
        EMoney(
          cardNumber: "3333333333",
          pin: "333333",
          balance: 100,
        ),
        EMoney(
          cardNumber: "1408822288",
          pin: "680071",
          balance: 100,
        ),
      ];

      cardMachine = CardMachineImpl(cards: testCards);
    });
    test("removeCard", () {
      // given
      cardMachine.insertCard(cardNumber);
      cardMachine.authenticate(pin);

      // when
      cardMachine.removeCard();

      // then
      // sukses mengubah status otentikasi, ditandai dengan
      // throw unauthenticated ketika ingin melakukan checkout
      expect(() => cardMachine.checkOut(1000),
          throwsA(isA<UnauthenticatedException>()));
    });

    setUp(() {
      testCards = [
        ATM(
          cardNumber: "1111111111",
          accountNumber: "0000000000",
          pin: "111111",
          name: "Dimas",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "2222222222",
          accountNumber: "9999999999",
          pin: "222222",
          name: "Abi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9371047517",
          accountNumber: "1379290461",
          pin: "256351",
          name: "Ozi",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "6109164644",
          accountNumber: "0075772055",
          pin: "143273",
          name: "Brian",
          bankBranch: "Semarang",
          balance: 100,
        ),
        ATM(
          cardNumber: "9803420422",
          accountNumber: "4998144570",
          pin: "109149",
          name: "Henik",
          bankBranch: "Semarang",
          balance: 100,
        ),
        EMoney(
          cardNumber: "3333333333",
          pin: "333333",
          balance: 100,
        ),
        EMoney(
          cardNumber: "1408822288",
          pin: "680071",
          balance: 100,
        ),
      ];

      cardMachine = CardMachineImpl(cards: testCards);
    });
    test("checkout", () {
      // given
      cardMachine.insertCard(cardNumber);
      cardMachine.authenticate(pin);

      // when
      cardMachine.checkOut(10);

      // then
      // saldo berkurang 100 - 10 = 90
      expect(cardMachine.getCardInformation()!.balance, 90.0);
    });
  });
}
