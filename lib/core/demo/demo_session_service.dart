import '../api/api_client.dart';
import 'demo_session.dart';

class DemoSessionService {
  const DemoSessionService(this._apiClient);

  final ApiClient _apiClient;

  Future<DemoSession> openSession() async {
    final response = await _apiClient.get<DemoSession>(
      '/demo/session',
      parser: DemoSession.fromJson,
    );
    return response.data;
  }
}
