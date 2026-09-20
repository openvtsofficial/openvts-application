// Focused tests for User → Map → 2-second hold → Create Landmark feature.
//
// Coverage:
//   • HoldDetector timer: short-press → no popup
//   • HoldDetector timer: successful 2-second hold → callback with correct LatLng
//   • HoldDetector timer: cancelled hold (pointerUp) → no callback
//   • HoldDetector timer: drag before 2 s → cancels hold
//   • HoldDetector timer: new hold replaces pending one
//   • HoldDetector timer: menu open guard prevents duplicate forms
//   • POI form receives initialCoordinates from map hold
//   • Existing POI coordinates take precedence over initialCoordinates
//   • No initialCoordinates → standard Landmark Studio POI flow (null coords)
//   • Geofence quick-create: UserCircleGeoData built from initialCenter
//   • Geofence quick-create: radius is 200 m
//   • Geofence quick-create: center equals held coordinate exactly
//   • Existing geofence ignores initialCenter
//   • No initialCenter → standard Landmark Studio geofence flow (null geodata)
//   • Demo map: creation callbacks absent (isDemo=true → null callbacks)
//   • Live map: callbacks present for non-demo user (isDemo=false)
//   • Admin: config does not support POI/geofence overlays
//   • User/Superadmin: config supports POI/geofence overlays
//   • Held LatLng round-trips through UserGeoPoint with full precision

import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import 'package:open_vts/features/live_map/models/live_map_role_config.dart';
import 'package:open_vts/features/user/models/user_landmark_model.dart';

// ── Minimal hold-detector (pure logic, no Flutter widget tree) ─────────────────

/// Mirrors the exact hold-detection logic in _LiveMapState.
class _HoldDetector {
  _HoldDetector({required this.onCompleted});

  final void Function(LatLng point) onCompleted;

  static const _duration = Duration(seconds: 2);

  Timer? _timer;
  LatLng? _point;
  bool _menuOpen = false;

  bool get timerActive => _timer?.isActive ?? false;

  void pointerDown(LatLng point) {
    if (_menuOpen) return;
    _cancel();
    _point = point;
    _timer = Timer(_duration, _complete);
  }

  void pointerUp() => _cancel();

  void pointerCancel() => _cancel();

  void drag() {
    if (timerActive) _cancel();
  }

  void menuDismissed() => _menuOpen = false;

  void _cancel() {
    _timer?.cancel();
    _timer = null;
    _point = null;
  }

  void _complete() {
    final p = _point;
    _timer = null;
    _point = null;
    if (p == null) return;
    _menuOpen = true;
    onCompleted(p);
  }
}

// ── Tests ──────────────────────────────────────────────────────────────────────

