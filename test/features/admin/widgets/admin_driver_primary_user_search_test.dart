import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/admin/models/admin_drivers_model.dart';
import 'package:open_vts/features/admin/screens/drivers/widgets/admin_driver_create_sheet.dart';

const _users = [
  AdminDriverListItem(
    id: 'user-42',
    firstName: 'Alice Sharma',
    email: 'alice@example.com',
    username: 'alice_admin',
    mobilePrefix: '+91',
    mobile: '9876543210',
    phone: '+91 9876543210',
    address: '',
    fullAddress: '',
    countryCode: 'IN',
    stateCode: 'MH',
    city: 'Mumbai',
    pincode: '',
    primaryUserName: '',
    primaryUserUid: '',
    isVerified: true,
    isActive: true,
    statusLabel: 'Active',
    createdAt: null,
    updatedAt: null,
  ),
  AdminDriverListItem(
    id: 'user-77',
    firstName: 'Bob Jones',
    email: '',
    username: 'bob',
    mobilePrefix: '+44',
    mobile: '7700900123',
    phone: '+44 7700900123',
    address: '',
    fullAddress: '',
    countryCode: 'GB',
    stateCode: '',
    city: 'London',
    pincode: '',
    primaryUserName: '',
    primaryUserUid: '',
    isVerified: true,
    isActive: true,
    statusLabel: 'Active',
    createdAt: null,
    updatedAt: null,
  ),
];

class _Harness extends StatefulWidget {
  const _Harness();

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  final _formKey = GlobalKey<FormState>();
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              AdminDriverPrimaryUserDropdown(
                value: _selected,
                users: _users,
                isLoading: false,
                onChanged: (value) => setState(() => _selected = value),
              ),
              TextButton(
                onPressed: () => _formKey.currentState!.validate(),
                child: const Text('Validate'),
              ),
              Text('Selected: ${_selected ?? '-'}'),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('primary user validates, searches all fields, and selects ID', (
    tester,
  ) async {
    await tester.pumpWidget(const _Harness());

    await tester.tap(find.text('Validate'));
    await tester.pump();
    expect(find.text('Primary user is required'), findsOneWidget);

    await tester.tap(find.text('Select primary user'));
    await tester.pumpAndSettle();

    final searchField = find.byType(TextField).last;
    final aliceOption = find.descendant(
      of: find.byType(ListView).last,
      matching: find.text('Alice Sharma'),
    );
    for (final query in const [
      'alice sharma',
      'alice_admin',
      'alice@example.com',
      '+91 9876',
      '9876543210',
      'user-42',
    ]) {
      await tester.enterText(searchField, query);
      await tester.pump();
      expect(aliceOption, findsOneWidget);
      expect(find.text('Bob Jones'), findsNothing);
    }

    expect(find.text('alice@example.com'), findsOneWidget);
    await tester.tap(aliceOption);
    await tester.pumpAndSettle();

    expect(find.text('Selected: user-42'), findsOneWidget);
    expect(find.text('Alice Sharma'), findsOneWidget);
    expect(find.text('alice@example.com'), findsOneWidget);
    await tester.tap(find.text('Validate'));
    await tester.pump();
    expect(find.text('Primary user is required'), findsNothing);
  });
}
