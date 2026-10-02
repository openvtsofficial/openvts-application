import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_settings_model.dart';
import 'package:open_vts/features/admin/models/admin_users_model.dart';
import 'package:open_vts/features/admin/screens/settings/widgets/admin_profile_settings_section.dart';

void main() {
  testWidgets('profile address card renders readable location labels',
      (tester) async {
    const profile = AdminProfileSettings(
      address: AdminAddressSettings(
        countryCode: 'IN',
        stateCode: 'MH',
        cityId: 'city-42',
      ),
    );

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AdminProfileAddressCard(
              profile: profile,
              initialCities: <AdminUserCityOption>[
                AdminUserCityOption(value: 'city-42', label: 'Mumbai'),
              ],
              loadCatalogs: false,
            ),
          ),
        ),
      ),
    );

    expect(find.text('India'), findsOneWidget);
    expect(find.text('Maharashtra'), findsOneWidget);
    expect(find.text('Mumbai'), findsOneWidget);
    expect(find.text('IN'), findsNothing);
    expect(find.text('MH'), findsNothing);
    expect(find.text('city-42'), findsNothing);
  });
}
