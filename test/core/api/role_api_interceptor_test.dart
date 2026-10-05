import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/core/api/api_client.dart';
import 'package:open_vts/core/api/interceptors/role_api_interceptor.dart';
import 'package:open_vts/core/storage/token_storage.dart';
import 'package:open_vts/features/auth/models/current_user.dart';
import 'package:open_vts/shared/models/user_role.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late TokenStorage storage;
  late Dio dio;
  late ApiClient api;
  final sent = <RequestOptions>[];
  Future<void> signIn(UserRole role) => storage.saveSessionForRole(
        role: role,
        accessToken: 'test-token',
        refreshToken: 'test-refresh',
        currentUserJson: jsonEncode(CurrentUser(
          id: '42',
          name: 'Test',
          email: '',
          role: role,
        ).toJson()),
      );
  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    storage = TokenStorage(const FlutterSecureStorage());
    await signIn(UserRole.team);
    sent.clear();
    dio = Dio(BaseOptions(baseUrl: 'https://fleet.example/api'));
    dio.interceptors.add(RoleApiInterceptor(storage));
    dio.interceptors.add(InterceptorsWrapper(onRequest: (request, handler) {
      sent.add(request);
      handler.resolve(Response(
          requestOptions: request,
          statusCode: 200,
          data: {'action': true, 'data': <String, dynamic>{}}));
    }));
    api = ApiClient(dio);
  });
  tearDown(() => dio.close(force: true));

  test('Team remapping preserves deployed API prefix and search', () async {
    await api.get('/admin/devices',
        queryParameters: {'q': 'Truck 7', 'page': 2}, parser: (value) => value);
    expect(sent.single.uri.path, '/api/team/inventory/devices');
    expect(sent.single.uri.queryParameters, {'q': 'Truck 7', 'page': '2'});
  });
  test('unsupported Team method never reaches transport or Admin fallback',
      () async {
    await expectLater(
        api.post('/admin/pricingplans', data: {}, parser: (value) => value),
        throwsA(isA<DioException>()));
    expect(sent, isEmpty);
  });
  test('Admin endpoints remain unchanged for an Admin identity', () async {
    await signIn(UserRole.admin);
    await api.get('/admin/transactions', parser: (value) => value);
    expect(sent.single.uri.path, '/api/admin/transactions');
  });
}
