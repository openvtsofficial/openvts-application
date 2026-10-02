import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/api/api_exception.dart';
import 'package:open_vts/features/admin/models/admin_settings_model.dart';
import 'package:open_vts/features/admin/services/admin_settings_service.dart';

void main() {
  test('profile update uses PATCH then canonical GET on the /api route',
      () async {
    final requests = <String>[];
    final dio = Dio(BaseOptions(baseUrl: 'https://app.openvts.io/api'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add('${options.method} ${options.uri}');
          handler.resolve(
            Response<dynamic>(
              requestOptions: options,
              statusCode: 200,
              data: options.method == 'PATCH'
                  ? _success(null, 'Profile updated')
                  : _success(<String, dynamic>{'name': 'Updated Admin'},
                      'Profile fetched'),
            ),
          );
        },
      ),
    );

    final profile = await AdminSettingsService(ApiClient(dio)).updateProfile(
      const AdminUpdateProfileRequest(name: 'Updated Admin'),
    );

    expect(profile.name, 'Updated Admin');
    expect(requests, <String>[
      'PATCH https://app.openvts.io/api/admin/profile',
      'GET https://app.openvts.io/api/admin/profile',
    ]);
  });

  test('reports a PATCH 404 as a save failure and does not run GET', () async {
    var getCount = 0;
    final service = AdminSettingsService(
      ApiClient(
          _profileFailureDio(failMethod: 'PATCH', onGet: () => getCount++)),
    );

    await expectLater(
      service.updateProfile(const AdminUpdateProfileRequest(name: 'Admin')),
      throwsA(
        isA<ApiException>()
            .having((error) => error.statusCode, 'status', 404)
            .having(
              (error) => error.message,
              'message',
              'Unable to save profile: Cannot find route',
            ),
      ),
    );
    expect(getCount, 0);
  });

  test('reports a follow-up GET 404 separately after PATCH succeeds', () async {
    final service = AdminSettingsService(
      ApiClient(_profileFailureDio(failMethod: 'GET')),
    );

    await expectLater(
      service.updateProfile(const AdminUpdateProfileRequest(name: 'Admin')),
      throwsA(
        isA<ApiException>()
            .having((error) => error.statusCode, 'status', 404)
            .having(
              (error) => error.message,
              'message',
              'Profile saved, but refresh failed: Cannot find route',
            ),
      ),
    );
  });
}

Map<String, dynamic> _success(dynamic data, String message) {
  return <String, dynamic>{
    'status': 'success',
    'data': <String, dynamic>{
      'action': true,
      'message': message,
      'data': data,
    },
  };
}

Dio _profileFailureDio({
  required String failMethod,
  void Function()? onGet,
}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://app.openvts.io/api'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (options.method == 'GET') onGet?.call();
        if (options.method == failMethod) {
          handler.reject(
            DioException.badResponse(
              statusCode: 404,
              requestOptions: options,
              response: Response<dynamic>(
                requestOptions: options,
                statusCode: 404,
                data: <String, dynamic>{'message': 'Cannot find route'},
              ),
            ),
          );
          return;
        }
        handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: _success(null, 'Profile updated'),
          ),
        );
      },
    ),
  );
  return dio;
}
