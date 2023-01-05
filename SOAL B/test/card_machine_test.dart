import 'package:test/test.dart';

import '../card.dart';
import '../card_machine.dart';
import '../cards.dart';
import '../exceptions.dart';

void main() {
  final cardMachine = CardMachineImpl(cards: cards);

  group("insertedCardType", () {
    test("ATM", () {
      // given
      cardMachine.insertCard("1111111111");
      cardMachine.authenticate('111111');

      // when
      Type cardType = cardMachine.insertedCardType;

      // then (kondisi yang diharapkan)
      expect(cardType, ATM);
    });
    test("E-Money", () {
      // given
      cardMachine.insertCard("3333333333");
      cardMachine.authenticate("333333");

      // when
      Type cardType = cardMachine.insertedCardType;

      // then (kondisi yang diharapkan)
      expect(cardType, EMoney);
    });
  });

  test("insertCard", () {
    cardMachine.insertCard("1111111111");
  });

  test("authenticate", () {
    cardMachine.insertCard("1111111111");
    cardMachine.authenticate("111111");
  });

  test("removeCard", () {
    // given
    cardMachine.insertCard("1111111111");
    cardMachine.authenticate("111111");
    
    // when
    cardMachine.removeCard();

    // then
    expect(() => cardMachine.checkOut(1000), throwsA(isA<UnauthenticatedException>()));
  });
}
