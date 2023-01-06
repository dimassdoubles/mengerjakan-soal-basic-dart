import 'package:test/test.dart';

import '../card.dart';
import '../card_information.dart';
import '../card_machine.dart';
import '../cards.dart';
import '../exceptions.dart';

void main() {
  CardMachine cardMachine = CardMachineImpl(cards: cards);

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

    
    
    test("getter insertedCardType", () {
      // given
      cardMachine.insertCard(cardNumber);
      cardMachine.authenticate(pin);

      // when
      Type cardType = cardMachine.insertedCardType;

      // then (kondisi yang diharapkan)
      expect(cardType, ATM);
    });

    
    test("insertCard", () {
      // given / when
      cardMachine.insertCard(cardNumber);

      //
    });

    
    test("authenticate", () {
      // given
      cardMachine.insertCard(cardNumber);

      // when / then
      // sukses otentikasi
      cardMachine.authenticate(pin);
    });

    
    test("getCardInformation", () {
      // given
      cardMachine.insertCard(cardNumber);
      cardMachine.authenticate(pin);

      // then
      expect(cardMachine.getCardInformation()!, cardInfo);
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

    
    test("getter insertedCardType", () {
      // given
      cardMachine.insertCard(cardNumber);
      cardMachine.authenticate(pin);

      // when
      Type cardType = cardMachine.insertedCardType;

      // then (kondisi yang diharapkan)
      expect(cardType, EMoney);
    });

    
    test("insertCard", () {
      // given / when
      cardMachine.insertCard(cardNumber);

      //
    });

    
    test("authenticate", () {
      // given
      cardMachine.insertCard(cardNumber);

      // when / then
      // sukses otentikasi
      cardMachine.authenticate(pin);
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
