// Tests for AdminVehicleDocument parsing and VehicleDocumentUrlResolver.

import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_vehicle_model.dart';
import 'package:open_vts/features/admin/utils/vehicle_document_url_resolver.dart';

void main() {
  // ---------------------------------------------------------------------------
  // AdminVehicleDocument.fromJson — field parsing
  // ---------------------------------------------------------------------------

  group('AdminVehicleDocument.fromJson', () {
    test('parses filePath into filePath field', () {
      final doc = AdminVehicleDocument.fromJson(<String, dynamic>{
        'id': '1',
        'title': 'Insurance',
        'filePath': '/uploads/docs/insurance.pdf',
      });
      expect(doc.filePath, '/uploads/docs/insurance.pdf');
      expect(doc.url, '');
    });

    test('parses absolute url into url field', () {
      final doc = AdminVehicleDocument.fromJson(<String, dynamic>{
        'id': '2',
        'title': 'Insurance',
        'url': 'https://cdn.example.com/file.pdf',
      });
      expect(doc.url, 'https://cdn.example.com/file.pdf');
      expect(doc.filePath, '');
    });

    test('parses fileUrl alias into url field', () {
      final doc = AdminVehicleDocument.fromJson(<String, dynamic>{
        'id': '3',
        'fileUrl': 'https://cdn.example.com/file.pdf',
      });
      expect(doc.url, 'https://cdn.example.com/file.pdf');
    });

    test('parses file_url alias into url field', () {
      final doc = AdminVehicleDocument.fromJson(<String, dynamic>{
        'id': '4',
        'file_url': 'https://cdn.example.com/file.pdf',
      });
      expect(doc.url, 'https://cdn.example.com/file.pdf');
    });

    test('parses file_path alias into filePath field', () {
      final doc = AdminVehicleDocument.fromJson(<String, dynamic>{
        'id': '5',
        'file_path': '/uploads/doc.pdf',
      });
      expect(doc.filePath, '/uploads/doc.pdf');
    });

    test('fileName is kept separate from filePath', () {
      final doc = AdminVehicleDocument.fromJson(<String, dynamic>{
        'id': '6',
        'fileName': 'insurance.pdf',
        'filePath': '/uploads/insurance.pdf',
      });
      expect(doc.fileName, 'insurance.pdf');
      expect(doc.filePath, '/uploads/insurance.pdf');
    });

    test('empty document has empty url and filePath', () {
      final doc = AdminVehicleDocument.fromJson(<String, dynamic>{'id': '7'});
      expect(doc.url, '');
      expect(doc.filePath, '');
    });

    test('url and filePath are both parsed when both present', () {
      final doc = AdminVehicleDocument.fromJson(<String, dynamic>{
        'id': '8',
        'url': 'https://cdn.example.com/doc.pdf',
        'filePath': '/uploads/doc.pdf',
      });
      expect(doc.url, 'https://cdn.example.com/doc.pdf');
      expect(doc.filePath, '/uploads/doc.pdf');
    });

    test('refreshed document after upload retains filePath', () {
      // Simulates the canonical record returned by GET after upload.
      final doc = AdminVehicleDocument.fromJson(<String, dynamic>{
        'id': '9',
        'title': 'Registration',
        'filePath': '/uploads/vehicles/42/registration.pdf',
        'fileName': 'registration.pdf',
        'fileType': 'pdf',
        'isVisible': true,
        'createdAt': '2026-08-01T10:00:00Z',
      });
      expect(doc.filePath, '/uploads/vehicles/42/registration.pdf');
      expect(doc.fileName, 'registration.pdf');
      expect(doc.url, '');
    });
  });

  // ---------------------------------------------------------------------------
  // VehicleDocumentUrlResolver.resolve
  // ---------------------------------------------------------------------------

  group('VehicleDocumentUrlResolver.resolve', () {
    const relativeBase = '/api';
    const absoluteBase = 'https://app.openvts.io/api';
    const absoluteBaseNoPath = 'https://app.openvts.io';
    const absoluteBaseTrailingSlash = 'https://app.openvts.io/api/';

    // --- Absolute URL in url field ---

    test('absolute url field is preserved unchanged', () {
      final uri = VehicleDocumentUrlResolver.resolve(
        url: 'https://cdn.example.com/doc.pdf',
        filePath: '',
        apiBaseUrl: relativeBase,
      );
      expect(uri.toString(), 'https://cdn.example.com/doc.pdf');
    });

    test('absolute http url field is preserved unchanged', () {
      final uri = VehicleDocumentUrlResolver.resolve(
        url: 'http://cdn.example.com/doc.pdf',
        filePath: '',
        apiBaseUrl: relativeBase,
      );
      expect(uri.toString(), 'http://cdn.example.com/doc.pdf');
    });

    // --- filePath with relative base URL ---

    test('relative filePath with relative /api base produces /api/uploads/…',
        () {
      final uri = VehicleDocumentUrlResolver.resolve(
        url: '',
        filePath: '/uploads/doc.pdf',
        apiBaseUrl: relativeBase,
      );
      expect(uri.toString(), '/api/uploads/doc.pdf');
    });

    test('relative filePath without leading slash still gets one slash', () {
      final uri = VehicleDocumentUrlResolver.resolve(
        url: '',
        filePath: 'uploads/doc.pdf',
        apiBaseUrl: relativeBase,
      );
      expect(uri.toString(), '/api/uploads/doc.pdf');
    });

    // --- filePath with absolute base URL ---

    test('absolute base with /api path: origin only is used (no /api/api)', () {
      final uri = VehicleDocumentUrlResolver.resolve(
        url: '',
        filePath: '/uploads/doc.pdf',
        apiBaseUrl: absoluteBase,
      );
      // Must NOT produce https://app.openvts.io/api/api/uploads/doc.pdf
      expect(uri.toString(), 'https://app.openvts.io/uploads/doc.pdf');
    });

    test('absolute base without path: origin used directly', () {
      final uri = VehicleDocumentUrlResolver.resolve(
        url: '',
        filePath: '/uploads/doc.pdf',
        apiBaseUrl: absoluteBaseNoPath,
      );
      expect(uri.toString(), 'https://app.openvts.io/uploads/doc.pdf');
    });

    test('absolute base with trailing slash: no duplicate slash in result', () {
      final uri = VehicleDocumentUrlResolver.resolve(
        url: '',
        filePath: '/uploads/doc.pdf',
        apiBaseUrl: absoluteBaseTrailingSlash,
      );
      expect(uri.toString(), 'https://app.openvts.io/uploads/doc.pdf');
      // Path must not have a double slash (scheme `://` is expected).
      expect(uri!.path, isNot(contains('//')));
    });

    test('relative base with trailing slash: no duplicate slash in result', () {
      final uri = VehicleDocumentUrlResolver.resolve(
        url: '',
        filePath: '/uploads/doc.pdf',
        apiBaseUrl: '/api/',
      );
      expect(uri.toString(), '/api/uploads/doc.pdf');
      expect(uri.toString(), isNot(contains('//')));
    });

    // --- Empty / null-like inputs ---

    test('empty url and empty filePath returns null', () {
      final uri = VehicleDocumentUrlResolver.resolve(
        url: '',
        filePath: '',
        apiBaseUrl: relativeBase,
      );
      expect(uri, isNull);
    });

    test('whitespace-only url and filePath returns null', () {
      final uri = VehicleDocumentUrlResolver.resolve(
        url: '   ',
        filePath: '   ',
        apiBaseUrl: relativeBase,
      );
      expect(uri, isNull);
    });

    // --- Priority: url beats filePath ---

    test('url field takes priority over filePath', () {
      final uri = VehicleDocumentUrlResolver.resolve(
        url: 'https://cdn.example.com/from-url.pdf',
        filePath: '/uploads/from-path.pdf',
        apiBaseUrl: relativeBase,
      );
      expect(uri.toString(), 'https://cdn.example.com/from-url.pdf');
    });

    // --- Encoded paths and query parameters ---

    test('encoded path segments are preserved', () {
      final uri = VehicleDocumentUrlResolver.resolve(
        url: '',
        filePath: '/uploads/my%20doc.pdf',
        apiBaseUrl: relativeBase,
      );
      expect(uri.toString(), '/api/uploads/my%20doc.pdf');
    });

    test('query parameters in filePath are preserved', () {
      final uri = VehicleDocumentUrlResolver.resolve(
        url: '',
        filePath: '/uploads/doc.pdf?token=abc123',
        apiBaseUrl: relativeBase,
      );
      expect(uri?.query, 'token=abc123');
    });

    // --- filePath that is itself an absolute URL ---

    test('absolute URL in filePath is used directly without base', () {
      final uri = VehicleDocumentUrlResolver.resolve(
        url: '',
        filePath: 'https://storage.example.com/doc.pdf',
        apiBaseUrl: relativeBase,
      );
      expect(uri.toString(), 'https://storage.example.com/doc.pdf');
    });

    // --- Relative base with /api prefix preserved ---

    test('relative /api base: /api prefix is preserved in final URL', () {
      final uri = VehicleDocumentUrlResolver.resolve(
        url: '',
        filePath: '/uploads/vehicles/5/cert.pdf',
        apiBaseUrl: '/api',
      );
      expect(uri.toString(), '/api/uploads/vehicles/5/cert.pdf');
      expect(uri.toString(), isNot(contains('/api/api/')));
    });
  });
}
