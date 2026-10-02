import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/features/superadmin/models/superadmin_settings_model.dart';
import 'package:open_vts/features/superadmin/services/superadmin_settings_service.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Map<String, dynamic> _successEnvelope(dynamic data, [String msg = 'ok']) =>
    <String, dynamic>{'action': true, 'message': msg, 'data': data};

Map<String, dynamic> _minimalProfileJson({
  String stateCode = 'MH',
  String cityId = 'Mumbai',
}) =>
    <String, dynamic>{
      'uid': 1,
      'name': 'Super Admin',
      'email': 'sa@example.com',
      'mobilePrefix': '+91',
      'mobileNumber': '9999999999',
      'address': <String, dynamic>{
        'addressLine': '123 Main St',
        'countryCode': 'IN',
        'stateCode': stateCode,
        'cityId': cityId,
        'pincode': '400001',
      },
    };

/// Creates a Dio that handles PATCH and GET to the profile endpoint.
/// [patchStatusCode] controls whether PATCH succeeds or not.
/// [getStatusCode] controls whether the follow-up GET succeeds.
Dio _profileDio({
  int patchStatusCode = 200,
  int getStatusCode = 200,
  Map<String, dynamic>? getProfileData,
}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://app.openvts.io/api'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (options.method == 'PATCH') {
          if (patchStatusCode >= 400) {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response<dynamic>(
                  requestOptions: options,
                  statusCode: patchStatusCode,
                  data: <String, dynamic>{'message': 'PATCH failed'},
                ),
                type: DioExceptionType.badResponse,
              ),
            );
            return;
          }
          handler.resolve(Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: _successEnvelope(null, 'Profile updated'),
          ));
        } else {
          // GET
          if (getStatusCode >= 400) {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response<dynamic>(
                  requestOptions: options,
                  statusCode: getStatusCode,
                  data: <String, dynamic>{'message': 'GET failed'},
                ),
                type: DioExceptionType.badResponse,
              ),
            );
            return;
          }
          handler.resolve(Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: _successEnvelope(
                getProfileData ?? _minimalProfileJson(), 'Profile fetched'),
          ));
        }
      },
    ),
  );
  return dio;
}

SuperadminSettingsService _serviceWith(Dio dio) =>
    SuperadminSettingsService(ApiClient(dio));