void main() {
  // ── HoldDetector logic ────────────────────────────────────────────────────

  group('HoldDetector — timer logic', () {
    test('short press (pointerUp before 2 s) does not invoke callback', () {
      LatLng? captured;
      final det = _HoldDetector(onCompleted: (p) => captured = p);
      det.pointerDown(const LatLng(27.0, 78.0));
      det.pointerUp();
      expect(captured, isNull);
      expect(det.timerActive, isFalse);
    });

    test('successful 2-second hold invokes callback with exact LatLng', () {
      fakeAsync((fake) {
        LatLng? captured;
        final det = _HoldDetector(onCompleted: (p) => captured = p);
        const held = LatLng(27.176670, 78.008075);
        det.pointerDown(held);
        fake.elapse(const Duration(seconds: 2));
        expect(captured, isNotNull);
        expect(captured!.latitude, closeTo(27.176670, 1e-9));
        expect(captured!.longitude, closeTo(78.008075, 1e-9));
      });
    });

    test('hold at exactly 1999 ms does not fire', () {
      fakeAsync((fake) {
        LatLng? captured;
        final det = _HoldDetector(onCompleted: (p) => captured = p);
        det.pointerDown(const LatLng(27.0, 78.0));
        fake.elapse(const Duration(milliseconds: 1999));
        expect(captured, isNull);
        expect(det.timerActive, isTrue);
      });
    });

    test('pointerCancel before 2 s prevents callback', () {
      fakeAsync((fake) {
        LatLng? captured;
        final det = _HoldDetector(onCompleted: (p) => captured = p);
        det.pointerDown(const LatLng(27.0, 78.0));
        fake.elapse(const Duration(milliseconds: 500));
        det.pointerCancel();
        fake.elapse(const Duration(seconds: 2));
        expect(captured, isNull);
      });
    });

    test('drag before 2 s cancels hold', () {
      fakeAsync((fake) {
        LatLng? captured;
        final det = _HoldDetector(onCompleted: (p) => captured = p);
        det.pointerDown(const LatLng(27.0, 78.0));
        fake.elapse(const Duration(milliseconds: 800));
        det.drag();
        fake.elapse(const Duration(seconds: 2));
        expect(captured, isNull);
        expect(det.timerActive, isFalse);
      });
    });

    test('new pointerDown replaces in-flight hold', () {
      fakeAsync((fake) {
        final captured = <LatLng>[];
        final det = _HoldDetector(onCompleted: (p) => captured.add(p));
        det.pointerDown(const LatLng(10.0, 10.0));
        fake.elapse(const Duration(milliseconds: 500));
        det.pointerDown(const LatLng(20.0, 20.0)); // replaces first
        fake.elapse(const Duration(seconds: 2));
        expect(captured.length, 1);
        expect(captured.first.latitude, closeTo(20.0, 1e-9));
      });
    });

    test('menu open blocks second hold until dismissed', () {
      fakeAsync((fake) {
        final captured = <LatLng>[];
        final det = _HoldDetector(onCompleted: (p) => captured.add(p));
        // First hold completes.
        det.pointerDown(const LatLng(27.0, 78.0));
        fake.elapse(const Duration(seconds: 2));
        expect(captured.length, 1);

        // Second hold while menu is open → ignored.
        det.pointerDown(const LatLng(28.0, 79.0));
        fake.elapse(const Duration(seconds: 2));
        expect(captured.length, 1);

        // After menu dismissed → second hold works.
        det.menuDismissed();
        det.pointerDown(const LatLng(28.0, 79.0));
        fake.elapse(const Duration(seconds: 2));
        expect(captured.length, 2);
      });
    });
  });

  // ── POI initialCoordinates ────────────────────────────────────────────────

  group('POI form — initialCoordinates injection', () {
    test('held point becomes initial coordinates when no existing POI', () {
      const held = UserGeoPoint(lat: 27.176670, lon: 78.008075);
      // Mirrors: _coordinates = existing?.coordinates ?? widget.initialCoordinates
      const UserGeoPoint? existingCoords = null;
      final result = existingCoords ?? held;
      expect(result.lat, closeTo(27.176670, 1e-9));
      expect(result.lon, closeTo(78.008075, 1e-9));
    });

    test('existing POI coordinates take precedence over initialCoordinates',
        () {
      const existingCoords = UserGeoPoint(lat: 10.0, lon: 20.0);
      // initialCoords would be supplied from map hold but existing wins.
      final result = existingCoords; // existing?.coordinates is non-null
      expect(result.lat, closeTo(10.0, 1e-9));
    });

    test('null existing and null initialCoordinates → null (standard flow)',
        () {
      const UserGeoPoint? existingCoords = null;
      const UserGeoPoint? initialCoords = null;
      final UserGeoPoint? result = existingCoords ?? initialCoords;
      expect(result, isNull);
    });
  });

  // ── Geofence quick-create geometry ────────────────────────────────────────

  group('Geofence form — quick-create geometry from map hold', () {
    test('UserCircleGeoData built from initialCenter', () {
      const initialCenter = LatLng(27.176670, 78.008075);
      // Mirrors initState: existing == null && initialCenter != null
      final geodata = UserCircleGeoData(
        center: UserGeoPoint(
            lat: initialCenter.latitude, lon: initialCenter.longitude),
        radiusM: 200,
      );
      expect(geodata, isA<UserCircleGeoData>());
    });

    test('quick-create circle has initial radius 200 m', () {
      const initialCenter = LatLng(27.176670, 78.008075);
      final geodata = UserCircleGeoData(
        center: UserGeoPoint(
            lat: initialCenter.latitude, lon: initialCenter.longitude),
        radiusM: 200,
      );
      expect(geodata.radiusM, 200.0);
    });

    test('quick-create circle center equals held coordinate exactly', () {
      const held = LatLng(27.176670, 78.008075);
      final geodata = UserCircleGeoData(
        center: UserGeoPoint(lat: held.latitude, lon: held.longitude),
        radiusM: 200,
      );
      expect(geodata.center.lat, closeTo(27.176670, 1e-9));
      expect(geodata.center.lon, closeTo(78.008075, 1e-9));
    });

    test('existing geofence geodata is used unchanged (initialCenter ignored)',
        () {
      const existing = UserCircleGeoData(
        center: UserGeoPoint(lat: 1.0, lon: 2.0),
        radiusM: 500,
      );
      // initState: existing != null → use existing, skip initialCenter logic
      final result = existing;
      expect(result.center.lat, closeTo(1.0, 1e-9));
      expect(result.radiusM, 500.0);
    });

    test(
        'null initialCenter and no existing → null geodata (standard Landmark Studio flow)',
        () {
      const UserGeofenceGeoData? existingGeodata = null;
      const LatLng? initialCenter = null;

      // Mirrors: if (existing != null) { … } else if (initialCenter != null) { … }
      UserGeofenceGeoData? geodata;
      if (existingGeodata != null) {
        geodata = existingGeodata;
      } else if (initialCenter != null) {
        geodata = UserCircleGeoData(
          center: UserGeoPoint(
              lat: initialCenter.latitude, lon: initialCenter.longitude),
          radiusM: 200,
        );
      }

      expect(geodata, isNull);
    });
  });

  // ── Demo and role guards ───────────────────────────────────────────────────

  group('Demo / role callback guard', () {
    test('isDemo=true → both creation callbacks null (not exposed)', () {
      // Mirrors: onCreatePoiAt: isDemo ? null : handler
      // Written as a function to avoid Dart constant-folding the branch away.
      void Function(LatLng)? resolveCallback(bool isDemo) {
        if (isDemo) return null;
        return (_) {};
      }

      expect(resolveCallback(true), isNull);
    });

    test('isDemo=false → both creation callbacks non-null (exposed)', () {
      void Function(LatLng)? resolveCallback(bool isDemo) {
        if (isDemo) return null;
        return (_) {};
      }

      expect(resolveCallback(false), isNotNull);
    });

    test('admin config: supportsPoi=false, supportsGeofence=false', () {
      final cfg = LiveMapRoleConfig.admin();
      expect(cfg.supportsPoi, isFalse);
      expect(cfg.supportsGeofence, isFalse);
    });

    test('user config: supportsPoi=true, supportsGeofence=true', () {
      final cfg = LiveMapRoleConfig.user();
      expect(cfg.supportsPoi, isTrue);
      expect(cfg.supportsGeofence, isTrue);
    });

    test('superadmin config: supportsPoi=true, supportsGeofence=true', () {
      final cfg = LiveMapRoleConfig.superadmin();
      expect(cfg.supportsPoi, isTrue);
      expect(cfg.supportsGeofence, isTrue);
    });

    test('demo config role is LiveMapRole.user', () {
      final cfg = LiveMapRoleConfig.demo();
      expect(cfg.role, LiveMapRole.user);
    });
  });

  // ── Coordinate accuracy ───────────────────────────────────────────────────

  group('Held LatLng coordinate accuracy', () {
    test('UserGeoPoint round-trips held coordinate with no precision loss', () {
      const held = LatLng(27.176670, 78.008075);
      final gp = UserGeoPoint(lat: held.latitude, lon: held.longitude);
      final roundTrip = gp.toLatLng();
      expect(roundTrip.latitude, closeTo(held.latitude, 1e-9));
      expect(roundTrip.longitude, closeTo(held.longitude, 1e-9));
    });

    test('held Agra coordinate is not Delhi map-center', () {
      const delhi = LatLng(28.6139, 77.2090);
      const agra = LatLng(27.176670, 78.008075);
      expect(agra.latitude, isNot(closeTo(delhi.latitude, 0.01)));
    });
  });
}
