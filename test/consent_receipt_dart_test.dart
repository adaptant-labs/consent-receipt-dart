import 'package:consent_receipt_dart/consent_receipt_dart.dart';
import 'package:validators/validators.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    ConsentReceiptGenerator gen;
    ConsentReceipt? cr;

    setUp(() {
      gen = ConsentReceiptGenerator(
        countryCode: 'US',
        privacyPolicy: 'https://www.example.com/privacy',
        piiControllers: [
          DataController(
            address: PostalAddress(
              addressCountry: 'US',
              postalCode: '00000',
              addressLocality: 'N/A',
              streetAddress: 'N/A',
            ),
            contact: 'Jon Doe',
            email: 'example@example.com',
            phone: '00-000-000-0000',
            piiController: 'DataController, Inc.'
          ),
        ],
      );

      cr = gen.generateConsentReceipt(
          collectionMethod: 'N/A',
          subjectId: 'example@example.com',
          services: [
            Service(
              service: 'test service',
              purposes: [
                Purpose(
                  piiCategory: [
                    DataCategory.AssetData,
                  ],
                  purposeCategory: PurposeSpecification.CoreFunction,
                  termination: 'At the end of this test run',
                ),
              ],
            ),
          ],
      );
    });

    test('Sensitive setting should be false', () {
      expect(cr!.sensitive, false);
    });

    test('ReceiptID should be a valid UUID', () {
      expect(isUUID(cr!.consentReceiptID), true);
    });
  });
}