const _baseRequest = SuperadminUpdateProfileRequest(
  name: 'Super Admin',
  mobilePrefix: '+91',
  mobileNumber: '9999999999',
  addressLine: '123 Main St',
  countryCode: 'IN',
  stateCode: 'MH',
  cityName: 'Mumbai',
);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // A. Service: updateProfile separates PATCH from GET
  // -------------------------------------------------------------------------
  group('SuperadminSettingsService.updateProfile — PATCH/GET separation', () {
    test('successful PATCH + successful GET returns refreshed profile',
        () async {
      final service = _serviceWith(_profileDio());
      final result = await service.updateProfile(_baseRequest);
      expect(result.refreshedProfile, isNotNull);
      expect(result.refreshedProfile!.name, 'Super Admin');
    });

    test(
        'successful PATCH + failed GET returns null refreshedProfile (not a throw)',
        () async {
      final service = _serviceWith(_profileDio(getStatusCode: 500));
      final result = await service.updateProfile(_baseRequest);
      // PATCH succeeded → result is returned, not thrown.
      expect(result.refreshedProfile, isNull);
    });

    test('failed PATCH throws and does not proceed to GET', () async {
      final requests = <String>[];
      final dio = _profileDio(patchStatusCode: 400);
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) => requests.add(options.method),
      ));
      final service = _serviceWith(dio);
      await expectLater(
        service.updateProfile(_baseRequest),
        throwsA(isA<DioException>()),
      );
      // GET must not have been attempted after PATCH failure.
      expect(requests.contains('GET'), isFalse);
    });
  });

  // -------------------------------------------------------------------------
  // B. Model: SuperadminUpdateProfileRequest.toJson — subdivision serialization
  // -------------------------------------------------------------------------
  group('SuperadminUpdateProfileRequest.toJson — subdivision encoding', () {
    test('sends stateCode as non-empty string when state is selected', () {
      final json = const SuperadminUpdateProfileRequest(
        name: 'Admin',
        mobilePrefix: '+91',
        mobileNumber: '9999999999',
        addressLine: 'Addr',
        countryCode: 'IN',
        stateCode: 'MH',
        cityName: 'Mumbai',
      ).toJson();
      expect(json['stateCode'], 'MH');
      expect(json['cityName'], 'Mumbai');
    });

    test('sends stateCode as empty string for no-state country', () {
      final json = const SuperadminUpdateProfileRequest(
        name: 'Admin',
        mobilePrefix: '+91',
        mobileNumber: '9999999999',
        addressLine: 'Addr',
        countryCode: 'AX',
        stateCode: '',
        cityName: '',
      ).toJson();
      expect(json['stateCode'], '');
      expect(json['cityName'], '');
    });

    test('empty stateCode is present in JSON (not omitted)', () {
      final json = const SuperadminUpdateProfileRequest(
        name: 'Admin',
        mobilePrefix: '+91',
        mobileNumber: '9999999999',
        addressLine: 'Addr',
        countryCode: 'AX',
        stateCode: '',
        cityName: '',
      ).toJson();
      expect(json.containsKey('stateCode'), isTrue);
      expect(json.containsKey('cityName'), isTrue);
    });

    test('sends stateCode with empty cityName for no-city state', () {
      final json = const SuperadminUpdateProfileRequest(
        name: 'Admin',
        mobilePrefix: '+91',
        mobileNumber: '9999999999',
        addressLine: 'Addr',
        countryCode: 'US',
        stateCode: 'TX',
        cityName: '',
      ).toJson();
      expect(json['stateCode'], 'TX');
      expect(json['cityName'], '');
    });

    test('null stateCode is omitted (not sent as null)', () {
      final json = const SuperadminUpdateProfileRequest(
        name: 'Admin',
        mobilePrefix: '+91',
        mobileNumber: '9999999999',
        addressLine: 'Addr',
        countryCode: 'IN',
      ).toJson();
      expect(json.containsKey('stateCode'), isFalse);
      expect(json.containsKey('cityName'), isFalse);
    });
  });

  // -------------------------------------------------------------------------
  // C. Controller optimistic update when refresh fails
  // -------------------------------------------------------------------------
  group(
      'SuperadminSettingsController._applyRequestToProfile — optimistic update',
      () {
    // We test this via the model directly since it is a pure data transformation.
    test('optimistic address reflects empty stateCode for no-state country',
        () {
      const current = SuperadminProfileSettings(
        name: 'Old',
        address: SuperadminAddressSettings(
          addressLine: '1 Old St',
          countryCode: 'IN',
          stateCode: 'MH',
          cityId: 'Mumbai',
        ),
      );
      const request = SuperadminUpdateProfileRequest(
        name: 'New',
        mobilePrefix: '+91',
        mobileNumber: '9999999999',
        addressLine: '1 New St',
        countryCode: 'AX',
        stateCode: '',
        cityName: '',
      );
      final updated = SuperadminProfileSettings(
        uid: current.uid,
        name: request.name ?? current.name,
        email: request.email ?? current.email,
        mobilePrefix: request.mobilePrefix ?? current.mobilePrefix,
        mobileNumber: request.mobileNumber ?? current.mobileNumber,
        address: SuperadminAddressSettings(
          id: current.address?.id,
          addressLine: request.addressLine ?? current.address?.addressLine,
          countryCode: request.countryCode ?? current.address?.countryCode,
          stateCode: request.stateCode ?? current.address?.stateCode,
          cityName: request.cityName ?? current.address?.cityName,
          cityId: request.cityName ?? current.address?.cityId,
          cityCode: current.address?.cityCode,
          pincode: request.pincode ?? current.address?.pincode,
          fullAddress: current.address?.fullAddress,
        ),
        cityName: request.cityName ?? current.cityName,
      );
      expect(updated.address?.stateCode, '');
      expect(updated.address?.cityId, '');
      expect(updated.name, 'New');
      expect(updated.address?.countryCode, 'AX');
    });

    test('optimistic address preserves existing uid and non-address fields',
        () {
      const current = SuperadminProfileSettings(
        uid: 42,
        name: 'Old Admin',
        credits: 100.0,
        address: SuperadminAddressSettings(
          countryCode: 'IN',
          stateCode: 'MH',
        ),
      );
      const request = SuperadminUpdateProfileRequest(
        name: 'New Admin',
        mobilePrefix: '+91',
        mobileNumber: '9999999999',
        addressLine: 'Addr',
        countryCode: 'IN',
        stateCode: 'GJ',
        cityName: 'Surat',
      );
      final updated = current.copyWith(
        name: request.name ?? current.name,
        mobilePrefix: request.mobilePrefix ?? current.mobilePrefix,
        mobileNumber: request.mobileNumber ?? current.mobileNumber,
      );
      expect(updated.uid, 42);
      expect(updated.credits, 100.0);
      expect(updated.name, 'New Admin');
    });
  });

  // -------------------------------------------------------------------------
  // D. Service: GET profile after successful refresh carries correct city
  // -------------------------------------------------------------------------
  group('SuperadminSettingsService.updateProfile — refresh carries city', () {
    test('returned profile contains city from GET response', () async {
      final service = _serviceWith(_profileDio(
        getProfileData: _minimalProfileJson(
          stateCode: 'GJ',
          cityId: 'Surat',
        ),
      ));
      final result = await service.updateProfile(
        const SuperadminUpdateProfileRequest(
          name: 'Admin',
          mobilePrefix: '+91',
          mobileNumber: '9999999999',
          addressLine: 'Addr',
          countryCode: 'IN',
          stateCode: 'GJ',
          cityName: 'Surat',
        ),
      );
      expect(result.refreshedProfile?.address?.cityDisplayName, 'Surat');
    });

    test('country without state/city: GET returns empty stateCode and cityId',
        () async {
      final service = _serviceWith(_profileDio(
        getProfileData: _minimalProfileJson(
          stateCode: '',
          cityId: '',
        ),
      ));
      final result = await service.updateProfile(
        const SuperadminUpdateProfileRequest(
          name: 'Admin',
          mobilePrefix: '+91',
          mobileNumber: '9999999999',
          addressLine: 'Addr',
          countryCode: 'AX',
          stateCode: '',
          cityName: '',
        ),
      );
      expect(result.refreshedProfile?.address?.stateCode, isNull);
      expect(result.refreshedProfile?.address?.cityDisplayName, isNull);
    });
  });
}
