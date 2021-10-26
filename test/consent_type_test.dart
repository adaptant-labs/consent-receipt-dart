import 'package:consent_receipt_dart/consent_receipt_dart.dart';
import 'package:test/test.dart';
import 'package:validators/validators.dart' as validators;

void main() {
  group('Consent type', () {
    var explicitConsent = ConsentType.explicit;
    var consentNotApplicable = ConsentType.notApplicable;

    test('name verification', () {
      expect(explicitConsent.name, equals('EXPLICIT'));
      expect(consentNotApplicable.name, equals('N/A'));
    });

    test('enum conversion verification', () {
      var parsedExplicit = ConsentTypeNameExtension.parseName('EXPLICIT');
      var parsedNotApplicable = ConsentTypeNameExtension.parseName('N/A');
      expect(parsedExplicit, equals(explicitConsent));
      expect(parsedNotApplicable, equals(consentNotApplicable));
    });

    test('invalid type conversion', () {
      var parsedInvalid = ConsentTypeNameExtension.parseName('INVALID');
      expect(parsedInvalid, isNull);
    });

    test('case insensitivity verification', () {
      var parsedImplicit = ConsentTypeNameExtension.parseName('implicit');
      expect(parsedImplicit, isNotNull);
      expect(parsedImplicit, equals(ConsentType.implicit));
      expect(validators.isUppercase(parsedImplicit!.name), isTrue);
    });
  });
}
