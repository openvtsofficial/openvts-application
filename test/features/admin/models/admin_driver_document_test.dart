import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_driver_details_model.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

AdminDriverDocument _parse(Map<String, dynamic> raw) =>
    AdminDriverDocument.fromJson(raw);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // Nested docType — id and name
  // -------------------------------------------------------------------------

  group('nested docType object', () {
    test('docTypeName is read from nested docType.name', () {
      final doc = _parse({
        'id': 'doc-1',
        'title': 'Driving Licence',
        'docType': {'id': 'dt-9', 'name': 'Driving License'},
      });
      expect(doc.docTypeName, 'Driving License');
    });

    test('docTypeId falls back to nested docType.id when flat key absent', () {
      final doc = _parse({
        'id': 'doc-1',
        'title': 'Passport',
        'docType': {'id': 'dt-42', 'name': 'Passport'},
      });
      expect(doc.docTypeId, 'dt-42');
    });

    test('flat docTypeId is preferred over nested docType.id', () {
      final doc = _parse({
        'id': 'doc-1',
        'title': 'Passport',
        'docTypeId': 'FLAT-99',
        'docType': {'id': 'dt-42', 'name': 'Passport'},
      });
      expect(doc.docTypeId, 'FLAT-99');
    });

    test('nested docType.name falls back to docType.title', () {
      final doc = _parse({
        'id': 'doc-1',
        'title': 'NID',
        'docType': {'id': 'dt-5', 'title': 'National ID'},
      });
      expect(doc.docTypeName, 'National ID');
    });

    test('nested docType object never produces map-like text', () {
      final doc = _parse({
        'id': 'doc-1',
        'title': 'Something',
        'docType': {'id': 'dt-1', 'name': 'Some Type'},
      });
      expect(doc.docTypeName, isNot(contains('{')));
      expect(doc.docTypeName, isNot(contains('Instance')));
    });
  });

  // -------------------------------------------------------------------------
  // Scalar fallbacks (no nested docType)
  // -------------------------------------------------------------------------

  group('scalar fallbacks when docType is absent', () {
    test('docTypeName uses flat docTypeName key', () {
      final doc = _parse({
        'id': 'doc-1',
        'title': 'Licence',
        'docTypeName': 'Driving Licence',
      });
      expect(doc.docTypeName, 'Driving Licence');
    });

    test('docTypeName uses documentTypeName key', () {
      final doc = _parse({
        'id': 'doc-1',
        'title': 'Licence',
        'documentTypeName': 'Vehicle Registration',
      });
      expect(doc.docTypeName, 'Vehicle Registration');
    });

    test('docTypeName falls back to dash when all keys absent', () {
      final doc = _parse({'id': 'doc-1', 'title': 'T'});
      expect(doc.docTypeName, '-');
    });

    test('docTypeId uses flat key', () {
      final doc = _parse({'id': 'doc-1', 'title': 'T', 'docTypeId': 'XY-7'});
      expect(doc.docTypeId, 'XY-7');
    });

    test('docTypeId falls back to dash when all keys absent', () {
      final doc = _parse({'id': 'doc-1', 'title': 'T'});
      expect(doc.docTypeId, '-');
    });
  });

  // -------------------------------------------------------------------------
  // Map / List values must never stringify into display fields
  // -------------------------------------------------------------------------

  group('map / list values rejected for string fields', () {
    test('map value in docTypeName key is rejected; falls back to nested', () {
      final doc = _parse({
        'id': 'doc-1',
        'title': 'T',
        'docTypeName': {'nested': 'should not appear'},
        'docType': {'id': 'dt-1', 'name': 'Safe Name'},
      });
      expect(doc.docTypeName, 'Safe Name');
      expect(doc.docTypeName, isNot(contains('{')));
    });

    test('map value in title key falls back to name key', () {
      final doc = _parse({
        'id': 'doc-1',
        'title': {'nested': 'bad'},
        'name': 'Good Title',
      });
      expect(doc.title, 'Good Title');
      expect(doc.title, isNot(contains('{')));
    });

    test('list in fileName key produces dash placeholder', () {
      final doc = _parse({
        'id': 'doc-1',
        'title': 'T',
        'fileName': ['a.pdf'],
      });
      expect(doc.fileName, '-');
    });

    test('map in fileType key produces dash placeholder', () {
      final doc = _parse({
        'id': 'doc-1',
        'title': 'T',
        'fileType': {'mime': 'pdf'},
      });
      expect(doc.fileType, '-');
    });
  });

  // -------------------------------------------------------------------------
  // Missing and partial metadata
  // -------------------------------------------------------------------------

  group('missing and partial metadata', () {
    test('minimal valid document parses without crashing', () {
      final doc = _parse({'id': 'doc-1', 'title': 'Minimal'});
      expect(doc.id, 'doc-1');
      expect(doc.title, 'Minimal');
      expect(doc.docTypeName, '-');
      expect(doc.fileName, '-');
      expect(doc.status, 'PENDING');
      expect(doc.isVisible, isTrue);
      expect(doc.expiryAt, isNull);
      expect(doc.createdAt, isNull);
    });

    test('null expiryAt produces null field', () {
      final doc = _parse({'id': 'doc-1', 'title': 'T', 'expiryAt': null});
      expect(doc.expiryAt, isNull);
    });

    test('valid expiryAt parses to DateTime', () {
      final doc = _parse({
        'id': 'doc-1',
        'title': 'T',
        'expiryAt': '2027-12-31T00:00:00.000Z',
      });
      expect(doc.expiryAt, isNotNull);
      expect(doc.expiryAt!.year, 2027);
    });

    test('null createdAt produces null field', () {
      final doc = _parse({'id': 'doc-1', 'title': 'T', 'createdAt': null});
      expect(doc.createdAt, isNull);
    });

    test('isVisible defaults to true when absent', () {
      final doc = _parse({'id': 'doc-1', 'title': 'T'});
      expect(doc.isVisible, isTrue);
    });

    test('isVisible false is parsed', () {
      final doc = _parse({'id': 'doc-1', 'title': 'T', 'isVisible': false});
      expect(doc.isVisible, isFalse);
    });

    test('empty description is parsed', () {
      final doc = _parse({'id': 'doc-1', 'title': 'T', 'description': ''});
      // _firstString rejects empty strings.
      expect(doc.description, '-');
    });

    test('non-empty description is preserved', () {
      final doc = _parse({
        'id': 'doc-1',
        'title': 'T',
        'description': 'Annual renewal required',
      });
      expect(doc.description, 'Annual renewal required');
    });
  });

  // -------------------------------------------------------------------------
  // Status parsing
  // -------------------------------------------------------------------------

  group('status field', () {
    test('explicit status is preserved', () {
      final doc = _parse({'id': 'd', 'title': 'T', 'status': 'APPROVED'});
      expect(doc.status, 'APPROVED');
    });

    test('missing status defaults to PENDING', () {
      final doc = _parse({'id': 'd', 'title': 'T'});
      expect(doc.status, 'PENDING');
    });
  });

  // -------------------------------------------------------------------------
  // tags parsing
  // -------------------------------------------------------------------------

  group('tags', () {
    test('list of tags is joined with comma-space', () {
      final doc = _parse({
        'id': 'd',
        'title': 'T',
        'tags': ['kyc', 'identity'],
      });
      expect(doc.tags, 'kyc, identity');
    });

    test('string tags are preserved', () {
      final doc = _parse({'id': 'd', 'title': 'T', 'tags': 'kyc, identity'});
      expect(doc.tags, 'kyc, identity');
    });

    test('null tags produce dash', () {
      final doc = _parse({'id': 'd', 'title': 'T', 'tags': null});
      expect(doc.tags, '-');
    });
  });

  // -------------------------------------------------------------------------
  // listFromJson
  // -------------------------------------------------------------------------

  group('listFromJson', () {
    test('parses list with data wrapper', () {
      final list = AdminDriverDocument.listFromJson({
        'data': [
          {'id': 'd-1', 'title': 'Driving Licence'},
          {'id': 'd-2', 'title': 'Passport'},
        ],
      });
      expect(list.length, 2);
    });

    test('filters out entries with empty id', () {
      final list = AdminDriverDocument.listFromJson([
        {'id': '', 'title': 'Bad'},
        {'id': 'ok-1', 'title': 'Good'},
      ]);
      expect(list.length, 1);
      expect(list.first.id, 'ok-1');
    });

    test('handles empty list gracefully', () {
      expect(AdminDriverDocument.listFromJson([]), isEmpty);
    });
  });
}
